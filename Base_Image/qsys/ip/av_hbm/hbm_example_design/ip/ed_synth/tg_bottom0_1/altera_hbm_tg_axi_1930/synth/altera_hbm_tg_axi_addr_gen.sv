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


//////////////////////////////////////////////////////////////////////////////
// This module is a wrapper for the address generators.  The generators'
// outputs are multiplexed in this module using the select signals.
// The address generation modes are sequential (from a given start address),
// random, random sequential which produces sequential addresses from a
// random start address, and one-hot
//////////////////////////////////////////////////////////////////////////////
module altera_hbm_tg_axi_addr_gen # (
   parameter ADDRESS_WIDTH               = "",
   parameter AMM_BURSTCOUNT_WIDTH        = "",
   // width of the row address bits
   parameter ROW_ADDR_WIDTH              = "",
   //bit location of the LSB of the row address within the total address
   parameter ROW_ADDR_LSB                = "",

   parameter SEQ_CNT_WIDTH               = "",
   parameter RAND_SEQ_CNT_WIDTH          = "",
   parameter SEQ_ADDR_INCR_WIDTH         = "",

   parameter PORT_AXI_RID_WIDTH          = "",
   parameter MAX_ID                      = "",

   parameter SID_ADDR_WIDTH             = "",
   parameter SID_ADDR_LSB               = "",
   parameter BANK_ADDR_WIDTH             = "",
   parameter BANK_ADDR_LSB               = "",
   parameter BANK_GROUP_WIDTH            = "",
   parameter BANK_GROUP_LSB              = "",
   parameter SID_ADDR_WIDTH_LOCAL       = "",
   parameter BANK_GROUP_WIDTH_LOCAL      = "",
   parameter BURST_COUNT_DIVISIBLE_BY    = "",
   parameter WORD_ADDRESS_DIVISIBLE_BY   = "",
   parameter DIAG_EFFICIENCY_TEST_MODE   = "",
   parameter DIAG_HBMC_TEST_MODE         = "",
   parameter HBM_LFSR                    = "",
   parameter WRITE_GEN                   = "",
   parameter TG_USE_EFFICIENCY_PATTERN   = "",
   parameter ENABLE_DATA_CHECK           = ""
) (
   // Clock and reset
   input                                 clk,
   input                                 rst,

   // Control and status
   input                                 enable,

   input                                 start,
   input [ADDRESS_WIDTH-1:0]             start_addr,
   input [1:0]                           addr_gen_mode,
   input [PORT_AXI_RID_WIDTH-1:0]   rid,
   input                            rvalid,

   //for sequential mode
   input                                 seq_return_to_start_addr,
   input [SEQ_CNT_WIDTH-1:0]             seq_addr_num,

   //for random sequential mode
   input [RAND_SEQ_CNT_WIDTH-1:0]        rand_seq_num_seq_addr,
   input initialization_phase,

   //increment size for sequential and random sequential addressing
   //increments avalon address
   input [SEQ_ADDR_INCR_WIDTH-1:0]       seq_addr_increment,

   // Address generator outputs
   output logic [ADDRESS_WIDTH-1:0]       addr_out,
   output logic [PORT_AXI_RID_WIDTH-1:0]  id_out,

   input [1:0] sid_mask_en,
   input [1:0] bank_mask_en,
   input [1:0] row_mask_en,
   input [1:0] bankgroup_mask_en,
   input [SID_ADDR_WIDTH_LOCAL-1:0]  sid_mask,
   input [BANK_ADDR_WIDTH-1:0]  bank_mask,
   input [ROW_ADDR_WIDTH-1:0]   row_mask,
   input [BANK_GROUP_WIDTH_LOCAL-1:0] bankgroup_mask,
   input [AMM_BURSTCOUNT_WIDTH-1:0] burstcount
);
   timeunit 1ns;
   timeprecision 1ps;

   import tg_axi_defs::*;

   logic [ADDRESS_WIDTH-1:0]      addr;

   // Sequential address generator signals
   logic                          seq_addr_gen_enable;
   logic [ADDRESS_WIDTH-1:0]      seq_addr_gen_addr;
   logic [ADDRESS_WIDTH-1:0]      seq_start_addr;

   // Random address generator signals
   logic                          rand_addr_gen_enable;
   logic [ADDRESS_WIDTH-1:0]      rand_addr_gen_addr;

   //one-hot address generator signals
   logic                          one_hot_addr_gen_enable;
   logic [ADDRESS_WIDTH-1:0]      one_hot_addr_gen_addr;

   always_comb
   begin
      case (addr_gen_mode)
         TG_ADDR_SEQ:
         begin
            addr  = seq_addr_gen_addr;
         end
         TG_ADDR_RAND:
         begin
            addr  = rand_addr_gen_addr;
         end
         TG_ADDR_ONE_HOT:
         begin
            addr = one_hot_addr_gen_addr;
         end
         TG_ADDR_RAND_SEQ:
         begin
            addr  = rand_addr_gen_addr;
         end
         default: addr = 'x;
      endcase
   end

   // Address generator inputs
   assign seq_addr_gen_enable      = enable & (addr_gen_mode == TG_ADDR_SEQ);
   assign rand_addr_gen_enable     = enable & (addr_gen_mode == TG_ADDR_RAND || addr_gen_mode == TG_ADDR_RAND_SEQ);
   assign one_hot_addr_gen_enable  = enable & (addr_gen_mode == TG_ADDR_ONE_HOT);

   //the sequential start address should be the input start address for sequential mode
   assign seq_start_addr = start_addr;

   //masking for constraining or cycling row, bank, sid, bank group (DDR4)
   logic [ROW_ADDR_WIDTH-1:0] row_mask_reg;
   logic [BANK_ADDR_WIDTH-1:0] bank_mask_reg;
   logic [SID_ADDR_WIDTH_LOCAL-1:0] sid_mask_reg;
   logic [BANK_GROUP_WIDTH_LOCAL-1:0] bankgroup_mask_reg;

   always_ff @ (posedge clk)
   begin
      if (rst || start) begin
         row_mask_reg       <= row_mask;
         bank_mask_reg      <= bank_mask;
         sid_mask_reg       <= sid_mask;
         bankgroup_mask_reg <= bankgroup_mask;
      end
      else if (enable) begin
         if (sid_mask_en == TG_MASK_FULL_CYCLING) begin
            sid_mask_reg <= sid_mask_reg + 1'b1;
         end
         //bank cycling
         //option of cycling all banks (8) or just 3 for improved efficiency since
         //only 3 banks can remain open at once
         if (bank_mask_en & TG_MASK_FULL_CYCLING) begin
            //default to cycling all banks
            bank_mask_reg <= bank_mask_reg + 1'b1;
            //go back to starting bank after 3 if enabled
            if (bank_mask_en == TG_MASK_PARTIAL_CYCLING && bank_mask_reg == bank_mask + 2'h2) begin
               bank_mask_reg <= bank_mask;
            end
         end
         if (row_mask_en == TG_MASK_FULL_CYCLING) begin
            row_mask_reg <= row_mask_reg + 1'b1;
         end
         if (bankgroup_mask_en == TG_MASK_FULL_CYCLING) begin
            bankgroup_mask_reg <= bankgroup_mask_reg + 1'b1;
         end
      end
   end
   //apply masks
   integer i;
   always @ (*) begin
      for (i = 0; i < ADDRESS_WIDTH; i = i + 1) begin
         if (i >= SID_ADDR_LSB && i < SID_ADDR_LSB + SID_ADDR_WIDTH) begin
           addr_out[i] = (sid_mask_en == TG_MASK_DISABLED) ? addr[i] : sid_mask_reg[i - SID_ADDR_LSB];
         end else if (i >= ROW_ADDR_LSB && i < ROW_ADDR_LSB + ROW_ADDR_WIDTH) begin
           addr_out[i] = (row_mask_en == TG_MASK_DISABLED) ? addr[i] : row_mask_reg[i - ROW_ADDR_LSB];
         end else if (i >= BANK_ADDR_LSB && i < BANK_ADDR_LSB + BANK_ADDR_WIDTH) begin
           addr_out[i] = (bank_mask_en == TG_MASK_DISABLED) ? addr[i] : bank_mask_reg[i - BANK_ADDR_LSB];
         end else if (i >= BANK_GROUP_LSB && i < BANK_GROUP_LSB + BANK_GROUP_WIDTH) begin
           addr_out[i] = (bankgroup_mask_en == TG_MASK_DISABLED) ? addr[i] : bankgroup_mask_reg[i - BANK_GROUP_LSB];
         end else begin
           addr_out[i] = addr[i];
         end
      end
   end

   // Sequential address generator
   altera_hbm_tg_axi_seq_addr_gen # (
      .ADDR_WIDTH                  (ADDRESS_WIDTH),
      .SEQ_CNT_WIDTH               (SEQ_CNT_WIDTH),
      .SEQ_ADDR_INCR_WIDTH         (SEQ_ADDR_INCR_WIDTH),
      .WORD_ADDRESS_DIVISIBLE_BY   (WORD_ADDRESS_DIVISIBLE_BY),
      .BURST_COUNT_DIVISIBLE_BY    (BURST_COUNT_DIVISIBLE_BY)
   ) seq_addr_gen_inst (
      .clk                          (clk),
      .rst                          (rst),
      .enable                       (seq_addr_gen_enable),
      .seq_addr                     (seq_addr_gen_addr),
      .start_addr                   (seq_start_addr),
      .start                        (start),
      .return_to_start_addr         (seq_return_to_start_addr),
      .seq_addr_increment           (seq_addr_increment),
      .num_seq_addr                 (seq_addr_num)
   );

   // Random address generator
   altera_hbm_tg_axi_rand_seq_addr_gen # (
      .ADDR_WIDTH                  (ADDRESS_WIDTH),
      .AMM_BURSTCOUNT_WIDTH        (AMM_BURSTCOUNT_WIDTH),
      .SEQ_ADDR_INCR_WIDTH         (SEQ_ADDR_INCR_WIDTH),
      //width for number of sequential addresses between each random address
      .NUM_SEQ_ADDR_WIDTH          (RAND_SEQ_CNT_WIDTH),
      .WORD_ADDRESS_DIVISIBLE_BY   (WORD_ADDRESS_DIVISIBLE_BY),
      .BURST_COUNT_DIVISIBLE_BY    (BURST_COUNT_DIVISIBLE_BY),
      .DIAG_EFFICIENCY_TEST_MODE   (DIAG_EFFICIENCY_TEST_MODE),
      .DIAG_HBMC_TEST_MODE         (DIAG_HBMC_TEST_MODE),
      .HBM_LFSR                     (HBM_LFSR),
      .WRITE_GEN                   (WRITE_GEN),
      .TG_USE_EFFICIENCY_PATTERN   (TG_USE_EFFICIENCY_PATTERN)
   ) rand_seq_addr_gen_inst (
      .clk                          (clk),
      .rst                          (rst),
      .enable                       (rand_addr_gen_enable),
      .addr_out                     (rand_addr_gen_addr),
      .start                        (start),
      .initialization_phase(initialization_phase),
      //number of sequential addresses between each random address
      //for full random mode, set to 1
      .num_seq_addr                 (addr_gen_mode == TG_ADDR_RAND_SEQ ? rand_seq_num_seq_addr : 1'b1 ),
      //increment size for sequential addresses
      .seq_addr_increment           (seq_addr_increment),
      .burstcount                   (burstcount)
   );

   altera_hbm_tg_axi_one_hot_addr_gen # (
      .ADDR_WIDTH                  (ADDRESS_WIDTH),
      .AMM_WORD_ADDRESS_WIDTH      (ADDRESS_WIDTH),
      .WORD_ADDRESS_DIVISIBLE_BY   (WORD_ADDRESS_DIVISIBLE_BY),
      .BURST_COUNT_DIVISIBLE_BY    (BURST_COUNT_DIVISIBLE_BY)
   ) one_hot_addr_gen_inst (
      .clk                          (clk),
      .rst                          (rst),
      .enable                       (one_hot_addr_gen_enable),
      .one_hot_addr                 (one_hot_addr_gen_addr),
      .start                        (start)
   );

   altera_hbm_tg_axi_rwid_gen #(
      .PORT_AXI_RID_WIDTH  (PORT_AXI_RID_WIDTH),
      .MAX_ID                      (MAX_ID),
      .WRITE_GEN                   (WRITE_GEN),
      .TG_USE_EFFICIENCY_PATTERN   (TG_USE_EFFICIENCY_PATTERN),
      .ENABLE_DATA_CHECK           (ENABLE_DATA_CHECK)
   ) rwid_gen_inst (
      .clk                 (clk),
      .rst                 (rst),
      .enable              (enable),
      .rvalid              (rvalid),
      .rid                 (rid),      
      .start               (start),
      .id_out              (id_out)
   );

endmodule

