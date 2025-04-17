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


////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Wrapper for altera_iopll instance
////////////////////////////////////////////////////////////////////////////////////////////////////////////
module altera_hbm_arch_nd_pll_hbm_top_example_design_altera_abstract_uib_191_4v7vvyy (
   input  logic                                               global_reset_n_int,    
   input  logic                                               pll_ref_clk,       
   output logic                                               lock_from_pll,            
   output logic [7:0]                                         phy_clk_phs,           
   output logic [1:0]                                         phy_clks,               
  	input	wire [8:0]	dprio_pll_addr,
	input	wire		dprio_pll_clk,
	input	wire		dprio_pll_read,
	output	wire [7:0]	dprio_pll_readdata,
	input	wire		dprio_pll_rst_n,
	input	wire		dprio_pll_write,
	input	wire [7:0]	dprio_pll_writedata
);
   timeunit 1ns;
   timeprecision 1ps;


   hbm_top_example_design_altera_abstract_uib_altera_iopll_191_zd66zjy pll_inst (
      .rst(~global_reset_n_int),
      .adjpllin (pll_ref_clk),
      .permit_cal(1'b1),
      .locked (lock_from_pll),
      .outclk_0(phy_clks[1]),
      .outclk_1(phy_clks[0]),
      .phout(phy_clk_phs)
   );

endmodule

