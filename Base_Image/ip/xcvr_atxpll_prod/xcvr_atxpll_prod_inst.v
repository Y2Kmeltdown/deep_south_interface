	xcvr_atxpll_prod u0 (
		.pll_refclk0       (_connected_to_pll_refclk0_),       //   input,  width = 1,       pll_refclk0.clk
		.tx_serial_clk_gxt (_connected_to_tx_serial_clk_gxt_), //  output,  width = 1, tx_serial_clk_gxt.clk
		.pll_locked        (_connected_to_pll_locked_),        //  output,  width = 1,        pll_locked.pll_locked
		.pll_cal_busy      (_connected_to_pll_cal_busy_)       //  output,  width = 1,      pll_cal_busy.pll_cal_busy
	);

