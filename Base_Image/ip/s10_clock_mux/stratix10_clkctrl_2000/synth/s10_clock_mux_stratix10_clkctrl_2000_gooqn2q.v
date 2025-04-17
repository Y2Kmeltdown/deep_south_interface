// (C) 2001-2020 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module  s10_clock_mux_stratix10_clkctrl_2000_gooqn2q  (
    inclk0x,
    inclk1x,
    clkselect,
    outclk
);

input inclk0x;
input inclk1x;
input clkselect;
output outclk;

wire inclk_muxout;

s10_clock_mux_stratix10_clkctrl_2000_gooqn2q_clksel_mux clksel_inst (
    .inclk0x(inclk0x),
    .inclk1x(inclk1x),
    .clkselect(clkselect),
    .clkout(inclk_muxout)
); 
GLOBAL global_inst(.in(inclk_muxout), .out(outclk));

endmodule

module s10_clock_mux_stratix10_clkctrl_2000_gooqn2q_clksel_mux (
    input inclk0x,
    input inclk1x,
    input clkselect,
    output clkout
);

assign clkout = clkselect ? inclk1x : inclk0x;

endmodule


