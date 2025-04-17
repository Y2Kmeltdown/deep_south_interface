// (C) 1992-2015 Altera Corporation. All rights reserved.                         
// Your use of Altera Corporation's design tools, logic functions and other       
// software and tools, and its AMPP partner logic functions, and any output       
// files any of the foregoing (including device programming or simulation         
// files), and any associated documentation or information are expressly subject  
// to the terms and conditions of the Altera Program License Subscription         
// Agreement, Altera MegaCore Function License Agreement, or other applicable     
// license agreement, including, without limitation, that your use is for the     
// sole purpose of programming logic devices manufactured by Altera and sold by   
// Altera or its authorized distributors.  Please refer to the applicable         
// agreement for further details.                                                 
    

module irq_bridge
(
    // master inputs:
    clk,
    read,
    rst_n,

    // master outputs:
    readdata,
    
    // interrupt request ports:
    irq_i
);
  input            clk;
  input            read;
  input            rst_n;
  output reg [31:0] readdata;
  input     [31:0]  irq_i;
  
  always @(posedge clk) begin
    if (read) begin
      readdata <= irq_i;
    end
  end

endmodule
