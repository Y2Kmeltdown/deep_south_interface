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


module altera_hbm_tg_axi_reset_sync # (
   parameter RESET_SYNC_STAGES          = 4,
   parameter NUM_RESET_OUTPUT           = 1
) (
   input  logic                         reset_n,
   input  logic                         clk,
   output logic [NUM_RESET_OUTPUT-1:0]  reset_n_sync
);
   timeunit 1ns;
   timeprecision 1ps;

   (* altera_attribute = "-name FORCE_HYPER_REGISTER_FOR_PERIPHERY_CORE_TRANSFER ON; -name GLOBAL_SIGNAL OFF" *)
   
   reg [RESET_SYNC_STAGES+NUM_RESET_OUTPUT+1:0] reset_reg /* synthesis dont_merge  */;

   // synthesis translate_off
   initial begin
      if (RESET_SYNC_STAGES <2) begin
         $display("%m: Error: reset synchronizer length: %0d less than 2.", RESET_SYNC_STAGES);
      end
   end

`ifdef __ALTERA_STD__METASTABLE_SIM

   reg[31:0]  RANDOM_SEED = 123456;
   wire       next_reset_reg0_s1;
   reg        reset_reg0_last = 1'b0;
   reg        random = 1'b0;
   event      metastable_event; 

   initial begin
      $display("%m: Info: Metastable event injection simulation mode enabled");
   end

   always @(posedge clk) begin
      if (reset_n == 0)
        random <= $random(RANDOM_SEED);
      else
        random <= $random;
   end

   always @(posedge clk) begin
      reset_reg0_last <= reset_n;
   end

   assign next_reset_reg0_s1 = (reset_reg0_last ^ reset_n) ? random : reset_n;

   always @(posedge clk) begin
      reset_reg[0] <= next_reset_reg0_s1;
   end

`else

   // synthesis translate_on
     //reset first stage asyncronously
     always @(posedge clk ) begin
       reset_reg[0] <= reset_n;
     end
   // synthesis translate_off

`endif

`ifdef __ALTERA_STD__METASTABLE_SIM_VERBOSE
   always @(*) begin
      if ((reset_reg0_last != reset_n) && (random != reset_n)) begin
         $display("%m: Verbose Info: metastable event @ time %t", $time);
         ->metastable_event;
      end
   end
`endif

   // synthesis translate_on

   generate
   genvar i;
      for (i=1; i<RESET_SYNC_STAGES+NUM_RESET_OUTPUT+2; i=i+1)
      begin: reset_stage
         always @(posedge clk) begin
              reset_reg[i] <= reset_reg[i-1];
         end
      end
   endgenerate

   assign reset_n_sync = reset_reg[RESET_SYNC_STAGES+NUM_RESET_OUTPUT+1];
endmodule
