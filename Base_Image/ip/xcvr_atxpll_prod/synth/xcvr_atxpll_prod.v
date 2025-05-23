// xcvr_atxpll_prod.v

// Generated using ACDS version 20.3 158

`timescale 1 ps / 1 ps
module xcvr_atxpll_prod (
		input  wire  pll_refclk0,       //       pll_refclk0.clk
		output wire  tx_serial_clk_gxt, // tx_serial_clk_gxt.clk
		output wire  pll_locked,        //        pll_locked.pll_locked
		output wire  pll_cal_busy       //      pll_cal_busy.pll_cal_busy
	);

	xcvr_atxpll_prod_altera_xcvr_atx_pll_s10_htile_1911_bcgy6la #(
		.rcfg_enable                                                      (0),
		.rcfg_jtag_enable                                                 (0),
		.rcfg_separate_avmm_busy                                          (0),
		.dbg_embedded_debug_enable                                        (0),
		.dbg_capability_reg_enable                                        (0),
		.dbg_user_identifier                                              (0),
		.dbg_stat_soft_logic_enable                                       (0),
		.dbg_ctrl_soft_logic_enable                                       (0),
		.rcfg_emb_strm_enable                                             (0),
		.rcfg_profile_cnt                                                 (2),
		.hssi_avmm2_if_pcs_arbiter_ctrl                                   ("avmm2_arbiter_uc_sel"),
		.hssi_avmm2_if_pcs_cal_done                                       ("avmm2_cal_done_deassert"),
		.hssi_avmm2_if_pcs_cal_reserved                                   (0),
		.hssi_avmm2_if_pcs_calibration_feature_en                         ("avmm2_pcs_calibration_en"),
		.hssi_avmm2_if_pldadapt_gate_dis                                  ("disable"),
		.hssi_avmm2_if_pcs_hip_cal_en                                     ("disable"),
		.hssi_avmm2_if_hssiadapt_avmm_osc_clock_setting                   ("osc_clk_div_by1"),
		.hssi_avmm2_if_pldadapt_avmm_osc_clock_setting                    ("osc_clk_div_by1"),
		.hssi_avmm2_if_hssiadapt_avmm_testbus_sel                         ("avmm1_transfer_testbus"),
		.hssi_avmm2_if_pldadapt_avmm_testbus_sel                          ("avmm1_transfer_testbus"),
		.hssi_avmm2_if_hssiadapt_hip_mode                                 ("disable_hip"),
		.hssi_avmm2_if_pldadapt_hip_mode                                  ("disable_hip"),
		.hssi_avmm2_if_silicon_rev                                        ("14nm4acr2eb"),
		.hssi_avmm2_if_calibration_type                                   ("one_time"),
		.atx_pll_analog_mode                                              ("user_custom"),
		.atx_pll_bonding                                                  ("cpri_bonding"),
		.atx_pll_bw_mode                                                  ("low_bw"),
		.atx_pll_cascadeclk_test                                          ("cascadetest_off"),
		.atx_pll_cgb_div                                                  (1),
		.atx_pll_chgpmp_testmode                                          ("cp_normal"),
		.atx_pll_clk_high_perf_voltage                                    (0),
		.atx_pll_clk_low_power_voltage                                    (0),
		.atx_pll_clk_mid_power_voltage                                    (0),
		.atx_pll_datarate_bps                                             ("25781250000"),
		.atx_pll_device_variant                                           ("device_off"),
		.atx_pll_clk_vreg_boost_expected_voltage                          (0),
		.atx_pll_clk_vreg_boost_scratch                                   (0),
		.atx_pll_clk_vreg_boost_step_size                                 (0),
		.atx_pll_lc_vreg1_boost_expected_voltage                          (0),
		.atx_pll_lc_vreg1_boost_scratch                                   (0),
		.atx_pll_lc_vreg_boost_expected_voltage                           (0),
		.atx_pll_lc_vreg_boost_scratch                                    (0),
		.atx_pll_mcgb_vreg_boost_expected_voltage                         (0),
		.atx_pll_mcgb_vreg_boost_scratch                                  (0),
		.atx_pll_mcgb_vreg_boost_step_size                                (0),
		.atx_pll_pm_dprio_lc_dprio_status_select                          ("dprio_normal_status"),
		.atx_pll_vreg1_boost_step_size                                    (0),
		.atx_pll_vreg_boost_step_size                                     (0),
		.atx_pll_enable_hclk                                              ("false"),
		.atx_pll_expected_lc_boost_voltage                                (0),
		.atx_pll_f_max_lcnt_fpll_cascading                                ("1200000000"),
		.atx_pll_f_max_pfd                                                ("160000000"),
		.atx_pll_f_max_pfd_fractional                                     ("1"),
		.atx_pll_f_max_ref                                                ("800000000"),
		.atx_pll_f_max_tank_0                                             ("8800000000"),
		.atx_pll_f_max_tank_1                                             ("11400000000"),
		.atx_pll_f_max_tank_2                                             ("14400000000"),
		.atx_pll_f_max_vco                                                ("14400000000"),
		.atx_pll_f_max_vco_fractional                                     ("1"),
		.atx_pll_f_max_x1                                                 ("8700000000"),
		.atx_pll_f_min_pfd                                                ("61440000"),
		.atx_pll_f_min_ref                                                ("61440000"),
		.atx_pll_f_min_tank_0                                             ("6500000000"),
		.atx_pll_f_min_tank_1                                             ("8800000000"),
		.atx_pll_f_min_tank_2                                             ("11400000000"),
		.atx_pll_f_min_vco                                                ("7200000000"),
		.atx_pll_fpll_refclk_selection                                    ("select_vco_output"),
		.atx_pll_hclk_en                                                  ("hclk_disabled"),
		.atx_pll_initial_settings                                         ("true"),
		.atx_pll_is_otn                                                   ("false"),
		.atx_pll_is_sdi                                                   ("false"),
		.atx_pll_l_counter                                                (1),
		.atx_pll_lc_cal_reserved                                          ("lc_cal_reserved_off"),
		.atx_pll_lc_dyn_reconfig                                          ("lc_dyn_reconfig_off"),
		.atx_pll_lc_to_fpll_l_counter                                     ("lcounter_setting0"),
		.atx_pll_lc_to_fpll_l_counter_scratch                             (0),
		.atx_pll_lccmu_mode                                               ("lccmu_normal"),
		.atx_pll_lcpll_gt_in_sel                                          ("lc_gt_in_sel0"),
		.atx_pll_lcpll_gt_out_left_enb                                    ("lcpll_gt_out_left_dis"),
		.atx_pll_lcpll_gt_out_mid_enb                                     ("lcpll_gt_out_mid_en"),
		.atx_pll_lcpll_gt_out_right_enb                                   ("lcpll_gt_out_right_dis"),
		.atx_pll_lcpll_lckdet_sel                                         ("lc_lckdet_sel0"),
		.atx_pll_max_fractional_percentage                                (100),
		.atx_pll_mcnt_divide                                              (80),
		.atx_pll_min_fractional_percentage                                (0),
		.atx_pll_n_counter                                                (8),
		.atx_pll_out_freq                                                 ("12890625000"),
		.atx_pll_pfd_delay_compensation                                   ("normal_delay"),
		.atx_pll_pfd_pulse_width                                          ("pulse_width_setting0"),
		.atx_pll_pma_width                                                (64),
		.atx_pll_power_mode                                               ("high_perf"),
		.atx_pll_power_rail_et                                            (1120),
		.atx_pll_powerdown_mode                                           ("powerup_off"),
		.atx_pll_primary_use                                              ("hssi_hf"),
		.atx_pll_prot_mode                                                ("basic_tx"),
		.atx_pll_reference_clock_frequency                                ("644531250"),
		.atx_pll_regulator_bypass                                         ("reg_enable"),
		.atx_pll_bcm_silicon_rev                                          ("rev_off"),
		.atx_pll_sup_mode                                                 ("user_mode"),
		.atx_pll_vccdreg_clk                                              ("vreg_clk5"),
		.atx_pll_vccdreg_fb                                               ("vreg_fb31"),
		.atx_pll_vccdreg_fw                                               ("vreg_fw5"),
		.atx_pll_vco_freq                                                 ("12890625000"),
		.atx_pll_xatb_lccmu_atb                                           ("atb_selectdisable"),
		.atx_pll_chgpmp_compensation                                      ("cp_mode_enable"),
		.atx_pll_chgpmp_current_setting                                   ("cp_current_setting22"),
		.atx_pll_cp_current_boost                                         ("normal_setting"),
		.atx_pll_lf_3rd_pole_freq                                         ("lf_3rd_pole_setting3"),
		.atx_pll_lf_cbig_size                                             ("lf_cbig_setting4"),
		.atx_pll_lf_order                                                 ("lf_3rd_order"),
		.atx_pll_lf_resistance                                            ("lf_setting2"),
		.atx_pll_lf_ripplecap                                             ("lf_ripple_cap_0"),
		.atx_pll_lc_sel_tank                                              ("lctank2"),
		.atx_pll_lc_tank_band                                             ("lc_band5"),
		.atx_pll_lc_tank_voltage_coarse                                   ("vreg_setting_coarse0"),
		.atx_pll_lc_tank_voltage_fine                                     ("vreg_setting5"),
		.atx_pll_output_regulator_supply                                  ("vreg1v_setting0"),
		.atx_pll_overrange_voltage                                        ("over_setting0"),
		.atx_pll_underrange_voltage                                       ("under_setting4"),
		.atx_pll_xd2a_lc_d2a_voltage                                      ("d2a_setting_4"),
		.atx_pll_dsm_mode                                                 ("dsm_mode_integer"),
		.atx_pll_pll_dsm_out_sel                                          ("pll_dsm_disable"),
		.atx_pll_pll_ecn_bypass                                           ("pll_ecn_bypass_disable"),
		.atx_pll_pll_ecn_test_en                                          ("pll_ecn_test_disable"),
		.atx_pll_dsm_fractional_division                                  ("1"),
		.atx_pll_pll_fractional_value_ready                               ("pll_k_ready"),
		.atx_pll_direct_fb                                                ("direct_fb"),
		.atx_pll_iqclk_sel                                                ("iqtxrxclk0"),
		.atx_pll_lcnt_bypass                                              ("lcnt_no_bypass"),
		.atx_pll_lcnt_divide                                              (1),
		.atx_pll_lcnt_off                                                 ("lcnt_off"),
		.atx_pll_ref_clk_div                                              (8),
		.atx_pll_silicon_rev                                              ("14nm4acr2eb"),
		.atx_pll_is_cascaded_pll                                          ("false"),
		.hssi_pma_lc_refclk_select_mux_powerdown_mode                     ("powerup"),
		.hssi_pma_lc_refclk_select_mux_silicon_rev                        ("14nm4acr2eb"),
		.hssi_pma_lc_refclk_select_mux_refclk_select                      ("ref_iqclk0"),
		.hssi_pma_lc_refclk_select_mux_inclk0_logical_to_physical_mapping ("ref_iqclk0"),
		.hssi_pma_lc_refclk_select_mux_inclk1_logical_to_physical_mapping ("power_down"),
		.hssi_pma_lc_refclk_select_mux_inclk2_logical_to_physical_mapping ("power_down"),
		.hssi_pma_lc_refclk_select_mux_inclk3_logical_to_physical_mapping ("power_down"),
		.hssi_pma_lc_refclk_select_mux_inclk4_logical_to_physical_mapping ("power_down"),
		.hssi_refclk_divider_silicon_rev                                  ("14nm4acr2eb"),
		.hip_cal_en                                                       ("disable"),
		.calibration_en                                                   ("enable"),
		.enable_analog_resets                                             (0),
		.enable_pcie_hip_connectivity                                     (0),
		.enable_mcgb                                                      (0),
		.enable_mcgb_reset                                                (0),
		.enable_mcgb_debug_ports_parameters                               (0),
		.hssi_pma_cgb_master_prot_mode                                    ("basic_tx"),
		.hssi_pma_cgb_master_silicon_rev                                  ("14nm4acr2eb"),
		.hssi_pma_cgb_master_x1_div_m_sel                                 ("divbypass"),
		.hssi_pma_cgb_master_cgb_enable_iqtxrxclk                         ("disable_iqtxrxclk"),
		.hssi_pma_cgb_master_ser_mode                                     ("sixty_four_bit"),
		.hssi_pma_cgb_master_datarate_bps                                 ("25781250000"),
		.hssi_pma_cgb_master_cgb_power_down                               ("normal_cgb"),
		.hssi_pma_cgb_master_observe_cgb_clocks                           ("observe_nothing"),
		.hssi_pma_cgb_master_tx_ucontrol_reset_pcie                       ("pcscorehip_controls_mcgb"),
		.hssi_pma_cgb_master_vccdreg_output                               ("vccdreg_nominal"),
		.hssi_pma_cgb_master_input_select                                 ("lcpll_top"),
		.hssi_pma_cgb_master_input_select_gen3                            ("not_used")
	) xcvr_atx_pll_s10_htile_0 (
		.pll_refclk0             (pll_refclk0),                          //   input,  width = 1,       pll_refclk0.clk
		.tx_serial_clk_gxt       (tx_serial_clk_gxt),                    //  output,  width = 1, tx_serial_clk_gxt.clk
		.pll_locked              (pll_locked),                           //  output,  width = 1,        pll_locked.pll_locked
		.pll_cal_busy            (pll_cal_busy),                         //  output,  width = 1,      pll_cal_busy.pll_cal_busy
		.pll_powerdown           (1'b0),                                 // (terminated),                               
		.pll_refclk1             (1'b0),                                 // (terminated),                               
		.pll_refclk2             (1'b0),                                 // (terminated),                               
		.pll_refclk3             (1'b0),                                 // (terminated),                               
		.pll_refclk4             (1'b0),                                 // (terminated),                               
		.tx_serial_clk           (),                                     // (terminated),                               
		.gxt_input_from_abv_atx  (1'b0),                                 // (terminated),                               
		.gxt_input_from_blw_atx  (1'b0),                                 // (terminated),                               
		.gxt_output_to_abv_atx   (),                                     // (terminated),                               
		.gxt_output_to_blw_atx   (),                                     // (terminated),                               
		.pll_locked_hip          (),                                     // (terminated),                               
		.pll_pcie_clk            (),                                     // (terminated),                               
		.pll_cascade_clk         (),                                     // (terminated),                               
		.atx_to_fpll_cascade_clk (),                                     // (terminated),                               
		.reconfig_clk0           (1'b0),                                 // (terminated),                               
		.reconfig_reset0         (1'b0),                                 // (terminated),                               
		.reconfig_write0         (1'b0),                                 // (terminated),                               
		.reconfig_read0          (1'b0),                                 // (terminated),                               
		.reconfig_address0       (11'b00000000000),                      // (terminated),                               
		.reconfig_writedata0     (32'b00000000000000000000000000000000), // (terminated),                               
		.reconfig_readdata0      (),                                     // (terminated),                               
		.reconfig_waitrequest0   (),                                     // (terminated),                               
		.avmm_busy0              (),                                     // (terminated),                               
		.hip_cal_done            (),                                     // (terminated),                               
		.clklow                  (),                                     // (terminated),                               
		.fref                    (),                                     // (terminated),                               
		.overrange               (),                                     // (terminated),                               
		.underrange              (),                                     // (terminated),                               
		.mcgb_rst                (1'b0),                                 // (terminated),                               
		.mcgb_rst_stat           (),                                     // (terminated),                               
		.mcgb_aux_clk0           (1'b0),                                 // (terminated),                               
		.mcgb_aux_clk1           (1'b0),                                 // (terminated),                               
		.mcgb_aux_clk2           (1'b0),                                 // (terminated),                               
		.tx_bonding_clocks       (),                                     // (terminated),                               
		.mcgb_serial_clk         (),                                     // (terminated),                               
		.pcie_sw                 (2'b00),                                // (terminated),                               
		.pcie_sw_done            (),                                     // (terminated),                               
		.reconfig_clk1           (1'b0),                                 // (terminated),                               
		.reconfig_reset1         (1'b0),                                 // (terminated),                               
		.reconfig_write1         (1'b0),                                 // (terminated),                               
		.reconfig_read1          (1'b0),                                 // (terminated),                               
		.reconfig_address1       (11'b00000000000),                      // (terminated),                               
		.reconfig_writedata1     (32'b00000000000000000000000000000000), // (terminated),                               
		.reconfig_readdata1      (),                                     // (terminated),                               
		.reconfig_waitrequest1   (),                                     // (terminated),                               
		.mcgb_cal_busy           (),                                     // (terminated),                               
		.mcgb_hip_cal_done       ()                                      // (terminated),                               
	);

endmodule
