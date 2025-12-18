// (C) 2001-2020 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// This module uses a fifo to store the read addresses, in order to
// use them to determine when to generate the next read compare data.
// If consecutive addresses are the same, we are doing multiple reads
// to the same address and hence should not update the read compare data.
// The status checker also uses this address to report at which address a
// failure occurred.
//
//
// Process flow :
// 1.  Once out of reset and configuration is done as indicated by tg_restart signal, this module will assert
//     'check_in_prog' signal which use to backpressure the configuration block and as indicator for test under
//     progress.
// 2.  Whenever Read address generator generate Read address and the AXI slave ready to accept the Reads as
//     indicated by 'read_addr_valid' signal, this module will push in the generated 'read_addr' into 'read_addr_fifo'.
//     At this momement, the 'read_addr_fifo_out' signal shows the current Read address and the expected read data generator
//     shows the current expected read data for the incoming read data. This signals use by other blocks to generate
//     pnf signals and report the address of a failure
// 3.  As the read data coming back as indicated by 'rdata_valid' signal, the 'read_addr_fifo' will pop out the subsequent
//     read address for the current 'read_id_fifo_out'. The 'rdata_handler' will also count down the counters that track how
//     many read data has came back base on number of cycle the 'rdata_valid' asserted. The count down continue each and
//     everytime it received 'rdata_valid' starting from the outer loop counter until the inner loop counter reach '0'.
//     The outter loop begin with counting down the 'data_burst_counter' till it reach '1' before counting down the
//     '*_same_addr_counter', '*_diff_addr_counter' and then 'diff_loop_counter' counter
// 4.  The 'rdata_handler' also signal the Expected read data generator to generate next expected read data through
//     'next_read_data_en' signal each time the 'rdata_valid' has been received.
// 5.  The process continue until no more pending read data is expected as indicated by 'rdata_diff_loop_counter' == '0'
//     and 'no_pending_rdata' signal asserted..
// 6.  Once 'no_pending_rdata' signal asserted, the 'check_in_prog' de-asserted, allowing reconfiguration to occur for another test

