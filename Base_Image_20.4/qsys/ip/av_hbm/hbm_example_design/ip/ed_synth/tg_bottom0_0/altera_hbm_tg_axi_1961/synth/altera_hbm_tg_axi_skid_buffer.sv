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


`timescale 1ps / 1ps

module altera_hbm_tg_axi_skid_buffer #(
   parameter DATA_WIDTH = 8
) (
   input                   clk,
   input                   rst_n,

   output                  in_ready,
   input                   in_valid,
   input [DATA_WIDTH-1:0]  in_data,

   input                   out_ready,
   output                  out_valid,
   output [DATA_WIDTH-1:0] out_data
);

reg                  full0;
reg                  full1;
reg [DATA_WIDTH-1:0] data0;
reg [DATA_WIDTH-1:0] data1;

assign out_valid = full1;
assign out_data  = data1;

assign in_ready  = !full0;

always @(posedge clk)
begin
   if (~rst_n)
   begin
      data0 <= {DATA_WIDTH{1'b0}};
      data1 <= {DATA_WIDTH{1'b0}};
   end
   else
   begin
      if (~full0)
         data0 <= in_data;
      if (~full1 || (out_ready && out_valid))
      begin
         if (full0)
            data1 <= data0;
         else
            data1 <= in_data;
      end
   end
end

always @(posedge clk)
begin
   if (~rst_n)
   begin
      full0    <= 1'b0;
      full1    <= 1'b0;
   end else
   begin
      if (~full0 & ~full1)
      begin
         if (in_valid)
         begin
            full1 <= 1'b1;
         end
      end 
      else if (full1 & ~full0)
      begin
         if (in_valid & ~out_ready)
         begin
            full0 <= 1'b1;
         end
         if (~in_valid & out_ready)
         begin
            full1 <= 1'b0;
         end
      end 
      else if (full1 & full0)
      begin
         if (out_ready)
         begin
            full0 <= 1'b0;
         end
      end 
   end
end

endmodule
