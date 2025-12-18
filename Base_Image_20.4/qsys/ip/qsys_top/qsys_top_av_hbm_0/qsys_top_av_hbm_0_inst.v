	qsys_top_av_hbm_0 u0 (
		.clk                              (_connected_to_clk_),                              //   input,   width = 1,                 clk.clk
		.rst                              (_connected_to_rst_),                              //   input,   width = 1,                 rst.reset
		.av_address                       (_connected_to_av_address_),                       //   input,   width = 1,              reg_if.address
		.av_read                          (_connected_to_av_read_),                          //   input,   width = 1,                    .read
		.av_waitrequest                   (_connected_to_av_waitrequest_),                   //  output,   width = 1,                    .waitrequest
		.av_write                         (_connected_to_av_write_),                         //   input,   width = 1,                    .write
		.av_readdata                      (_connected_to_av_readdata_),                      //  output,  width = 32,                    .readdata
		.av_writedata                     (_connected_to_av_writedata_),                     //   input,  width = 32,                    .writedata
		.bottom_core_clk_iopll_refclk_clk (_connected_to_bottom_core_clk_iopll_refclk_clk_), //   input,   width = 1, hbm_bottom_ref_clks.iopll_ref_clk
		.bottom_pll_ref_clk_clk           (_connected_to_bottom_pll_ref_clk_clk_),           //   input,   width = 1,                    .pll_ref_clk
		.top_core_clk_iopll_ref_clk_clk   (_connected_to_top_core_clk_iopll_ref_clk_clk_),   //   input,   width = 1,    hbm_top_ref_clks.iopll_ref_clk
		.top_pll_ref_clk_clk              (_connected_to_top_pll_ref_clk_clk_),              //   input,   width = 1,                    .pll_ref_clk
		.bottom_m2u_bridge_cattrip        (_connected_to_bottom_m2u_bridge_cattrip_),        //   input,   width = 1,          bottom_m2u.cattrip
		.bottom_m2u_bridge_temp           (_connected_to_bottom_m2u_bridge_temp_),           //   input,   width = 3,                    .temp
		.bottom_m2u_bridge_wso            (_connected_to_bottom_m2u_bridge_wso_),            //   input,   width = 8,                    .wso
		.bottom_m2u_bridge_reset_n        (_connected_to_bottom_m2u_bridge_reset_n_),        //  output,   width = 1,                    .reset
		.bottom_m2u_bridge_wrst_n         (_connected_to_bottom_m2u_bridge_wrst_n_),         //  output,   width = 1,                    .wrst
		.bottom_m2u_bridge_wrck           (_connected_to_bottom_m2u_bridge_wrck_),           //  output,   width = 1,                    .wrck
		.bottom_m2u_bridge_shiftwr        (_connected_to_bottom_m2u_bridge_shiftwr_),        //  output,   width = 1,                    .shiftwr
		.bottom_m2u_bridge_capturewr      (_connected_to_bottom_m2u_bridge_capturewr_),      //  output,   width = 1,                    .capturewr
		.bottom_m2u_bridge_updatewr       (_connected_to_bottom_m2u_bridge_updatewr_),       //  output,   width = 1,                    .updatewr
		.bottom_m2u_bridge_selectwir      (_connected_to_bottom_m2u_bridge_selectwir_),      //  output,   width = 1,                    .selectwir
		.bottom_m2u_bridge_wsi            (_connected_to_bottom_m2u_bridge_wsi_),            //  output,   width = 1,                    .wsi
		.top_m2u_bridge_cattrip           (_connected_to_top_m2u_bridge_cattrip_),           //   input,   width = 1,             top_m2u.cattrip
		.top_m2u_bridge_temp              (_connected_to_top_m2u_bridge_temp_),              //   input,   width = 3,                    .temp
		.top_m2u_bridge_wso               (_connected_to_top_m2u_bridge_wso_),               //   input,   width = 8,                    .wso
		.top_m2u_bridge_reset_n           (_connected_to_top_m2u_bridge_reset_n_),           //  output,   width = 1,                    .reset
		.top_m2u_bridge_wrst_n            (_connected_to_top_m2u_bridge_wrst_n_),            //  output,   width = 1,                    .wrst
		.top_m2u_bridge_wrck              (_connected_to_top_m2u_bridge_wrck_),              //  output,   width = 1,                    .wrck
		.top_m2u_bridge_shiftwr           (_connected_to_top_m2u_bridge_shiftwr_),           //  output,   width = 1,                    .shiftwr
		.top_m2u_bridge_capturewr         (_connected_to_top_m2u_bridge_capturewr_),         //  output,   width = 1,                    .capturewr
		.top_m2u_bridge_updatewr          (_connected_to_top_m2u_bridge_updatewr_),          //  output,   width = 1,                    .updatewr
		.top_m2u_bridge_selectwir         (_connected_to_top_m2u_bridge_selectwir_),         //  output,   width = 1,                    .selectwir
		.top_m2u_bridge_wsi               (_connected_to_top_m2u_bridge_wsi_)                //  output,   width = 1,                    .wsi
	);

