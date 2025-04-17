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
// The sequential address generator generates sequential addresses starting
// with a parametrizable address. There is an option to return to the start
// address after a configurable number of sequential addresses.
//////////////////////////////////////////////////////////////////////////////
module altera_hbm_tg_axi_seq_addr_gen # (
   parameter ADDR_WIDTH                      = "",
   parameter SEQ_CNT_WIDTH                   = "",
   parameter SEQ_ADDR_INCR_WIDTH             = "",
   parameter BURST_COUNT_DIVISIBLE_BY    = "",
   parameter WORD_ADDRESS_DIVISIBLE_BY   = ""
) (
   // Clock and reset
   input                                 clk,
   input                                 rst,

   // Control and status
   input                                 enable,

   input                                 start,
   input [ADDR_WIDTH-1:0]                start_addr,

   input                                 return_to_start_addr,
   input [SEQ_CNT_WIDTH-1:0]             num_seq_addr,
   //increment size for sequential addresses
   input [SEQ_ADDR_INCR_WIDTH-1:0]       seq_addr_increment,

   // Address generator outputs
   output logic [ADDR_WIDTH-1:0]         seq_addr
);
   timeunit 1ns;
   timeprecision 1ps;

   localparam MAX_PARAM_WIDTH = (ADDR_WIDTH > 32) ? 32 : ADDR_WIDTH;

   logic [SEQ_CNT_WIDTH-1:0]              addr_cntr;
   logic [ADDR_WIDTH-1:0]                 word_addr_divisible_by;
   logic [ADDR_WIDTH-1:0]                 seq_addr_raw;

   // This value will be used to round the address to its nearest multiple
   assign word_addr_divisible_by = (ADDR_WIDTH > 32) ? {(ADDR_WIDTH){1'b0}} | WORD_ADDRESS_DIVISIBLE_BY[MAX_PARAM_WIDTH-1:0] : WORD_ADDRESS_DIVISIBLE_BY[ADDR_WIDTH-1:0];

   // Sequential address generation
   always_ff @(posedge clk)
   begin
      //go back to start address when starting a new test run
      if (rst || start) begin
         // Make address divisible by WORD_ADDRESS_DIVISIBLE_BY (which must be a power of 2)
         // Round down, because it's simpler and faster.
         seq_addr_raw <= start_addr;
         addr_cntr <= num_seq_addr;
      end
      else if (enable) begin
         seq_addr_raw   <= seq_addr + seq_addr_increment;
         addr_cntr      <= addr_cntr - 1'b1;
         if (return_to_start_addr && addr_cntr==1) begin
            addr_cntr         <= num_seq_addr;
            seq_addr_raw      <= start_addr;
         end
      end
   end

   assign seq_addr = ~(word_addr_divisible_by - 1'b1) & seq_addr_raw;

endmodule


