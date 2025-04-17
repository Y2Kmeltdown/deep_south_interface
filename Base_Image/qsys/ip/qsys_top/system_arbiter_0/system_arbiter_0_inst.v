	system_arbiter_0 u0 (
		.clk                (_connected_to_clk_),                //   input,   width = 1,     clock.clk
		.reset              (_connected_to_reset_),              //   input,   width = 1,     reset.reset
		.avs_s0_address     (_connected_to_avs_s0_address_),     //   input,   width = 2,        s0.address
		.avs_s0_read        (_connected_to_avs_s0_read_),        //   input,   width = 1,          .read
		.avs_s0_readdata    (_connected_to_avs_s0_readdata_),    //  output,  width = 32,          .readdata
		.avs_s0_write       (_connected_to_avs_s0_write_),       //   input,   width = 1,          .write
		.avs_s0_writedata   (_connected_to_avs_s0_writedata_),   //   input,  width = 32,          .writedata
		.avs_s0_waitrequest (_connected_to_avs_s0_waitrequest_), //  output,   width = 1,          .waitrequest
		.hps_gp_o           (_connected_to_hps_gp_o_),           //   input,  width = 32, hps_gp_if.gp_out
		.hps_gp_i           (_connected_to_hps_gp_i_)            //  output,  width = 32,          .gp_in
	);

