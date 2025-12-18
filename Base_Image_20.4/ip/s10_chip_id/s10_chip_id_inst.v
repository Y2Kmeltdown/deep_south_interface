	s10_chip_id u0 (
		.clk        (_connected_to_clk_),        //   input,   width = 1,    clk.clk
		.reset      (_connected_to_reset_),      //   input,   width = 1,  reset.reset
		.data_valid (_connected_to_data_valid_), //  output,   width = 1, output.valid
		.chip_id    (_connected_to_chip_id_),    //  output,  width = 64,       .data
		.readid     (_connected_to_readid_)      //   input,   width = 1, readid.readid
	);

