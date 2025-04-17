module esram (
		output wire [31:0] c0_q_0,          // ram_output.s2c0_qb_0
		output wire        esram2f_clk,     //           .esram2f_clk
		output wire        iopll_lock2core, //           .iopll_lock2core
		input  wire [31:0] c0_data_0,       //  ram_input.s2c0_da_0
		input  wire [10:0] c0_rdaddress_0,  //           .s2c0_adrb_0
		input  wire        c0_rden_n_0,     //           .s2c0_meb_n_0
		input  wire        c0_sd_n_0,       //           .s2c0_sd_n_0
		input  wire [10:0] c0_wraddress_0,  //           .s2c0_adra_0
		input  wire        c0_wren_n_0,     //           .s2c0_mea_n_0
		input  wire        refclk           //           .clock
	);
endmodule

