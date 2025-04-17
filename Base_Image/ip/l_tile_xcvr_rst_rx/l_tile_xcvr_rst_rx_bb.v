module l_tile_xcvr_rst_rx (
		input  wire       clock,                //                clock.clk
		input  wire       reset,                //                reset.reset
		output wire [0:0] rx_analogreset,       //       rx_analogreset.rx_analogreset
		output wire [0:0] rx_digitalreset,      //      rx_digitalreset.rx_digitalreset
		output wire [0:0] rx_ready,             //             rx_ready.rx_ready
		input  wire [0:0] rx_is_lockedtodata,   //   rx_is_lockedtodata.rx_is_lockedtodata
		input  wire [0:0] rx_cal_busy,          //          rx_cal_busy.rx_cal_busy
		input  wire [0:0] rx_analogreset_stat,  //  rx_analogreset_stat.rx_analogreset_stat
		input  wire [0:0] rx_digitalreset_stat  // rx_digitalreset_stat.rx_digitalreset_stat
	);
endmodule

