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




module altera_pcie_s10_gen3x16_dcfifo #(
    parameter DEVICE_FAMILY 	= "Stratix 10",
	parameter FIFO_WIDTH  = 256,
    parameter ADDR_WIDTH = 5,
    parameter SIM_EMULATE = 0                                    
                                        ) 
    (
     input                         din_clk,
     input                         din_sclr,
     input                         din_wreq,
     input [FIFO_WIDTH-1:0]        din,
     output [ADDR_WIDTH-1:0]       din_wusedw,

     input                         dout_clk,
     input                         dout_sclr,
     input                         dout_rreq,
     output logic [FIFO_WIDTH-1:0] dout,
     output logic [ADDR_WIDTH-1:0] dout_rusedw,
     output logic                  fifo_empty,
     output logic                  fifo_empty2,
     output logic                  fifo_almost_empty,
     output logic                  fifo_almost_full
     );

    ///////////////////////////////
    // write pointer

    logic [ADDR_WIDTH-1:0]              din_wptr;
    logic [ADDR_WIDTH-1:0]              sub_pointers;
    always @ (posedge din_clk)
      begin
          if (din_sclr)
            din_wptr <= 0;
          else
            din_wptr <= din_wreq ? din_wptr + 1'b1 : din_wptr;
      end

    ///////////////////////////////
    // read pointer

    logic [ADDR_WIDTH-1:0] dout_rptr;

    always @ (posedge dout_clk)
      begin
          if (dout_sclr)
            dout_rptr <= 0;
          else
            dout_rptr <= dout_rreq ? dout_rptr + 1'b1 : dout_rptr;
      end

///////////////////////////////
// storage

    wire [FIFO_WIDTH-1:0] dout_w;
    alt_mlab m0 (
                 .wclk(din_clk),
                 .wena(1'b1),
                 .waddr_reg(din_wptr),
                 .wdata_reg(din),
                 .raddr(dout_rptr),
                 .rdata(dout_w)
                 );
    defparam m0 .SIM_EMULATE = SIM_EMULATE;
    defparam m0 .WIDTH = FIFO_WIDTH;
    defparam m0 .ADDR_WIDTH = ADDR_WIDTH;
	defparam m0 .DEVICE_FAMILY = DEVICE_FAMILY;
    
    ///////////////////////////////////
    // pointer cross domain exchange

    wire [ADDR_WIDTH-1:0]            dout_xwptr;
    wire [ADDR_WIDTH-1:0]            din_xrptr;

    altera_s10_pcie_gen3x16_gpx3 #(
    .WIDTH (ADDR_WIDTH)
    ) gx0 (
           .din_clk(din_clk),
           .din_rst  (din_sclr),
           .din(din_wptr),
           .dout_clk(dout_clk),
           .dout_rst_n (~dout_sclr),
           .dout(dout_xwptr)
           );

    altera_s10_pcie_gen3x16_gpx3 #(
    .WIDTH (ADDR_WIDTH)
    )
      gx1 (
           .din_clk(dout_clk),
           .din_rst  (dout_sclr),
           .din(dout_rptr),
           .dout_clk(din_clk),
           .dout_rst_n (~din_sclr),
           .dout(din_xrptr)
           );

    ///////////////////////////////////
    // compute used words

    reg [ADDR_WIDTH-1:0] rusedw = '0;
    reg [ADDR_WIDTH-1:0] wusedw = '0;
         
    assign sub_pointers = dout_xwptr - dout_rptr;
    always @(posedge dout_clk) begin
      rusedw <= dout_xwptr - dout_rptr;
      fifo_empty <= (dout_xwptr - dout_rptr == 0);
      fifo_empty2 <= (sub_pointers == 1) & dout_rreq;
      fifo_almost_empty <= (sub_pointers == 1);        
    end

    always @(posedge din_clk) begin
        wusedw <= din_wptr - din_xrptr;
    end

    assign din_wusedw = wusedw;
    assign dout_rusedw = rusedw;
    assign fifo_almost_full = wusedw[ADDR_WIDTH-1] & wusedw[ADDR_WIDTH-2]; // Full at 24 locations.

    ///////////////////////////////
    // output registers
    always @ (posedge dout_clk)
      //dout <= dout_rreq ? dout_w : dout;
      dout <= dout_w;
    
endmodule

