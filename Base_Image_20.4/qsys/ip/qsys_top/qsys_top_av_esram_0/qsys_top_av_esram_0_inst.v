	qsys_top_av_esram_0 u0 (
		.refclk         (_connected_to_refclk_),         //   input,   width = 1,     refclk.clk
		.esram_clk      (_connected_to_esram_clk_),      //  output,   width = 1,  esram_clk.clk
		.esram_rst      (_connected_to_esram_rst_),      //  output,   width = 1,  esram_rst.reset
		.iopll_lock     (_connected_to_iopll_lock_),     //  output,   width = 1, iopll_lock.iopll_lock
		.av_address     (_connected_to_av_address_),     //   input,  width = 11,     reg_if.address
		.av_read        (_connected_to_av_read_),        //   input,   width = 1,           .read
		.av_waitrequest (_connected_to_av_waitrequest_), //  output,   width = 1,           .waitrequest
		.av_write       (_connected_to_av_write_),       //   input,   width = 1,           .write
		.av_readdata    (_connected_to_av_readdata_),    //  output,  width = 32,           .readdata
		.av_writedata   (_connected_to_av_writedata_)    //   input,  width = 32,           .writedata
	);

