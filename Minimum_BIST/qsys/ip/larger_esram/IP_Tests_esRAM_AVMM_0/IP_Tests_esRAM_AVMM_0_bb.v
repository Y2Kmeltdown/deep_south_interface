module IP_Tests_esRAM_AVMM_0 (
		input  wire [19:0] av_address,       //             av.address
		input  wire        av_write,         //               .write
		input  wire [31:0] av_writedata,     //               .writedata
		input  wire        av_read,          //               .read
		output wire [31:0] av_readdata,      //               .readdata
		output wire        av_waitrequest,   //               .waitrequest
		output wire        reset_n,          //          reset.reset_n
		output wire        esram_clk_locked, // esram_locked_1.esram_clk_locked
		output wire        esram_clk,        //      esram_clk.clk
		input  wire        refclk            //        ref_clk.clk
	);
endmodule

