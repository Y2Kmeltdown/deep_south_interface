module system_manager_system_manager_if_0 (
		input  wire        clk,                    //                    clk.clk
		input  wire        rst,                    //            Reset_Input.reset
		input  wire        pll_clk,                //                pll_clk.clk
		inout  wire [7:0]  conf_d,                 //                 conf_d.conf_d
		output wire        soft_reconfigure_req_n, // soft_reconfigure_req_n.soft_reconfigure_req_n
		output wire [9:0]  d_address,              //                 mem_if.address
		output wire        d_read,                 //                       .read
		output wire        d_write,                //                       .write
		input  wire [15:0] d_readdata,             //                       .readdata
		output wire [15:0] d_writedata,            //                       .writedata
		input  wire        d_waitrequest,          //                       .waitrequest
		input  wire [7:0]  c_address,              //                 reg_if.address
		input  wire        c_read,                 //                       .read
		input  wire        c_write,                //                       .write
		output wire [31:0] c_readdata,             //                       .readdata
		input  wire [31:0] c_writedata,            //                       .writedata
		output wire [3:0]  conf_c_out,             //             conf_c_out.conf_c_out
		input  wire [3:0]  conf_c_in               //              conf_c_in.conf_c_in
	);
endmodule

