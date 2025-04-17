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


//-------------------------------------------------------------------------------
// Filename    : rw_gen.v
// Description : Read-Write Enable Generator. Issues a block of "rw_gen_write_cnt"
//                writes to different addresses (which can be random, sequential,
//                etc), performing each write "rw_gen_write_rpt_cnt" times. Then,
//                issues a block of "rw_gen_read_cnt" reads to the read addresses,
//                performing each read "num_read_repeats" times. This sequence
//                repeats "num_loops" times, with addresses and data different on
//                every iteration of the loop.
//                The operation_handler module manages the operation counters,
//                while the rw_gen module manages the FSM.
//-----------------------------------------------------------------------------
//
//
// Process flow :
// 1.  Once out of reset and configuration is done as indicated by 'start' signal, the 'wcmd/wdata_state'
//     FSM goes to 'WRITE' or 'WRITE_DATA' state to start the Writes processes. Meanwhile, the 'rcmd_state' FSM
//     goes to 'WAIT_FOR_WRITES' state to wait for a block of Writes to complete first to avoid TG reading from
//     uninitialized location.
// 2.  Detecting they're in those stages, this module issue the Write / Write data requests to AXI Slave (Controller)
//     through the '*_req' signals. Its also assert 'waitrequest' signal to AXI Master (Configuration block) to
//     prevent it from reconfiguring the TG at the middle of the process.
// 3.  Once the AXI Slave accept the first cycle of the request as '*_ready' signal asserted, the 'w*_handler'
//     will count down the counters. The count down continue each and everytime the request has been accepted,
//     starting from the outer loop counter until the inner loop counter reach '0'. For data counters 'wdata_handler,
//     the outter loop begin with counting down the 'data_burst_counter' till it reach '1' before counting down the
//     '*_same_addr_counter', '*_diff_addr_counter' and then 'diff_loop_counter' counter. For command counters,
//     'wcmd_handler' the count down loop is the same except it start with '*_same_addr_counter'  instead of the
//     'data_burst_counter' counter.
// 4.  The 'wdata_handler' also signal the data generator to generate new data through 'next_data_write' signal each
//     time the request has been accepted. The 'wcmd_handler' also signal the address generator to generate new address through
//     'next_addr_write' each time the cmd going to cycle to different address as triggered by the '*_same_addr_counter'==1
//      which also cause the '*_diff_addr_counter'value to decrement.
// 5.  The TG continue issuing writes to AXI Slave until it finish number of all the Writes in the current loop. Then
//     'wcmd/wdata_state' FSM goes to 'WAIT_FOR_BVALID' state.
// 6.  The 'wcmd_handler' count the number bvalid it receive through 'rsp*counter'. Once it reach the value of response
//     it expected for the current loop, then 'wcmd/wdata_state' FSM go back to 'WRITE' or 'WRITE_DATA' state to
//     continue issuing Writes for the subsequent loop.
// 7.  As the 'rcmd_state' FSM detecting the there is pending reads as indicated by 'rcmd_diff_loop_counter > wrsp_diff_loop_counter'
//     the FSM goes to 'READ' state so that this module could issue Reads through 'rcmd_req' signal.
// 8.  Same as wcmd_handler, the read_handler count down the counters each time the read request has been excepted
//     as well as signaling the read address generator to generate new address through 'next_addr_read' signal.
// 9.  Once the pending reads for the current loop finished, it go back to 'WAIT_FOR_WRITES' state, waiting for Writes
//     to finish writing and get responded for the subsequent loop.
// 10. The process continue until all counters reach '1' as indicated by 'last_wcmd/wdata/rcmd' signal and all FSM back to 'IDLE'.
// 11. Once IDLE, the waitrequest' deassert, allowing reconfiguration to occur for another test
//
// Example of rw_gen_write_rpt_cnt = 4, rw_gen_write_cnt = 2 and rw_gen_loop_cnt = 2
//
// :----------------------------------Loop/Diff Loop Counter--------------------------------------------:
// :------Write Read Block/Diff Addr Counter--------:                                                   :
// :--Repeat/Same Addr C--                          :                                                   :
// :____  ____  ____  ____:   ____  ____  ____  ____:   ____  ____  ____  ____    ____  ____  ____  ____:
// / A0 \/ A0 \/ A0 \/ A0 \__/ A2 \/ A2 \/ A2 \/ A2 \__/ A0 \/ A0 \/ A0 \/ A0 \__/ A2 \/ A2 \/ A2 \/ A2 \__
// \____/\____/\____/\____/  \____/\____/\____/\____/  \____/\____/\____/\____/  \____/\____/\____/\____/
//

