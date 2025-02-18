module PCIe_to_BMC_IRQ_Generator_1 #(
		parameter appear_in_device_tree = 0,
		parameter IRQ_WIDTH             = 8
	) (
		input  wire [1:0]  address,    //    avalon_slave_0.address
		input  wire        chipselect, //                  .chipselect
		input  wire        write_n,    //                  .write_n
		input  wire [31:0] writedata,  //                  .writedata
		output wire [31:0] readdata,   //                  .readdata
		input  wire        clk,        //             clock.clk
		input  wire        reset_n,    //             reset.reset_n
		output wire        irq,        //  interrupt_sender.irq
		input  wire [1:0]  irq_in      // Ext_irq_interface.irq_in
	);
endmodule

