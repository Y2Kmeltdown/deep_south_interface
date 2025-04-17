	l_tile_xcvr_phy_prod u0 (
		.tx_analogreset          (_connected_to_tx_analogreset_),          //   input,    width = 4,          tx_analogreset.tx_analogreset
		.rx_analogreset          (_connected_to_rx_analogreset_),          //   input,    width = 4,          rx_analogreset.rx_analogreset
		.tx_digitalreset         (_connected_to_tx_digitalreset_),         //   input,    width = 4,         tx_digitalreset.tx_digitalreset
		.rx_digitalreset         (_connected_to_rx_digitalreset_),         //   input,    width = 4,         rx_digitalreset.rx_digitalreset
		.tx_analogreset_stat     (_connected_to_tx_analogreset_stat_),     //  output,    width = 4,     tx_analogreset_stat.tx_analogreset_stat
		.rx_analogreset_stat     (_connected_to_rx_analogreset_stat_),     //  output,    width = 4,     rx_analogreset_stat.rx_analogreset_stat
		.tx_digitalreset_stat    (_connected_to_tx_digitalreset_stat_),    //  output,    width = 4,    tx_digitalreset_stat.tx_digitalreset_stat
		.rx_digitalreset_stat    (_connected_to_rx_digitalreset_stat_),    //  output,    width = 4,    rx_digitalreset_stat.rx_digitalreset_stat
		.tx_cal_busy             (_connected_to_tx_cal_busy_),             //  output,    width = 4,             tx_cal_busy.tx_cal_busy
		.rx_cal_busy             (_connected_to_rx_cal_busy_),             //  output,    width = 4,             rx_cal_busy.rx_cal_busy
		.tx_serial_clk0          (_connected_to_tx_serial_clk0_),          //   input,    width = 4,          tx_serial_clk0.clk
		.rx_cdr_refclk0          (_connected_to_rx_cdr_refclk0_),          //   input,    width = 1,          rx_cdr_refclk0.clk
		.tx_serial_data          (_connected_to_tx_serial_data_),          //  output,    width = 4,          tx_serial_data.tx_serial_data
		.rx_serial_data          (_connected_to_rx_serial_data_),          //   input,    width = 4,          rx_serial_data.rx_serial_data
		.rx_is_lockedtoref       (_connected_to_rx_is_lockedtoref_),       //  output,    width = 4,       rx_is_lockedtoref.rx_is_lockedtoref
		.rx_is_lockedtodata      (_connected_to_rx_is_lockedtodata_),      //  output,    width = 4,      rx_is_lockedtodata.rx_is_lockedtodata
		.tx_coreclkin            (_connected_to_tx_coreclkin_),            //   input,    width = 4,            tx_coreclkin.clk
		.rx_coreclkin            (_connected_to_rx_coreclkin_),            //   input,    width = 4,            rx_coreclkin.clk
		.tx_clkout               (_connected_to_tx_clkout_),               //  output,    width = 4,               tx_clkout.clk
		.rx_clkout               (_connected_to_rx_clkout_),               //  output,    width = 4,               rx_clkout.clk
		.rx_clkout2              (_connected_to_rx_clkout2_),              //  output,    width = 4,              rx_clkout2.clk
		.tx_parallel_data        (_connected_to_tx_parallel_data_),        //   input,  width = 256,        tx_parallel_data.tx_parallel_data
		.tx_control              (_connected_to_tx_control_),              //   input,    width = 8,              tx_control.tx_control
		.tx_enh_data_valid       (_connected_to_tx_enh_data_valid_),       //   input,    width = 4,       tx_enh_data_valid.tx_enh_data_valid
		.unused_tx_parallel_data (_connected_to_unused_tx_parallel_data_), //   input,   width = 52, unused_tx_parallel_data.unused_tx_parallel_data
		.rx_parallel_data        (_connected_to_rx_parallel_data_),        //  output,  width = 256,        rx_parallel_data.rx_parallel_data
		.rx_control              (_connected_to_rx_control_),              //  output,    width = 8,              rx_control.rx_control
		.rx_enh_data_valid       (_connected_to_rx_enh_data_valid_),       //  output,    width = 4,       rx_enh_data_valid.rx_enh_data_valid
		.unused_rx_parallel_data (_connected_to_unused_rx_parallel_data_), //  output,   width = 52, unused_rx_parallel_data.unused_rx_parallel_data
		.tx_fifo_full            (_connected_to_tx_fifo_full_),            //  output,    width = 4,            tx_fifo_full.tx_fifo_full
		.tx_fifo_empty           (_connected_to_tx_fifo_empty_),           //  output,    width = 4,           tx_fifo_empty.tx_fifo_empty
		.rx_fifo_full            (_connected_to_rx_fifo_full_),            //  output,    width = 4,            rx_fifo_full.rx_fifo_full
		.rx_fifo_empty           (_connected_to_rx_fifo_empty_),           //  output,    width = 4,           rx_fifo_empty.rx_fifo_empty
		.rx_fifo_rd_en           (_connected_to_rx_fifo_rd_en_),           //   input,    width = 4,           rx_fifo_rd_en.rx_fifo_rd_en
		.rx_enh_blk_lock         (_connected_to_rx_enh_blk_lock_)          //  output,    width = 4,         rx_enh_blk_lock.rx_enh_blk_lock
	);