module altera_hbm_tg_axi_rw_gen #(
    parameter SEPARATE_READ_WRITE_IFS   = "",
    parameter RPT_COUNT_WIDTH           = "",
    parameter OPERATION_COUNT_WIDTH     = "",
    parameter LOOP_COUNT_WIDTH          = "",
    parameter AMM_BURSTCOUNT_WIDTH      = "",
    parameter DIAG_EFFICIENCY_TEST_MODE = "",
    parameter BURST_LEN_EXTEND_EN       = 0,
    parameter MAX_BURST_COUNT           = 3,
    parameter MIN_BURST_COUNT           = 1,
    parameter BURST_COUNT_DIVISIBLE_BY  = "",
    parameter BURST_COUNT_MODE          = "RAND"
)(
    input                               clk,
    input                               rst,

    // Signal from configuration registers used for initializing the *_handler counters and start test
    input [AMM_BURSTCOUNT_WIDTH-1:0]    burstlength,
    input [RPT_COUNT_WIDTH-1:0]         rw_gen_read_rpt_cnt,
    input [RPT_COUNT_WIDTH-1:0]         rw_gen_write_rpt_cnt,
    input [OPERATION_COUNT_WIDTH-1:0]   rw_gen_write_cnt,
    input [OPERATION_COUNT_WIDTH-1:0]   rw_gen_read_cnt,
    input [LOOP_COUNT_WIDTH-1:0]        rw_gen_loop_cnt,
    input                               start,

   //Signal to backpressure the configuration unit as configuration should not occur except all FSM in 'IDLE' state
    output                              waitrequest,

   // Signals to AXI Interface/ Slave to request Writes and Reads
    output                              wcmd_req,
    output                              wdata_req,
    output                              rcmd_req,

   //Signal from AXI slave indicating its ready to accept/ has accepted the TG  Write/ Read request
    input                               awrite_ready,
    input                               write_ready,
    input                               bvalid,
    input                               bready,
    input                               read_ready,

   //Signals to address or data generators to generate next read or write address or write data
    output                              next_addr_write,
    output                              next_data_write,
    output                              next_wlast,
    output                              next_addr_read

);
    timeunit 1ns;
    timeprecision 1ps;

    wire [RPT_COUNT_WIDTH-1:0]          wcmd_same_addr_counter;
    wire [OPERATION_COUNT_WIDTH-1:0]    wcmd_diff_addr_counter;
    wire [LOOP_COUNT_WIDTH-1:0]         wcmd_diff_loop_counter;

    wire [AMM_BURSTCOUNT_WIDTH-1:0]     wdata_burst_counter;
    wire [RPT_COUNT_WIDTH-1:0]          wdata_same_addr_counter;
    wire [OPERATION_COUNT_WIDTH-1:0]    wdata_diff_addr_counter;
    wire [LOOP_COUNT_WIDTH-1:0]         wdata_diff_loop_counter;

    wire [RPT_COUNT_WIDTH-1:0]          wrsp_same_addr_counter;
    wire [OPERATION_COUNT_WIDTH-1:0]    wrsp_diff_addr_counter;
    wire [LOOP_COUNT_WIDTH-1:0]         wrsp_diff_loop_counter;

    wire [RPT_COUNT_WIDTH-1:0]          rcmd_same_addr_counter;
    wire [OPERATION_COUNT_WIDTH-1:0]    rcmd_diff_addr_counter;
    wire [LOOP_COUNT_WIDTH-1:0]         rcmd_diff_loop_counter;

    wire have_reads;
    wire have_writes;

    wire last_wcmd_current_loop_d  ;
    wire last_wcmd_d               ;
    wire last_wdata_current_loop_d ;
    wire last_wdata_d              ;
    wire last_wrsp_current_loop_d  ;
    wire last_wrsp_d               ;
    wire last_rcmd_current_loop_d  ;
    wire last_rcmd_d               ;
    wire last_rcmd_loop_d          ;
    
    wire [AMM_BURSTCOUNT_WIDTH-1:0] wdata_burstlength;

    logic have_writes_r;   /* synthesis dont_merge */
    logic last_wdata_current_loop;
    logic last_wdata;
    logic last_wrsp_current_loop;
    logic last_wrsp;
    logic last_wcmd_current_loop;
    logic last_wcmd;
    logic last_rcmd_current_loop;
    logic last_rcmd;
    logic last_rcmd_loop;

    logic wcmd_diff_loop_counter_gt_0;
    logic wdata_diff_loop_counter_gt_0;
    logic wrsp_diff_loop_counter_gt_0;
    logic rcmd_diff_loop_counter_gt_0;


    logic                            wcmd_same_addr_counter_dec_en;
    logic                            wcmd_diff_addr_counter_dec_en;
    logic                            wcmd_diff_loop_counter_dec_en;

    logic                            wdata_burst_counter_dec_en;
    logic                            wdata_same_addr_counter_dec_en;
    logic                            wdata_diff_addr_counter_dec_en;
    logic                            wdata_diff_loop_counter_dec_en;

    logic                            wrsp_same_addr_counter_dec_en;
    logic                            wrsp_diff_addr_counter_dec_en;
    logic                            wrsp_diff_loop_counter_dec_en;

    logic                            rcmd_same_addr_counter_dec_en;
    logic                            rcmd_diff_addr_counter_dec_en;
    logic                            rcmd_diff_loop_counter_dec_en;

    assign last_wcmd_current_loop  = ~wcmd_diff_addr_counter_dec_en & ~wcmd_same_addr_counter_dec_en & awrite_ready;
    assign last_wcmd               = ~wcmd_diff_loop_counter_dec_en & last_wcmd_current_loop;


    assign last_wdata_current_loop= ~wdata_diff_addr_counter_dec_en & ~wdata_same_addr_counter_dec_en & ~wdata_burst_counter_dec_en & write_ready;
    assign last_wdata             = ~wdata_diff_loop_counter_dec_en & last_wdata_current_loop;

    assign last_wrsp_current_loop = ~wrsp_diff_addr_counter_dec_en & ~wrsp_same_addr_counter_dec_en & bvalid & bready;
    assign last_wrsp              = ~wrsp_diff_loop_counter_dec_en & last_wrsp_current_loop;

    assign last_rcmd_current_loop = ~rcmd_diff_addr_counter_dec_en & ~rcmd_same_addr_counter_dec_en & read_ready;
    assign last_rcmd              = ~rcmd_diff_loop_counter_dec_en & last_rcmd_current_loop;
    assign last_rcmd_loop         = (rcmd_diff_loop_counter == 2) && (~rcmd_diff_addr_counter_dec_en & ~rcmd_same_addr_counter_dec_en) & read_ready;

    always @ ( posedge clk ) begin
      have_writes_r  <= have_writes;
    end

    typedef enum logic [1:0]  {
        WCMD_IDLE=0,
        WCMD_WRITE=2,
        WCMD_WAIT_FOR_BVALID=3
    } wcmd_state_t;

    typedef enum logic [1:0] {
        WDATA_IDLE=0,
        WDATA_WRITE_DATA=2,
        WDATA_WAIT_FOR_BVALID=3
    } wdata_state_t;

    typedef enum logic [1:0] {
        RCMD_IDLE=0,
        RCMD_WAIT_FOR_WRITES=2,
        RCMD_READ=3
    } rcmd_state_t;

    wcmd_state_t    wcmd_state;
    wdata_state_t   wdata_state;
    rcmd_state_t    rcmd_state;

    //AXI has separate channel for Write Command, Write Data, Write Response Read Command and Read Data, To break any dependency, each channel will
    //have their own counter within this module. However, to ensure consistency and simplification, all counters to count each operation for each
    //AXI channel in every module is done by the same operation_handler module.

    altera_hbm_tg_axi_operation_handler #(AMM_BURSTCOUNT_WIDTH, RPT_COUNT_WIDTH, OPERATION_COUNT_WIDTH, LOOP_COUNT_WIDTH)
    wcmd_handler(
        .clk                (clk                        ),
        .rst                (rst                        ),
        .burstlength        ({{(AMM_BURSTCOUNT_WIDTH-1){1'b0}}, 1'b1 }),
        .num_same_addr      (rw_gen_write_rpt_cnt       ),
        .num_diff_addr      (rw_gen_write_cnt           ),
        .num_diff_loop	    (rw_gen_loop_cnt            ),
        .load               (start                      ),
        .enable             (wcmd_req && awrite_ready   ),
        .burst_counter      (                           ),
        .same_addr_counter  (wcmd_same_addr_counter     ),
        .diff_addr_counter  (wcmd_diff_addr_counter     ),
        .diff_loop_counter  (wcmd_diff_loop_counter     ),
        .next_cycle_enable  (                           ),
        .next_bursts_enable (                           ),
        .next_addr_enable   (next_addr_write            ),
        .diff_loop_counter_gt_0 (   wcmd_diff_loop_counter_gt_0    ),
        .burst_counter_dec_en   (                       ),
        .same_addr_counter_dec_en  (  wcmd_same_addr_counter_dec_en  ),
        .diff_addr_counter_dec_en  ( wcmd_diff_addr_counter_dec_en),
        .diff_loop_counter_dec_en  ( wcmd_diff_loop_counter_dec_en  ),
        .have_operations    (have_writes                )
    );


    altera_hbm_tg_axi_operation_handler #(AMM_BURSTCOUNT_WIDTH, RPT_COUNT_WIDTH, OPERATION_COUNT_WIDTH, LOOP_COUNT_WIDTH)
    wdata_handler(
        .clk                (clk                        ),
        .rst                (rst                        ),
        .burstlength        (wdata_burstlength          ),
        .num_same_addr      (rw_gen_write_rpt_cnt       ),
        .num_diff_addr      (rw_gen_write_cnt           ),
        .num_diff_loop	    (rw_gen_loop_cnt            ),
        .load               (start                      ),
        .enable             (wdata_req && write_ready   ),
        .burst_counter      (wdata_burst_counter        ),
        .same_addr_counter  (wdata_same_addr_counter    ),
        .diff_addr_counter  (wdata_diff_addr_counter    ),
        .diff_loop_counter  (wdata_diff_loop_counter    ),
        .next_cycle_enable  (next_data_write            ),
        .next_bursts_enable (next_wlast                 ),
        .next_addr_enable   (                           ),
        .diff_loop_counter_gt_0 ( wdata_diff_loop_counter_gt_0  ),
        .burst_counter_dec_en   ( wdata_burst_counter_dec_en  ),
        .same_addr_counter_dec_en  ( wdata_same_addr_counter_dec_en ),
        .diff_addr_counter_dec_en  ( wdata_diff_addr_counter_dec_en ),
        .diff_loop_counter_dec_en  ( wdata_diff_loop_counter_dec_en ),
        .have_operations    (                           )
    );


    altera_hbm_tg_axi_operation_handler #(AMM_BURSTCOUNT_WIDTH, RPT_COUNT_WIDTH, OPERATION_COUNT_WIDTH, LOOP_COUNT_WIDTH)
    wrsp_handler(
        .clk                (clk                        ),
        .rst                (rst                        ),
        .burstlength        ({{(AMM_BURSTCOUNT_WIDTH-1){1'b0}}, 1'b1 }),
        .num_same_addr      (rw_gen_write_rpt_cnt       ),
        .num_diff_addr      (rw_gen_write_cnt           ),
        .num_diff_loop	    (rw_gen_loop_cnt            ),
        .load               (start                      ),
        .enable             (bvalid & bready            ),
        .burst_counter      (                           ),
        .same_addr_counter  (wrsp_same_addr_counter     ),
        .diff_addr_counter  (wrsp_diff_addr_counter     ),
        .diff_loop_counter  (wrsp_diff_loop_counter     ),
        .next_cycle_enable  (                           ),
        .next_bursts_enable (                           ),
        .next_addr_enable   (                           ),
        .diff_loop_counter_gt_0 ( wrsp_diff_loop_counter_gt_0 ),
        .burst_counter_dec_en   (                       ),
        .same_addr_counter_dec_en  ( wrsp_same_addr_counter_dec_en ),
        .diff_addr_counter_dec_en  ( wrsp_diff_addr_counter_dec_en ),
        .diff_loop_counter_dec_en  ( wrsp_diff_loop_counter_dec_en ),
        .have_operations    (                           )
    );

    altera_hbm_tg_axi_operation_handler #(AMM_BURSTCOUNT_WIDTH, RPT_COUNT_WIDTH, OPERATION_COUNT_WIDTH, LOOP_COUNT_WIDTH)
    rcmd_handler(
        .clk                (clk                        ),
        .rst                (rst                        ),
        .burstlength        ({{(AMM_BURSTCOUNT_WIDTH-1){1'b0}}, 1'b1 }),
        .num_same_addr      (rw_gen_read_rpt_cnt       ),
        .num_diff_addr      (rw_gen_read_cnt           ),
        .num_diff_loop	    (rw_gen_loop_cnt            ),
        .load               (start                      ),
        .enable             (rcmd_req && read_ready     ),
        .burst_counter      (                           ),
        .same_addr_counter  (rcmd_same_addr_counter     ),
        .diff_addr_counter  (rcmd_diff_addr_counter     ),
        .diff_loop_counter  (rcmd_diff_loop_counter     ),
        .next_cycle_enable  (                           ),
        .next_bursts_enable (                           ),
        .next_addr_enable   (next_addr_read             ),
        .diff_loop_counter_gt_0 ( rcmd_diff_loop_counter_gt_0  ),
        .burst_counter_dec_en   (                       ),
        .same_addr_counter_dec_en  ( rcmd_same_addr_counter_dec_en ),
        .diff_addr_counter_dec_en  ( rcmd_diff_addr_counter_dec_en ),
        .diff_loop_counter_dec_en  ( rcmd_diff_loop_counter_dec_en ),
        .have_operations    (have_reads                 )
    );

   //random number generator that the test stages can use to generate random burst lengths within a range
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
              .enable            (start | (~wdata_burst_counter_dec_en & wdata_req & write_ready)),
              .burstcount_out    (wdata_burstlength)
           );	
	end else if (BURST_COUNT_MODE == "SEQ") begin
	   altera_hbm_tg_axi_seq_burst_gen # (
              .NUM_WIDTH               (AMM_BURSTCOUNT_WIDTH),
              .NUM_MIN                 (MIN_BURST_COUNT),
              .NUM_MAX                 (MAX_BURST_COUNT)
           ) seq_burstcount_gen (
              .clk               (clk),
              .rst               (rst),
              .enable            (start | (~wdata_burst_counter_dec_en & wdata_req & write_ready)),
              .burstcount_out    (wdata_burstlength)	
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
              .enable            (start | (~wdata_burst_counter_dec_en & wdata_req & write_ready)),
              .ready             (),
              .rand_num          (wdata_burstlength)
           );
	end
     end else begin
        assign wdata_burstlength = burstlength;
     end
   endgenerate

    //AXI has separate channel for Write Command, Write Data, Write Response Read Command and Read Data, To break any dependency, each channel will
    //have their own FSM within this module


    // Write Command FSM
    always @(posedge clk)
    begin
        if (rst) begin
            wcmd_state <= WCMD_IDLE;
        end
        else begin
            case (wcmd_state)

                WCMD_IDLE:
                begin
                    if (start && have_writes_r)
                        wcmd_state <= WCMD_WRITE;
                end

                WCMD_WRITE:
                begin
                    if ((!DIAG_EFFICIENCY_TEST_MODE && last_wcmd_current_loop) || (DIAG_EFFICIENCY_TEST_MODE && last_wcmd))
                        wcmd_state <= WCMD_WAIT_FOR_BVALID;
                end

                WCMD_WAIT_FOR_BVALID:
                begin
                    if (last_wrsp)
                        wcmd_state <= WCMD_IDLE;
                    else if (!DIAG_EFFICIENCY_TEST_MODE && last_wrsp_current_loop)
                        wcmd_state <= WCMD_WRITE;
                end
                default:
                begin
                    wcmd_state <= WCMD_IDLE;
                end

            endcase
        end
    end

    logic go_to_WDATA_WAIT_FOR_BVALID;
    assign go_to_WDATA_WAIT_FOR_BVALID  =
            (!DIAG_EFFICIENCY_TEST_MODE && last_wdata_current_loop) || (DIAG_EFFICIENCY_TEST_MODE && last_wdata);

    // Write Data FSM
    always @(posedge clk)
    begin
        if (rst) begin
            wdata_state <= WDATA_IDLE;
        end
        else begin
            case (wdata_state)

                WDATA_IDLE:
                begin
                    if (start && have_writes_r)
                        wdata_state <= WDATA_WRITE_DATA;
                end

                WDATA_WRITE_DATA:
                begin
                    if (go_to_WDATA_WAIT_FOR_BVALID)
                        wdata_state <= WDATA_WAIT_FOR_BVALID;
                end

                WDATA_WAIT_FOR_BVALID:
                begin
                    if (last_wrsp)
                        wdata_state <= WDATA_IDLE;
                    else if (!DIAG_EFFICIENCY_TEST_MODE && last_wrsp_current_loop)
                        wdata_state <= WDATA_WRITE_DATA;
                end
                default:
                begin
                    wdata_state <= WDATA_IDLE;
                end

            endcase
        end
    end

    // Read Command FSM
    always @(posedge clk)
    begin
        if (rst) begin
            rcmd_state <= RCMD_IDLE;
        end
        else begin
            case (rcmd_state)

                RCMD_IDLE:
                begin
                    if (start && have_reads)
                        if (!DIAG_EFFICIENCY_TEST_MODE && have_writes_r)
                            rcmd_state <= RCMD_WAIT_FOR_WRITES;
                        else
                            rcmd_state <= RCMD_READ;
                end

                RCMD_WAIT_FOR_WRITES:
                begin
                    if ((!DIAG_EFFICIENCY_TEST_MODE && (rcmd_diff_loop_counter > wrsp_diff_loop_counter)) ||
                                         (DIAG_EFFICIENCY_TEST_MODE && wrsp_diff_loop_counter == 0))
                        rcmd_state <= RCMD_READ;
                end

                RCMD_READ:
                begin
                    if (last_rcmd)
                        rcmd_state <= RCMD_IDLE;
                    else if ((!DIAG_EFFICIENCY_TEST_MODE && last_rcmd_current_loop) || (DIAG_EFFICIENCY_TEST_MODE && last_rcmd_loop))
                        rcmd_state <= RCMD_WAIT_FOR_WRITES;
                end
                default:
                begin
                    rcmd_state <= RCMD_IDLE;
                end
            endcase
        end
    end

   assign waitrequest   = (wcmd_state[1] || wdata_state[1] || rcmd_state[1] );
   assign wcmd_req      = (wcmd_diff_loop_counter_gt_0==1'b1) && (wcmd_state == WCMD_WRITE);
   assign wdata_req     = (wdata_diff_loop_counter_gt_0==1'b1) && (wdata_state == WDATA_WRITE_DATA);
   assign rcmd_req      = (rcmd_diff_loop_counter_gt_0==1'b1) && (rcmd_state == RCMD_READ);

endmodule

module altera_hbm_tg_axi_operation_handler #(
    parameter AMM_BURSTCOUNT_WIDTH      = "",
    parameter RPT_COUNT_WIDTH           = "",
    parameter OPERATION_COUNT_WIDTH     = "",
    parameter LOOP_COUNT_WIDTH          = ""
)(
    input                                   clk,
    input                                   rst,
    //Signal from configuration registers
    input [AMM_BURSTCOUNT_WIDTH-1:0]        burstlength,
    input [RPT_COUNT_WIDTH-1:0]             num_same_addr,
    input [OPERATION_COUNT_WIDTH-1:0] 		num_diff_addr,
    input [LOOP_COUNT_WIDTH-1:0]            num_diff_loop,
    input                                   load,

    //Signal from high level module to enable the counting
    input                                   enable,

    //Signal to high level module to indicate current counter value
    output reg [AMM_BURSTCOUNT_WIDTH-1:0]  	burst_counter,
    output reg [RPT_COUNT_WIDTH-1:0]        same_addr_counter,
    output reg [OPERATION_COUNT_WIDTH-1:0] 	diff_addr_counter,

 (* altera_attribute = "-name FORCE_HYPER_REGISTER_FOR_PERIPHERY_CORE_TRANSFER ON " *)
    output reg [LOOP_COUNT_WIDTH-1:0]       diff_loop_counter,

    //Signals to high level module to indicate current counter reaching certain value
    output                                  next_cycle_enable,
    output                                  next_bursts_enable,
    output                                  next_addr_enable,
    output logic                            diff_loop_counter_gt_0,
    output logic                            burst_counter_dec_en,
    output logic                            same_addr_counter_dec_en,
    output logic                            diff_addr_counter_dec_en,
    output logic                            diff_loop_counter_dec_en,

    //Signal to high level module to indicate counter is not empty
    output                                  have_operations
);
    timeunit 1ns;
    timeprecision 1ps;

    logic burstlength_gt_1;
    logic num_same_addr_gt_1;
    logic num_diff_addr_gt_1;
    logic num_diff_addr_gt_0;
    logic num_diff_loop_gt_1;
    
    reg     diff_addr_counter_msb_gt_1;
    reg     same_addr_counter_msb_gt_1;
    reg     diff_loop_counter_msb_gt_1;

    reg enable_r;
    always @ (posedge clk)  begin
      enable_r <= enable;
    end

    always @ (posedge clk)
    begin
            if (load) begin    
                burst_counter      <= burstlength;
                same_addr_counter  <= num_same_addr;
                diff_addr_counter  <= num_diff_addr;
            end else begin


                if (enable) begin   
                    if (burst_counter_dec_en) begin
                        burst_counter <= burst_counter - 1'b1;
                    end else begin
                        burst_counter <= burstlength;
                        if (same_addr_counter_dec_en) begin
                            same_addr_counter <= same_addr_counter - 1'b1;
                        end else begin
                            same_addr_counter <= num_same_addr;
                            if (diff_addr_counter_dec_en) begin
                                diff_addr_counter <= diff_addr_counter - 1'b1;
                            end else begin
                                diff_addr_counter <= num_diff_addr;
                            end
                        end
                    end
                end

            end
   end

    always @ (posedge clk) begin
        num_same_addr_gt_1   <= num_same_addr>'d1;
        num_diff_addr_gt_1   <= num_diff_addr>'d1;
        num_diff_addr_gt_0   <= num_diff_addr>'d0;
        num_diff_loop_gt_1   <= num_diff_loop>'d1;
    end
    assign burstlength_gt_1   = burstlength>'d1;

    always @ (posedge clk) begin
      if ( load ) begin
        same_addr_counter_msb_gt_1 <= |num_same_addr[RPT_COUNT_WIDTH-1:2];
        diff_addr_counter_msb_gt_1 <= |num_diff_addr[OPERATION_COUNT_WIDTH-1:2];
        diff_loop_counter_msb_gt_1 <= |num_diff_loop[LOOP_COUNT_WIDTH-1:2];
      end
      else begin
        same_addr_counter_msb_gt_1 <= |same_addr_counter[RPT_COUNT_WIDTH-1:2];
        diff_addr_counter_msb_gt_1 <= |diff_addr_counter[OPERATION_COUNT_WIDTH-1:2];
        diff_loop_counter_msb_gt_1 <= |diff_loop_counter[LOOP_COUNT_WIDTH-1:2];
      end
    end

    logic                            same_addr_counter_dec_en_r;
    logic                            diff_addr_counter_dec_en_r;
    logic                            diff_loop_counter_dec_en_r;    

    always @ (posedge clk) begin
        if (rst) begin
            same_addr_counter_dec_en_r <= '0;
            diff_addr_counter_dec_en_r <= '0;
            diff_loop_counter_dec_en_r <= '0;
        end else begin
            same_addr_counter_dec_en_r <= same_addr_counter_dec_en;
            diff_addr_counter_dec_en_r <= diff_addr_counter_dec_en;
            diff_loop_counter_dec_en_r <= diff_loop_counter_dec_en;
        end                                                                             
    end

    always @ (posedge clk) begin
        if ( load ) begin
          burst_counter_dec_en     <= burstlength_gt_1;
          same_addr_counter_dec_en <= num_same_addr_gt_1;
          diff_addr_counter_dec_en <= num_diff_addr_gt_1;
          diff_loop_counter_dec_en <= num_diff_loop_gt_1;
        end
        else if ( enable ) begin
          burst_counter_dec_en     <= (burst_counter>'d2)     | (~burst_counter_dec_en &     burstlength_gt_1);
          if ( ~burst_counter_dec_en ) begin
            same_addr_counter_dec_en <= (same_addr_counter[2:0]>'d2) | same_addr_counter_msb_gt_1 | (~(same_addr_counter_dec_en &&  same_addr_counter_dec_en_r) & num_same_addr_gt_1);
            if ( ~same_addr_counter_dec_en ) begin
              diff_addr_counter_dec_en <= (diff_addr_counter[2:0] > 'd2) | diff_addr_counter_msb_gt_1 | (~(diff_addr_counter_dec_en && diff_addr_counter_dec_en_r) & num_diff_addr_gt_1);
              if ( ~diff_addr_counter_dec_en ) 
                diff_loop_counter_dec_en <= (diff_loop_counter[2:0] > 'd2) | diff_loop_counter_msb_gt_1;
            end
          end
        end
    end

    always @ (posedge clk)
    begin
            if (load) begin    
                diff_loop_counter <= num_diff_addr_gt_0 ? num_diff_loop : '0;   

                if ( num_diff_loop>0 )
                  diff_loop_counter_gt_0              <= 1'b1;
                else
                  diff_loop_counter_gt_0              <= 1'b0;

            end else begin

                if (enable) begin   

                    if (~burst_counter_dec_en & ~same_addr_counter_dec_en & ~diff_addr_counter_dec_en ) begin
                                if (diff_loop_counter_dec_en) begin
                                    diff_loop_counter <= diff_loop_counter - 1'b1;
                                end else begin
                                    diff_loop_counter                   <= 0;
                                    diff_loop_counter_gt_0              <= 1'b0;
                                end
                    end
                end

            end
   end

   assign next_cycle_enable     = enable;
   assign next_bursts_enable    = (burst_counter == 1);
   assign next_addr_enable      = enable & (same_addr_counter == 1'b1);
   assign have_operations       = (num_same_addr > 0) && (num_diff_addr > 0) && (num_diff_loop > 0);

endmodule


