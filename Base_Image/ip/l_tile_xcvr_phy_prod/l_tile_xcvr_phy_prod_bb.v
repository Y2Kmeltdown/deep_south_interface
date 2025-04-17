module l_tile_xcvr_phy_prod (
		input  wire [3:0]   tx_analogreset,          //          tx_analogreset.tx_analogreset
		input  wire [3:0]   rx_analogreset,          //          rx_analogreset.rx_analogreset
		input  wire [3:0]   tx_digitalreset,         //         tx_digitalreset.tx_digitalreset
		input  wire [3:0]   rx_digitalreset,         //         rx_digitalreset.rx_digitalreset
		output wire [3:0]   tx_analogreset_stat,     //     tx_analogreset_stat.tx_analogreset_stat
		output wire [3:0]   rx_analogreset_stat,     //     rx_analogreset_stat.rx_analogreset_stat
		output wire [3:0]   tx_digitalreset_stat,    //    tx_digitalreset_stat.tx_digitalreset_stat
		output wire [3:0]   rx_digitalreset_stat,    //    rx_digitalreset_stat.rx_digitalreset_stat
		output wire [3:0]   tx_cal_busy,             //             tx_cal_busy.tx_cal_busy
		output wire [3:0]   rx_cal_busy,             //             rx_cal_busy.rx_cal_busy
		input  wire [3:0]   tx_serial_clk0,          //          tx_serial_clk0.clk
		input  wire         rx_cdr_refclk0,          //          rx_cdr_refclk0.clk
		output wire [3:0]   tx_serial_data,          //          tx_serial_data.tx_serial_data
		input  wire [3:0]   rx_serial_data,          //          rx_serial_data.rx_serial_data
		output wire [3:0]   rx_is_lockedtoref,       //       rx_is_lockedtoref.rx_is_lockedtoref
		output wire [3:0]   rx_is_lockedtodata,      //      rx_is_lockedtodata.rx_is_lockedtodata
		input  wire [3:0]   tx_coreclkin,            //            tx_coreclkin.clk
		input  wire [3:0]   rx_coreclkin,            //            rx_coreclkin.clk
		output wire [3:0]   tx_clkout,               //               tx_clkout.clk
		output wire [3:0]   rx_clkout,               //               rx_clkout.clk
		output wire [3:0]   rx_clkout2,              //              rx_clkout2.clk
		input  wire [255:0] tx_parallel_data,        //        tx_parallel_data.tx_parallel_data
		input  wire [7:0]   tx_control,              //              tx_control.tx_control
		input  wire [3:0]   tx_enh_data_valid,       //       tx_enh_data_valid.tx_enh_data_valid
		input  wire [51:0]  unused_tx_parallel_data, // unused_tx_parallel_data.unused_tx_parallel_data
		output wire [255:0] rx_parallel_data,        //        rx_parallel_data.rx_parallel_data
		output wire [7:0]   rx_control,              //              rx_control.rx_control
		output wire [3:0]   rx_enh_data_valid,       //       rx_enh_data_valid.rx_enh_data_valid
		output wire [51:0]  unused_rx_parallel_data, // unused_rx_parallel_data.unused_rx_parallel_data
		output wire [3:0]   tx_fifo_full,            //            tx_fifo_full.tx_fifo_full
		output wire [3:0]   tx_fifo_empty,           //           tx_fifo_empty.tx_fifo_empty
		output wire [3:0]   rx_fifo_full,            //            rx_fifo_full.rx_fifo_full
		output wire [3:0]   rx_fifo_empty,           //           rx_fifo_empty.rx_fifo_empty
		input  wire [3:0]   rx_fifo_rd_en,           //           rx_fifo_rd_en.rx_fifo_rd_en
		output wire [3:0]   rx_enh_blk_lock          //         rx_enh_blk_lock.rx_enh_blk_lock
	);
endmodule

