module qsys_top_av_hbm_0 (
		input  wire        clk,                              //                 clk.clk
		input  wire        rst,                              //                 rst.reset
		input  wire [0:0]  av_address,                       //              reg_if.address
		input  wire        av_read,                          //                    .read
		output wire        av_waitrequest,                   //                    .waitrequest
		input  wire        av_write,                         //                    .write
		output wire [31:0] av_readdata,                      //                    .readdata
		input  wire [31:0] av_writedata,                     //                    .writedata
		input  wire        bottom_core_clk_iopll_refclk_clk, // hbm_bottom_ref_clks.iopll_ref_clk
		input  wire        bottom_pll_ref_clk_clk,           //                    .pll_ref_clk
		input  wire        top_core_clk_iopll_ref_clk_clk,   //    hbm_top_ref_clks.iopll_ref_clk
		input  wire        top_pll_ref_clk_clk,              //                    .pll_ref_clk
		input  wire        bottom_m2u_bridge_cattrip,        //          bottom_m2u.cattrip
		input  wire [2:0]  bottom_m2u_bridge_temp,           //                    .temp
		input  wire [7:0]  bottom_m2u_bridge_wso,            //                    .wso
		output wire        bottom_m2u_bridge_reset_n,        //                    .reset
		output wire        bottom_m2u_bridge_wrst_n,         //                    .wrst
		output wire        bottom_m2u_bridge_wrck,           //                    .wrck
		output wire        bottom_m2u_bridge_shiftwr,        //                    .shiftwr
		output wire        bottom_m2u_bridge_capturewr,      //                    .capturewr
		output wire        bottom_m2u_bridge_updatewr,       //                    .updatewr
		output wire        bottom_m2u_bridge_selectwir,      //                    .selectwir
		output wire        bottom_m2u_bridge_wsi,            //                    .wsi
		input  wire        top_m2u_bridge_cattrip,           //             top_m2u.cattrip
		input  wire [2:0]  top_m2u_bridge_temp,              //                    .temp
		input  wire [7:0]  top_m2u_bridge_wso,               //                    .wso
		output wire        top_m2u_bridge_reset_n,           //                    .reset
		output wire        top_m2u_bridge_wrst_n,            //                    .wrst
		output wire        top_m2u_bridge_wrck,              //                    .wrck
		output wire        top_m2u_bridge_shiftwr,           //                    .shiftwr
		output wire        top_m2u_bridge_capturewr,         //                    .capturewr
		output wire        top_m2u_bridge_updatewr,          //                    .updatewr
		output wire        top_m2u_bridge_selectwir,         //                    .selectwir
		output wire        top_m2u_bridge_wsi                //                    .wsi
	);
endmodule

