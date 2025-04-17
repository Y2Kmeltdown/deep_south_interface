module system_manager_flash_memory_buffer (
		input  wire [8:0]  address,     //     s1.address
		input  wire        clken,       //       .clken
		input  wire        chipselect,  //       .chipselect
		input  wire        write,       //       .write
		output wire [15:0] readdata,    //       .readdata
		input  wire [15:0] writedata,   //       .writedata
		input  wire [1:0]  byteenable,  //       .byteenable
		input  wire [8:0]  address2,    //     s2.address
		input  wire        chipselect2, //       .chipselect
		input  wire        clken2,      //       .clken
		input  wire        write2,      //       .write
		output wire [15:0] readdata2,   //       .readdata
		input  wire [15:0] writedata2,  //       .writedata
		input  wire [1:0]  byteenable2, //       .byteenable
		input  wire        clk,         //   clk1.clk
		input  wire        reset,       // reset1.reset
		input  wire        reset_req    //       .reset_req
	);
endmodule

