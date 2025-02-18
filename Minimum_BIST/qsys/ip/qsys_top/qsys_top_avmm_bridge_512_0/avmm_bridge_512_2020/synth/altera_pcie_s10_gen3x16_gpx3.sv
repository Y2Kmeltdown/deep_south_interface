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


// (C) 2001-2018 Intel Corporation. All rights reserved.
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


module altera_s10_pcie_gen3x16_gpx3
  #(
     parameter     WIDTH = 4
  )(
   input logic        din_clk,
   input logic        din_rst,
   input logic [WIDTH-1:0]  din,
   input logic        dout_clk,
   input logic        dout_rst_n,
   output logic [WIDTH-1:0] dout
   );

    //binary to gray conversion
    logic [WIDTH-1:0] din_gry,
                din_gry_sync,
                din_bin;

   /*  assign din_gry[2] = din[2];
    assign din_gry[1] = din[2]^din[1];
    assign din_gry[0] = din[1]^din[0]; */

    //genvar i;
    always @ (posedge din_clk) begin
      if (din_rst) begin
        din_gry <= '0;
      end
      else begin
        din_gry[WIDTH - 1] <= din [WIDTH - 1];
        for (int i = 0; i < (WIDTH - 1); i=i+1) begin: gry_convert
          din_gry[i] <= din[i] ^ din[i+1];
        end    
      end   
    end   
    
    
    sync_bit #(.DWIDTH(WIDTH)) u_din_gry_sync (.clk(dout_clk), .rst_n(dout_rst_n), .din(din_gry), .dout(din_gry_sync));

    //assign din_bin = {din_gry_sync[2], din_gry_sync[1]^din_bin[2], din_gry_sync[0]^din_bin[1]};
    assign din_bin[WIDTH-1] = din_gry_sync[WIDTH-1];
/*     assign din_bin[3] = din_gry_sync[3] ^ din_bin[4];
    assign din_bin[2] = din_gry_sync[2] ^ din_bin[3];
    assign din_bin[1] = din_gry_sync[1] ^ din_bin[2];
    assign din_bin[0] = din_gry_sync[0] ^ din_bin[1]; */
    
    genvar i;
    generate
    for (i = 0; i < (WIDTH - 1); i=i+1) begin: bin_convert
      assign din_bin[i] = din_gry_sync[i] ^ din_bin[i+1];
    end
    
    endgenerate
    
    
    
    
    //convert back to binary
    always @ (posedge dout_clk)
      if (!dout_rst_n)
        dout <= '0;
      else
        dout <= din_bin;

endmodule