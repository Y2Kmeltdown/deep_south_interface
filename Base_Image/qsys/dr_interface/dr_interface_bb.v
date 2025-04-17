module dr_interface (
		input  wire        config_clk_clk,           //     config_clk.clk
		input  wire        config_rstn_reset_n,      //    config_rstn.reset_n
		input  wire        pcie_user_clk_clk,        //  pcie_user_clk.clk
		input  wire        pcie_user_rstn_reset_n,   // pcie_user_rstn.reset_n
		input  wire        avmm_phy_0_waitrequest,   //     avmm_phy_0.waitrequest
		input  wire [31:0] avmm_phy_0_readdata,      //               .readdata
		input  wire        avmm_phy_0_readdatavalid, //               .readdatavalid
		output wire [0:0]  avmm_phy_0_burstcount,    //               .burstcount
		output wire [31:0] avmm_phy_0_writedata,     //               .writedata
		output wire [12:0] avmm_phy_0_address,       //               .address
		output wire        avmm_phy_0_write,         //               .write
		output wire        avmm_phy_0_read,          //               .read
		output wire [3:0]  avmm_phy_0_byteenable,    //               .byteenable
		output wire        avmm_phy_0_debugaccess,   //               .debugaccess
		input  wire        avmm_phy_1_waitrequest,   //     avmm_phy_1.waitrequest
		input  wire [31:0] avmm_phy_1_readdata,      //               .readdata
		input  wire        avmm_phy_1_readdatavalid, //               .readdatavalid
		output wire [0:0]  avmm_phy_1_burstcount,    //               .burstcount
		output wire [31:0] avmm_phy_1_writedata,     //               .writedata
		output wire [12:0] avmm_phy_1_address,       //               .address
		output wire        avmm_phy_1_write,         //               .write
		output wire        avmm_phy_1_read,          //               .read
		output wire [3:0]  avmm_phy_1_byteenable,    //               .byteenable
		output wire        avmm_phy_1_debugaccess,   //               .debugaccess
		input  wire        avmm_phy_2_waitrequest,   //     avmm_phy_2.waitrequest
		input  wire [31:0] avmm_phy_2_readdata,      //               .readdata
		input  wire        avmm_phy_2_readdatavalid, //               .readdatavalid
		output wire [0:0]  avmm_phy_2_burstcount,    //               .burstcount
		output wire [31:0] avmm_phy_2_writedata,     //               .writedata
		output wire [12:0] avmm_phy_2_address,       //               .address
		output wire        avmm_phy_2_write,         //               .write
		output wire        avmm_phy_2_read,          //               .read
		output wire [3:0]  avmm_phy_2_byteenable,    //               .byteenable
		output wire        avmm_phy_2_debugaccess,   //               .debugaccess
		input  wire        avmm_phy_3_waitrequest,   //     avmm_phy_3.waitrequest
		input  wire [31:0] avmm_phy_3_readdata,      //               .readdata
		input  wire        avmm_phy_3_readdatavalid, //               .readdatavalid
		output wire [0:0]  avmm_phy_3_burstcount,    //               .burstcount
		output wire [31:0] avmm_phy_3_writedata,     //               .writedata
		output wire [12:0] avmm_phy_3_address,       //               .address
		output wire        avmm_phy_3_write,         //               .write
		output wire        avmm_phy_3_read,          //               .read
		output wire [3:0]  avmm_phy_3_byteenable,    //               .byteenable
		output wire        avmm_phy_3_debugaccess,   //               .debugaccess
		output wire        avmm_slave_waitrequest,   //     avmm_slave.waitrequest
		output wire [31:0] avmm_slave_readdata,      //               .readdata
		output wire        avmm_slave_readdatavalid, //               .readdatavalid
		input  wire [0:0]  avmm_slave_burstcount,    //               .burstcount
		input  wire [31:0] avmm_slave_writedata,     //               .writedata
		input  wire [17:0] avmm_slave_address,       //               .address
		input  wire        avmm_slave_write,         //               .write
		input  wire        avmm_slave_read,          //               .read
		input  wire [3:0]  avmm_slave_byteenable,    //               .byteenable
		input  wire        avmm_slave_debugaccess    //               .debugaccess
	);
endmodule

