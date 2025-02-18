	IP_Tests_esRAM_AVMM_0 u0 (
		.av_address       (_connected_to_av_address_),       //   input,  width = 20,             av.address
		.av_write         (_connected_to_av_write_),         //   input,   width = 1,               .write
		.av_writedata     (_connected_to_av_writedata_),     //   input,  width = 32,               .writedata
		.av_read          (_connected_to_av_read_),          //   input,   width = 1,               .read
		.av_readdata      (_connected_to_av_readdata_),      //  output,  width = 32,               .readdata
		.av_waitrequest   (_connected_to_av_waitrequest_),   //  output,   width = 1,               .waitrequest
		.reset_n          (_connected_to_reset_n_),          //  output,   width = 1,          reset.reset_n
		.esram_clk_locked (_connected_to_esram_clk_locked_), //  output,   width = 1, esram_locked_1.esram_clk_locked
		.esram_clk        (_connected_to_esram_clk_),        //  output,   width = 1,      esram_clk.clk
		.refclk           (_connected_to_refclk_)            //   input,   width = 1,        ref_clk.clk
	);

