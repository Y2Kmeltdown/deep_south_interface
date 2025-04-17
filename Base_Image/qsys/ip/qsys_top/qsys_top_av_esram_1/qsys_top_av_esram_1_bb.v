module qsys_top_av_esram_1 (
		input  wire        refclk,         //     refclk.clk
		output wire        esram_clk,      //  esram_clk.clk
		output wire        esram_rst,      //  esram_rst.reset
		output wire        iopll_lock,     // iopll_lock.iopll_lock
		input  wire [10:0] av_address,     //     reg_if.address
		input  wire        av_read,        //           .read
		output wire        av_waitrequest, //           .waitrequest
		input  wire        av_write,       //           .write
		output wire [31:0] av_readdata,    //           .readdata
		input  wire [31:0] av_writedata    //           .writedata
	);
endmodule

