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



module altera_hbm_tg_axi_backpressure # (
   parameter PORT_AXI_AWID_WIDTH           = 0,
   parameter PORT_AXI_AWADDR_WIDTH         = 0,
   parameter PORT_AXI_AWLEN_WIDTH          = 0,
   parameter PORT_AXI_AWSIZE_WIDTH         = 0,
   parameter PORT_AXI_AWBURST_WIDTH        = 0,
   parameter PORT_AXI_AWPROT_WIDTH         = 0,
   parameter PORT_AXI_AWQOS_WIDTH          = 0,
   parameter PORT_AXI_AWUSER_AP_WIDTH      = 0,
   parameter PORT_AXI_WDATA_WIDTH          = 0,
   parameter PORT_AXI_WSTRB_WIDTH          = 0,
   parameter PORT_AXI_BID_WIDTH            = 0,
   parameter PORT_AXI_BRESP_WIDTH          = 0,
   parameter PORT_AXI_ARID_WIDTH           = 0,
   parameter PORT_AXI_ARADDR_WIDTH         = 0,
   parameter PORT_AXI_ARLEN_WIDTH          = 0,
   parameter PORT_AXI_ARSIZE_WIDTH         = 0,
   parameter PORT_AXI_ARBURST_WIDTH        = 0,
   parameter PORT_AXI_ARPROT_WIDTH         = 0,
   parameter PORT_AXI_ARQOS_WIDTH          = 0,
   parameter PORT_AXI_ARUSER_AP_WIDTH      = 0,
   parameter PORT_AXI_RID_WIDTH            = 0,
   parameter PORT_AXI_RDATA_WIDTH          = 0,
   parameter PORT_AXI_RRESP_WIDTH          = 0,

   parameter PORT_AXI_EXTRA_RUSER_DATA_WIDTH = 0,
   parameter PORT_AXI_EXTRA_WUSER_DATA_WIDTH = 0,
   parameter PORT_AXI_EXTRA_WUSER_STRB_WIDTH = 0,

   parameter BACKPRESSURE_LATENCY         = 0,
   parameter PIPELINE_RRESP               = 0,
   parameter PIPELINE_BRESP               = 0
) (
   input  wmc_clk_in,
   input  wmcrst_n_in,

   input  [PORT_AXI_AWID_WIDTH-1:0]      awid_tg,
   input  [PORT_AXI_AWADDR_WIDTH-1:0]    awaddr_tg,
   input  [PORT_AXI_AWLEN_WIDTH-1:0]     awlen_tg,
   input  [PORT_AXI_AWSIZE_WIDTH-1:0]    awsize_tg,
   input  [PORT_AXI_AWBURST_WIDTH-1:0]   awburst_tg,
   input  [PORT_AXI_AWPROT_WIDTH-1:0]    awprot_tg,
   input  [PORT_AXI_AWQOS_WIDTH-1:0]     awqos_tg,
   input  [PORT_AXI_AWUSER_AP_WIDTH-1:0] awuser_ap_tg,
   input                                 awvalid_tg,
   output                                awready_tg,
   input  [PORT_AXI_WDATA_WIDTH-1:0]     wdata_tg,
   input  [PORT_AXI_WSTRB_WIDTH-1:0]     wstrb_tg,
   input                                 wlast_tg,
   input                                 wvalid_tg,
   output                                wready_tg,
   output [PORT_AXI_BID_WIDTH-1:0]       bid_tg,
   output [PORT_AXI_BRESP_WIDTH-1:0]     bresp_tg,
   output                                bvalid_tg,
   input                                 bready_tg,
   input  [PORT_AXI_ARID_WIDTH-1:0]      arid_tg,
   input  [PORT_AXI_ARADDR_WIDTH-1:0]    araddr_tg,
   input  [PORT_AXI_ARLEN_WIDTH-1:0]     arlen_tg,
   input  [PORT_AXI_ARSIZE_WIDTH-1:0]    arsize_tg,
   input  [PORT_AXI_ARBURST_WIDTH-1:0]   arburst_tg,
   input  [PORT_AXI_ARPROT_WIDTH-1:0]    arprot_tg,
   input  [PORT_AXI_ARQOS_WIDTH-1:0]     arqos_tg,
   input  [PORT_AXI_ARUSER_AP_WIDTH-1:0] aruser_ap_tg,
   input                                 arvalid_tg,
   output                                arready_tg,
   output [PORT_AXI_RID_WIDTH-1:0]       rid_tg,
   output [PORT_AXI_RDATA_WIDTH-1:0]     rdata_tg,
   output [PORT_AXI_RRESP_WIDTH-1:0]     rresp_tg,
   output                                rlast_tg,
   output                                rvalid_tg,
   input                                 rready_tg,
   output                                       ruser_err_dbe_tg,
   output [PORT_AXI_EXTRA_RUSER_DATA_WIDTH-1:0] ruser_data_tg,
   input  [PORT_AXI_EXTRA_WUSER_DATA_WIDTH-1:0] wuser_data_tg,
   input  [PORT_AXI_EXTRA_WUSER_STRB_WIDTH-1:0] wuser_strb_tg,

   output [PORT_AXI_AWID_WIDTH-1:0]      awid_hbm,
   output [PORT_AXI_AWADDR_WIDTH-1:0]    awaddr_hbm,
   output [PORT_AXI_AWLEN_WIDTH-1:0]     awlen_hbm,
   output [PORT_AXI_AWSIZE_WIDTH-1:0]    awsize_hbm,
   output [PORT_AXI_AWBURST_WIDTH-1:0]   awburst_hbm,
   output [PORT_AXI_AWPROT_WIDTH-1:0]    awprot_hbm,
   output [PORT_AXI_AWQOS_WIDTH-1:0]     awqos_hbm,
   output [PORT_AXI_AWUSER_AP_WIDTH-1:0] awuser_ap_hbm,
   output                                awvalid_hbm,
   input                                 awready_hbm,
   output [PORT_AXI_WDATA_WIDTH-1:0]     wdata_hbm,
   output [PORT_AXI_WSTRB_WIDTH-1:0]     wstrb_hbm,
   output                                wlast_hbm,
   output                                wvalid_hbm,
   input                                 wready_hbm,
   input [PORT_AXI_BID_WIDTH-1:0]        bid_hbm,
   input [PORT_AXI_BRESP_WIDTH-1:0]      bresp_hbm,
   input                                 bvalid_hbm,
   output                                bready_hbm,
   output [PORT_AXI_ARID_WIDTH-1:0]      arid_hbm,
   output [PORT_AXI_ARADDR_WIDTH-1:0]    araddr_hbm,
   output [PORT_AXI_ARLEN_WIDTH-1:0]     arlen_hbm,
   output [PORT_AXI_ARSIZE_WIDTH-1:0]    arsize_hbm,
   output [PORT_AXI_ARBURST_WIDTH-1:0]   arburst_hbm,
   output [PORT_AXI_ARPROT_WIDTH-1:0]    arprot_hbm,
   output [PORT_AXI_ARQOS_WIDTH-1:0]     arqos_hbm,
   output [PORT_AXI_ARUSER_AP_WIDTH-1:0] aruser_ap_hbm,
   output                                arvalid_hbm,
   input                                 arready_hbm,
   input [PORT_AXI_RID_WIDTH-1:0]        rid_hbm,
   input [PORT_AXI_RDATA_WIDTH-1:0]      rdata_hbm,
   input [PORT_AXI_RRESP_WIDTH-1:0]      rresp_hbm,
   input                                 rlast_hbm,
   input                                 rvalid_hbm,
   output                                rready_hbm,
   input                                        ruser_err_dbe_hbm,
   input  [PORT_AXI_EXTRA_RUSER_DATA_WIDTH-1:0] ruser_data_hbm,
   output [PORT_AXI_EXTRA_WUSER_DATA_WIDTH-1:0] wuser_data_hbm,
   output [PORT_AXI_EXTRA_WUSER_STRB_WIDTH-1:0] wuser_strb_hbm
);

   timeunit 1ns;
   timeprecision 1ps;


   
   generate
     if(PIPELINE_BRESP) begin
       altera_hbm_tg_axi_skid_buffer #(
         .DATA_WIDTH(PORT_AXI_BID_WIDTH+PORT_AXI_BRESP_WIDTH)
       ) bresp_skid_buf_inst (
         .clk      (wmc_clk_in ),
         .rst_n    (wmcrst_n_in),

         .in_ready (bready_hbm ),
         .in_valid (bvalid_hbm ),
         .in_data  ({bresp_hbm, bid_hbm}),

         .out_ready (bready_tg ),
         .out_valid (bvalid_tg ),
         .out_data  ({bresp_tg, bid_tg})
      );
    end
    else begin
     assign bid_tg     = bid_hbm   ;
     assign bresp_tg   = bresp_hbm ;
     assign bvalid_tg  = bvalid_hbm;
     assign bready_hbm = bready_tg ;  
    end
  endgenerate

   generate
     if(PIPELINE_RRESP) begin
       altera_hbm_tg_axi_skid_buffer #(
         .DATA_WIDTH(PORT_AXI_RID_WIDTH + PORT_AXI_RDATA_WIDTH + PORT_AXI_RRESP_WIDTH +1 +PORT_AXI_EXTRA_RUSER_DATA_WIDTH +1)
       ) rresp_skid_buf_inst (
         .clk      (wmc_clk_in ),
         .rst_n    (wmcrst_n_in),

         .in_ready (rready_hbm ),
         .in_valid (rvalid_hbm ),
         .in_data  ({rid_hbm, rdata_hbm, rresp_hbm, rlast_hbm, ruser_data_hbm, ruser_err_dbe_hbm}),

         .out_ready (rready_tg ),
         .out_valid (rvalid_tg ),
         .out_data  ({rid_tg, rdata_tg, rresp_tg, rlast_tg, ruser_data_tg, ruser_err_dbe_tg})
      );
    end
    else begin
     assign rid_tg = rid_hbm;
     assign rdata_tg = rdata_hbm;
     assign rresp_tg = rresp_hbm;
     assign rlast_tg = rlast_hbm;
     assign rvalid_tg = rvalid_hbm;
     assign rready_hbm = rready_tg; 
     assign ruser_err_dbe_tg = ruser_err_dbe_hbm;
     assign ruser_data_tg = ruser_data_hbm;     
    end
  endgenerate

   generate
   case(BACKPRESSURE_LATENCY)
      2:
      begin : two_clk_latency
         logic [PORT_AXI_AWID_WIDTH-1:0]      awid_hbm_r      = '0;
         logic [PORT_AXI_AWADDR_WIDTH-1:0]    awaddr_hbm_r    = '0;
         logic [PORT_AXI_AWLEN_WIDTH-1:0]     awlen_hbm_r     = '0;
         logic [PORT_AXI_AWSIZE_WIDTH-1:0]    awsize_hbm_r    = '0;
         logic [PORT_AXI_AWBURST_WIDTH-1:0]   awburst_hbm_r   = '0;
         logic [PORT_AXI_AWPROT_WIDTH-1:0]    awprot_hbm_r    = '0;
         logic [PORT_AXI_AWQOS_WIDTH-1:0]     awqos_hbm_r     = '0;
         logic [PORT_AXI_AWUSER_AP_WIDTH-1:0] awuser_ap_hbm_r = '0;
         logic awvalid_hbm_r = '0;
         logic awready_tg_r  = '0;

         logic [PORT_AXI_WDATA_WIDTH-1:0] wdata_hbm_r  = '0;
         logic [PORT_AXI_WSTRB_WIDTH-1:0] wstrb_hbm_r  = '0;
         logic wlast_hbm_r  = '0;
         logic wvalid_hbm_r = '0;
         logic wready_tg_r = '0;

         logic [PORT_AXI_ARID_WIDTH-1:0]      arid_hbm_r      = '0;
         logic [PORT_AXI_ARADDR_WIDTH-1:0]    araddr_hbm_r    = '0;
         logic [PORT_AXI_ARLEN_WIDTH-1:0]     arlen_hbm_r     = '0;
         logic [PORT_AXI_ARSIZE_WIDTH-1:0]    arsize_hbm_r    = '0;
         logic [PORT_AXI_ARBURST_WIDTH-1:0]   arburst_hbm_r   = '0;
         logic [PORT_AXI_ARPROT_WIDTH-1:0]    arprot_hbm_r    = '0;
         logic [PORT_AXI_ARQOS_WIDTH-1:0]     arqos_hbm_r     = '0;
         logic [PORT_AXI_ARUSER_AP_WIDTH-1:0] aruser_ap_hbm_r = '0;
         logic arvalid_hbm_r   = '0;
         logic arready_tg_r   = '0;

         logic [PORT_AXI_EXTRA_WUSER_DATA_WIDTH-1:0] wuser_data_hbm_r = '0;
         logic [PORT_AXI_EXTRA_WUSER_STRB_WIDTH-1:0] wuser_strb_hbm_r = '0;

         always @ (posedge wmc_clk_in) begin
            awid_hbm_r      <= awid_tg;
            awaddr_hbm_r    <= awaddr_tg;
            awlen_hbm_r     <= awlen_tg;
            awsize_hbm_r    <= awsize_tg;
            awburst_hbm_r   <= awburst_tg;
            awprot_hbm_r    <= awprot_tg;
            awqos_hbm_r     <= awqos_tg;
            awuser_ap_hbm_r <= awuser_ap_tg;
            awvalid_hbm_r   <= awvalid_tg;
            awready_tg_r    <= awready_hbm;

            wdata_hbm_r  <= wdata_tg;
            wstrb_hbm_r  <= wstrb_tg;
            wlast_hbm_r  <= wlast_tg;
            wvalid_hbm_r <= wvalid_tg;
            wready_tg_r  <= wready_hbm;

            arid_hbm_r      <= arid_tg;
            araddr_hbm_r    <= araddr_tg;
            arlen_hbm_r     <= arlen_tg;
            arsize_hbm_r    <= arsize_tg;
            arburst_hbm_r   <= arburst_tg;
            arprot_hbm_r    <= arprot_tg;
            arqos_hbm_r     <= arqos_tg;
            aruser_ap_hbm_r <= aruser_ap_tg;
            arvalid_hbm_r   <= arvalid_tg;
            arready_tg_r    <= arready_hbm;

            wuser_data_hbm_r <= wuser_data_tg;
            wuser_strb_hbm_r <= wuser_strb_tg;
         end

         assign awid_hbm      = awid_hbm_r;
         assign awaddr_hbm    = awaddr_hbm_r;
         assign awlen_hbm     = awlen_hbm_r;
         assign awsize_hbm    = awsize_hbm_r;
         assign awburst_hbm   = awburst_hbm_r;
         assign awprot_hbm    = awprot_hbm_r;
         assign awqos_hbm     = awqos_hbm_r;
         assign awuser_ap_hbm = awuser_ap_hbm_r;
         assign awvalid_hbm   = awvalid_hbm_r;
         assign awready_tg    = awready_tg_r;

         assign wdata_hbm  = wdata_hbm_r;
         assign wstrb_hbm  = wstrb_hbm_r;
         assign wlast_hbm  = wlast_hbm_r;
         assign wvalid_hbm = wvalid_hbm_r;
         assign wready_tg  = wready_tg_r;

         assign arid_hbm      = arid_hbm_r;
         assign araddr_hbm    = araddr_hbm_r;
         assign arlen_hbm     = arlen_hbm_r;
         assign arsize_hbm    = arsize_hbm_r;
         assign arburst_hbm   = arburst_hbm_r;
         assign arprot_hbm    = arprot_hbm_r;
         assign arqos_hbm     = arqos_hbm_r;
         assign aruser_ap_hbm = aruser_ap_hbm_r;
         assign arvalid_hbm   = arvalid_hbm_r;
         assign arready_tg    = arready_tg_r;

         assign wuser_data_hbm = wuser_data_hbm_r;
         assign wuser_strb_hbm = wuser_strb_hbm_r;
      end

      1:
      begin : one_clk_latency
         logic [PORT_AXI_AWID_WIDTH-1:0]      awid_hbm_r      = '0;
         logic [PORT_AXI_AWADDR_WIDTH-1:0]    awaddr_hbm_r    = '0;
         logic [PORT_AXI_AWLEN_WIDTH-1:0]     awlen_hbm_r     = '0;
         logic [PORT_AXI_AWSIZE_WIDTH-1:0]    awsize_hbm_r    = '0;
         logic [PORT_AXI_AWBURST_WIDTH-1:0]   awburst_hbm_r   = '0;
         logic [PORT_AXI_AWPROT_WIDTH-1:0]    awprot_hbm_r    = '0;
         logic [PORT_AXI_AWQOS_WIDTH-1:0]     awqos_hbm_r     = '0;
         logic [PORT_AXI_AWUSER_AP_WIDTH-1:0] awuser_ap_hbm_r = '0;
         logic awvalid_hbm_r = '0;

         logic [PORT_AXI_WDATA_WIDTH-1:0] wdata_hbm_r  = '0;
         logic [PORT_AXI_WSTRB_WIDTH-1:0] wstrb_hbm_r  = '0;
         logic wlast_hbm_r  = '0;
         logic wvalid_hbm_r = '0;

         logic [PORT_AXI_ARID_WIDTH-1:0]      arid_hbm_r      = '0;
         logic [PORT_AXI_ARADDR_WIDTH-1:0]    araddr_hbm_r    = '0;
         logic [PORT_AXI_ARLEN_WIDTH-1:0]     arlen_hbm_r     = '0;
         logic [PORT_AXI_ARSIZE_WIDTH-1:0]    arsize_hbm_r    = '0;
         logic [PORT_AXI_ARBURST_WIDTH-1:0]   arburst_hbm_r   = '0;
         logic [PORT_AXI_ARPROT_WIDTH-1:0]    arprot_hbm_r    = '0;
         logic [PORT_AXI_ARQOS_WIDTH-1:0]     arqos_hbm_r     = '0;
         logic [PORT_AXI_ARUSER_AP_WIDTH-1:0] aruser_ap_hbm_r = '0;
         logic arvalid_hbm_r   = '0;

         logic [PORT_AXI_EXTRA_WUSER_DATA_WIDTH-1:0] wuser_data_hbm_r = '0;
         logic [PORT_AXI_EXTRA_WUSER_STRB_WIDTH-1:0] wuser_strb_hbm_r = '0;

         always @ (posedge wmc_clk_in) begin
            awid_hbm_r      <= awid_tg;
            awaddr_hbm_r    <= awaddr_tg;
            awlen_hbm_r     <= awlen_tg;
            awsize_hbm_r    <= awsize_tg;
            awburst_hbm_r   <= awburst_tg;
            awprot_hbm_r    <= awprot_tg;
            awqos_hbm_r     <= awqos_tg;
            awuser_ap_hbm_r <= awuser_ap_tg;
            awvalid_hbm_r   <= awvalid_tg;

            wdata_hbm_r  <= wdata_tg;
            wstrb_hbm_r  <= wstrb_tg;
            wlast_hbm_r  <= wlast_tg;
            wvalid_hbm_r <= wvalid_tg;

            arid_hbm_r      <= arid_tg;
            araddr_hbm_r    <= araddr_tg;
            arlen_hbm_r     <= arlen_tg;
            arsize_hbm_r    <= arsize_tg;
            arburst_hbm_r   <= arburst_tg;
            arprot_hbm_r    <= arprot_tg;
            arqos_hbm_r     <= arqos_tg;
            aruser_ap_hbm_r <= aruser_ap_tg;
            arvalid_hbm_r   <= arvalid_tg;

            wuser_data_hbm_r <= wuser_data_tg;
            wuser_strb_hbm_r <= wuser_strb_tg;
         end

         assign awid_hbm      = awid_hbm_r;
         assign awaddr_hbm    = awaddr_hbm_r;
         assign awlen_hbm     = awlen_hbm_r;
         assign awsize_hbm    = awsize_hbm_r;
         assign awburst_hbm   = awburst_hbm_r;
         assign awprot_hbm    = awprot_hbm_r;
         assign awqos_hbm     = awqos_hbm_r;
         assign awuser_ap_hbm = awuser_ap_hbm_r;
         assign awvalid_hbm   = awvalid_hbm_r;
         assign awready_tg    = awready_hbm; 

         assign wdata_hbm  = wdata_hbm_r;
         assign wstrb_hbm  = wstrb_hbm_r;
         assign wlast_hbm  = wlast_hbm_r;
         assign wvalid_hbm = wvalid_hbm_r;
         assign wready_tg  = wready_hbm; 

         assign arid_hbm      = arid_hbm_r;
         assign araddr_hbm    = araddr_hbm_r;
         assign arlen_hbm     = arlen_hbm_r;
         assign arsize_hbm    = arsize_hbm_r;
         assign arburst_hbm   = arburst_hbm_r;
         assign arprot_hbm    = arprot_hbm_r;
         assign arqos_hbm     = arqos_hbm_r;
         assign aruser_ap_hbm = aruser_ap_hbm_r;
         assign arvalid_hbm   = arvalid_hbm_r;
         assign arready_tg    = arready_hbm; 

         assign wuser_data_hbm = wuser_data_hbm_r;
         assign wuser_strb_hbm = wuser_strb_hbm_r;
      end

      0:
      begin : zero_latency
         assign awid_hbm      = awid_tg;
         assign awaddr_hbm    = awaddr_tg;
         assign awlen_hbm     = awlen_tg;
         assign awsize_hbm    = awsize_tg;
         assign awburst_hbm   = awburst_tg;
         assign awprot_hbm    = awprot_tg;
         assign awqos_hbm     = awqos_tg;
         assign awuser_ap_hbm = awuser_ap_tg;
         assign awvalid_hbm   = awvalid_tg;
         assign awready_tg    = awready_hbm;

         assign wdata_hbm  = wdata_tg;
         assign wstrb_hbm  = wstrb_tg;
         assign wlast_hbm  = wlast_tg;
         assign wvalid_hbm = wvalid_tg;
         assign wready_tg  = wready_hbm;

         assign arid_hbm      = arid_tg;
         assign araddr_hbm    = araddr_tg;
         assign arlen_hbm     = arlen_tg;
         assign arsize_hbm    = arsize_tg;
         assign arburst_hbm   = arburst_tg;
         assign arprot_hbm    = arprot_tg;
         assign arqos_hbm     = arqos_tg;
         assign aruser_ap_hbm = aruser_ap_tg;
         assign arvalid_hbm   = arvalid_tg;
         assign arready_tg    = arready_hbm;

         assign wuser_data_hbm = wuser_data_tg;
         assign wuser_strb_hbm = wuser_strb_tg;
      end
   endcase
   endgenerate

endmodule
