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


//-----------------------------------------------------------------------------
// Description : Parameterizable Vector Sync Module, This can only be used
// for SLOW changing vector, i.e vector should be stable at least for the
// synchronization latency.
//-----------------------------------------------------------------------------
module sync_vec
   #(
      parameter DWIDTH           = 2
   )(
   // Inputs
   input  wire               wr_clk,        // write clock
   input  wire               rd_clk,        // read clock
   input  wire               wr_rst_n,      // async write reset
   input  wire               rd_rst_n,      // async read reset
   input  wire [DWIDTH-1:0]  data_in,       // data in
   // Outputs
   output reg  [DWIDTH-1:0]  data_out       // data out
   );

//******************************************************************************
// Define regs
//******************************************************************************
reg  [DWIDTH-1:0]  data_in_d0;
reg                req_wr_clk;
wire               req_rd_clk;
wire               ack_wr_clk;
wire               ack_rd_clk;
reg                req_rd_clk_d0;

//******************************************************************************
// WRITE CLOCK DOMAIN: Generate req & Store data when synchroniztion is not
// already in progress 
//******************************************************************************
always @(negedge wr_rst_n or posedge wr_clk) begin
   if (wr_rst_n == 1'b0) begin
      data_in_d0 <= {DWIDTH{1'b0}};
      req_wr_clk <= 1'b0; 
   end
   else begin
      // Store data when Write Req equals Write Ack
      if (req_wr_clk == ack_wr_clk) begin
         data_in_d0 <= data_in;
      end
      
      // Generate a Req when there is change in data 
      if ((req_wr_clk == ack_wr_clk) & (data_in_d0 != data_in)) begin
         req_wr_clk <= ~req_wr_clk;
      end
   end
end

//******************************************************************************
// WRITE CLOCK DOMAIN:  
//******************************************************************************
sync_bit
#(
.DWIDTH      (1),         // Sync Data input
.RESET_VAL   (0)          // Reset value
)
u_ack_wr_clk
   (
   .clk      (wr_clk),
   .rst_n    (wr_rst_n),
   .din      (ack_rd_clk),
   .dout     (ack_wr_clk)
   );
assign ack_rd_clk = req_rd_clk_d0;

//******************************************************************************
// READ CLOCK DOMAIN:  
//******************************************************************************
sync_bit
#(
.DWIDTH      (1),         // Sync Data input
.RESET_VAL   (0)          // Reset value
)
u_req_rd_clk
(
   .clk      (rd_clk),
   .rst_n    (rd_rst_n),
   .din      (req_wr_clk),
   .dout     (req_rd_clk)
);

//******************************************************************************
// READ CLOCK DOMAIN:  
//******************************************************************************
always @(negedge rd_rst_n or posedge rd_clk) begin
   if (rd_rst_n == 1'b0) begin
      data_out      <= {DWIDTH{1'b0}};
      req_rd_clk_d0 <= 1'b0;
   end
   else begin 
      req_rd_clk_d0 <= req_rd_clk;
      if (req_rd_clk_d0 != req_rd_clk) begin
         data_out <= data_in_d0;
      end
   end
end


endmodule //sync_vec

