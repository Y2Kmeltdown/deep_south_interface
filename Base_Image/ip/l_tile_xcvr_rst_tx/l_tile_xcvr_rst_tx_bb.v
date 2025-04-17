module l_tile_xcvr_rst_tx (
		input  wire       clock,                //                clock.clk
		input  wire       reset,                //                reset.reset
		output wire [3:0] tx_analogreset,       //       tx_analogreset.tx_analogreset
		output wire [3:0] tx_digitalreset,      //      tx_digitalreset.tx_digitalreset
		output wire [3:0] tx_ready,             //             tx_ready.tx_ready
		input  wire [0:0] pll_locked,           //           pll_locked.pll_locked
		input  wire [0:0] pll_select,           //           pll_select.pll_select
		input  wire [3:0] tx_cal_busy,          //          tx_cal_busy.tx_cal_busy
		input  wire [3:0] tx_analogreset_stat,  //  tx_analogreset_stat.tx_analogreset_stat
		input  wire [3:0] tx_digitalreset_stat  // tx_digitalreset_stat.tx_digitalreset_stat
	);
endmodule

