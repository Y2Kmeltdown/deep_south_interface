	hbm_top_example_design u0 (
		.pll_ref_clk                 (_connected_to_pll_ref_clk_),                 //   input,    width = 1,         pll_ref_clk.clk
		.ext_core_clk                (_connected_to_ext_core_clk_),                //   input,    width = 1,        ext_core_clk.clk
		.ext_core_clk_locked         (_connected_to_ext_core_clk_locked_),         //   input,    width = 1, ext_core_clk_locked.export
		.wmcrst_n_in                 (_connected_to_wmcrst_n_in_),                 //   input,    width = 1,         wmcrst_n_in.reset_n
		.hbm_only_reset_in           (_connected_to_hbm_only_reset_in_),           //   input,    width = 1,   hbm_only_reset_in.reset
		.local_cal_success           (_connected_to_local_cal_success_),           //  output,    width = 1,              status.local_cal_success
		.local_cal_fail              (_connected_to_local_cal_fail_),              //  output,    width = 1,                    .local_cal_fail
		.cal_lat                     (_connected_to_cal_lat_),                     //  output,    width = 3,             cal_lat.cal_lat
		.ck_t_0                      (_connected_to_ck_t_0_),                      //  output,    width = 1,               mem_0.ck_t
		.ck_c_0                      (_connected_to_ck_c_0_),                      //  output,    width = 1,                    .ck_c
		.cke_0                       (_connected_to_cke_0_),                       //  output,    width = 1,                    .cke
		.c_0                         (_connected_to_c_0_),                         //  output,    width = 8,                    .c
		.r_0                         (_connected_to_r_0_),                         //  output,    width = 6,                    .r
		.dq_0                        (_connected_to_dq_0_),                        //   inout,  width = 128,                    .dq
		.dm_0                        (_connected_to_dm_0_),                        //   inout,   width = 16,                    .dm
		.dbi_0                       (_connected_to_dbi_0_),                       //   inout,   width = 16,                    .dbi
		.par_0                       (_connected_to_par_0_),                       //   inout,    width = 4,                    .par
		.derr_0                      (_connected_to_derr_0_),                      //   inout,    width = 4,                    .derr
		.rdqs_t_0                    (_connected_to_rdqs_t_0_),                    //   input,    width = 4,                    .rdqs_t
		.rdqs_c_0                    (_connected_to_rdqs_c_0_),                    //   input,    width = 4,                    .rdqs_c
		.wdqs_t_0                    (_connected_to_wdqs_t_0_),                    //  output,    width = 4,                    .wdqs_t
		.wdqs_c_0                    (_connected_to_wdqs_c_0_),                    //  output,    width = 4,                    .wdqs_c
		.rd_0                        (_connected_to_rd_0_),                        //   inout,    width = 8,                    .rd
		.rr_0                        (_connected_to_rr_0_),                        //  output,    width = 1,                    .rr
		.rc_0                        (_connected_to_rc_0_),                        //  output,    width = 1,                    .rc
		.aerr_0                      (_connected_to_aerr_0_),                      //   input,    width = 1,                    .aerr
		.cattrip                     (_connected_to_cattrip_),                     //   input,    width = 1,          m2u_bridge.cattrip
		.temp                        (_connected_to_temp_),                        //   input,    width = 3,                    .temp
		.wso                         (_connected_to_wso_),                         //   input,    width = 8,                    .wso
		.reset_n                     (_connected_to_reset_n_),                     //  output,    width = 1,                    .reset_n
		.wrst_n                      (_connected_to_wrst_n_),                      //  output,    width = 1,                    .wrst_n
		.wrck                        (_connected_to_wrck_),                        //  output,    width = 1,                    .wrck
		.shiftwr                     (_connected_to_shiftwr_),                     //  output,    width = 1,                    .shiftwr
		.capturewr                   (_connected_to_capturewr_),                   //  output,    width = 1,                    .capturewr
		.updatewr                    (_connected_to_updatewr_),                    //  output,    width = 1,                    .updatewr
		.selectwir                   (_connected_to_selectwir_),                   //  output,    width = 1,                    .selectwir
		.wsi                         (_connected_to_wsi_),                         //  output,    width = 1,                    .wsi
		.wmc_clk_0_clk               (_connected_to_wmc_clk_0_clk_),               //  output,    width = 1,           wmc_clk_0.clk
		.phy_clk_0_clk               (_connected_to_phy_clk_0_clk_),               //  output,    width = 1,           phy_clk_0.clk
		.wmcrst_n_0_reset_n          (_connected_to_wmcrst_n_0_reset_n_),          //  output,    width = 1,          wmcrst_n_0.reset_n
		.axi_0_1_awid                (_connected_to_axi_0_1_awid_),                //   input,    width = 9,             axi_0_1.awid
		.axi_0_1_awaddr              (_connected_to_axi_0_1_awaddr_),              //   input,   width = 29,                    .awaddr
		.axi_0_1_awlen               (_connected_to_axi_0_1_awlen_),               //   input,    width = 8,                    .awlen
		.axi_0_1_awsize              (_connected_to_axi_0_1_awsize_),              //   input,    width = 3,                    .awsize
		.axi_0_1_awburst             (_connected_to_axi_0_1_awburst_),             //   input,    width = 2,                    .awburst
		.axi_0_1_awprot              (_connected_to_axi_0_1_awprot_),              //   input,    width = 3,                    .awprot
		.axi_0_1_awqos               (_connected_to_axi_0_1_awqos_),               //   input,    width = 4,                    .awqos
		.axi_0_1_awuser              (_connected_to_axi_0_1_awuser_),              //   input,    width = 1,                    .awuser
		.axi_0_1_awvalid             (_connected_to_axi_0_1_awvalid_),             //   input,    width = 1,                    .awvalid
		.axi_0_1_awready             (_connected_to_axi_0_1_awready_),             //  output,    width = 1,                    .awready
		.axi_0_1_wdata               (_connected_to_axi_0_1_wdata_),               //   input,  width = 256,                    .wdata
		.axi_0_1_wstrb               (_connected_to_axi_0_1_wstrb_),               //   input,   width = 32,                    .wstrb
		.axi_0_1_wlast               (_connected_to_axi_0_1_wlast_),               //   input,    width = 1,                    .wlast
		.axi_0_1_wvalid              (_connected_to_axi_0_1_wvalid_),              //   input,    width = 1,                    .wvalid
		.axi_0_1_wready              (_connected_to_axi_0_1_wready_),              //  output,    width = 1,                    .wready
		.axi_0_1_bid                 (_connected_to_axi_0_1_bid_),                 //  output,    width = 9,                    .bid
		.axi_0_1_bresp               (_connected_to_axi_0_1_bresp_),               //  output,    width = 2,                    .bresp
		.axi_0_1_bvalid              (_connected_to_axi_0_1_bvalid_),              //  output,    width = 1,                    .bvalid
		.axi_0_1_bready              (_connected_to_axi_0_1_bready_),              //   input,    width = 1,                    .bready
		.axi_0_1_arid                (_connected_to_axi_0_1_arid_),                //   input,    width = 9,                    .arid
		.axi_0_1_araddr              (_connected_to_axi_0_1_araddr_),              //   input,   width = 29,                    .araddr
		.axi_0_1_arlen               (_connected_to_axi_0_1_arlen_),               //   input,    width = 8,                    .arlen
		.axi_0_1_arsize              (_connected_to_axi_0_1_arsize_),              //   input,    width = 3,                    .arsize
		.axi_0_1_arburst             (_connected_to_axi_0_1_arburst_),             //   input,    width = 2,                    .arburst
		.axi_0_1_arprot              (_connected_to_axi_0_1_arprot_),              //   input,    width = 3,                    .arprot
		.axi_0_1_arqos               (_connected_to_axi_0_1_arqos_),               //   input,    width = 4,                    .arqos
		.axi_0_1_aruser              (_connected_to_axi_0_1_aruser_),              //   input,    width = 1,                    .aruser
		.axi_0_1_arvalid             (_connected_to_axi_0_1_arvalid_),             //   input,    width = 1,                    .arvalid
		.axi_0_1_arready             (_connected_to_axi_0_1_arready_),             //  output,    width = 1,                    .arready
		.axi_0_1_rid                 (_connected_to_axi_0_1_rid_),                 //  output,    width = 9,                    .rid
		.axi_0_1_rdata               (_connected_to_axi_0_1_rdata_),               //  output,  width = 256,                    .rdata
		.axi_0_1_rresp               (_connected_to_axi_0_1_rresp_),               //  output,    width = 2,                    .rresp
		.axi_0_1_rlast               (_connected_to_axi_0_1_rlast_),               //  output,    width = 1,                    .rlast
		.axi_0_1_rvalid              (_connected_to_axi_0_1_rvalid_),              //  output,    width = 1,                    .rvalid
		.axi_0_1_rready              (_connected_to_axi_0_1_rready_),              //   input,    width = 1,                    .rready
		.axi_0_0_awid                (_connected_to_axi_0_0_awid_),                //   input,    width = 9,             axi_0_0.awid
		.axi_0_0_awaddr              (_connected_to_axi_0_0_awaddr_),              //   input,   width = 29,                    .awaddr
		.axi_0_0_awlen               (_connected_to_axi_0_0_awlen_),               //   input,    width = 8,                    .awlen
		.axi_0_0_awsize              (_connected_to_axi_0_0_awsize_),              //   input,    width = 3,                    .awsize
		.axi_0_0_awburst             (_connected_to_axi_0_0_awburst_),             //   input,    width = 2,                    .awburst
		.axi_0_0_awprot              (_connected_to_axi_0_0_awprot_),              //   input,    width = 3,                    .awprot
		.axi_0_0_awqos               (_connected_to_axi_0_0_awqos_),               //   input,    width = 4,                    .awqos
		.axi_0_0_awuser              (_connected_to_axi_0_0_awuser_),              //   input,    width = 1,                    .awuser
		.axi_0_0_awvalid             (_connected_to_axi_0_0_awvalid_),             //   input,    width = 1,                    .awvalid
		.axi_0_0_awready             (_connected_to_axi_0_0_awready_),             //  output,    width = 1,                    .awready
		.axi_0_0_wdata               (_connected_to_axi_0_0_wdata_),               //   input,  width = 256,                    .wdata
		.axi_0_0_wstrb               (_connected_to_axi_0_0_wstrb_),               //   input,   width = 32,                    .wstrb
		.axi_0_0_wlast               (_connected_to_axi_0_0_wlast_),               //   input,    width = 1,                    .wlast
		.axi_0_0_wvalid              (_connected_to_axi_0_0_wvalid_),              //   input,    width = 1,                    .wvalid
		.axi_0_0_wready              (_connected_to_axi_0_0_wready_),              //  output,    width = 1,                    .wready
		.axi_0_0_bid                 (_connected_to_axi_0_0_bid_),                 //  output,    width = 9,                    .bid
		.axi_0_0_bresp               (_connected_to_axi_0_0_bresp_),               //  output,    width = 2,                    .bresp
		.axi_0_0_bvalid              (_connected_to_axi_0_0_bvalid_),              //  output,    width = 1,                    .bvalid
		.axi_0_0_bready              (_connected_to_axi_0_0_bready_),              //   input,    width = 1,                    .bready
		.axi_0_0_arid                (_connected_to_axi_0_0_arid_),                //   input,    width = 9,                    .arid
		.axi_0_0_araddr              (_connected_to_axi_0_0_araddr_),              //   input,   width = 29,                    .araddr
		.axi_0_0_arlen               (_connected_to_axi_0_0_arlen_),               //   input,    width = 8,                    .arlen
		.axi_0_0_arsize              (_connected_to_axi_0_0_arsize_),              //   input,    width = 3,                    .arsize
		.axi_0_0_arburst             (_connected_to_axi_0_0_arburst_),             //   input,    width = 2,                    .arburst
		.axi_0_0_arprot              (_connected_to_axi_0_0_arprot_),              //   input,    width = 3,                    .arprot
		.axi_0_0_arqos               (_connected_to_axi_0_0_arqos_),               //   input,    width = 4,                    .arqos
		.axi_0_0_aruser              (_connected_to_axi_0_0_aruser_),              //   input,    width = 1,                    .aruser
		.axi_0_0_arvalid             (_connected_to_axi_0_0_arvalid_),             //   input,    width = 1,                    .arvalid
		.axi_0_0_arready             (_connected_to_axi_0_0_arready_),             //  output,    width = 1,                    .arready
		.axi_0_0_rid                 (_connected_to_axi_0_0_rid_),                 //  output,    width = 9,                    .rid
		.axi_0_0_rdata               (_connected_to_axi_0_0_rdata_),               //  output,  width = 256,                    .rdata
		.axi_0_0_rresp               (_connected_to_axi_0_0_rresp_),               //  output,    width = 2,                    .rresp
		.axi_0_0_rlast               (_connected_to_axi_0_0_rlast_),               //  output,    width = 1,                    .rlast
		.axi_0_0_rvalid              (_connected_to_axi_0_0_rvalid_),              //  output,    width = 1,                    .rvalid
		.axi_0_0_rready              (_connected_to_axi_0_0_rready_),              //   input,    width = 1,                    .rready
		.axi_extra_0_1_ruser_err_dbe (_connected_to_axi_extra_0_1_ruser_err_dbe_), //  output,    width = 1,       axi_extra_0_1.ruser_err_dbe
		.axi_extra_0_1_ruser_data    (_connected_to_axi_extra_0_1_ruser_data_),    //  output,   width = 32,                    .ruser_data
		.axi_extra_0_1_wuser_data    (_connected_to_axi_extra_0_1_wuser_data_),    //   input,   width = 32,                    .wuser_data
		.axi_extra_0_1_wuser_strb    (_connected_to_axi_extra_0_1_wuser_strb_),    //   input,    width = 4,                    .wuser_strb
		.axi_extra_0_0_ruser_err_dbe (_connected_to_axi_extra_0_0_ruser_err_dbe_), //  output,    width = 1,       axi_extra_0_0.ruser_err_dbe
		.axi_extra_0_0_ruser_data    (_connected_to_axi_extra_0_0_ruser_data_),    //  output,   width = 32,                    .ruser_data
		.axi_extra_0_0_wuser_data    (_connected_to_axi_extra_0_0_wuser_data_),    //   input,   width = 32,                    .wuser_data
		.axi_extra_0_0_wuser_strb    (_connected_to_axi_extra_0_0_wuser_strb_),    //   input,    width = 4,                    .wuser_strb
		.apb_0_ur_paddr              (_connected_to_apb_0_ur_paddr_),              //   input,   width = 16,               apb_0.ur_paddr
		.apb_0_ur_psel               (_connected_to_apb_0_ur_psel_),               //   input,    width = 1,                    .ur_psel
		.apb_0_ur_penable            (_connected_to_apb_0_ur_penable_),            //   input,    width = 1,                    .ur_penable
		.apb_0_ur_pwrite             (_connected_to_apb_0_ur_pwrite_),             //   input,    width = 1,                    .ur_pwrite
		.apb_0_ur_pwdata             (_connected_to_apb_0_ur_pwdata_),             //   input,   width = 16,                    .ur_pwdata
		.apb_0_ur_pstrb              (_connected_to_apb_0_ur_pstrb_),              //   input,    width = 2,                    .ur_pstrb
		.apb_0_ur_prready            (_connected_to_apb_0_ur_prready_),            //  output,    width = 1,                    .ur_prready
		.apb_0_ur_prdata             (_connected_to_apb_0_ur_prdata_)              //  output,   width = 16,                    .ur_prdata
	);

