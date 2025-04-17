// (C) 2001-2019 Intel Corporation. All rights reserved.
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


//This is a sample driver control block for the traffic generator
//It coordinates the issuing of individual test stages, each of which will perform
//their own configuration of the traffic generator specific to a certain test case
//New test stages can easily be added
module altera_hbm_tg_axi_bringup_dcb #(
   parameter NUMBER_OF_DATA_GENERATORS    = "",
   parameter NUMBER_OF_BYTE_EN_GENERATORS = "",
   parameter DATA_PATTERN_LENGTH          = "",
   parameter BYTE_EN_PATTERN_LENGTH       = "",
   parameter USE_BYTE_EN                  = "",
   parameter USE_MMR_EN                   = 0,
   parameter MMR_LINK                     = 0,
   parameter MEM_ADDR_WIDTH               = "",
   parameter BURSTCOUNT_WIDTH             = "",
   parameter TG_TEST_DURATION             = "SHORT",
   parameter PORT_TG_CFG_ADDRESS_WIDTH    = 1,
   parameter PORT_TG_CFG_RDATA_WIDTH      = 1,
   parameter PORT_TG_CFG_WDATA_WIDTH      = 1,
   parameter WRITE_GROUP_WIDTH            = 1,
   parameter DIAG_BYPASS_DEFAULT_PATTERN  = 0,
   parameter DIAG_BYPASS_USER_STAGE       = 0,
   parameter DIAG_BYPASS_REPEAT_STAGE     = 1,
   parameter DIAG_BYPASS_STRESS_STAGE     = 1,
   parameter DIAG_HBMC_TEST_MODE          = 0,
   parameter DIAG_MIXED_TRAFFIC           = 0,
   parameter SEED_OFFSET                  = 0,
   parameter BURST_COUNT_DIVISIBLE_BY     = 1,
   parameter BURST_LEN                    = 1,
   parameter DIAG_HBMC_TEST_PATTERN       = 0,
   parameter CFG_TG_READ_COUNT            = 0,
   parameter CFG_TG_WRITE_COUNT           = 0,
   parameter CFG_TG_SEQUENCE              = "",
   parameter TG_USE_EFFICIENCY_PATTERN    = "",
   parameter NUM_OF_PATTERNS              = 2,
  parameter RD_RATIO_1  = "",
  parameter RD_RATIO_2  = "",
  parameter RD_RATIO_3  = "",
  parameter RD_RATIO_4  = "",
  parameter RD_RATIO_5  = "",
  parameter RD_RATIO_6  = "",
  parameter RD_RATIO_7  = "",
  parameter RD_RATIO_8  = "",
  parameter RD_RATIO_9  = "",
  parameter RD_RATIO_10 = "",
  parameter RD_RATIO_11 = "",
  parameter RD_RATIO_12 = "",
  parameter RD_RATIO_13 = "",
  parameter RD_RATIO_14 = "",
  parameter RD_RATIO_15 = "",
  parameter RD_RATIO_16 = "",
  parameter RD_RATIO_17 = "",
  parameter RD_RATIO_18 = "",
  parameter RD_RATIO_19 = "",
  parameter WR_RATIO_1  = "",
  parameter WR_RATIO_2  = "",
  parameter WR_RATIO_3  = "",
  parameter WR_RATIO_4  = "",
  parameter WR_RATIO_5  = "",
  parameter WR_RATIO_6  = "",
  parameter WR_RATIO_7  = "",
  parameter WR_RATIO_8  = "",
  parameter WR_RATIO_9  = "",
  parameter WR_RATIO_10 = "",
  parameter WR_RATIO_11 = "",
  parameter WR_RATIO_12 = "",
  parameter WR_RATIO_13 = "",
  parameter WR_RATIO_14 = "",
  parameter WR_RATIO_15 = "",
  parameter WR_RATIO_16 = "",
  parameter WR_RATIO_17 = "",
  parameter WR_RATIO_18 = "",
  parameter WR_RATIO_19 = "",
  parameter INIT_WRITE_PHASE_LENGTH      = "",
  parameter STATIC_RATIO_1  = ""
   )(
   input                        clk,
   input                        rst,
   input                        awready,
   input                        arready,

   output                                      amm_cfg_in_waitrequest,
   input  [PORT_TG_CFG_ADDRESS_WIDTH-1:0]      amm_cfg_in_address,
   input  [PORT_TG_CFG_WDATA_WIDTH-1:0]        amm_cfg_in_writedata,
   input                                       amm_cfg_in_write,
   input                                       amm_cfg_in_read,
   output [PORT_TG_CFG_RDATA_WIDTH-1:0]        amm_cfg_in_readdata,
   output                                      amm_cfg_in_readdatavalid,

   input                                       amm_cfg_out_waitrequest,
   output [PORT_TG_CFG_ADDRESS_WIDTH-1:0]      amm_cfg_out_address,
   output [PORT_TG_CFG_WDATA_WIDTH-1:0]        amm_cfg_out_writedata,
   output                                      amm_cfg_out_write,
   output                                      amm_cfg_out_read,
   input  [PORT_TG_CFG_RDATA_WIDTH-1:0]        amm_cfg_out_readdata,
   input                                       amm_cfg_out_readdatavalid,

   input                        restart_default_traffic,
   output                       all_tests_issued,
   output logic                 initialization_phase,
   output logic                 init_stage,

   output logic                 mmr_check_en,
   input                        mmr_check_done,
   input                        mmr_check_fail,
   //bring in the failure report from the status checker, so that it can be used in multi step tests
   //with multiple runs of the traffic generator
   input                        stage_failure,
   input [MEM_ADDR_WIDTH-1:0]   first_fail_addr,
   //output the final result at the end of all runs of the test stage
   output logic                 traffic_gen_fail

   );

   timeunit 1ns;
   timeprecision 1ps;

   import tg_axi_defs::*;

   localparam NUM_DRIVER_LOOP  = (TG_TEST_DURATION == "INFINITE") ? 0    :
                                 (TG_TEST_DURATION == "MEDIUM")   ? 524288 :
                                 (TG_TEST_DURATION == "SHORT")    ? 1    : 1;
   `ifdef GAB_ENABLE
      localparam IDLE_PERIOD = 100;
   `endif
   localparam RD_RATIO_INIT = 0            ; localparam WR_RATIO_INIT = INIT_WRITE_PHASE_LENGTH   ;
   logic [PORT_TG_CFG_WDATA_WIDTH    -1:0] write_ratio ;
   logic [PORT_TG_CFG_WDATA_WIDTH    -1:0] read_ratio  ;
   logic [$clog2(NUM_OF_PATTERNS)+(NUM_OF_PATTERNS%2):0] cnt_ptrn    ;
  `ifdef GAB_ENABLE
    logic [$clog2(IDLE_PERIOD)-1:0] cnt_idle;
  `endif

   // The burstcount is limited to keep the value reasonable for simulation purposes.
   localparam TG_MIN_BURSTCOUNT         = 1;
   localparam TG_MAX_BURSTCOUNT         = ((2**BURSTCOUNT_WIDTH < 64) ? 2**BURSTCOUNT_WIDTH : 64) - 1;

   // Test stages definition
   //if you use unsigned int 2 problems - only 2 state, and not recognized as state machine
   typedef enum logic [3:0] {
      INIT,
      DONE_DEFAULT_PATTERN,
      EFFMON_SNAPSHOT_STAGE,
      DONE,
      BYTEENABLE_STAGE,
      SINGLE_RW, BLOCK_RW,
      REPEAT_STAGE,
      STRESS_STAGE,
      HBMC_TEST_STAGE,
      WAIT_USER_STAGE,
      INIT_USER_STAGE,
      WAIT_FOR_TEST_COMPLETE,
      DONE_USER_LOOP,
      MMR_CHECK,
      MMR_CHECK_HANDLE
   } tst_stage_t;

   tst_stage_t stage;

   logic rst1,rst2a,rst2b; /* synthesis dont_merge */

   always_ff @(posedge clk)
   begin
      rst1   <= rst;
      rst2a   <= rst1;
      rst2b   <= rst1;
   end

   logic                 traffic_gen_fail_d;
   logic [4:0]           traffic_gen_fail_pipe;

   logic [22:0] loop_counter;

   reg [2:0]      wait_counter;

   // Byteenable stage signals
   wire [PORT_TG_CFG_ADDRESS_WIDTH-1:0] byteenable_test_stage_address;
   wire [PORT_TG_CFG_WDATA_WIDTH-1:0] byteenable_test_stage_writedata;
   wire byteenable_test_stage_write;
   wire byteenable_test_stage_read;
   wire byteenable_test_stage_complete;
   wire byteenable_test_stage_rand_num_en;

   //write/read stage signals
   wire [PORT_TG_CFG_ADDRESS_WIDTH-1:0] rw_stage_address;
   wire [PORT_TG_CFG_WDATA_WIDTH-1:0] rw_stage_writedata;
   wire rw_stage_write;
   wire rw_stage_read;
   wire rw_stage_complete;
   wire rw_stage_rand_num_en;

   logic                       rand_num_enable;
   wire [BURSTCOUNT_WIDTH-1:0] rand_burstcount;

   logic [PORT_TG_CFG_ADDRESS_WIDTH-1:0]            w_amm_cfg_address;
   logic [PORT_TG_CFG_WDATA_WIDTH-1:0]           w_amm_cfg_writedata;
   logic                  w_amm_cfg_write;
   logic                  w_amm_cfg_read;

   wire user_cfg_start;
   assign user_cfg_start = ~amm_cfg_in_waitrequest && amm_cfg_in_write && amm_cfg_in_address == TG_START;
   wire user_cfg_start_default;
   assign user_cfg_start_default = ~amm_cfg_in_waitrequest && amm_cfg_in_write && amm_cfg_in_address == TG_RESTART_DEFAULT_TRAFFIC;

   wire use_amm_cfg_in;
   logic use_amm_cfg_in_r;
   always_ff @(posedge clk) begin
      if (rst2a)
        use_amm_cfg_in_r <= 1'b1;
      else
        use_amm_cfg_in_r <= (stage == WAIT_USER_STAGE || stage == INIT_USER_STAGE || stage == DONE);
   end

   assign use_amm_cfg_in = use_amm_cfg_in_r;

   assign                 amm_cfg_in_waitrequest   = use_amm_cfg_in ? amm_cfg_out_waitrequest : '1;
   assign                 amm_cfg_out_address      = use_amm_cfg_in ? amm_cfg_in_address : w_amm_cfg_address;
   assign                 amm_cfg_out_writedata    = use_amm_cfg_in ? amm_cfg_in_writedata : w_amm_cfg_writedata;
   assign                 amm_cfg_out_write        = use_amm_cfg_in ? amm_cfg_in_write : w_amm_cfg_write;
   assign                 amm_cfg_out_read         = use_amm_cfg_in ? amm_cfg_in_read : w_amm_cfg_read;
   assign                 amm_cfg_in_readdata      = use_amm_cfg_in ? amm_cfg_out_readdata : '0;
   assign                 amm_cfg_in_readdatavalid = use_amm_cfg_in ? amm_cfg_out_readdatavalid : '0;

   integer i;

   always @ ( posedge clk ) begin
      if (rst2a) begin
        traffic_gen_fail_pipe        <= '0;
      end
      else begin
        traffic_gen_fail_pipe[0]          <= traffic_gen_fail_d;
        for ( i=1; i<5; i++ ) begin
          traffic_gen_fail_pipe[i]        <= traffic_gen_fail_pipe[i-1];
        end
      end
   end
   assign traffic_gen_fail = traffic_gen_fail_pipe[4];

   // Test stages signals mux
   always @ ( posedge clk ) begin
      if (rst2a) begin
        w_amm_cfg_address    <= '0;
        w_amm_cfg_writedata  <= '0;
        w_amm_cfg_write      <= 1'b0;
        w_amm_cfg_read       <= 1'b0;
        traffic_gen_fail_d   <= 1'b0;
        rand_num_enable      <= '0;
        mmr_check_en         <= '0;
      end
      else begin
        case (stage)
           BYTEENABLE_STAGE:
           begin
              w_amm_cfg_address   <= byteenable_test_stage_address;
              w_amm_cfg_writedata <= byteenable_test_stage_writedata;
              w_amm_cfg_write     <= byteenable_test_stage_write;
              w_amm_cfg_read      <= byteenable_test_stage_read;
              traffic_gen_fail_d  <= stage_failure;
              rand_num_enable     <= '0;
              mmr_check_en        <= '0;
           end
           SINGLE_RW, REPEAT_STAGE, BLOCK_RW, STRESS_STAGE, HBMC_TEST_STAGE:
           begin
              w_amm_cfg_address   <= rw_stage_address;
              w_amm_cfg_writedata <= rw_stage_writedata;
              w_amm_cfg_write     <= rw_stage_write;
              w_amm_cfg_read      <= rw_stage_read;
              traffic_gen_fail_d  <= stage_failure;
              rand_num_enable     <= rw_stage_rand_num_en;
              mmr_check_en        <= '0;
           end
           EFFMON_SNAPSHOT_STAGE:
           begin
              w_amm_cfg_address    <= TG_STOP_EFFMON;
              w_amm_cfg_writedata  <= '0;
              w_amm_cfg_write      <= (wait_counter == '0);
              w_amm_cfg_read       <= 1'b0;
              traffic_gen_fail_d   <= stage_failure;
              rand_num_enable      <= '0;
              mmr_check_en         <= '0;
           end
           WAIT_FOR_TEST_COMPLETE:
           begin
              w_amm_cfg_address    <= TG_TEST_COMPLETE;
              w_amm_cfg_writedata  <= '0;
              w_amm_cfg_write      <= 1'b0;
              w_amm_cfg_read       <= 1'b1;
              traffic_gen_fail_d   <= stage_failure;
              rand_num_enable      <= '0;
              mmr_check_en         <= '0;
           end
           MMR_CHECK:
           begin
              w_amm_cfg_address    <= '0;
              w_amm_cfg_writedata  <= '0;
              w_amm_cfg_write      <= 1'b0;
              w_amm_cfg_read       <= 1'b0;
              traffic_gen_fail_d   <= mmr_check_fail;
              rand_num_enable      <= '0;
              mmr_check_en         <= '1;
           end
           default:
           begin
              w_amm_cfg_address    <= '0;
              w_amm_cfg_writedata  <= '0;
              w_amm_cfg_write      <= 1'b0;
              w_amm_cfg_read       <= 1'b0;
              traffic_gen_fail_d   <= stage_failure;
              rand_num_enable      <= '0;
              mmr_check_en         <= '0;
           end
        endcase
      end
   end

   // Test stages state machine
   always_ff @(posedge clk)
   begin
      if (rst2a) begin
        stage            <= INIT;
        wait_counter     <= '0;
        if(TG_USE_EFFICIENCY_PATTERN) begin
          write_ratio      <= WR_RATIO_INIT;
          read_ratio       <= RD_RATIO_INIT;
          cnt_ptrn         <= 1;
          `ifdef GAB_ENABLE
            cnt_idle <= {(IDLE_PERIOD){1'b0}};
          `endif
          initialization_phase <= 1'b0;
        end
        else begin
          write_ratio  <= '0;
          read_ratio   <= '0;
          loop_counter <= '0;
        end
      end
      else begin
         case (stage)
            INIT:
            begin
               // Start test when controller is ready and efficiency monitor has been reset
               if(awready || arready) begin
                if (DIAG_BYPASS_DEFAULT_PATTERN && DIAG_BYPASS_REPEAT_STAGE && DIAG_BYPASS_STRESS_STAGE) begin
                  stage              <= WAIT_USER_STAGE;
                end
                else begin
                  if (DIAG_BYPASS_DEFAULT_PATTERN) begin
                    if (DIAG_BYPASS_REPEAT_STAGE) begin
                      stage <= STRESS_STAGE;
                    end
                    else begin
                      stage <= REPEAT_STAGE;
                    end
                    end
                    else begin
                      if (DIAG_HBMC_TEST_MODE) begin
                        stage <= HBMC_TEST_STAGE;
                      end else begin
                        stage <= DIAG_MIXED_TRAFFIC ? SINGLE_RW : BLOCK_RW;
                      end
                    end
                    if(TG_USE_EFFICIENCY_PATTERN) begin
                      init_stage <= 1'b0;
                    end
                    else begin
                      loop_counter <= loop_counter + 1'b1;
                    end
                  end
               end
            end

            HBMC_TEST_STAGE:
            begin
              if (rw_stage_complete)
                stage <= DONE_DEFAULT_PATTERN;
              end

            SINGLE_RW:
            begin
              if (rw_stage_complete)
                stage <= USE_BYTE_EN ? BYTEENABLE_STAGE : BLOCK_RW;
              end
            
            BYTEENABLE_STAGE:
            begin
              if (byteenable_test_stage_complete)
                stage <= BLOCK_RW;
            end

            BLOCK_RW:
            begin
              if (rw_stage_complete)
                stage <= DIAG_MIXED_TRAFFIC ? (DIAG_BYPASS_REPEAT_STAGE ? (DIAG_BYPASS_STRESS_STAGE ? DONE_DEFAULT_PATTERN : STRESS_STAGE) : REPEAT_STAGE) : DONE_DEFAULT_PATTERN;
            end

            REPEAT_STAGE:
            begin
               if (rw_stage_complete)
                stage <= DIAG_BYPASS_STRESS_STAGE ? DONE_DEFAULT_PATTERN : STRESS_STAGE;
            end

            STRESS_STAGE:
            begin
              if (rw_stage_complete)
                stage <= DONE_DEFAULT_PATTERN;
              end

            DONE_DEFAULT_PATTERN:
            begin
              if(TG_USE_EFFICIENCY_PATTERN) begin
                initialization_phase <= 1'b1;
                `ifdef GAB_ENABLE
                if(cnt_idle < IDLE_PERIOD) cnt_idle <= cnt_idle + 1'b1;
                else begin cnt_idle <= 'd0;
                `endif
                  if (cnt_ptrn < NUM_OF_PATTERNS+1) begin
                  stage <= INIT;
                  init_stage <= 1'b1;
                  if(STATIC_RATIO_1) cnt_ptrn <= 'd1;
                    else cnt_ptrn <= cnt_ptrn + 1'b1;
                    if(cnt_ptrn == 1 && NUM_OF_PATTERNS > 0 )begin       write_ratio <= WR_RATIO_1 ; read_ratio <= RD_RATIO_1 ; end
                    else if(cnt_ptrn == 2  && NUM_OF_PATTERNS > 1 )begin write_ratio <= WR_RATIO_2 ; read_ratio <= RD_RATIO_2 ; end
                    else if(cnt_ptrn == 3  && NUM_OF_PATTERNS > 2 )begin write_ratio <= WR_RATIO_3 ; read_ratio <= RD_RATIO_3 ; end
                    else if(cnt_ptrn == 4  && NUM_OF_PATTERNS > 3 )begin write_ratio <= WR_RATIO_4 ; read_ratio <= RD_RATIO_4 ; end
                    else if(cnt_ptrn == 5  && NUM_OF_PATTERNS > 4 )begin write_ratio <= WR_RATIO_5 ; read_ratio <= RD_RATIO_5 ; end
                    else if(cnt_ptrn == 6  && NUM_OF_PATTERNS > 5 )begin write_ratio <= WR_RATIO_6 ; read_ratio <= RD_RATIO_6 ; end
                    else if(cnt_ptrn == 7  && NUM_OF_PATTERNS > 6 )begin write_ratio <= WR_RATIO_7 ; read_ratio <= RD_RATIO_7 ; end
                    else if(cnt_ptrn == 8  && NUM_OF_PATTERNS > 7 )begin write_ratio <= WR_RATIO_8 ; read_ratio <= RD_RATIO_8 ; end
                    else if(cnt_ptrn == 9  && NUM_OF_PATTERNS > 8 )begin write_ratio <= WR_RATIO_9 ; read_ratio <= RD_RATIO_9 ; end
                    else if(cnt_ptrn == 10 && NUM_OF_PATTERNS > 9 )begin write_ratio <= WR_RATIO_10; read_ratio <= RD_RATIO_10; end
                    else if(cnt_ptrn == 11 && NUM_OF_PATTERNS > 10)begin write_ratio <= WR_RATIO_11; read_ratio <= RD_RATIO_11; end
                    else if(cnt_ptrn == 12 && NUM_OF_PATTERNS > 11)begin write_ratio <= WR_RATIO_12; read_ratio <= RD_RATIO_12; end
                    else if(cnt_ptrn == 13 && NUM_OF_PATTERNS > 12)begin write_ratio <= WR_RATIO_13; read_ratio <= RD_RATIO_13; end
                    else if(cnt_ptrn == 14 && NUM_OF_PATTERNS > 13)begin write_ratio <= WR_RATIO_14; read_ratio <= RD_RATIO_14; end
                    else if(cnt_ptrn == 15 && NUM_OF_PATTERNS > 14)begin write_ratio <= WR_RATIO_15; read_ratio <= RD_RATIO_15; end
                    else if(cnt_ptrn == 16 && NUM_OF_PATTERNS > 15)begin write_ratio <= WR_RATIO_16; read_ratio <= RD_RATIO_16; end
                    else if(cnt_ptrn == 17 && NUM_OF_PATTERNS > 16)begin write_ratio <= WR_RATIO_17; read_ratio <= RD_RATIO_17; end
                    else if(cnt_ptrn == 18 && NUM_OF_PATTERNS > 17)begin write_ratio <= WR_RATIO_18; read_ratio <= RD_RATIO_18; end
                    else if(cnt_ptrn == 19 && NUM_OF_PATTERNS > 18)begin write_ratio <= WR_RATIO_19; read_ratio <= RD_RATIO_19; end
                  end
                  else begin
                    write_ratio  <= '0;
                    read_ratio   <= '0;
                    wait_counter <= '0;
                    stage <= DIAG_BYPASS_USER_STAGE ?
                      EFFMON_SNAPSHOT_STAGE : WAIT_USER_STAGE;
                  end
                `ifdef GAB_ENABLE
                end
                `endif
              end
              else begin
                if (NUM_DRIVER_LOOP == 0) begin
                  // A setting of 0 means loop forever
                  stage <= INIT;
                end
                else if (loop_counter < NUM_DRIVER_LOOP) begin
                  // The loop limit has not yet been reached
                  stage <= INIT;
                end
                else begin
                  // Pass control to the amm_cfg_in interface, unless bypassed
                  wait_counter <= '0;
                  stage <= DIAG_BYPASS_USER_STAGE ? EFFMON_SNAPSHOT_STAGE : WAIT_USER_STAGE;
                end
              end
            end

            WAIT_USER_STAGE:
            begin
               if (user_cfg_start) begin
                  if(!TG_USE_EFFICIENCY_PATTERN)
                    loop_counter <= '0;
                  stage <= INIT_USER_STAGE;
               end
            end

            INIT_USER_STAGE:
            begin
               if(!TG_USE_EFFICIENCY_PATTERN) loop_counter         <= loop_counter + 1'b1;
               stage                <= WAIT_FOR_TEST_COMPLETE;
            end

            WAIT_FOR_TEST_COMPLETE:
            begin
               if (~amm_cfg_out_waitrequest) begin
                  if (amm_cfg_out_readdatavalid) begin
                     if (amm_cfg_out_readdata[0]) begin
                        stage <= DONE_USER_LOOP;
                     end
                  end
               end
            end

            DONE_USER_LOOP:
            begin
              if (NUM_DRIVER_LOOP == 0) begin
                stage                <= INIT_USER_STAGE;
              end else if ((loop_counter < NUM_DRIVER_LOOP) && !TG_USE_EFFICIENCY_PATTERN) begin
                stage                <= INIT_USER_STAGE;
              end else begin
                stage <= EFFMON_SNAPSHOT_STAGE;
              end
            end

            EFFMON_SNAPSHOT_STAGE:
            begin
               if (&wait_counter) begin
                  stage                <= DONE;
               end else begin
                  wait_counter <= wait_counter + 1'b1;
               end
            end

            MMR_CHECK_HANDLE:
            begin
            if(!TG_USE_EFFICIENCY_PATTERN) loop_counter <= '0;
               if (user_cfg_start) begin
                  stage <= INIT_USER_STAGE;
               end
               else if (user_cfg_start_default) begin
                  stage <= INIT;
                  if(TG_USE_EFFICIENCY_PATTERN)
                    init_stage <= 1'b1;
               end
               else if (USE_MMR_EN & MMR_LINK) begin
                  stage <= MMR_CHECK;
               end
               else begin
                  stage <= DONE;
               end
            end

            MMR_CHECK:
            begin
            if (mmr_check_done)
              stage <= DONE;
            end

            DONE:
            begin
              stage <= DONE;
            end
         endcase
      end
   end

   //status outputs
   assign all_tests_issued = (stage == DONE);

   // TEST STAGE MODULE INSTANTIATIONS
   // These modules should comply with the following protocol:
   // - when 'rst' is deasserted, it should idle and listen to 'stage_enable'
   // - it should proceed with the test operations when 'stage_enable' is asserted
   // - when the test completes, it should assert 'stage_complete' and properly
   //drive the stage failure output signal (usually just plugging back in the input stage failure
   //which comes from the status checker, unless it is a multi run test) -this could be done above

   altera_hbm_tg_axi_byteenable_test_stage #(
      .NUMBER_OF_DATA_GENERATORS    (NUMBER_OF_DATA_GENERATORS),
      .NUMBER_OF_BYTE_EN_GENERATORS (NUMBER_OF_BYTE_EN_GENERATORS),
      .DATA_PATTERN_LENGTH          (DATA_PATTERN_LENGTH),
      .BYTE_EN_PATTERN_LENGTH       (BYTE_EN_PATTERN_LENGTH),
      .TG_TEST_DURATION             (TG_TEST_DURATION),
      .BURSTCOUNT_WIDTH             (BURSTCOUNT_WIDTH),
      .MEM_ADDR_WIDTH               (MEM_ADDR_WIDTH),
      .SEED_OFFSET                  (SEED_OFFSET),
      .BURST_LEN        (BURST_LEN),
      .PORT_TG_CFG_ADDRESS_WIDTH    (PORT_TG_CFG_ADDRESS_WIDTH),
      .PORT_TG_CFG_RDATA_WIDTH      (PORT_TG_CFG_RDATA_WIDTH),
      .PORT_TG_CFG_WDATA_WIDTH      (PORT_TG_CFG_WDATA_WIDTH),
      .TG_USE_EFFICIENCY_PATTERN    (TG_USE_EFFICIENCY_PATTERN)
   ) byteenable_test_stage_inst(
      .clk                          (clk),
      .rst                          (rst2b),
      .enable                       ((stage==BYTEENABLE_STAGE)),
      .amm_cfg_waitrequest          (amm_cfg_out_waitrequest),
      .amm_cfg_address              (byteenable_test_stage_address),
      .amm_cfg_writedata            (byteenable_test_stage_writedata),
      .amm_cfg_write                (byteenable_test_stage_write),
      .amm_cfg_read                 (byteenable_test_stage_read),
      .amm_cfg_readdatavalid        (amm_cfg_out_readdatavalid),
      .amm_cfg_readdata             (amm_cfg_out_readdata),
      .stage_complete               (byteenable_test_stage_complete),
      .rand_burstcount_en           (byteenable_test_stage_rand_num_en),
      .rand_burstcount              (rand_burstcount)
   );

   //read/write test stages
   altera_hbm_tg_axi_rw_stage # (
      .TG_TEST_DURATION             (TG_TEST_DURATION),
      .NUMBER_OF_DATA_GENERATORS    (NUMBER_OF_DATA_GENERATORS),
      .NUMBER_OF_BYTE_EN_GENERATORS (NUMBER_OF_BYTE_EN_GENERATORS),
      .DATA_PATTERN_LENGTH          (DATA_PATTERN_LENGTH),
      .BYTE_EN_PATTERN_LENGTH       (BYTE_EN_PATTERN_LENGTH),
      .BURSTCOUNT_WIDTH             (BURSTCOUNT_WIDTH),
      .BURST_COUNT_DIVISIBLE_BY     (BURST_COUNT_DIVISIBLE_BY),
      .MEM_ADDR_WIDTH               (MEM_ADDR_WIDTH),
      .SEED_OFFSET                  (SEED_OFFSET),
      .BURST_LEN                    (BURST_LEN),
      .PORT_TG_CFG_ADDRESS_WIDTH    (PORT_TG_CFG_ADDRESS_WIDTH),
      .PORT_TG_CFG_RDATA_WIDTH      (PORT_TG_CFG_RDATA_WIDTH),
      .PORT_TG_CFG_WDATA_WIDTH      (PORT_TG_CFG_WDATA_WIDTH),
      .WRITE_GROUP_WIDTH            (WRITE_GROUP_WIDTH),
      .DIAG_HBMC_TEST_PATTERN       (DIAG_HBMC_TEST_PATTERN),
      .DIAG_MIXED_TRAFFIC           (DIAG_MIXED_TRAFFIC),
      .TG_USE_EFFICIENCY_PATTERN    (TG_USE_EFFICIENCY_PATTERN)
   ) rw_stage (
      .clk                             (clk),
      .rst                             (rst2b),
      .enable                          (stage == SINGLE_RW || stage == BLOCK_RW || stage == REPEAT_STAGE || stage == STRESS_STAGE || stage == HBMC_TEST_STAGE),
      .block_rw_mode                   (stage == BLOCK_RW),
      .repeat_mode                     (stage == REPEAT_STAGE),
      .stress_mode                     (stage == STRESS_STAGE),
      .efficiency_test_mode            (stage == HBMC_TEST_STAGE),
      .amm_cfg_waitrequest             (amm_cfg_out_waitrequest),
      .amm_cfg_address                 (rw_stage_address),
      .amm_cfg_writedata               (rw_stage_writedata),
      .amm_cfg_write                   (rw_stage_write),
      .amm_cfg_read                    (rw_stage_read),
      .amm_cfg_readdata                (amm_cfg_out_readdata),
      .amm_cfg_readdatavalid           (amm_cfg_out_readdatavalid),
      .stage_complete                  (rw_stage_complete),

      .write_ratio (write_ratio),
      .read_ratio  (read_ratio ),
      .rand_burstcount_en              (rw_stage_rand_num_en),
      .rand_burstcount                 (rand_burstcount)
   );

   //random number generator that the test stages can use to generate random burst lengths within a range
   altera_hbm_tg_axi_rand_num_gen # (
      .RAND_NUM_WIDTH               (BURSTCOUNT_WIDTH),
      .RAND_NUM_MIN                 (TG_MIN_BURSTCOUNT),
      .RAND_NUM_MAX                 (TG_MAX_BURSTCOUNT),
      .BURST_COUNT_DIVISIBLE_BY     (BURST_COUNT_DIVISIBLE_BY),
      .TG_USE_EFFICIENCY_PATTERN    (TG_USE_EFFICIENCY_PATTERN)
   ) rand_burstcount_gen (
      .clk               (clk),
      .rst               (rst2a),
      .enable            (rand_num_enable),
      .ready             (),
      .rand_num          (rand_burstcount)
      );

endmodule
