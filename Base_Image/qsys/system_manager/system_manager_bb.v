module system_manager (
		input  wire        config_clk_clk,                          //       config_clk.clk
		input  wire        config_rstn_reset_n,                     //      config_rstn.reset_n
		output wire        system_mm_waitrequest,                   //        system_mm.waitrequest
		output wire [31:0] system_mm_readdata,                      //                 .readdata
		output wire        system_mm_readdatavalid,                 //                 .readdatavalid
		input  wire [0:0]  system_mm_burstcount,                    //                 .burstcount
		input  wire [31:0] system_mm_writedata,                     //                 .writedata
		input  wire [12:0] system_mm_address,                       //                 .address
		input  wire        system_mm_write,                         //                 .write
		input  wire        system_mm_read,                          //                 .read
		input  wire [3:0]  system_mm_byteenable,                    //                 .byteenable
		input  wire        system_mm_debugaccess,                   //                 .debugaccess
		inout  wire [7:0]  conf_d_conf_d,                           //           conf_d.conf_d
		output wire        soft_recfg_req_n_soft_reconfigure_req_n, // soft_recfg_req_n.soft_reconfigure_req_n
		output wire [3:0]  conf_c_out_conf_c_out,                   //       conf_c_out.conf_c_out
		input  wire [3:0]  conf_c_in_conf_c_in,                     //        conf_c_in.conf_c_in
		input  wire        user_clk_clk,                            //         user_clk.clk
		input  wire        user_rstn_reset_n                        //        user_rstn.reset_n
	);
endmodule

