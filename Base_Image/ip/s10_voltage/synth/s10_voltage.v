// s10_voltage.v

// Generated using ACDS version 19.4 64

`timescale 1 ps / 1 ps
module s10_voltage (
		input  wire        clk,               //   clk.clk
		input  wire        reset,             // reset.reset
		output wire        rsp_valid,         //   rsp.valid
		output wire [31:0] rsp_data,          //      .data
		output wire [3:0]  rsp_channel,       //      .channel
		output wire        rsp_startofpacket, //      .startofpacket
		output wire        rsp_endofpacket,   //      .endofpacket
		input  wire        cmd_valid,         //   cmd.valid
		output wire        cmd_ready,         //      .ready
		input  wire [15:0] cmd_data           //      .data
	);

	s10_voltage_altera_s10_voltage_sensor_1911_lilv2cy #(
		.CMD_WIDTH (16)
	) s10_voltage_sensor_0 (
		.clk               (clk),               //   input,   width = 1,   clk.clk
		.reset             (reset),             //   input,   width = 1, reset.reset
		.rsp_valid         (rsp_valid),         //  output,   width = 1,   rsp.valid
		.rsp_data          (rsp_data),          //  output,  width = 32,      .data
		.rsp_channel       (rsp_channel),       //  output,   width = 4,      .channel
		.rsp_startofpacket (rsp_startofpacket), //  output,   width = 1,      .startofpacket
		.rsp_endofpacket   (rsp_endofpacket),   //  output,   width = 1,      .endofpacket
		.cmd_valid         (cmd_valid),         //   input,   width = 1,   cmd.valid
		.cmd_ready         (cmd_ready),         //  output,   width = 1,      .ready
		.cmd_data          (cmd_data)           //   input,  width = 16,      .data
	);

endmodule
