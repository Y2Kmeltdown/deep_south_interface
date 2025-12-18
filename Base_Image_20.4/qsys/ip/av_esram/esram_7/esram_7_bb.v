module esram_7 (
		output wire [31:0] c7_q_0,          // ram_output.s2c7_qb_0
		output wire        esram2f_clk,     //           .esram2f_clk
		output wire        iopll_lock2core, //           .iopll_lock2core
		input  wire [31:0] c7_data_0,       //  ram_input.s2c7_da_0
		input  wire [10:0] c7_rdaddress_0,  //           .s2c7_adrb_0
		input  wire        c7_rden_n_0,     //           .s2c7_meb_n_0
		input  wire        c7_sd_n_0,       //           .s2c7_sd_n_0
		input  wire [10:0] c7_wraddress_0,  //           .s2c7_adra_0
		input  wire        c7_wren_n_0,     //           .s2c7_mea_n_0
		input  wire        refclk           //           .clock
	);
endmodule

