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


module sync_bit
  #(
    parameter DWIDTH = 1,    // Sync Data input
    parameter RESET_VAL = 0  // Reset value
    )
    (
    input  logic              clk,     // clock
    input  logic              rst_n,   // async reset
    input  logic [DWIDTH-1:0] din,     // data in
    output logic [DWIDTH-1:0] dout     // data out
     );

   // Define wires/regs
  logic [(DWIDTH)-1:0] sync_regs_s1; /* synthesis preserve */
  logic [(DWIDTH)-1:0] sync_regs_s2; /* synthesis preserve */
  
  localparam reset_value = (RESET_VAL == 1) ? 1'b1 : 1'b0;  // To eliminate truncating warning

  `ifdef __ALTERA_STD__METASTABLE_SIM
     logic [DWIDTH-1:0]  next_din_s1;
     logic [DWIDTH-1:0]  din_last;
  
     event metastable_event; // hook for debug monitoring
  
     initial begin
        $display("%m: Info: Metastable event injection simulation mode enabled");
     end
  
     genvar i;
      generate
      for (i = 0; i < (DWIDTH); i=i+1) begin: meta_sim
        assign next_din_s1[i] = ((din_last[i] ^ din[i]) == 0) ? din[i] : $urandom_range(1,0);
      end
     endgenerate
  
     always @(posedge clk or negedge rst_n) begin
         if (rst_n == 0)
           din_last <= {(DWIDTH){reset_value}};
         else
           din_last <= din;
     end
  
     always @(negedge rst_n or posedge clk) begin
        if (rst_n == 1'b0) begin
           sync_regs_s1[DWIDTH-1:0] <= {(DWIDTH){reset_value}};
        end
        else begin
           sync_regs_s1[DWIDTH-1:0] <= next_din_s1;
        end
     end
  `else
  
     // NF: both FF stages have reset
     always @(negedge rst_n or posedge clk) begin
        if (rst_n == 1'b0) begin
           sync_regs_s1[DWIDTH-1:0] <= {(DWIDTH){reset_value}};
        end
        else begin
           sync_regs_s1[DWIDTH-1:0] <= din;
        end
     end
  
  `endif

   // Sync Always block
   always @(negedge rst_n or posedge clk) begin
      if (rst_n == 1'b0) begin
         sync_regs_s2[DWIDTH-1:0] <= {(DWIDTH){reset_value}};
      end
      else begin
         sync_regs_s2[DWIDTH-1:0] <= sync_regs_s1[(DWIDTH-1):0];
      end
   end

   assign dout = sync_regs_s2;
endmodule
