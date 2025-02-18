	system_manager u0 (
		.config_clk_clk                          (_connected_to_config_clk_clk_),                          //   input,   width = 1,       config_clk.clk
		.config_rstn_reset_n                     (_connected_to_config_rstn_reset_n_),                     //   input,   width = 1,      config_rstn.reset_n
		.system_mm_waitrequest                   (_connected_to_system_mm_waitrequest_),                   //  output,   width = 1,        system_mm.waitrequest
		.system_mm_readdata                      (_connected_to_system_mm_readdata_),                      //  output,  width = 32,                 .readdata
		.system_mm_readdatavalid                 (_connected_to_system_mm_readdatavalid_),                 //  output,   width = 1,                 .readdatavalid
		.system_mm_burstcount                    (_connected_to_system_mm_burstcount_),                    //   input,   width = 1,                 .burstcount
		.system_mm_writedata                     (_connected_to_system_mm_writedata_),                     //   input,  width = 32,                 .writedata
		.system_mm_address                       (_connected_to_system_mm_address_),                       //   input,  width = 11,                 .address
		.system_mm_write                         (_connected_to_system_mm_write_),                         //   input,   width = 1,                 .write
		.system_mm_read                          (_connected_to_system_mm_read_),                          //   input,   width = 1,                 .read
		.system_mm_byteenable                    (_connected_to_system_mm_byteenable_),                    //   input,   width = 4,                 .byteenable
		.system_mm_debugaccess                   (_connected_to_system_mm_debugaccess_),                   //   input,   width = 1,                 .debugaccess
		.conf_d_conf_d                           (_connected_to_conf_d_conf_d_),                           //   inout,   width = 8,           conf_d.conf_d
		.soft_recfg_req_n_soft_reconfigure_req_n (_connected_to_soft_recfg_req_n_soft_reconfigure_req_n_), //  output,   width = 1, soft_recfg_req_n.soft_reconfigure_req_n
		.conf_c_out_conf_c_out                   (_connected_to_conf_c_out_conf_c_out_),                   //  output,   width = 4,       conf_c_out.conf_c_out
		.conf_c_in_conf_c_in                     (_connected_to_conf_c_in_conf_c_in_),                     //   input,   width = 4,        conf_c_in.conf_c_in
		.user_clk_clk                            (_connected_to_user_clk_clk_),                            //   input,   width = 1,         user_clk.clk
		.user_rstn_reset_n                       (_connected_to_user_rstn_reset_n_)                        //   input,   width = 1,        user_rstn.reset_n
	);

