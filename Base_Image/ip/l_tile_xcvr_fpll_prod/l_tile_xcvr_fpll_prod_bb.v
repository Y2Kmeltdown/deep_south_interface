module l_tile_xcvr_fpll_prod (
		input  wire  pll_refclk0,     //     pll_refclk0.clk
		output wire  tx_serial_clk,   //   tx_serial_clk.clk
		output wire  pll_locked,      //      pll_locked.pll_locked
		output wire  pll_cal_busy,    //    pll_cal_busy.pll_cal_busy
		output wire  mcgb_serial_clk  // mcgb_serial_clk.clk
	);
endmodule

