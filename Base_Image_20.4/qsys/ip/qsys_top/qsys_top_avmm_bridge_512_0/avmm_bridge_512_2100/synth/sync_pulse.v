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


module sync_pulse
  (
   input wr_clk,
   input rd_clk,
   input wr_rst_n,
   input rd_rst_n,
   input din,
   output dout
   );

    reg   din_lat,
          dout_lat;
    reg   din_sync_q;
    
    wire  din_sync,
          dout_sync;
        
    always @ (posedge wr_clk or negedge wr_rst_n)
      if (!wr_rst_n)
        din_lat <= 1'b0;
      else
        din_lat <= dout_sync ? 1'b0 : din? 1'b1 : din_lat;

    sync_bit u_din_sync (.clk(rd_clk), .rst_n(rd_rst_n), .din(din_lat), .dout(din_sync));
    sync_bit u_dout_sync (.clk(wr_clk), .rst_n(wr_rst_n), .din(dout_lat), .dout(dout_sync));
    assign dout = din_sync & ~din_sync_q;
    
    always @ (posedge rd_clk or negedge rd_rst_n)
      if (!rd_rst_n)
        begin
            dout_lat <= 1'b0;
            din_sync_q<=1'b0;
        end
      else
        begin
            dout_lat <= !din_sync? 1'b0 : din_sync ? 1'b1 : dout_lat;
            din_sync_q <= din_sync;
        end

endmodule