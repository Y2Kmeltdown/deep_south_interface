	esram_7 u0 (
		.c7_q_0          (_connected_to_c7_q_0_),          //  output,  width = 32, ram_output.s2c7_qb_0
		.esram2f_clk     (_connected_to_esram2f_clk_),     //  output,   width = 1,           .esram2f_clk
		.iopll_lock2core (_connected_to_iopll_lock2core_), //  output,   width = 1,           .iopll_lock2core
		.c7_data_0       (_connected_to_c7_data_0_),       //   input,  width = 32,  ram_input.s2c7_da_0
		.c7_rdaddress_0  (_connected_to_c7_rdaddress_0_),  //   input,  width = 11,           .s2c7_adrb_0
		.c7_rden_n_0     (_connected_to_c7_rden_n_0_),     //   input,   width = 1,           .s2c7_meb_n_0
		.c7_sd_n_0       (_connected_to_c7_sd_n_0_),       //   input,   width = 1,           .s2c7_sd_n_0
		.c7_wraddress_0  (_connected_to_c7_wraddress_0_),  //   input,  width = 11,           .s2c7_adra_0
		.c7_wren_n_0     (_connected_to_c7_wren_n_0_),     //   input,   width = 1,           .s2c7_mea_n_0
		.refclk          (_connected_to_refclk_)           //   input,   width = 1,           .clock
	);

