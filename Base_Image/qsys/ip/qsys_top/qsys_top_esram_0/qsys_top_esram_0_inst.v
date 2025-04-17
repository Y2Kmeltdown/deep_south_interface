	qsys_top_esram_0 u0 (
		.c0_q_0          (_connected_to_c0_q_0_),          //  output,  width = 32, ram_output.s2c0_qb_0
		.esram2f_clk     (_connected_to_esram2f_clk_),     //  output,   width = 1,           .esram2f_clk
		.iopll_lock2core (_connected_to_iopll_lock2core_), //  output,   width = 1,           .iopll_lock2core
		.c0_data_0       (_connected_to_c0_data_0_),       //   input,  width = 32,  ram_input.s2c0_da_0
		.c0_rdaddress_0  (_connected_to_c0_rdaddress_0_),  //   input,  width = 16,           .s2c0_adrb_0
		.c0_rden_n_0     (_connected_to_c0_rden_n_0_),     //   input,   width = 1,           .s2c0_meb_n_0
		.c0_sd_n_0       (_connected_to_c0_sd_n_0_),       //   input,   width = 1,           .s2c0_sd_n_0
		.c0_wraddress_0  (_connected_to_c0_wraddress_0_),  //   input,  width = 16,           .s2c0_adra_0
		.c0_wren_n_0     (_connected_to_c0_wren_n_0_),     //   input,   width = 1,           .s2c0_mea_n_0
		.refclk          (_connected_to_refclk_)           //   input,   width = 1,           .clock
	);

