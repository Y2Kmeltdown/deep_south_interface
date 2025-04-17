module qsys_top_avmm_to_esram_0 #(
		parameter c_ADDR_BITS = 16,
		parameter c_WORD_SIZE = 32
	) (
		input  wire [(((c_ADDR_BITS-1)-0)+1)-1:0] av_address,      //         av.address
		input  wire                               av_read,         //           .read
		output wire                               av_waitrequest,  //           .waitrequest
		input  wire                               av_write,        //           .write
		output wire [(((c_WORD_SIZE-1)-0)+1)-1:0] av_readdata,     //           .readdata
		input  wire [(((c_WORD_SIZE-1)-0)+1)-1:0] av_writedata,    //           .writedata
		output wire [(((c_WORD_SIZE-1)-0)+1)-1:0] data,            //  ram_input.s2c0_da_0
		output wire [(((c_ADDR_BITS-1)-0)+1)-1:0] rdaddress,       //           .s2c0_adrb_0
		output wire                               rden_n,          //           .s2c0_meb_n_0
		output wire                               sd_n,            //           .s2c0_sd_n_0
		output wire [(((c_ADDR_BITS-1)-0)+1)-1:0] wraddress,       //           .s2c0_adra_0
		output wire                               wren_n,          //           .s2c0_mea_n_0
		output wire                               refclk_out,      //           .clock
		input  wire [(((c_WORD_SIZE-1)-0)+1)-1:0] q,               // ram_output.s2c0_qb_0
		input  wire                               esram_clk_i,     //           .esram2f_clk
		input  wire                               iopll_lock2core, //           .iopll_lock2core
		output wire                               iopll_lock,      // iopll_lock.writeresponsevalid_n
		input  wire                               refclk,          //     refclk.clk
		output wire                               esram_clk,       //  esram_clk.clk
		output wire                               esram_rst        //  esram_rst.reset
	);
endmodule

