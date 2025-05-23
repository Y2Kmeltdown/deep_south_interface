	PCIe_to_BMC_IRQ_Generator_0 u0 (
		.address    (_connected_to_address_),    //   input,   width = 2,    avalon_slave_0.address
		.chipselect (_connected_to_chipselect_), //   input,   width = 1,                  .chipselect
		.write_n    (_connected_to_write_n_),    //   input,   width = 1,                  .write_n
		.writedata  (_connected_to_writedata_),  //   input,  width = 32,                  .writedata
		.readdata   (_connected_to_readdata_),   //  output,  width = 32,                  .readdata
		.clk        (_connected_to_clk_),        //   input,   width = 1,             clock.clk
		.reset_n    (_connected_to_reset_n_),    //   input,   width = 1,             reset.reset_n
		.irq_in     (_connected_to_irq_in_),     //   input,   width = 2, Ext_irq_interface.irq_in
		.irq        (_connected_to_irq_)         //  output,   width = 1,  interrupt_sender.irq
	);

