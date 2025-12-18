module s10_chip_id (
		input  wire        clk,        //    clk.clk
		input  wire        reset,      //  reset.reset
		output wire        data_valid, // output.valid
		output wire [63:0] chip_id,    //       .data
		input  wire        readid      // readid.readid
	);
endmodule

