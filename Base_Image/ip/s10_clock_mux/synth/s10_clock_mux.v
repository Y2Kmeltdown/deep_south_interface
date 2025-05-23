// s10_clock_mux.v

// Generated using ACDS version 20.3 158

`timescale 1 ps / 1 ps
module s10_clock_mux (
		input  wire  inclk0x,   //   inclk0x.clk
		input  wire  inclk1x,   //   inclk1x.clk
		input  wire  clkselect, // clkselect.export
		output wire  outclk     //    outclk.clk
	);

	s10_clock_mux_stratix10_clkctrl_2000_gooqn2q stratix10_clkctrl_0 (
		.inclk0x   (inclk0x),   //   input,  width = 1,   inclk0x.clk
		.inclk1x   (inclk1x),   //   input,  width = 1,   inclk1x.clk
		.clkselect (clkselect), //   input,  width = 1, clkselect.export
		.outclk    (outclk)     //  output,  width = 1,    outclk.clk
	);

endmodule
