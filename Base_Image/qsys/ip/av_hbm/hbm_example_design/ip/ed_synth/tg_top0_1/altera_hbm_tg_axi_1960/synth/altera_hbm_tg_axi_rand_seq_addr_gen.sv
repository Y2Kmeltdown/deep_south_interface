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


//////////////////////////////////////////////////////////////////////////////
// The random sequential address generator generates sequential addresses from
// a random start address. The number of sequential addresses between each random
// address is configurable. This is set to 1 for full random mode.
// For simplicity in avoiding overlaps between sequential blocks, generate
// a random address for the upper part and zero the lower part.
//////////////////////////////////////////////////////////////////////////////
module altera_hbm_tg_axi_rand_seq_addr_gen # (
   //total width of generated address
   parameter ADDR_WIDTH                           = "",
   parameter AMM_BURSTCOUNT_WIDTH                 = "",
   parameter SEQ_ADDR_INCR_WIDTH                  = "",
   parameter NUM_SEQ_ADDR_WIDTH                   = "",
   parameter BURST_COUNT_DIVISIBLE_BY             = "",
   parameter WORD_ADDRESS_DIVISIBLE_BY            = "",
   parameter DIAG_EFFICIENCY_TEST_MODE            = "",
   parameter DIAG_HBMC_TEST_MODE                  = "",
   parameter HBM_LFSR                             = "",
   parameter WRITE_GEN                            = "",
   parameter TG_USE_EFFICIENCY_PATTERN            = "",
   parameter SEED                                 = 36'b000000111110000011110000111000110010
) (
   input                             clk,
   input                             rst,
   input                             enable,
   input                             start,

   //number of sequential addresses between each random address
   input [NUM_SEQ_ADDR_WIDTH-1:0]    num_seq_addr,
   input                             initialization_phase,
   //increment size for sequential addresses
   input [SEQ_ADDR_INCR_WIDTH-1:0]   seq_addr_increment,
   input [AMM_BURSTCOUNT_WIDTH-1:0]  burstcount,

   output logic [ADDR_WIDTH-1:0]     addr_out
);
   timeunit 1ns;
   timeprecision 1ps;
   import tg_axi_defs::*;

   localparam ZERO_PAD_WIDTH = log2(WORD_ADDRESS_DIVISIBLE_BY);
   localparam RAND_ADDR_WIDTH = ADDR_WIDTH - ZERO_PAD_WIDTH;
   localparam LOWER_ADDR_WIDTH = NUM_SEQ_ADDR_WIDTH - ZERO_PAD_WIDTH;
   localparam UPPER_ADDR_WIDTH = RAND_ADDR_WIDTH - LOWER_ADDR_WIDTH;

   logic [UPPER_ADDR_WIDTH-1:0]      upper_addr;
   logic [RAND_ADDR_WIDTH-1:0]       full_addr;
   logic [ADDR_WIDTH-1:0]            seq_addr;
   logic [ADDR_WIDTH-1:0]            hbmc_addr;
   logic [1:0]                       hbmc_ba;
   logic [4:0]                       hbmc_col;
   logic                             gen_rand_addr;
   logic [NUM_SEQ_ADDR_WIDTH-1:0]    seq_addr_cnt;
   logic [ADDR_WIDTH-1:0]            rand_addr_out;

   logic                             seq_addr_cnt_match;
   logic                             num_seq_addr_eq_1;

   assign rand_addr_out = {(DIAG_EFFICIENCY_TEST_MODE || (num_seq_addr_eq_1 && burstcount == 1'b1) || HBM_LFSR) ? full_addr : {upper_addr, {LOWER_ADDR_WIDTH{1'b0}}}, {ZERO_PAD_WIDTH{1'b0}}};

   assign hbmc_addr[0] = seq_addr_cnt[0];
   assign hbmc_addr[1] = (seq_addr_cnt <= (num_seq_addr >> 1));
   assign hbmc_addr[6:2] = hbmc_col + rand_addr_out[6:2];
   assign hbmc_addr[8:7] = hbmc_ba;
   assign hbmc_addr[ADDR_WIDTH-1 : 9] = rand_addr_out[ADDR_WIDTH-1 : 9];

   always_ff @ (posedge clk)
   begin
    //go back to start address when starting a new series of reads or writes
      if (rst || start) begin
         seq_addr_cnt <= num_seq_addr;
         seq_addr <= rand_addr_out;
         hbmc_ba <= WRITE_GEN ? 2'b10 : 2'b00;
         hbmc_col <= 5'b0;
      end
      else if (enable) begin
         seq_addr_cnt <= seq_addr_cnt - 1'b1;

         if (seq_addr_cnt == num_seq_addr) begin //prepare for next cycle
            seq_addr     <= rand_addr_out + seq_addr_increment;
         end
         else if (seq_addr_cnt > 1) begin
            seq_addr     <= seq_addr + seq_addr_increment;
         end
         if (seq_addr_cnt == 1) begin
            seq_addr_cnt <= num_seq_addr;
         end
         if (seq_addr_cnt == 1 || seq_addr_cnt == (num_seq_addr >> 1) + 1) begin
            hbmc_ba <= hbmc_ba + 1'b1;
         end
         if (seq_addr_cnt[0]) begin
            hbmc_col <= hbmc_col + 1'b1;
         end
      end
   end

   always_ff @ (posedge clk)
   begin

      seq_addr_cnt_match <= (num_seq_addr == 1) || ((seq_addr_cnt==1) & enable) || start || ((seq_addr_cnt == num_seq_addr) & ~enable);
      num_seq_addr_eq_1  <= (num_seq_addr == 1);
   end

      assign addr_out = DIAG_HBMC_TEST_MODE ? (num_seq_addr_eq_1 ? rand_addr_out : hbmc_addr) : seq_addr_cnt_match ? rand_addr_out : seq_addr ;

   assign gen_rand_addr = enable & (seq_addr_cnt <= 1);

   // LFSRs for random addresses
   altera_hbm_tg_axi_lfsr # (
      .WIDTH                     (UPPER_ADDR_WIDTH),
      .TG_USE_EFFICIENCY_PATTERN (TG_USE_EFFICIENCY_PATTERN)
   ) rand_addr_high (
      .clk       (clk),
      .rst       (rst),
      .enable    (gen_rand_addr),
      .initialization_phase(1'b0),
      .data      (upper_addr),
      .tg_start  (start)
   );

    generate
    if (HBM_LFSR == 1) begin
        altera_hbm_tg_axi_hbm_lfsr # (
            .LFSR_TYPE   ("AWORD"),
            .WIDTH       (30)
        ) rand_addr_full (
            .clk        (clk),
            .prst       (rst),
            .enable     (gen_rand_addr),
            .data       (full_addr),
            .tg_start   (start)
        );

    end else begin
        altera_hbm_tg_axi_lfsr # (
            .WIDTH     (RAND_ADDR_WIDTH),
            .SEED (TG_USE_EFFICIENCY_PATTERN? (WRITE_GEN? SEED  : ~SEED): SEED),
      	    .TG_USE_EFFICIENCY_PATTERN (TG_USE_EFFICIENCY_PATTERN)
        ) rand_addr_full (
            .clk       (clk),
            .rst       (rst),
            .enable    (gen_rand_addr),
            .initialization_phase(initialization_phase),
            .data      (full_addr),
            .tg_start  (start)
        );
    end
    endgenerate

endmodule
