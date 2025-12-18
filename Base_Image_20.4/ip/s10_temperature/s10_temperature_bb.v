module s10_temperature (
		input  wire        clk,               //   clk.clk
		input  wire        reset,             // reset.reset
		output wire        rsp_valid,         //   rsp.valid
		output wire [31:0] rsp_data,          //      .data
		output wire [3:0]  rsp_channel,       //      .channel
		output wire        rsp_startofpacket, //      .startofpacket
		output wire        rsp_endofpacket,   //      .endofpacket
		input  wire        cmd_valid,         //   cmd.valid
		output wire        cmd_ready,         //      .ready
		input  wire [8:0]  cmd_data           //      .data
	);
endmodule

