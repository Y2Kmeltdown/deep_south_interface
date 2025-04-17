module ed_synth (
		input  wire       bottom_core_clk_iopll_reset_reset,       //  bottom_core_clk_iopll_reset.reset
		input  wire       bottom_core_clk_iopll_refclk_clk,        // bottom_core_clk_iopll_refclk.clk
		input  wire       bottom_pll_ref_clk_clk,                  //           bottom_pll_ref_clk.clk
		input  wire       bottom_wmcrst_n_in_reset_n,              //           bottom_wmcrst_n_in.reset_n
		input  wire       bottom_only_reset_in_reset,              //         bottom_only_reset_in.reset
		input  wire       bottom_m2u_bridge_cattrip,               //            bottom_m2u_bridge.cattrip
		input  wire [2:0] bottom_m2u_bridge_temp,                  //                             .temp
		input  wire [7:0] bottom_m2u_bridge_wso,                   //                             .wso
		output wire       bottom_m2u_bridge_reset_n,               //                             .reset_n
		output wire       bottom_m2u_bridge_wrst_n,                //                             .wrst_n
		output wire       bottom_m2u_bridge_wrck,                  //                             .wrck
		output wire       bottom_m2u_bridge_shiftwr,               //                             .shiftwr
		output wire       bottom_m2u_bridge_capturewr,             //                             .capturewr
		output wire       bottom_m2u_bridge_updatewr,              //                             .updatewr
		output wire       bottom_m2u_bridge_selectwir,             //                             .selectwir
		output wire       bottom_m2u_bridge_wsi,                   //                             .wsi
		input  wire       top_pll_ref_clk_clk,                     //              top_pll_ref_clk.clk
		input  wire       top_wmcrst_n_in_reset_n,                 //              top_wmcrst_n_in.reset_n
		input  wire       top_only_reset_in_reset,                 //            top_only_reset_in.reset
		input  wire       top_m2u_bridge_cattrip,                  //               top_m2u_bridge.cattrip
		input  wire [2:0] top_m2u_bridge_temp,                     //                             .temp
		input  wire [7:0] top_m2u_bridge_wso,                      //                             .wso
		output wire       top_m2u_bridge_reset_n,                  //                             .reset_n
		output wire       top_m2u_bridge_wrst_n,                   //                             .wrst_n
		output wire       top_m2u_bridge_wrck,                     //                             .wrck
		output wire       top_m2u_bridge_shiftwr,                  //                             .shiftwr
		output wire       top_m2u_bridge_capturewr,                //                             .capturewr
		output wire       top_m2u_bridge_updatewr,                 //                             .updatewr
		output wire       top_m2u_bridge_selectwir,                //                             .selectwir
		output wire       top_m2u_bridge_wsi,                      //                             .wsi
		output wire       tg_bottom0_0_status_traffic_gen_pass,    //          tg_bottom0_0_status.traffic_gen_pass
		output wire       tg_bottom0_0_status_traffic_gen_fail,    //                             .traffic_gen_fail
		output wire       tg_bottom0_0_status_traffic_gen_timeout, //                             .traffic_gen_timeout
		output wire       tg_bottom0_1_status_traffic_gen_pass,    //          tg_bottom0_1_status.traffic_gen_pass
		output wire       tg_bottom0_1_status_traffic_gen_fail,    //                             .traffic_gen_fail
		output wire       tg_bottom0_1_status_traffic_gen_timeout, //                             .traffic_gen_timeout
		output wire       tg_top0_0_status_traffic_gen_pass,       //             tg_top0_0_status.traffic_gen_pass
		output wire       tg_top0_0_status_traffic_gen_fail,       //                             .traffic_gen_fail
		output wire       tg_top0_0_status_traffic_gen_timeout,    //                             .traffic_gen_timeout
		output wire       tg_top0_1_status_traffic_gen_pass,       //             tg_top0_1_status.traffic_gen_pass
		output wire       tg_top0_1_status_traffic_gen_fail,       //                             .traffic_gen_fail
		output wire       tg_top0_1_status_traffic_gen_timeout,    //                             .traffic_gen_timeout
		input  wire       top_core_clk_iopll_reset_reset,          //     top_core_clk_iopll_reset.reset
		input  wire       top_core_clk_iopll_ref_clk_clk           //   top_core_clk_iopll_ref_clk.clk
	);
endmodule

