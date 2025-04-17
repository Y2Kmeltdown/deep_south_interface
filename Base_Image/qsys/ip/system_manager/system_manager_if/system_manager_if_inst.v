	system_manager_if u0 (
		.clk                    (_connected_to_clk_),                    //   input,   width = 1,                    clk.clk
		.rst                    (_connected_to_rst_),                    //   input,   width = 1,                    rst.reset
		.pll_clk                (_connected_to_pll_clk_),                //   input,   width = 1,                pll_clk.clk
		.conf_d                 (_connected_to_conf_d_),                 //   inout,   width = 8,                 conf_d.conf_d
		.soft_reconfigure_req_n (_connected_to_soft_reconfigure_req_n_), //  output,   width = 1, soft_reconfigure_req_n.soft_reconfigure_req_n
		.d_address              (_connected_to_d_address_),              //  output,   width = 9,                 mem_if.address
		.d_read                 (_connected_to_d_read_),                 //  output,   width = 1,                       .read
		.d_write                (_connected_to_d_write_),                //  output,   width = 1,                       .write
		.d_readdata             (_connected_to_d_readdata_),             //   input,  width = 16,                       .readdata
		.d_writedata            (_connected_to_d_writedata_),            //  output,  width = 16,                       .writedata
		.d_waitrequest          (_connected_to_d_waitrequest_),          //   input,   width = 1,                       .waitrequest
		.c_address              (_connected_to_c_address_),              //   input,   width = 8,                 reg_if.address
		.c_read                 (_connected_to_c_read_),                 //   input,   width = 1,                       .read
		.c_write                (_connected_to_c_write_),                //   input,   width = 1,                       .write
		.c_readdata             (_connected_to_c_readdata_),             //  output,  width = 32,                       .readdata
		.c_writedata            (_connected_to_c_writedata_),            //   input,  width = 32,                       .writedata
		.conf_c_out             (_connected_to_conf_c_out_),             //  output,   width = 4,             conf_c_out.conf_c_out
		.conf_c_in              (_connected_to_conf_c_in_)               //   input,   width = 4,              conf_c_in.conf_c_in
	);

