	s10_temperature u0 (
		.clk               (_connected_to_clk_),               //   input,   width = 1,   clk.clk
		.reset             (_connected_to_reset_),             //   input,   width = 1, reset.reset
		.rsp_valid         (_connected_to_rsp_valid_),         //  output,   width = 1,   rsp.valid
		.rsp_data          (_connected_to_rsp_data_),          //  output,  width = 32,      .data
		.rsp_channel       (_connected_to_rsp_channel_),       //  output,   width = 4,      .channel
		.rsp_startofpacket (_connected_to_rsp_startofpacket_), //  output,   width = 1,      .startofpacket
		.rsp_endofpacket   (_connected_to_rsp_endofpacket_),   //  output,   width = 1,      .endofpacket
		.cmd_valid         (_connected_to_cmd_valid_),         //   input,   width = 1,   cmd.valid
		.cmd_ready         (_connected_to_cmd_ready_),         //  output,   width = 1,      .ready
		.cmd_data          (_connected_to_cmd_data_)           //   input,   width = 9,      .data
	);

