	qsys_top_avmm_to_esram_0 #(
		.c_ADDR_BITS (INTEGER_VALUE_FOR_c_ADDR_BITS),
		.c_WORD_SIZE (INTEGER_VALUE_FOR_c_WORD_SIZE)
	) u0 (
		.av_address      (_connected_to_av_address_),      //   input,  width = (((c_ADDR_BITS-1)-0)+1),         av.address
		.av_read         (_connected_to_av_read_),         //   input,                        width = 1,           .read
		.av_waitrequest  (_connected_to_av_waitrequest_),  //  output,                        width = 1,           .waitrequest
		.av_write        (_connected_to_av_write_),        //   input,                        width = 1,           .write
		.av_readdata     (_connected_to_av_readdata_),     //  output,  width = (((c_WORD_SIZE-1)-0)+1),           .readdata
		.av_writedata    (_connected_to_av_writedata_),    //   input,  width = (((c_WORD_SIZE-1)-0)+1),           .writedata
		.data            (_connected_to_data_),            //  output,  width = (((c_WORD_SIZE-1)-0)+1),  ram_input.s2c0_da_0
		.rdaddress       (_connected_to_rdaddress_),       //  output,  width = (((c_ADDR_BITS-1)-0)+1),           .s2c0_adrb_0
		.rden_n          (_connected_to_rden_n_),          //  output,                        width = 1,           .s2c0_meb_n_0
		.sd_n            (_connected_to_sd_n_),            //  output,                        width = 1,           .s2c0_sd_n_0
		.wraddress       (_connected_to_wraddress_),       //  output,  width = (((c_ADDR_BITS-1)-0)+1),           .s2c0_adra_0
		.wren_n          (_connected_to_wren_n_),          //  output,                        width = 1,           .s2c0_mea_n_0
		.refclk_out      (_connected_to_refclk_out_),      //  output,                        width = 1,           .clock
		.q               (_connected_to_q_),               //   input,  width = (((c_WORD_SIZE-1)-0)+1), ram_output.s2c0_qb_0
		.esram_clk_i     (_connected_to_esram_clk_i_),     //   input,                        width = 1,           .esram2f_clk
		.iopll_lock2core (_connected_to_iopll_lock2core_), //   input,                        width = 1,           .iopll_lock2core
		.iopll_lock      (_connected_to_iopll_lock_),      //  output,                        width = 1, iopll_lock.writeresponsevalid_n
		.refclk          (_connected_to_refclk_),          //   input,                        width = 1,     refclk.clk
		.esram_clk       (_connected_to_esram_clk_),       //  output,                        width = 1,  esram_clk.clk
		.esram_rst       (_connected_to_esram_rst_)        //  output,                        width = 1,  esram_rst.reset
	);

