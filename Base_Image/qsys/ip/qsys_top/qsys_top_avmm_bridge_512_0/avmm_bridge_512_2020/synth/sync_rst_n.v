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


// -----------------------------------------------------------------------
// Description: Active low reset synchronizer core which is replaced by
// special cells in synthesis
//------------------------------------------------------------------------
module sync_rst_n
  ( input  wire rst_n,     // Asynchronous reset
    input  wire clk,       // Clock to synchronize rst_n to
    input  wire tie_high,  // Tie high input
    output reg  rst_n_sync // Synchronized rst_n deassertion output  
  );

reg rst_n_sync1; /*synthesis preserve*/

// Reset synchronizer
// Assertion is asynchronous
// De-assertion is synchronous to clk
always @(negedge rst_n or posedge clk)
  begin
    if (rst_n == 1'b0)
      begin
        rst_n_sync1 <= 1'b0; 
        rst_n_sync  <= 1'b0; 
      end
    else
      begin
        rst_n_sync1 <= tie_high; 
        rst_n_sync  <= rst_n_sync1; 
      end 
  end 

endmodule