module altera_hbm_tg_axi_compare_addr_gen # (
    parameter ADDR_WIDTH                  = "",
    parameter ADDR_FIFO_DEPTH             = "",
    parameter PORT_AXI_RID_WIDTH          = "",
    parameter MAX_ID                      = "",
    parameter AMM_BURSTCOUNT_WIDTH        = "",
    parameter READ_RPT_COUNT_WIDTH        = "",
    parameter READ_COUNT_WIDTH            = "",
    parameter READ_LOOP_COUNT_WIDTH       = "",
    parameter BURST_LEN_EXTEND_EN         = 0,
    parameter MAX_BURST_COUNT             = 3,
    parameter MIN_BURST_COUNT             = 1,
    parameter BURST_COUNT_DIVISIBLE_BY    = "",
    parameter BURST_COUNT_MODE          = "RAND"
) (
    // Clock and reset
    input                               clk,
    input                               rst,

    // Signal from configuration registers used for initializing the *_handler counters and start test
    input [AMM_BURSTCOUNT_WIDTH-1:0]    burst_length,
    input [READ_COUNT_WIDTH-1:0]        num_read_bursts,
    input [READ_RPT_COUNT_WIDTH-1:0]    num_read_repeats,
    input [READ_LOOP_COUNT_WIDTH-1:0]   num_read_loops,
    input                               tg_restart,

    //Signal from Read address/id generator and AXI slave for current Read address/id. Will be use to push into 'read_addr_fifo'
    input                               read_addr_valid,
    input [PORT_AXI_RID_WIDTH-1:0]      read_id_fifo_in,
    input [ADDR_WIDTH-1:0]              read_addr,

   // Signal from AXI slave for current recived read data. Will be use to pop out the 'read_addr_fifo' data
    input                               rdata_valid,
    input [PORT_AXI_RID_WIDTH-1:0]      read_id_fifo_out,

    output logic [MAX_ID-1:0]           next_read_data_en,
    output logic [MAX_ID-1:0]           next_read_data_en_prev,

    output logic [ADDR_WIDTH-1:0]       current_written_addr,

    output                              fifo_almost_full,
    output logic                        check_in_prog
);

    timeunit 1ns;
    timeprecision 1ps;

    import tg_axi_defs::*;

   // FIFO address width
    localparam FIFO_WIDTHU              = ceil_log2(ADDR_FIFO_DEPTH);
   // Actual FIFO size
    localparam FIFO_NUMWORDS            = 2 ** FIFO_WIDTHU;

   // Read/write data registers
    logic [ADDR_WIDTH-1:0]              read_addr_fifo_out[0:MAX_ID-1];

    logic [MAX_ID-1:0]                  fifo_almost_full_all;

    logic [MAX_ID-1:0]                  fifo_read_req;
    logic                               fifo_write_req;
    logic [MAX_ID-1:0]                  fifo_empty;

    reg [AMM_BURSTCOUNT_WIDTH-1:0]      rdata_burst_counter[0:MAX_ID-1];
    reg [READ_RPT_COUNT_WIDTH-1:0]      rdata_same_addr_counter[0:MAX_ID-1];
    reg [READ_COUNT_WIDTH-1:0]          rdata_diff_addr_counter[0:MAX_ID-1];
    reg [READ_LOOP_COUNT_WIDTH-1:0]     rdata_diff_loop_counter[0:MAX_ID-1];
    wire [MAX_ID-1:0]                   have_reads;
    wire [MAX_ID-1:0]                   no_pending_rdata;
    wire [AMM_BURSTCOUNT_WIDTH-1:0]     compare_burstlength;
    wire                                burst_counter_dec_en;

    logic rdata_valid_r, rdata_valid_r2;

    always_ff @(posedge clk)
    begin
        if (rst) begin
            check_in_prog <= 1'b0;
            rdata_valid_r <= 1'b0;
            rdata_valid_r2 <= 1'b0;
        end else begin
            if (|have_reads)
                if (!check_in_prog)
                    check_in_prog <= tg_restart;
                else
                    check_in_prog <= ~(&no_pending_rdata) || ~(&fifo_empty);
            rdata_valid_r <= rdata_valid;
            rdata_valid_r2 <= rdata_valid_r;
        end
    end

   generate
     if(BURST_LEN_EXTEND_EN) begin  
        if(BURST_COUNT_MODE == "MIN_MAX") begin
	   altera_hbm_tg_axi_max_min_burst_gen # (
              .NUM_WIDTH               (AMM_BURSTCOUNT_WIDTH),
              .NUM_MIN                 (MIN_BURST_COUNT),
              .NUM_MAX                 (MAX_BURST_COUNT)
           ) min_max_burstcount_gen (
              .clk               (clk),
              .rst               (rst),
              .enable            (tg_restart | (~burst_counter_dec_en & rdata_valid_r2)),
              .burstcount_out    (compare_burstlength)
           );	
	end else if (BURST_COUNT_MODE == "SEQ") begin
	   altera_hbm_tg_axi_seq_burst_gen # (
              .NUM_WIDTH               (AMM_BURSTCOUNT_WIDTH),
              .NUM_MIN                 (MIN_BURST_COUNT),
              .NUM_MAX                 (MAX_BURST_COUNT)
           ) seq_burstcount_gen (
              .clk               (clk),
              .rst               (rst),
              .enable            (tg_restart | (~burst_counter_dec_en & rdata_valid_r2)),
              .burstcount_out    (compare_burstlength)	
           );
	end else begin
            altera_hbm_tg_axi_rand_num_gen # (
              .RAND_NUM_WIDTH               (AMM_BURSTCOUNT_WIDTH),
              .RAND_NUM_MIN                 (MIN_BURST_COUNT),
              .RAND_NUM_MAX                 (MAX_BURST_COUNT),
              .BURST_COUNT_DIVISIBLE_BY     (BURST_COUNT_DIVISIBLE_BY),
              .TG_USE_EFFICIENCY_PATTERN    (0)
           ) rand_burstcount_gen (
              .clk               (clk),
              .rst               (rst),
              .enable            (tg_restart | (~burst_counter_dec_en & rdata_valid_r2)),
              .ready             (),
              .rand_num          (compare_burstlength)
           );
	end
     end else begin
        assign compare_burstlength = burst_length;
     end
   endgenerate
    //To ensure consistency and simplification, all counters to count each operation for each AXI channel
    //in every module is done by the same operation_handler module.
    genvar id;
    generate
        for (id = 0; id < MAX_ID; id = id + 1) begin: gen_handler
            altera_hbm_tg_axi_operation_handler #(AMM_BURSTCOUNT_WIDTH, READ_RPT_COUNT_WIDTH, READ_COUNT_WIDTH, READ_LOOP_COUNT_WIDTH)
            rdata_handler(
                .clk                (clk                        ),
                .rst                (rst                        ),
                .burstlength        (compare_burstlength        ),
                .num_same_addr      (num_read_repeats           ),
                .num_diff_addr      (num_read_bursts            ),
                .num_diff_loop	   (num_read_loops             ),
                .load               (tg_restart                 ),
                .enable             (rdata_valid_r2 && ((read_id_fifo_out == id) || (MAX_ID == 1))),
                .burst_counter      (rdata_burst_counter[id]    ),
                .same_addr_counter  (rdata_same_addr_counter[id]),
                .diff_addr_counter  (rdata_diff_addr_counter[id]),
                .diff_loop_counter  (rdata_diff_loop_counter[id]),
                .next_cycle_enable  (next_read_data_en[id]      ),
                .next_bursts_enable (                           ),
                .next_addr_enable   (                           ),
                .diff_loop_counter_gt_0 (                       ),
                .burst_counter_dec_en   (burst_counter_dec_en   ),
                .same_addr_counter_dec_en  (                    ),
                .diff_addr_counter_dec_en  (                    ),
                .diff_loop_counter_dec_en  (                    ),
                .have_operations    (have_reads[id]             )
            );

            assign next_read_data_en_prev[id] = rdata_valid_r && ((read_id_fifo_out == id) || (MAX_ID == 1));
            assign no_pending_rdata[id] = (rdata_diff_loop_counter[id] == 0);
        end
    endgenerate

   //In order to report the address of a failure, a fifo is required to store the read addresses
   //due to the ability to read multiple times from the same address

    assign fifo_write_req = read_addr_valid;

   //once the count of the number of burst equals the number of read bursts issued, the last starting address will
   //already have been dequeued from the fifo. reading from it again will read from an empty fifo
   //we also only need to get the next address once per burst, as it is the start address of the burst
    always_comb begin
        for (integer id = 0; id < MAX_ID; id = id + 1) begin
            fifo_read_req[id] = rdata_valid_r2 & (id == read_id_fifo_out || MAX_ID == 1) & (rdata_burst_counter[id] == 1);
        end
    end

    genvar i;
    generate
        for (i = 0; i < MAX_ID; i = i + 1) begin: gen_fifo
        
        logic wrreq_pipe;                       /* synthesis dont_merge */
        logic [ADDR_WIDTH-1:0] read_addr_pipe;  /* synthesis dont_merge */
        always @ ( posedge clk ) begin
          if (rst ) begin
            wrreq_pipe <= 1'b0;
            read_addr_pipe  <= 'd0;
          end
          else begin
            wrreq_pipe <= fifo_write_req && (i == read_id_fifo_in || MAX_ID == 1);
            read_addr_pipe  <= read_addr;
          end
        end
        
        //Read address fifo
        scfifo # (
            .lpm_width                (ADDR_WIDTH),
            .lpm_widthu               (FIFO_WIDTHU),
            .lpm_numwords             (FIFO_NUMWORDS),
            .lpm_showahead            ("ON"),
            .almost_full_value        (FIFO_NUMWORDS > 2 ? FIFO_NUMWORDS-2 : 1),
            .use_eab                  ("ON"),
            .overflow_checking        ("OFF"),
            .underflow_checking       ("OFF")
        ) read_addr_fifo (
            .rdreq                    (fifo_read_req[i] & ~fifo_empty[i]),
            .aclr                     (1'b0),
            .clock                    (clk),
            .wrreq                    (wrreq_pipe),
            .data                     (read_addr_pipe),
            .full                     (),
            .q                        (read_addr_fifo_out[i]),
            .sclr                     (rst),
            .usedw                    (),
            .empty                    (fifo_empty[i]),
            .almost_full              (fifo_almost_full_all[i]),
            .almost_empty             (),
            .eccstatus                ()
        );
    end
    endgenerate

    assign current_written_addr = read_addr_fifo_out[MAX_ID == 1 ? 0 : read_id_fifo_out];
    assign fifo_almost_full     = |fifo_almost_full_all;

endmodule
