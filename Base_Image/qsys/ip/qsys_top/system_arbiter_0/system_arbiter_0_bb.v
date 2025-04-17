module system_arbiter_0 (
		input  wire        clk,                //     clock.clk
		input  wire        reset,              //     reset.reset
		input  wire [1:0]  avs_s0_address,     //        s0.address
		input  wire        avs_s0_read,        //          .read
		output wire [31:0] avs_s0_readdata,    //          .readdata
		input  wire        avs_s0_write,       //          .write
		input  wire [31:0] avs_s0_writedata,   //          .writedata
		output wire        avs_s0_waitrequest, //          .waitrequest
		input  wire [31:0] hps_gp_o,           // hps_gp_if.gp_out
		output wire [31:0] hps_gp_i            //          .gp_in
	);
endmodule

