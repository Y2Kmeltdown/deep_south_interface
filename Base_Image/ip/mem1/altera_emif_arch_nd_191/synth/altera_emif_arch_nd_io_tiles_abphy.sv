// (C) 2001-2020 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



///////////////////////////////////////////////////////////////////////////////
// This module instantiates one or more x48 I/O tiles (along with
// the necessary x12 I/O lanes) that are required to build as single EMIF.
//
///////////////////////////////////////////////////////////////////////////////

// Simple max/min
`define _get_max(_i, _j)                                 ( (_i) > (_j) ? (_i) : (_j) )
`define _get_min(_i, _j)                                 ( (_i) < (_j) ? (_i) : (_j) )

// Index to signal buses used to implement a daisy chain of
// (L0->L1->T0->L2->L3)->(L0->L1->T1->L2->L3)->...
`define _get_chain_index_for_tile(_tile_i)               ( _tile_i * (LANES_PER_TILE + 1) + 2 )

`define _get_chain_index_for_lane(_tile_i, _lane_i)      ( (_lane_i < 2) ? (_tile_i * (LANES_PER_TILE + 1) + _lane_i) : ( \
                                                                           (_tile_i * (LANES_PER_TILE + 1) + _lane_i + 1 )) )

// Index to signal buses used to implement a daisy chain of
// (L0->L1->L2->L3)->(L0->L1->L2->L3)->...
`define _get_broadcast_chain_index(_tile_i, _lane_i)     ( _tile_i * LANES_PER_TILE + _lane_i )

`define _get_lane_usage(_tile_i, _lane_i)                ( LANES_USAGE[(_tile_i * LANES_PER_TILE + _lane_i) * 3 +: 3] )

`define _get_pin_oct_mode_raw(_tile_i, _lane_i, _pin_i)  ( PINS_OCT_MODE[(_tile_i * LANES_PER_TILE * PINS_PER_LANE + _lane_i * PINS_PER_LANE + _pin_i)] )

`define _get_pin_dcc_split_raw(_tile_i, _lane_i, _pin_i) ( PINS_DCC_SPLIT[(_tile_i * LANES_PER_TILE * PINS_PER_LANE + _lane_i * PINS_PER_LANE + _pin_i)] )

`define _get_pin_ddr_raw(_tile_i, _lane_i, _pin_i)       ( PINS_RATE[_tile_i * LANES_PER_TILE * PINS_PER_LANE + _lane_i * PINS_PER_LANE + _pin_i] )
`define _get_pin_ddr_str(_tile_i, _lane_i, _pin_i)       ( `_get_pin_ddr_raw(_tile_i, _lane_i, _pin_i) == PIN_RATE_DDR ? "mode_ddr" : "mode_sdr" )

`define _get_pin_usage(_tile_i, _lane_i, _pin_i)         ( PINS_USAGE[_tile_i * LANES_PER_TILE * PINS_PER_LANE + _lane_i * PINS_PER_LANE + _pin_i] )

`define _get_db_pin_proc_mode_raw(_tile_i, _lane_i, _pin_i)       ( DB_PINS_PROC_MODE[(_tile_i * LANES_PER_TILE * PINS_PER_LANE + _lane_i * PINS_PER_LANE + _pin_i) * 5 +: 5] )
`define _get_db_pin_proc_mode_str(_tile_i, _lane_i, _pin_i)       ( `_get_db_pin_proc_mode_raw(_tile_i, _lane_i, _pin_i) == DB_PIN_PROC_MODE_AC_CORE        ? "ac_core"       : ( \
                                                                    `_get_db_pin_proc_mode_raw(_tile_i, _lane_i, _pin_i) == DB_PIN_PROC_MODE_WDB_AC         ? "ac_hmc"        : ( \
                                                                    `_get_db_pin_proc_mode_raw(_tile_i, _lane_i, _pin_i) == DB_PIN_PROC_MODE_WDB_DQ         ? "dq_wdb_mode"   : ( \
                                                                    `_get_db_pin_proc_mode_raw(_tile_i, _lane_i, _pin_i) == DB_PIN_PROC_MODE_WDB_DM         ? "dm_wdb_mode"   : ( \
                                                                    `_get_db_pin_proc_mode_raw(_tile_i, _lane_i, _pin_i) == DB_PIN_PROC_MODE_WDB_CLK        ? "clk_wdb_mode"  : ( \
                                                                    `_get_db_pin_proc_mode_raw(_tile_i, _lane_i, _pin_i) == DB_PIN_PROC_MODE_WDB_CLKB       ? "clkb_wdb_mode" : ( \
                                                                    `_get_db_pin_proc_mode_raw(_tile_i, _lane_i, _pin_i) == DB_PIN_PROC_MODE_WDB_DQS        ? "dqs_wdb_mode"  : ( \
                                                                    `_get_db_pin_proc_mode_raw(_tile_i, _lane_i, _pin_i) == DB_PIN_PROC_MODE_WDB_DQSB       ? "dqsb_wdb_mode" : ( \
                                                                    `_get_db_pin_proc_mode_raw(_tile_i, _lane_i, _pin_i) == DB_PIN_PROC_MODE_DQS            ? "dqs_mode"      : ( \
                                                                    `_get_db_pin_proc_mode_raw(_tile_i, _lane_i, _pin_i) == DB_PIN_PROC_MODE_DQSB           ? "dqsb_mode"     : ( \
                                                                    `_get_db_pin_proc_mode_raw(_tile_i, _lane_i, _pin_i) == DB_PIN_PROC_MODE_DQ             ? "dq_mode"       : ( \
                                                                    `_get_db_pin_proc_mode_raw(_tile_i, _lane_i, _pin_i) == DB_PIN_PROC_MODE_DM             ? "dm_mode"       : ( \
                                                                    `_get_db_pin_proc_mode_raw(_tile_i, _lane_i, _pin_i) == DB_PIN_PROC_MODE_DBI            ? "dbi_mode"      : ( \
                                                                    `_get_db_pin_proc_mode_raw(_tile_i, _lane_i, _pin_i) == DB_PIN_PROC_MODE_CLK            ? "clk_mode"      : ( \
                                                                    `_get_db_pin_proc_mode_raw(_tile_i, _lane_i, _pin_i) == DB_PIN_PROC_MODE_CLKB           ? "clkb_mode"     : ( \
                                                                    `_get_db_pin_proc_mode_raw(_tile_i, _lane_i, _pin_i) == DB_PIN_PROC_MODE_DQS_DDR4       ? "dqs_ddr4_mode" : ( \
                                                                    `_get_db_pin_proc_mode_raw(_tile_i, _lane_i, _pin_i) == DB_PIN_PROC_MODE_DQSB_DDR4      ? "dqsb_ddr4_mode": ( \
                                                                    `_get_db_pin_proc_mode_raw(_tile_i, _lane_i, _pin_i) == DB_PIN_PROC_MODE_RDQ            ? "rdq_mode"      : ( \
                                                                    `_get_db_pin_proc_mode_raw(_tile_i, _lane_i, _pin_i) == DB_PIN_PROC_MODE_RDQS           ? "rdqs_mode"     : ( \
                                                                    `_get_db_pin_proc_mode_raw(_tile_i, _lane_i, _pin_i) == DB_PIN_PROC_MODE_GPIO           ? "gpio_mode"     : ( \
                                                                                                                                                              "dq_mode"         )))))))))))))))))))))

`define _get_pin_oct_mode_str(_tile_i, _lane_i, _pin_i)   ( `_get_pin_oct_mode_raw(_tile_i, _lane_i, _pin_i) == PIN_OCT_STATIC_OFF  ? "static_off" : ( \
                                                            `_get_pin_oct_mode_raw(_tile_i, _lane_i, _pin_i) == PIN_OCT_DYNAMIC     ? "dynamic" : ( \
                                                                                                                                      "dynamic" )))

`define _get_pin_data_in_mode_raw(_tile_i, _lane_i, _pin_i) ( PINS_DATA_IN_MODE[(_tile_i * LANES_PER_TILE * PINS_PER_LANE + _lane_i * PINS_PER_LANE + _pin_i) * 3 +: 3] )

`define _get_pin_data_in_mode_str(_tile_i, _lane_i, _pin_i) ( `_get_pin_data_in_mode_raw(_tile_i, _lane_i, _pin_i) == PIN_DATA_IN_MODE_DISABLED         ? "dq" : ( \
                                                              `_get_pin_data_in_mode_raw(_tile_i, _lane_i, _pin_i) == PIN_DATA_IN_MODE_SSTL_IN          ? "dq" : ( \
                                                              `_get_pin_data_in_mode_raw(_tile_i, _lane_i, _pin_i) == PIN_DATA_IN_MODE_LOOPBACK_IN      ? "dq" : ( \
                                                              `_get_pin_data_in_mode_raw(_tile_i, _lane_i, _pin_i) == PIN_DATA_IN_MODE_XOR_LOOPBACK_IN  ? "dq" : ( \
                                                              `_get_pin_data_in_mode_raw(_tile_i, _lane_i, _pin_i) == PIN_DATA_IN_MODE_DIFF_IN          ? "dq" : ( \
                                                              `_get_pin_data_in_mode_raw(_tile_i, _lane_i, _pin_i) == PIN_DATA_IN_MODE_DIFF_IN_AVL_OUT  ? "dq" : ( \
                                                              `_get_pin_data_in_mode_raw(_tile_i, _lane_i, _pin_i) == PIN_DATA_IN_MODE_DIFF_IN_X12_OUT  ? "dq" : ( \
                                                                                                                                                          "dqs"  ))))))))

`define _get_pin_dqs_mode_str(_tile_i, _lane_i, _pin_i)   ( (PROTOCOL_ENUM == "PROTOCOL_QDR2")                       ?  "dqs_sampler_b_a_rise" :  ( \
                                                            (DQS_BUS_MODE_ENUM == "DQS_BUS_MODE_X4") && (_pin_i > 5) ?  "dqs_sampler_b" : ( \
                                                                                                                        "dqs_sampler_a" )))

//  Given the tile and lane index of a lane, returns the index of the AC tile controlling
//  this lane. For non-ping-pong, return value is always PRI_AC_TILE_INDEX.
//  For ping-pong, return SEC_AC_TILE_INDEX for all tiles below tile at SEC_AC_TILE_INDEX,
//  and for lane 2 and 3 of tile SEC_AC_TILE_INDEX; return PRI_AC_TILE_INDEX otherwise.
//  This assumption must be consistent with the logical pin placement strategy in hwtcl.
`define _get_ac_tile_index(_tile_i, _lane_i)             ( (PHY_PING_PONG_EN && (_tile_i < SEC_AC_TILE_INDEX || (_tile_i == SEC_AC_TILE_INDEX && _lane_i < 2))) ? SEC_AC_TILE_INDEX : PRI_AC_TILE_INDEX )

//  The following account for latency incurred when cross tile boundaries
`define _get_dbc_pipe_lat(_tile_i, _lane_i)                       ( DBC_PIPE_LATS[(_tile_i * LANES_PER_TILE + _lane_i) * 4 +: 4] )
`define _get_db_ptr_pipe_depth_str(_tile_i, _lane_i)              ( DB_PTR_PIPELINE_DEPTHS[(_tile_i * LANES_PER_TILE + _lane_i) * 4 +: 4] == 4'b0000 ? "db_ptr_pipeline_depth_uint0" : \
                                                                    DB_PTR_PIPELINE_DEPTHS[(_tile_i * LANES_PER_TILE + _lane_i) * 4 +: 4] == 4'b0001 ? "db_ptr_pipeline_depth_uint1" : \
                                                                    DB_PTR_PIPELINE_DEPTHS[(_tile_i * LANES_PER_TILE + _lane_i) * 4 +: 4] == 4'b0010 ? "db_ptr_pipeline_depth_uint2" : \
                                                                    DB_PTR_PIPELINE_DEPTHS[(_tile_i * LANES_PER_TILE + _lane_i) * 4 +: 4] == 4'b0011 ? "db_ptr_pipeline_depth_uint3" : \
                                                                    DB_PTR_PIPELINE_DEPTHS[(_tile_i * LANES_PER_TILE + _lane_i) * 4 +: 4] == 4'b0100 ? "db_ptr_pipeline_depth_uint4" : \
                                                                                                                                                       "db_ptr_pipeline_depth_uint0")

`define _get_db_seq_rd_en_full_pipeline_raw(_tile_i, _lane_i)     ( DB_SEQ_RD_EN_FULL_PIPELINES[(_tile_i * LANES_PER_TILE + _lane_i) * 4 +: 4] )
`define _get_db_seq_rd_en_full_pipeline_str(_tile_i, _lane_i)     ( `_get_db_seq_rd_en_full_pipeline_raw(_tile_i, _lane_i) == 4'b0000 ? "db_seq_rd_en_full_pipeline_uint0" : \
                                                                    `_get_db_seq_rd_en_full_pipeline_raw(_tile_i, _lane_i) == 4'b0001 ? "db_seq_rd_en_full_pipeline_uint1" : \
                                                                    `_get_db_seq_rd_en_full_pipeline_raw(_tile_i, _lane_i) == 4'b0010 ? "db_seq_rd_en_full_pipeline_uint2" : \
                                                                    `_get_db_seq_rd_en_full_pipeline_raw(_tile_i, _lane_i) == 4'b0011 ? "db_seq_rd_en_full_pipeline_uint3" : \
                                                                    `_get_db_seq_rd_en_full_pipeline_raw(_tile_i, _lane_i) == 4'b0100 ? "db_seq_rd_en_full_pipeline_uint4" : \
                                                                                                                                        "db_seq_rd_en_full_pipeline_uint0")

`define _get_db_data_alignment_mode                      ( (NUM_OF_HMC_PORTS > 0) ? "align_ena" : "align_disable" )

`define _get_lane_mode_rate_in                           ( PHY_HMC_CLK_RATIO == 4 ? "in_rate_1_4" : ( \
                                                           PHY_HMC_CLK_RATIO == 2 ? "in_rate_1_2" : ( \
                                                                                    "in_rate_full" )))

`define _get_lane_mode_rate_out                          ( PLL_VCO_TO_MEM_CLK_FREQ_RATIO == 8 ? "out_rate_1_8" : ( \
                                                           PLL_VCO_TO_MEM_CLK_FREQ_RATIO == 4 ? "out_rate_1_4" : ( \
                                                           PLL_VCO_TO_MEM_CLK_FREQ_RATIO == 2 ? "out_rate_1_2" : ( \
                                                                                                "out_rate_full" ))))

`define _get_hmc_ctrl_mem_type                           ( PROTOCOL_ENUM == "PROTOCOL_DDR3"   ? "mem_type_ddr3"   : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_DDR4"   ? "mem_type_ddr4"   : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_LPDDR3" ? "mem_type_lpddr3" : ( \
                                                                                                "mem_type_rld3"             ))) )

`define _get_hmc_or_core                                 ( NUM_OF_HMC_PORTS == 0 ? "core" : "hmc" )

`define _get_hmc_cmd_rate                                ( PHY_HMC_CLK_RATIO == 4 ? "ctrl_cfg_cmd_rate_qr" : "ctrl_cfg_cmd_rate_hr" )
`define _get_dbc0_cmd_rate                               ( PHY_HMC_CLK_RATIO == 4 ? "dbc0_cfg_cmd_rate_qr" : "dbc0_cfg_cmd_rate_hr" )
`define _get_dbc1_cmd_rate                               ( PHY_HMC_CLK_RATIO == 4 ? "dbc1_cfg_cmd_rate_qr" : "dbc1_cfg_cmd_rate_hr" )
`define _get_dbc2_cmd_rate                               ( PHY_HMC_CLK_RATIO == 4 ? "dbc2_cfg_cmd_rate_qr" : "dbc2_cfg_cmd_rate_hr" )
`define _get_dbc3_cmd_rate                               ( PHY_HMC_CLK_RATIO == 4 ? "dbc3_cfg_cmd_rate_qr" : "dbc3_cfg_cmd_rate_hr" )

`define _get_hmc_protocol                                ( HMC_AVL_PROTOCOL_ENUM == "CTRL_AVL_PROTOCOL_MM" ? "ctrl_amm" : "ctrl_ast" )
`define _get_dbc0_protocol                               ( HMC_AVL_PROTOCOL_ENUM == "CTRL_AVL_PROTOCOL_MM" ? "dbc0_amm" : "dbc0_ast" )
`define _get_dbc1_protocol                               ( HMC_AVL_PROTOCOL_ENUM == "CTRL_AVL_PROTOCOL_MM" ? "dbc1_amm" : "dbc1_ast" )
`define _get_dbc2_protocol                               ( HMC_AVL_PROTOCOL_ENUM == "CTRL_AVL_PROTOCOL_MM" ? "dbc2_amm" : "dbc2_ast" )
`define _get_dbc3_protocol                               ( HMC_AVL_PROTOCOL_ENUM == "CTRL_AVL_PROTOCOL_MM" ? "dbc3_amm" : "dbc3_ast" )

`define _get_dqs_lgc_burst_length                        ( PROTOCOL_ENUM == "PROTOCOL_RLD3" ? "burst_length_2" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_QDR2" ? "burst_length_2" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_QDR4" ? "burst_length_2" : ( \
                                                           MEM_BURST_LENGTH == 2 ? "burst_length_2"   : ( \
                                                           MEM_BURST_LENGTH == 4 ? "burst_length_4"   : ( \
                                                           MEM_BURST_LENGTH == 8 ? "burst_length_8"   : ( \
                                                                                   ""                   )))))))


`define _get_vfifo_burst_length                          ( PROTOCOL_ENUM == "PROTOCOL_RLD3" ? "vburst_length_2" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_QDR2" ? "vburst_length_2" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_QDR4" ? "vburst_length_2" : ( \
                                                           MEM_BURST_LENGTH == 2 ? "vburst_length_2"   : ( \
                                                           MEM_BURST_LENGTH == 4 ? "vburst_length_4"   : ( \
                                                           MEM_BURST_LENGTH == 8 ? "vburst_length_8"   : ( \
                                                                                   ""                   )))))))

`define _get_pa_exponent(_clk_ratio)                     ( (_clk_ratio * PLL_VCO_TO_MEM_CLK_FREQ_RATIO) == 1   ? 3'b000 : ( \
                                                           (_clk_ratio * PLL_VCO_TO_MEM_CLK_FREQ_RATIO) == 2   ? 3'b001 : ( \
                                                           (_clk_ratio * PLL_VCO_TO_MEM_CLK_FREQ_RATIO) == 4   ? 3'b010 : ( \
                                                           (_clk_ratio * PLL_VCO_TO_MEM_CLK_FREQ_RATIO) == 8   ? 3'b011 : ( \
                                                           (_clk_ratio * PLL_VCO_TO_MEM_CLK_FREQ_RATIO) == 16  ? 3'b100 : ( \
                                                           (_clk_ratio * PLL_VCO_TO_MEM_CLK_FREQ_RATIO) == 32  ? 3'b101 : ( \
                                                           (_clk_ratio * PLL_VCO_TO_MEM_CLK_FREQ_RATIO) == 64  ? 3'b110 : ( \
                                                           (_clk_ratio * PLL_VCO_TO_MEM_CLK_FREQ_RATIO) == 128 ? 3'b111 : ( \
                                                                                                                 3'b000 )))))))))

// CPA output 0 - in HMC mode, matches emif_usr_clk; in non-HMC mode, matches afi_half_clk
`define _get_cpa_0_clk_ratio                             ( NUM_OF_HMC_PORTS > 0 ? USER_CLK_RATIO : (USER_CLK_RATIO * 2) )
`define _get_pa_exponent_0                               ( (`_get_pa_exponent(`_get_cpa_0_clk_ratio)) )

// CPA output 1 - always matches the C2P/P2C rate
`define _get_cpa_1_clk_ratio                             ( C2P_P2C_CLK_RATIO )
`define _get_pa_exponent_1                               ( (`_get_pa_exponent(`_get_cpa_1_clk_ratio)) )

// CPA output 0 - clock divider on PHY clock feedback.
//                Enable divide-by-2 whenever the core clock needs to run at half the speed of the feedback clock
`define _get_pa_feedback_divider_p0                      ( (`_get_cpa_0_clk_ratio == C2P_P2C_CLK_RATIO * 2) ? "div_by_2" : "div_by_1" )

// CPA output 0 - clock divider on core clock feedback.
//                Enable divide-by-2 whenever the core clock needs to run at 2x the speed of the feedback clock
`define _get_pa_feedback_divider_c0                      ( (`_get_cpa_0_clk_ratio * 2 == C2P_P2C_CLK_RATIO) ? "div_by_2" : "div_by_1" )

`define _get_dqsin(_tile_i, _lane_i)                     ( (`_get_lane_usage(_tile_i, _lane_i) != LANE_USAGE_RDATA && `_get_lane_usage(_tile_i, _lane_i) != LANE_USAGE_WDATA && `_get_lane_usage(_tile_i, _lane_i) != LANE_USAGE_WRDATA) ? 2'b0 : ( \
                                                           DQS_BUS_MODE_ENUM == "DQS_BUS_MODE_X4"       ? t2l_dqsbus_x4[_lane_i]  : ( \
                                                           DQS_BUS_MODE_ENUM == "DQS_BUS_MODE_X8_X9"    ? t2l_dqsbus_x8[_lane_i]  : ( \
                                                           DQS_BUS_MODE_ENUM == "DQS_BUS_MODE_X16_X18"  ? t2l_dqsbus_x18[_lane_i] : ( \
                                                           DQS_BUS_MODE_ENUM == "DQS_BUS_MODE_X32_X36"  ? t2l_dqsbus_x36[_lane_i] : ( \
                                                                                                                                    2'b0 ))))))

`define _get_pin_dqs_x4_mode_0                          ( (DQS_BUS_MODE_ENUM != "DQS_BUS_MODE_X4") ? "dqs_x4_not_used" : "dqs_x4_a" )
`define _get_pin_dqs_x4_mode_1                          ( (DQS_BUS_MODE_ENUM != "DQS_BUS_MODE_X4") ? "dqs_x4_not_used" : "dqs_x4_a" )
`define _get_pin_dqs_x4_mode_2                          ( (DQS_BUS_MODE_ENUM != "DQS_BUS_MODE_X4") ? "dqs_x4_not_used" : "dqs_x4_a" )
`define _get_pin_dqs_x4_mode_3                          ( (DQS_BUS_MODE_ENUM != "DQS_BUS_MODE_X4") ? "dqs_x4_not_used" : "dqs_x4_a" )
`define _get_pin_dqs_x4_mode_4                          ( (DQS_BUS_MODE_ENUM != "DQS_BUS_MODE_X4") ? "dqs_x4_not_used" : "dqs_x4_a" )
`define _get_pin_dqs_x4_mode_5                          ( (DQS_BUS_MODE_ENUM != "DQS_BUS_MODE_X4") ? "dqs_x4_not_used" : "dqs_x4_a" )
`define _get_pin_dqs_x4_mode_6                          ( (DQS_BUS_MODE_ENUM != "DQS_BUS_MODE_X4") ? "dqs_x4_not_used" : "dqs_x4_b" )
`define _get_pin_dqs_x4_mode_7                          ( (DQS_BUS_MODE_ENUM != "DQS_BUS_MODE_X4") ? "dqs_x4_not_used" : "dqs_x4_b" )
`define _get_pin_dqs_x4_mode_8                          ( (DQS_BUS_MODE_ENUM != "DQS_BUS_MODE_X4") ? "dqs_x4_not_used" : "dqs_x4_a" )
`define _get_pin_dqs_x4_mode_9                          ( (DQS_BUS_MODE_ENUM != "DQS_BUS_MODE_X4") ? "dqs_x4_not_used" : "dqs_x4_a" )
`define _get_pin_dqs_x4_mode_10                         ( (DQS_BUS_MODE_ENUM != "DQS_BUS_MODE_X4") ? "dqs_x4_not_used" : "dqs_x4_b" )
`define _get_pin_dqs_x4_mode_11                         ( (DQS_BUS_MODE_ENUM != "DQS_BUS_MODE_X4") ? "dqs_x4_not_used" : "dqs_x4_b" )

`define _get_hmc_burst_length                            ( MEM_BURST_LENGTH == 2 ? 5'b00010   : ( \
                                                           MEM_BURST_LENGTH == 4 ? 5'b00100   : ( \
                                                           MEM_BURST_LENGTH == 8 ? 5'b01000   : ( \
                                                                                   5'b00000              ))))

// DBC Mux Scheme (non-ping-pong):
//
// Tiles above      :   switch0 = don't-care   dbc*_sel = switch1 (lower mux)
//                      switch1 = from lower
//
// AC Tile          :   switch0 = local        dbc*_sel = switch0 (upper mux)
//                      switch1 = local
//
// Tiles below      :   switch0 = from upper   dbc*_sel = switch0 (upper mux)
//                      switch1 = don't-care
//
`define _get_ctrl2dbc_switch_0_non_pp(_tile_i)             ( (_tile_i == PRI_AC_TILE_INDEX) ? "local_tile_dbc0" : ( \
                                                             (_tile_i <= PRI_AC_TILE_INDEX) ? "upper_tile_dbc0" : ( \
                                                                                              "lower_tile_dbc0" )))

`define _get_ctrl2dbc_switch_1_non_pp(_tile_i)             ( (_tile_i == PRI_AC_TILE_INDEX) ? "local_tile_dbc1" : ( \
                                                             (_tile_i >  PRI_AC_TILE_INDEX) ? "lower_tile_dbc1" : ( \
                                                                                              "upper_tile_dbc1" )))

`define _get_ctrl2dbc_sel_0_non_pp(_tile_i)                ( (_tile_i <= PRI_AC_TILE_INDEX) ? "upper_mux_dbc0" : "lower_mux_dbc0" )
`define _get_ctrl2dbc_sel_1_non_pp(_tile_i)                ( (_tile_i <= PRI_AC_TILE_INDEX) ? "upper_mux_dbc1" : "lower_mux_dbc1" )
`define _get_ctrl2dbc_sel_2_non_pp(_tile_i)                ( (_tile_i <= PRI_AC_TILE_INDEX) ? "upper_mux_dbc2" : "lower_mux_dbc2" )
`define _get_ctrl2dbc_sel_3_non_pp(_tile_i)                ( (_tile_i <= PRI_AC_TILE_INDEX) ? "upper_mux_dbc3" : "lower_mux_dbc3" )

// DBC Mux Scheme (ping-pong):
//
// Tiles above      :   switch0 = don't-care   dbc*_sel = switch1 (lower mux)
//                      switch1 = from lower
//
// Primary AC Tile  :   switch0 = local        dbc*_sel = switch1 (lower mux)
//                      switch1 = local
//
// Secondary AC Tile:   switch0 = local        dbc2_sel, dbc3_sel = switch0 (upper mux)
//                      switch1 = from upper   dbc0_sel, dbc1_sel = switch1 (lower mux)
//
// Tiles below      :   switch0 = from upper   dbc*_sel = switch0 (upper mux)
//                      switch1 = don't-care
//
`define _get_ctrl2dbc_switch_0_pp(_tile_i)               ( (_tile_i == PRI_AC_TILE_INDEX) ? "local_tile_dbc0" : ( \
                                                           (_tile_i == SEC_AC_TILE_INDEX) ? "local_tile_dbc0" : ( \
                                                           (_tile_i <  SEC_AC_TILE_INDEX) ? "upper_tile_dbc0" : ( \
                                                                                            "lower_tile_dbc0" ))))

`define _get_ctrl2dbc_switch_1_pp(_tile_i)               ( (_tile_i == PRI_AC_TILE_INDEX) ? "local_tile_dbc1" : ( \
                                                           (_tile_i == SEC_AC_TILE_INDEX) ? "upper_tile_dbc1" : ( \
                                                           (_tile_i >  PRI_AC_TILE_INDEX) ? "lower_tile_dbc1" : ( \
                                                                                            "upper_tile_dbc1" ))))

`define _get_ctrl2dbc_sel_0_pp(_tile_i)                  ( (_tile_i >= PRI_AC_TILE_INDEX) ? "lower_mux_dbc0" : ((_tile_i < SEC_AC_TILE_INDEX) ? "upper_mux_dbc0" : (`_get_ac_tile_index(_tile_i, 0) == PRI_AC_TILE_INDEX ? "lower_mux_dbc0" : "upper_mux_dbc0")) )
`define _get_ctrl2dbc_sel_1_pp(_tile_i)                  ( (_tile_i >= PRI_AC_TILE_INDEX) ? "lower_mux_dbc1" : ((_tile_i < SEC_AC_TILE_INDEX) ? "upper_mux_dbc1" : (`_get_ac_tile_index(_tile_i, 1) == PRI_AC_TILE_INDEX ? "lower_mux_dbc1" : "upper_mux_dbc1")) )
`define _get_ctrl2dbc_sel_2_pp(_tile_i)                  ( (_tile_i >= PRI_AC_TILE_INDEX) ? "lower_mux_dbc2" : ((_tile_i < SEC_AC_TILE_INDEX) ? "upper_mux_dbc2" : (`_get_ac_tile_index(_tile_i, 2) == PRI_AC_TILE_INDEX ? "lower_mux_dbc2" : "upper_mux_dbc2")) )
`define _get_ctrl2dbc_sel_3_pp(_tile_i)                  ( (_tile_i >= PRI_AC_TILE_INDEX) ? "lower_mux_dbc3" : ((_tile_i < SEC_AC_TILE_INDEX) ? "upper_mux_dbc3" : (`_get_ac_tile_index(_tile_i, 3) == PRI_AC_TILE_INDEX ? "lower_mux_dbc3" : "upper_mux_dbc3")) )

// DBC Mux Scheme (ping-pong and non-ping-pong)
`define _get_ctrl2dbc_switch_0(_tile_i)                  ( PHY_PING_PONG_EN ? `_get_ctrl2dbc_switch_0_pp(_tile_i) : `_get_ctrl2dbc_switch_0_non_pp(_tile_i) )
`define _get_ctrl2dbc_switch_1(_tile_i)                  ( PHY_PING_PONG_EN ? `_get_ctrl2dbc_switch_1_pp(_tile_i) : `_get_ctrl2dbc_switch_1_non_pp(_tile_i) )
`define _get_ctrl2dbc_sel_0(_tile_i)                     ( PHY_PING_PONG_EN ? `_get_ctrl2dbc_sel_0_pp(_tile_i)    : `_get_ctrl2dbc_sel_0_non_pp(_tile_i) )
`define _get_ctrl2dbc_sel_1(_tile_i)                     ( PHY_PING_PONG_EN ? `_get_ctrl2dbc_sel_1_pp(_tile_i)    : `_get_ctrl2dbc_sel_1_non_pp(_tile_i) )
`define _get_ctrl2dbc_sel_2(_tile_i)                     ( PHY_PING_PONG_EN ? `_get_ctrl2dbc_sel_2_pp(_tile_i)    : `_get_ctrl2dbc_sel_2_non_pp(_tile_i) )
`define _get_ctrl2dbc_sel_3(_tile_i)                     ( PHY_PING_PONG_EN ? `_get_ctrl2dbc_sel_3_pp(_tile_i)    : `_get_ctrl2dbc_sel_3_non_pp(_tile_i) )

// Select which DBC to use as shadow.
// For the primary HMC tile or non-Ping-Pong HMC tile, pick "dbc1_to_local" as it's guaranteed to be used by the interface (as an A/C lane).
//    The exception is for HPS mode - HPS is only connected to lane 3 of the HMC tile for the
//    various Avalon control signals, therefore we must denote lane 3 as shadow.
//    (note that HPS doesn't support Ping-Pong so we only need to handle non-Ping-Pong case)
// For the secondary HMC tile, which one we pick depends on which data lane in the tile belongs to the secondary interface.
`define _get_hmc_dbc2ctrl_sel_non_pp(_tile_i)            ( PRI_HMC_DBC_SHADOW_LANE_INDEX == 0 ? "dbc0_to_local" : ( \
                                                           PRI_HMC_DBC_SHADOW_LANE_INDEX == 1 ? "dbc1_to_local" : ( \
                                                           PRI_HMC_DBC_SHADOW_LANE_INDEX == 2 ? "dbc2_to_local" : ( \
                                                                                                "dbc3_to_local" ))))

`define _get_hmc_dbc2ctrl_sel_pp(_tile_i)                ( (_tile_i != SEC_AC_TILE_INDEX) ? `_get_hmc_dbc2ctrl_sel_non_pp(_tile_i) : ( \
                                                           (`_get_ac_tile_index(SEC_AC_TILE_INDEX, 0) == SEC_AC_TILE_INDEX) ? "dbc0_to_local" : ( \
                                                           (`_get_ac_tile_index(SEC_AC_TILE_INDEX, 1) == SEC_AC_TILE_INDEX) ? "dbc1_to_local" : ( \
                                                           (`_get_ac_tile_index(SEC_AC_TILE_INDEX, 2) == SEC_AC_TILE_INDEX) ? "dbc2_to_local" : ( \
                                                                                                                              "dbc3_to_local" )))))
`define _get_hmc_dbc2ctrl_sel(_tile_i)                   ( PHY_PING_PONG_EN ? `_get_hmc_dbc2ctrl_sel_pp(_tile_i) : `_get_hmc_dbc2ctrl_sel_non_pp(_tile_i) )

// ac_hmc is hard connectivity between HMC and A/C lanes
// The Fitter uses ac_hmc as a special connection to locate the A/C tile and lanes, regardless of whether HMC is used.
// Normally, we only connect these to lanes that are used as A/C, regardless of HMC or SMC.
// For HPS non-ECC, we must ensure even the unused lane 3 is connected so that the lane isn't swept away by Fitter
`define _get_ac_hmc(_tile_i, _lane_i)                    ( (`_get_lane_usage(_tile_i, _lane_i) == LANE_USAGE_AC_HMC || \
                                                            `_get_lane_usage(_tile_i, _lane_i) == LANE_USAGE_AC_CORE || \
                                                            (`_get_lane_usage(_tile_i, _lane_i) == LANE_USAGE_UNUSED && IS_HPS && _tile_i == PRI_AC_TILE_INDEX)) ? \
                                                            t2l_ac_hmc[lane_i] : 96'b0 )

// core2dbc_wr_data_vld needs to fanout to every data lane and also the A/C lane denoted as shadow by _get_hmc_dbc2ctrl_sel
`define _get_core2dbc_wr_data_vld_of_hmc(_tile_i, _lane_i)    ( (`_get_ac_tile_index(_tile_i, _lane_i) == PRI_AC_TILE_INDEX ? core2l_wr_data_vld_ast_0 : core2l_wr_data_vld_ast_1 ) )
`define _get_core2dbc_wr_data_vld(_tile_i, _lane_i)           ( ((`_get_lane_usage(_tile_i, _lane_i) == LANE_USAGE_WRDATA) || \
                                                                 (_lane_i == 0 && `_get_lane_usage(_tile_i, 0) == LANE_USAGE_AC_HMC && `_get_hmc_dbc2ctrl_sel(_tile_i) == "dbc0_to_local") || \
                                                                 (_lane_i == 1 && `_get_lane_usage(_tile_i, 1) == LANE_USAGE_AC_HMC && `_get_hmc_dbc2ctrl_sel(_tile_i) == "dbc1_to_local") || \
                                                                 (_lane_i == 2 && `_get_lane_usage(_tile_i, 2) == LANE_USAGE_AC_HMC && `_get_hmc_dbc2ctrl_sel(_tile_i) == "dbc2_to_local") || \
                                                                 (_lane_i == 3 && `_get_lane_usage(_tile_i, 3) == LANE_USAGE_AC_HMC && `_get_hmc_dbc2ctrl_sel(_tile_i) == "dbc3_to_local")) ? \
                                                                  `_get_core2dbc_wr_data_vld_of_hmc(_tile_i, _lane_i) : 1'b0 )

// core2dbc_rd_data_rdy needs to fanout to every data lane and also the lane denoted as shadow by _get_hmc_dbc2ctrl_sel
`define _get_core2dbc_rd_data_rdy_of_hmc(_tile_i, _lane_i)    ( (`_get_ac_tile_index(_tile_i, _lane_i) == PRI_AC_TILE_INDEX ? core2l_rd_data_rdy_ast_0 : core2l_rd_data_rdy_ast_1 ) )
`define _get_core2dbc_rd_data_rdy(_tile_i, _lane_i)           ( ((`_get_lane_usage(_tile_i, _lane_i) == LANE_USAGE_WRDATA) || \
                                                                 (_lane_i == 0 && `_get_lane_usage(_tile_i, 0) == LANE_USAGE_AC_HMC && `_get_hmc_dbc2ctrl_sel(_tile_i) == "dbc0_to_local") || \
                                                                 (_lane_i == 1 && `_get_lane_usage(_tile_i, 1) == LANE_USAGE_AC_HMC && `_get_hmc_dbc2ctrl_sel(_tile_i) == "dbc1_to_local") || \
                                                                 (_lane_i == 2 && `_get_lane_usage(_tile_i, 2) == LANE_USAGE_AC_HMC && `_get_hmc_dbc2ctrl_sel(_tile_i) == "dbc2_to_local") || \
                                                                 (_lane_i == 3 && `_get_lane_usage(_tile_i, 3) == LANE_USAGE_AC_HMC && `_get_hmc_dbc2ctrl_sel(_tile_i) == "dbc3_to_local")) ? \
                                                                  `_get_core2dbc_rd_data_rdy_of_hmc(_tile_i, _lane_i) : 1'b1 )

// core2dbc_wr_ecc_info needs to fanout to every data lane and also the lane denoted as shadow by _get_hmc_dbc2ctrl_sel
`define _get_core2dbc_wr_ecc_info_of_hmc(_tile_i, _lane_i)    ( (`_get_ac_tile_index(_tile_i, _lane_i) == PRI_AC_TILE_INDEX ? core2l_wr_ecc_info_0 : core2l_wr_ecc_info_1 ) )
`define _get_core2dbc_wr_ecc_info(_tile_i, _lane_i)           ( ((`_get_lane_usage(_tile_i, _lane_i) == LANE_USAGE_WRDATA) || \
                                                                 (_lane_i == 0 && `_get_lane_usage(_tile_i, 0) == LANE_USAGE_AC_HMC && `_get_hmc_dbc2ctrl_sel(_tile_i) == "dbc0_to_local") || \
                                                                 (_lane_i == 1 && `_get_lane_usage(_tile_i, 1) == LANE_USAGE_AC_HMC && `_get_hmc_dbc2ctrl_sel(_tile_i) == "dbc1_to_local") || \
                                                                 (_lane_i == 2 && `_get_lane_usage(_tile_i, 2) == LANE_USAGE_AC_HMC && `_get_hmc_dbc2ctrl_sel(_tile_i) == "dbc2_to_local") || \
                                                                 (_lane_i == 3 && `_get_lane_usage(_tile_i, 3) == LANE_USAGE_AC_HMC && `_get_hmc_dbc2ctrl_sel(_tile_i) == "dbc3_to_local")) ? \
                                                                  `_get_core2dbc_wr_ecc_info_of_hmc(_tile_i, _lane_i) : 13'b0 )

`define _get_center_tid(_tile_i)                         ( CENTER_TIDS[_tile_i * 9 +: 9] )
`define _get_hmc_tid(_tile_i)                            ( HMC_TIDS[_tile_i * 9 +: 9] )
`define _get_lane_tid(_tile_i, _lane_i)                  ( LANE_TIDS[(_tile_i * LANES_PER_TILE + _lane_i) * 9 +: 9] )

`define _get_preamble_track_dqs_enable_mode              ( PROTOCOL_ENUM == "PROTOCOL_DDR4"   ? "preamble_track_dqs_enable" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_DDR3"   ? "preamble_track_dqs_enable" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_LPDDR3" ? "preamble_track_dqs_enable" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_RLD3"   ? "preamble_track_toggler" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_QDR2"   ? "preamble_track_toggler" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_QDR4"   ? "preamble_track_toggler" : ( \
                                                                                                "" )))))))

`define _get_pst_preamble_mode                           ( PROTOCOL_ENUM == "PROTOCOL_DDR4"   ? "ddr4_preamble" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_DDR3"   ? "ddr3_preamble" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_LPDDR3" ? "ddr3_preamble" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_RLD3"   ? "ddr3_preamble" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_QDR2"   ? "ddr3_preamble" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_QDR4"   ? "ddr3_preamble" : ( \
                                                                                                "" )))))))

`define _get_pin_pair_mode                               ( PROTOCOL_ENUM == "PROTOCOL_DDR4"   ? "ddr4_idle" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_DDR3"   ? "ddr3_idle" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_LPDDR3" ? "ddr3_idle" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_RLD3"   ? "ddr3_idle" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_QDR2"   ? "ddr3_idle" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_QDR4"   ? "ddr3_idle" : ( \
                                                                                                "" )))))))

`define _get_ddr4_search                                 "ddr3_search"
/*`define _get_ddr4_search                                 ( PROTOCOL_ENUM == "PROTOCOL_DDR4" ? "ddr4_search" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_DDR3" ? "ddr3_search" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_RLD3" ? "ddr3_search" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_QDR2" ? "ddr3_search" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_QDR4" ? "ddr3_search" : ( \
                                                                                              "" ))))))
*/

// Enable DQSB bus for QDR-II and for x4 mode
`define _get_dqs_b_en                                    ( (PROTOCOL_ENUM == "PROTOCOL_QDR2") || (DQS_BUS_MODE_ENUM == "DQS_BUS_MODE_X4") ? "true" : "false" )

`define _get_pst_en_shrink                               ( PROTOCOL_ENUM == "PROTOCOL_DDR4"   ? "shrink_1_0" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_DDR3"   ? "shrink_1_1" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_LPDDR3" ? "shrink_1_1" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_RLD3"   ? "shrink_0_1" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_QDR2"   ? "shrink_0_1" : ( \
                                                           PROTOCOL_ENUM == "PROTOCOL_QDR4"   ? "shrink_0_1" : ( \
                                                                                              "" )))))))

`define _get_pa_filter_code                              ( 1600 )

`define _get_a_filter_code                               ( "freq_16ghz" )

`define _get_pa_track_speed                              ( 5'h0c )

// Enable the per-lane hard DBI circuitry. Only intended to be used by DDR4 data lanes.
`define _get_dbi_wr_en(_tile_i, _lane_i)                 ((`_get_lane_usage(_tile_i, _lane_i) == LANE_USAGE_WRDATA) ? DBI_WR_ENABLE : "false")
`define _get_dbi_rd_en(_tile_i, _lane_i)                 ((`_get_lane_usage(_tile_i, _lane_i) == LANE_USAGE_WRDATA) ? DBI_RD_ENABLE : "false")

// Set it to enabled to data lanes (or multi-rank shadow would not work).
// Set it to disabled for address/command lanes.
`define _get_mrnk_write_mode(_tile_i, _lane_i)           ( ((`_get_lane_usage(_tile_i, _lane_i) == LANE_USAGE_WRDATA) || \
                                                            (`_get_lane_usage(_tile_i, _lane_i) == LANE_USAGE_WDATA) || \
                                                            (`_get_lane_usage(_tile_i, _lane_i) == LANE_USAGE_RDATA)) ? "enabled" : "disabled" )
 
// Controls how early/late to enable Rt termination.
// Decimal to binary conversion required by Quartus.
`define _get_oct_size                                    ( (OCT_SIZE == 0 ) ? 4'b0000 : ( \
                                                           (OCT_SIZE == 1 ) ? 4'b0001 : ( \
                                                           (OCT_SIZE == 2 ) ? 4'b0010 : ( \
                                                           (OCT_SIZE == 3 ) ? 4'b0011 : ( \
                                                           (OCT_SIZE == 4 ) ? 4'b0100 : ( \
                                                           (OCT_SIZE == 5 ) ? 4'b0101 : ( \
                                                           (OCT_SIZE == 6 ) ? 4'b0110 : ( \
                                                           (OCT_SIZE == 7 ) ? 4'b0111 : ( \
                                                           (OCT_SIZE == 8 ) ? 4'b1000 : ( \
                                                           (OCT_SIZE == 9 ) ? 4'b1001 : ( \
                                                           (OCT_SIZE == 10) ? 4'b1010 : ( \
                                                           (OCT_SIZE == 11) ? 4'b1011 : ( \
                                                           (OCT_SIZE == 12) ? 4'b1100 : ( \
                                                           (OCT_SIZE == 13) ? 4'b1101 : ( \
                                                           (OCT_SIZE == 14) ? 4'b1110 : ( \
                                                                              4'b1111   ))))))))))))))))

`define _get_hmc_cb_tbp_reload_fix_en_n   ((PROTOCOL_ENUM == "PROTOCOL_DDR3" || PROTOCOL_ENUM == "PROTOCOL_LPDDR3") ? "enable" : "disable")
                                                                              
// Select primary or secondary HMC config
// For non-ping-pong and primary HMC of ping-pong, select primary
// For secondary HMC of ping-pong, select secondary
// For everything else, select primary
`define _sel_hmc_tile(_tile_i, _pri, _sec)            ( PHY_PING_PONG_EN ? (_tile_i <= SEC_AC_TILE_INDEX ? _sec : _pri) : _pri )

// Select primary/secondary/default HMC config
// For non-ping-pong and primary HMC of ping-pong, select primary
// For secondary HMC of ping-pong, select secondary
// For everything else, select default
`define _sel_hmc_default(_tile_i, _pri, _sec, _def)   ( PHY_PING_PONG_EN ? ((_tile_i == SEC_AC_TILE_INDEX) ? _sec : (_tile_i == PRI_AC_TILE_INDEX) ? _pri : _def) : _pri )

// Select primary or secondary HMC config, with lane dependence
// For non-ping-pong and primary HMC of ping-pong, select primary
// For secondary HMC of ping-pong, select primary or secondary based on lane affiliation
`define _sel_hmc_lane(_tile_i, _lane_i, _pri, _sec)   ( (PHY_PING_PONG_EN && (_tile_i < SEC_AC_TILE_INDEX || (_tile_i == SEC_AC_TILE_INDEX && _lane_i < 2))) ? _sec : _pri )

// RevA      devices have the x18 DQS tree connected to lane 1 pin 0 and lane 3 pin 0.
// Follow-on devices have the x18 DQS tree connected to lane 0 pin 8 and lane 2 pin 8.
// The following functions determine which scheme to use based on PINLOC params.
`define _get_pin_count(_loc) ( _loc[ 9 : 0 ] )
`define _get_pin_index(_loc, _port_i) ( _loc[ (_port_i + 1) * 10 +: 10 ] )

`define _use_reva_x18_dqstree  ((`_get_pin_count(PORT_MEM_QK_PINLOC) != 0  ? (`_get_pin_index(PORT_MEM_QK_PINLOC, 0)  % PINS_PER_LANE) : \
                                 `_get_pin_count(PORT_MEM_QKA_PINLOC) != 0 ? (`_get_pin_index(PORT_MEM_QKA_PINLOC, 0) % PINS_PER_LANE) : \
                                 `_get_pin_count(PORT_MEM_QKB_PINLOC) != 0 ? (`_get_pin_index(PORT_MEM_QKB_PINLOC, 0) % PINS_PER_LANE) : \
                                 `_get_pin_count(PORT_MEM_CQ_PINLOC) != 0  ? (`_get_pin_index(PORT_MEM_CQ_PINLOC, 0)  % PINS_PER_LANE) : \
                                                                             (`_get_pin_index(PORT_MEM_DQS_PINLOC, 0) % PINS_PER_LANE)) == 0 ? 1 : 0)

`define _get_x18_0_lane       (`_use_reva_x18_dqstree ? 1 : 0 )
`define _get_x18_1_lane       (`_use_reva_x18_dqstree ? 3 : 2 )

module altera_emif_arch_nd_io_tiles_abphy #(
   parameter DIAG_SYNTH_FOR_SIM                      = 0,
   parameter DIAG_CPA_OUT_1_EN                       = 0,
   parameter DIAG_FAST_SIM                           = 0,
   parameter MEM_ABPHY_VERBOSE                       = 1,
   parameter DIAG_SEQ_RESET_AUTO_RELEASE             = "avl",
   parameter DIAG_DB_RESET_AUTO_RELEASE              = "avl_release",
   parameter DIAG_SIM_MEMORY_PRELOAD                 = 0,
   parameter DIAG_SIM_MEMORY_PRELOAD_PRI_ABPHY_FILE  = "",
   parameter DIAG_SIM_MEMORY_PRELOAD_SEC_ABPHY_FILE  = "",
   parameter IS_HPS                                  = 0,
   parameter SILICON_REV                             = "",
   parameter PROTOCOL_ENUM                           = "",
   parameter PHY_PING_PONG_EN                        = 0,
   parameter DQS_BUS_MODE_ENUM                       = "",
   parameter USER_CLK_RATIO                          = 1,
   parameter PHY_HMC_CLK_RATIO                       = 1,
   parameter C2P_P2C_CLK_RATIO                       = 1,
   parameter PLL_VCO_TO_MEM_CLK_FREQ_RATIO           = 1,
   parameter PLL_VCO_FREQ_MHZ_INT                    = 0,
   parameter MEM_BURST_LENGTH                        = 0,
   parameter MEM_DATA_MASK_EN                        = 1,
   parameter PINS_PER_LANE                           = 1,
   parameter LANES_PER_TILE                          = 1,
   parameter PINS_IN_RTL_TILES                       = 1,
   parameter LANES_IN_RTL_TILES                      = 1,
   parameter NUM_OF_RTL_TILES                        = 1,
   parameter AC_PIN_MAP_SCHEME                       = "",
   parameter PRI_AC_TILE_INDEX                       = -1,
   parameter SEC_AC_TILE_INDEX                       = -1,
   parameter PRI_HMC_DBC_SHADOW_LANE_INDEX           = -1,
   parameter NUM_OF_HMC_PORTS                        = 1,
   parameter HMC_AVL_PROTOCOL_ENUM                   = "",
   parameter HMC_CTRL_DIMM_TYPE                      = "",
   
   parameter           PRI_HMC_CFG_PING_PONG_MODE              = "",
   parameter           PRI_HMC_CFG_CS_ADDR_WIDTH               = "",
   parameter           PRI_HMC_CFG_COL_ADDR_WIDTH              = "",
   parameter           PRI_HMC_CFG_ROW_ADDR_WIDTH              = "",
   parameter           PRI_HMC_CFG_BANK_ADDR_WIDTH             = "",
   parameter           PRI_HMC_CFG_BANK_GROUP_ADDR_WIDTH       = "",
   parameter           PRI_HMC_CFG_ADDR_ORDER                  = "",
   parameter           PRI_HMC_CFG_ARBITER_TYPE                = "",
   parameter           PRI_HMC_CFG_OPEN_PAGE_EN                = "",
   parameter           PRI_HMC_CFG_CTRL_ENABLE_RC              = "",
   parameter           PRI_HMC_CFG_DBC0_ENABLE_RC              = "",
   parameter           PRI_HMC_CFG_DBC1_ENABLE_RC              = "",
   parameter           PRI_HMC_CFG_DBC2_ENABLE_RC              = "",
   parameter           PRI_HMC_CFG_DBC3_ENABLE_RC              = "",
   parameter           PRI_HMC_CFG_CTRL_ENABLE_ECC             = "",
   parameter           PRI_HMC_CFG_DBC0_ENABLE_ECC             = "",
   parameter           PRI_HMC_CFG_DBC1_ENABLE_ECC             = "",
   parameter           PRI_HMC_CFG_DBC2_ENABLE_ECC             = "",
   parameter           PRI_HMC_CFG_DBC3_ENABLE_ECC             = "",
   parameter           PRI_HMC_CFG_REORDER_DATA                = "",
   parameter           PRI_HMC_CFG_REORDER_READ                = "",
   parameter           PRI_HMC_CFG_CTRL_REORDER_RDATA          = "",
   parameter           PRI_HMC_CFG_DBC0_REORDER_RDATA          = "",
   parameter           PRI_HMC_CFG_DBC1_REORDER_RDATA          = "",
   parameter           PRI_HMC_CFG_DBC2_REORDER_RDATA          = "",
   parameter           PRI_HMC_CFG_DBC3_REORDER_RDATA          = "",
   parameter [  1:  0] PRI_HMC_CFG_CTRL_SLOT_OFFSET            = 0,
   parameter [  1:  0] PRI_HMC_CFG_DBC0_SLOT_OFFSET            = 0,
   parameter [  1:  0] PRI_HMC_CFG_DBC1_SLOT_OFFSET            = 0,
   parameter [  1:  0] PRI_HMC_CFG_DBC2_SLOT_OFFSET            = 0,
   parameter [  1:  0] PRI_HMC_CFG_DBC3_SLOT_OFFSET            = 0,
   parameter           PRI_HMC_CFG_CTRL_SLOT_ROTATE_EN         = "",
   parameter           PRI_HMC_CFG_DBC0_SLOT_ROTATE_EN         = "",
   parameter           PRI_HMC_CFG_DBC1_SLOT_ROTATE_EN         = "",
   parameter           PRI_HMC_CFG_DBC2_SLOT_ROTATE_EN         = "",
   parameter           PRI_HMC_CFG_DBC3_SLOT_ROTATE_EN         = "",
   parameter [  3:  0] PRI_HMC_CFG_COL_CMD_SLOT                = 0,
   parameter [  3:  0] PRI_HMC_CFG_ROW_CMD_SLOT                = 0,
   parameter [ 31:  0] PRI_HMC_CFG_ROW_TO_COL_OFFSET           = 0,
   parameter [ 31:  0] PRI_HMC_CFG_ROW_TO_ROW_OFFSET           = 0,
   parameter [ 31:  0] PRI_HMC_CFG_COL_TO_COL_OFFSET           = 0,
   parameter [ 31:  0] PRI_HMC_CFG_COL_TO_DIFF_COL_OFFSET      = 0,
   parameter [ 31:  0] PRI_HMC_CFG_COL_TO_ROW_OFFSET           = 0,
   parameter [ 31:  0] PRI_HMC_CFG_SIDEBAND_OFFSET             = 0,
   parameter [ 15:  0] PRI_HMC_CFG_CS_TO_CHIP_MAPPING          = 0,
   parameter [ 31:  0] PRI_HMC_CFG_CTL_ODT_ENABLED             = 0,
   parameter [  5:  0] PRI_HMC_CFG_RD_ODT_ON                   = 0,
   parameter [  5:  0] PRI_HMC_CFG_RD_ODT_PERIOD               = 0,
   parameter [ 15:  0] PRI_HMC_CFG_READ_ODT_CHIP               = 0,
   parameter [  5:  0] PRI_HMC_CFG_WR_ODT_ON                   = 0,
   parameter [  5:  0] PRI_HMC_CFG_WR_ODT_PERIOD               = 0,
   parameter [ 15:  0] PRI_HMC_CFG_WRITE_ODT_CHIP              = 0,
   parameter           PRI_HMC_CFG_CMD_FIFO_RESERVE_EN         = "",
   parameter [  6:  0] PRI_HMC_CFG_RB_RESERVED_ENTRY           = 0,
   parameter [  6:  0] PRI_HMC_CFG_WB_RESERVED_ENTRY           = 0,
   parameter [  5:  0] PRI_HMC_CFG_STARVE_LIMIT                = 0,
   parameter [ 31:  0] PRI_HMC_CFG_PHY_DELAY_MISMATCH          = 0,
   parameter           PRI_HMC_CFG_DQSTRK_EN                   = "",
   parameter [  7:  0] PRI_HMC_CFG_DQSTRK_TO_VALID             = 0,
   parameter [  7:  0] PRI_HMC_CFG_DQSTRK_TO_VALID_LAST        = 0,
   parameter [ 31:  0] PRI_HMC_CFG_CTL_SHORT_DQSTRK_EN         = 0,
   parameter           PRI_HMC_CFG_PERIOD_DQSTRK_CTRL_EN       = "",
   parameter [ 15:  0] PRI_HMC_CFG_PERIOD_DQSTRK_INTERVAL      = 0,
   parameter           PRI_HMC_CFG_SHORT_DQSTRK_CTRL_EN        = "",
   parameter [ 31:  0] PRI_HMC_CFG_ENABLE_FAST_EXIT_PPD        = 0,
   parameter           PRI_HMC_CFG_USER_RFSH_EN                = "",
   parameter           PRI_HMC_CFG_GEAR_DOWN_EN                = "",
   parameter [ 31:  0] PRI_HMC_CFG_MEM_AUTO_PD_CYCLES          = 0,
   parameter [  5:  0] PRI_HMC_CFG_MEM_CLK_DISABLE_ENTRY_CYC   = 0,
   parameter [  7:  0] PRI_HMC_MEMCLKGATE_SETTING              = 0,
   parameter [  6:  0] PRI_HMC_CFG_TCL                         = 0,
   parameter [  7:  0] PRI_HMC_CFG_16_ACT_TO_ACT               = 0,
   parameter [  7:  0] PRI_HMC_CFG_4_ACT_TO_ACT                = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_AL                       = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_CS_PER_DIMM              = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_RD_PREAMBLE              = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TCCD                     = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TCCD_S                   = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TCKESR                   = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TCKSRX                   = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TCL                      = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TCWL                     = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TDQSCKMAX                = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TFAW                     = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TMOD                     = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TPL                      = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TRAS                     = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TRC                      = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TRCD                     = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TREFI                    = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TRFC                     = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TRP                      = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TRRD                     = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TRRD_S                   = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TRTP                     = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TWR                      = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TWR_CRC_DM               = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TWTR                     = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TWTR_L_CRC_DM            = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TWTR_S                   = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TWTR_S_CRC_DM            = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TXP                      = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TXPDLL                   = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TXSR                     = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TZQCS                    = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_TZQOPER                  = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_WR_CRC                   = 0,
   parameter [ 31:  0] PRI_HMC_MEM_IF_WR_PREAMBLE              = 0,
   parameter [  5:  0] PRI_HMC_CFG_ACT_TO_ACT                  = 0,
   parameter [  5:  0] PRI_HMC_CFG_ACT_TO_ACT_DIFF_BANK        = 0,
   parameter [  5:  0] PRI_HMC_CFG_ACT_TO_ACT_DIFF_BG          = 0,
   parameter [  5:  0] PRI_HMC_CFG_ACT_TO_PCH                  = 0,
   parameter [  5:  0] PRI_HMC_CFG_ACT_TO_RDWR                 = 0,
   parameter [ 12:  0] PRI_HMC_CFG_ARF_PERIOD                  = 0,
   parameter [  7:  0] PRI_HMC_CFG_ARF_TO_VALID                = 0,
   parameter [  7:  0] PRI_HMC_CFG_MMR_CMD_TO_VALID            = 0,
   parameter [  4:  0] PRI_HMC_CFG_MPR_TO_VALID                = 0,
   parameter           PRI_HMC_CFG_MPS_DQSTRK_DISABLE          = "",
   parameter [  3:  0] PRI_HMC_CFG_MPS_EXIT_CKE_TO_CS          = 0,
   parameter [  3:  0] PRI_HMC_CFG_MPS_EXIT_CS_TO_CKE          = 0,
   parameter [  9:  0] PRI_HMC_CFG_MPS_TO_VALID                = 0,
   parameter           PRI_HMC_CFG_MPS_ZQCAL_DISABLE           = "",
   parameter [  3:  0] PRI_HMC_CFG_MRR_TO_VALID                = 0,
   parameter [  3:  0] PRI_HMC_CFG_MRS_TO_VALID                = 0,
   parameter [  5:  0] PRI_HMC_CFG_PCH_ALL_TO_VALID            = 0,
   parameter [  5:  0] PRI_HMC_CFG_PCH_TO_VALID                = 0,
   parameter [ 15:  0] PRI_HMC_CFG_PDN_PERIOD                  = 0,
   parameter [  5:  0] PRI_HMC_CFG_PDN_TO_VALID                = 0,
   parameter [  5:  0] PRI_HMC_CFG_POWER_SAVING_EXIT_CYC       = 0,
   parameter [  5:  0] PRI_HMC_CFG_RD_AP_TO_VALID              = 0,
   parameter [  5:  0] PRI_HMC_CFG_RD_TO_PCH                   = 0,
   parameter [  5:  0] PRI_HMC_CFG_RD_TO_RD                    = 0,
   parameter [  5:  0] PRI_HMC_CFG_RD_TO_RD_DIFF_BG            = 0,
   parameter [  5:  0] PRI_HMC_CFG_RD_TO_RD_DIFF_CHIP          = 0,
   parameter [  5:  0] PRI_HMC_CFG_RD_TO_WR                    = 0,
   parameter [  5:  0] PRI_HMC_CFG_RD_TO_WR_DIFF_BG            = 0,
   parameter [  5:  0] PRI_HMC_CFG_RD_TO_WR_DIFF_CHIP          = 0,
   parameter [  6:  0] PRI_HMC_CFG_RFSH_WARN_THRESHOLD         = 0,
   parameter [  2:  0] PRI_HMC_CFG_RLD3_MULTIBANK_REF_DELAY    = 0,
   parameter [ 15:  0] PRI_HMC_CFG_RLD3_REFRESH_SEQ0           = 0,
   parameter [ 15:  0] PRI_HMC_CFG_RLD3_REFRESH_SEQ1           = 0,
   parameter [ 15:  0] PRI_HMC_CFG_RLD3_REFRESH_SEQ2           = 0,
   parameter [ 15:  0] PRI_HMC_CFG_RLD3_REFRESH_SEQ3           = 0,
   parameter           PRI_HMC_CFG_SB_CG_DISABLE               = "",
   parameter [ 19:  0] PRI_HMC_CFG_SB_DDR4_MR3                 = 0,
   parameter [ 19:  0] PRI_HMC_CFG_SB_DDR4_MR4                 = 0,
   parameter [ 19:  0] PRI_HMC_CFG_SB_DDR4_MR5                 = 0,
   parameter           PRI_HMC_CFG_DDR4_MPS_ADDRMIRROR         = "",
   parameter           PRI_HMC_CFG_SRF_AUTOEXIT_EN             = "",
   parameter [  1:  0] PRI_HMC_CFG_SRF_ENTRY_EXIT_BLOCK        = 0,
   parameter [  9:  0] PRI_HMC_CFG_SRF_TO_VALID                = 0,
   parameter [  9:  0] PRI_HMC_CFG_SRF_TO_ZQ_CAL               = 0,
   parameter           PRI_HMC_CFG_SRF_ZQCAL_DISABLE           = "",
   parameter [ 31:  0] PRI_HMC_TEMP_4_ACT_TO_ACT               = 0,
   parameter [ 31:  0] PRI_HMC_TEMP_RD_TO_RD_DIFF_BG           = 0,
   parameter [ 31:  0] PRI_HMC_TEMP_WR_TO_RD                   = 0,
   parameter [ 31:  0] PRI_HMC_TEMP_WR_TO_RD_DIFF_BG           = 0,
   parameter [ 31:  0] PRI_HMC_TEMP_WR_TO_RD_DIFF_CHIP         = 0,
   parameter [ 31:  0] PRI_HMC_TEMP_WR_TO_WR_DIFF_BG           = 0,
   parameter [  5:  0] PRI_HMC_CFG_WR_AP_TO_VALID              = 0,
   parameter [  5:  0] PRI_HMC_CFG_WR_TO_PCH                   = 0,
   parameter [  5:  0] PRI_HMC_CFG_WR_TO_RD                    = 0,
   parameter [  5:  0] PRI_HMC_CFG_WR_TO_RD_DIFF_BG            = 0,
   parameter [  5:  0] PRI_HMC_CFG_WR_TO_RD_DIFF_CHIP          = 0,
   parameter [  5:  0] PRI_HMC_CFG_WR_TO_WR                    = 0,
   parameter [  5:  0] PRI_HMC_CFG_WR_TO_WR_DIFF_BG            = 0,
   parameter [  5:  0] PRI_HMC_CFG_WR_TO_WR_DIFF_CHIP          = 0,
   parameter [  8:  0] PRI_HMC_CFG_ZQCL_TO_VALID               = 0,
   parameter [  6:  0] PRI_HMC_CFG_ZQCS_TO_VALID               = 0,
   parameter [  8:  0] PRI_HMC_CHIP_ID                         = 0,
   parameter [  1:  0] PRI_HMC_CID_ADDR_WIDTH                  = 0,
   parameter           PRI_HMC_3DS_EN                          = "",
   parameter [  3:  0] PRI_HMC_3DS_LR_NUM0                     = 0,
   parameter [  3:  0] PRI_HMC_3DS_LR_NUM1                     = 0,
   parameter [  3:  0] PRI_HMC_3DS_LR_NUM2                     = 0,
   parameter [  3:  0] PRI_HMC_3DS_LR_NUM3                     = 0,
   parameter           PRI_HMC_3DS_PR_STAG_ENABLE              = "",
   parameter [  6:  0] PRI_HMC_3DS_REF2REF_DLR                 = 0,
   parameter           PRI_HMC_3DSREF_ACK_ON_DONE              = "",
   parameter           SEC_HMC_CFG_PING_PONG_MODE              = "",
   parameter           SEC_HMC_CFG_CS_ADDR_WIDTH               = "",
   parameter           SEC_HMC_CFG_COL_ADDR_WIDTH              = "",
   parameter           SEC_HMC_CFG_ROW_ADDR_WIDTH              = "",
   parameter           SEC_HMC_CFG_BANK_ADDR_WIDTH             = "",
   parameter           SEC_HMC_CFG_BANK_GROUP_ADDR_WIDTH       = "",
   parameter           SEC_HMC_CFG_ADDR_ORDER                  = "",
   parameter           SEC_HMC_CFG_ARBITER_TYPE                = "",
   parameter           SEC_HMC_CFG_OPEN_PAGE_EN                = "",
   parameter           SEC_HMC_CFG_CTRL_ENABLE_RC              = "",
   parameter           SEC_HMC_CFG_DBC0_ENABLE_RC              = "",
   parameter           SEC_HMC_CFG_DBC1_ENABLE_RC              = "",
   parameter           SEC_HMC_CFG_DBC2_ENABLE_RC              = "",
   parameter           SEC_HMC_CFG_DBC3_ENABLE_RC              = "",
   parameter           SEC_HMC_CFG_CTRL_ENABLE_ECC             = "",
   parameter           SEC_HMC_CFG_DBC0_ENABLE_ECC             = "",
   parameter           SEC_HMC_CFG_DBC1_ENABLE_ECC             = "",
   parameter           SEC_HMC_CFG_DBC2_ENABLE_ECC             = "",
   parameter           SEC_HMC_CFG_DBC3_ENABLE_ECC             = "",
   parameter           SEC_HMC_CFG_REORDER_DATA                = "",
   parameter           SEC_HMC_CFG_REORDER_READ                = "",
   parameter           SEC_HMC_CFG_CTRL_REORDER_RDATA          = "",
   parameter           SEC_HMC_CFG_DBC0_REORDER_RDATA          = "",
   parameter           SEC_HMC_CFG_DBC1_REORDER_RDATA          = "",
   parameter           SEC_HMC_CFG_DBC2_REORDER_RDATA          = "",
   parameter           SEC_HMC_CFG_DBC3_REORDER_RDATA          = "",
   parameter [  1:  0] SEC_HMC_CFG_CTRL_SLOT_OFFSET            = 0,
   parameter [  1:  0] SEC_HMC_CFG_DBC0_SLOT_OFFSET            = 0,
   parameter [  1:  0] SEC_HMC_CFG_DBC1_SLOT_OFFSET            = 0,
   parameter [  1:  0] SEC_HMC_CFG_DBC2_SLOT_OFFSET            = 0,
   parameter [  1:  0] SEC_HMC_CFG_DBC3_SLOT_OFFSET            = 0,
   parameter           SEC_HMC_CFG_CTRL_SLOT_ROTATE_EN         = "",
   parameter           SEC_HMC_CFG_DBC0_SLOT_ROTATE_EN         = "",
   parameter           SEC_HMC_CFG_DBC1_SLOT_ROTATE_EN         = "",
   parameter           SEC_HMC_CFG_DBC2_SLOT_ROTATE_EN         = "",
   parameter           SEC_HMC_CFG_DBC3_SLOT_ROTATE_EN         = "",
   parameter [  3:  0] SEC_HMC_CFG_COL_CMD_SLOT                = 0,
   parameter [  3:  0] SEC_HMC_CFG_ROW_CMD_SLOT                = 0,
   parameter [ 31:  0] SEC_HMC_CFG_ROW_TO_COL_OFFSET           = 0,
   parameter [ 31:  0] SEC_HMC_CFG_ROW_TO_ROW_OFFSET           = 0,
   parameter [ 31:  0] SEC_HMC_CFG_COL_TO_COL_OFFSET           = 0,
   parameter [ 31:  0] SEC_HMC_CFG_COL_TO_DIFF_COL_OFFSET      = 0,
   parameter [ 31:  0] SEC_HMC_CFG_COL_TO_ROW_OFFSET           = 0,
   parameter [ 31:  0] SEC_HMC_CFG_SIDEBAND_OFFSET             = 0,
   parameter [ 15:  0] SEC_HMC_CFG_CS_TO_CHIP_MAPPING          = 0,
   parameter [ 31:  0] SEC_HMC_CFG_CTL_ODT_ENABLED             = 0,
   parameter [  5:  0] SEC_HMC_CFG_RD_ODT_ON                   = 0,
   parameter [  5:  0] SEC_HMC_CFG_RD_ODT_PERIOD               = 0,
   parameter [ 15:  0] SEC_HMC_CFG_READ_ODT_CHIP               = 0,
   parameter [  5:  0] SEC_HMC_CFG_WR_ODT_ON                   = 0,
   parameter [  5:  0] SEC_HMC_CFG_WR_ODT_PERIOD               = 0,
   parameter [ 15:  0] SEC_HMC_CFG_WRITE_ODT_CHIP              = 0,
   parameter           SEC_HMC_CFG_CMD_FIFO_RESERVE_EN         = "",
   parameter [  6:  0] SEC_HMC_CFG_RB_RESERVED_ENTRY           = 0,
   parameter [  6:  0] SEC_HMC_CFG_WB_RESERVED_ENTRY           = 0,
   parameter [  5:  0] SEC_HMC_CFG_STARVE_LIMIT                = 0,
   parameter [ 31:  0] SEC_HMC_CFG_PHY_DELAY_MISMATCH          = 0,
   parameter           SEC_HMC_CFG_DQSTRK_EN                   = "",
   parameter [  7:  0] SEC_HMC_CFG_DQSTRK_TO_VALID             = 0,
   parameter [  7:  0] SEC_HMC_CFG_DQSTRK_TO_VALID_LAST        = 0,
   parameter [ 31:  0] SEC_HMC_CFG_CTL_SHORT_DQSTRK_EN         = 0,
   parameter           SEC_HMC_CFG_PERIOD_DQSTRK_CTRL_EN       = "",
   parameter [ 15:  0] SEC_HMC_CFG_PERIOD_DQSTRK_INTERVAL      = 0,
   parameter           SEC_HMC_CFG_SHORT_DQSTRK_CTRL_EN        = "",
   parameter [ 31:  0] SEC_HMC_CFG_ENABLE_FAST_EXIT_PPD        = 0,
   parameter           SEC_HMC_CFG_USER_RFSH_EN                = "",
   parameter           SEC_HMC_CFG_GEAR_DOWN_EN                = "",
   parameter [ 31:  0] SEC_HMC_CFG_MEM_AUTO_PD_CYCLES          = 0,
   parameter [  5:  0] SEC_HMC_CFG_MEM_CLK_DISABLE_ENTRY_CYC   = 0,
   parameter [  7:  0] SEC_HMC_MEMCLKGATE_SETTING              = 0,
   parameter [  6:  0] SEC_HMC_CFG_TCL                         = 0,
   parameter [  7:  0] SEC_HMC_CFG_16_ACT_TO_ACT               = 0,
   parameter [  7:  0] SEC_HMC_CFG_4_ACT_TO_ACT                = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_AL                       = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_CS_PER_DIMM              = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_RD_PREAMBLE              = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TCCD                     = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TCCD_S                   = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TCKESR                   = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TCKSRX                   = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TCL                      = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TCWL                     = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TDQSCKMAX                = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TFAW                     = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TMOD                     = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TPL                      = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TRAS                     = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TRC                      = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TRCD                     = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TREFI                    = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TRFC                     = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TRP                      = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TRRD                     = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TRRD_S                   = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TRTP                     = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TWR                      = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TWR_CRC_DM               = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TWTR                     = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TWTR_L_CRC_DM            = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TWTR_S                   = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TWTR_S_CRC_DM            = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TXP                      = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TXPDLL                   = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TXSR                     = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TZQCS                    = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_TZQOPER                  = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_WR_CRC                   = 0,
   parameter [ 31:  0] SEC_HMC_MEM_IF_WR_PREAMBLE              = 0,
   parameter [  5:  0] SEC_HMC_CFG_ACT_TO_ACT                  = 0,
   parameter [  5:  0] SEC_HMC_CFG_ACT_TO_ACT_DIFF_BANK        = 0,
   parameter [  5:  0] SEC_HMC_CFG_ACT_TO_ACT_DIFF_BG          = 0,
   parameter [  5:  0] SEC_HMC_CFG_ACT_TO_PCH                  = 0,
   parameter [  5:  0] SEC_HMC_CFG_ACT_TO_RDWR                 = 0,
   parameter [ 12:  0] SEC_HMC_CFG_ARF_PERIOD                  = 0,
   parameter [  7:  0] SEC_HMC_CFG_ARF_TO_VALID                = 0,
   parameter [  7:  0] SEC_HMC_CFG_MMR_CMD_TO_VALID            = 0,
   parameter [  4:  0] SEC_HMC_CFG_MPR_TO_VALID                = 0,
   parameter           SEC_HMC_CFG_MPS_DQSTRK_DISABLE          = "",
   parameter [  3:  0] SEC_HMC_CFG_MPS_EXIT_CKE_TO_CS          = 0,
   parameter [  3:  0] SEC_HMC_CFG_MPS_EXIT_CS_TO_CKE          = 0,
   parameter [  9:  0] SEC_HMC_CFG_MPS_TO_VALID                = 0,
   parameter           SEC_HMC_CFG_MPS_ZQCAL_DISABLE           = "",
   parameter [  3:  0] SEC_HMC_CFG_MRR_TO_VALID                = 0,
   parameter [  3:  0] SEC_HMC_CFG_MRS_TO_VALID                = 0,
   parameter [  5:  0] SEC_HMC_CFG_PCH_ALL_TO_VALID            = 0,
   parameter [  5:  0] SEC_HMC_CFG_PCH_TO_VALID                = 0,
   parameter [ 15:  0] SEC_HMC_CFG_PDN_PERIOD                  = 0,
   parameter [  5:  0] SEC_HMC_CFG_PDN_TO_VALID                = 0,
   parameter [  5:  0] SEC_HMC_CFG_POWER_SAVING_EXIT_CYC       = 0,
   parameter [  5:  0] SEC_HMC_CFG_RD_AP_TO_VALID              = 0,
   parameter [  5:  0] SEC_HMC_CFG_RD_TO_PCH                   = 0,
   parameter [  5:  0] SEC_HMC_CFG_RD_TO_RD                    = 0,
   parameter [  5:  0] SEC_HMC_CFG_RD_TO_RD_DIFF_BG            = 0,
   parameter [  5:  0] SEC_HMC_CFG_RD_TO_RD_DIFF_CHIP          = 0,
   parameter [  5:  0] SEC_HMC_CFG_RD_TO_WR                    = 0,
   parameter [  5:  0] SEC_HMC_CFG_RD_TO_WR_DIFF_BG            = 0,
   parameter [  5:  0] SEC_HMC_CFG_RD_TO_WR_DIFF_CHIP          = 0,
   parameter [  6:  0] SEC_HMC_CFG_RFSH_WARN_THRESHOLD         = 0,
   parameter [  2:  0] SEC_HMC_CFG_RLD3_MULTIBANK_REF_DELAY    = 0,
   parameter [ 15:  0] SEC_HMC_CFG_RLD3_REFRESH_SEQ0           = 0,
   parameter [ 15:  0] SEC_HMC_CFG_RLD3_REFRESH_SEQ1           = 0,
   parameter [ 15:  0] SEC_HMC_CFG_RLD3_REFRESH_SEQ2           = 0,
   parameter [ 15:  0] SEC_HMC_CFG_RLD3_REFRESH_SEQ3           = 0,
   parameter           SEC_HMC_CFG_SB_CG_DISABLE               = "",
   parameter [ 19:  0] SEC_HMC_CFG_SB_DDR4_MR3                 = 0,
   parameter [ 19:  0] SEC_HMC_CFG_SB_DDR4_MR4                 = 0,
   parameter [ 19:  0] SEC_HMC_CFG_SB_DDR4_MR5                 = 0,
   parameter           SEC_HMC_CFG_DDR4_MPS_ADDRMIRROR         = "",
   parameter           SEC_HMC_CFG_SRF_AUTOEXIT_EN             = "",
   parameter [  1:  0] SEC_HMC_CFG_SRF_ENTRY_EXIT_BLOCK        = 0,
   parameter [  9:  0] SEC_HMC_CFG_SRF_TO_VALID                = 0,
   parameter [  9:  0] SEC_HMC_CFG_SRF_TO_ZQ_CAL               = 0,
   parameter           SEC_HMC_CFG_SRF_ZQCAL_DISABLE           = "",
   parameter [ 31:  0] SEC_HMC_TEMP_4_ACT_TO_ACT               = 0,
   parameter [ 31:  0] SEC_HMC_TEMP_RD_TO_RD_DIFF_BG           = 0,
   parameter [ 31:  0] SEC_HMC_TEMP_WR_TO_RD                   = 0,
   parameter [ 31:  0] SEC_HMC_TEMP_WR_TO_RD_DIFF_BG           = 0,
   parameter [ 31:  0] SEC_HMC_TEMP_WR_TO_RD_DIFF_CHIP         = 0,
   parameter [ 31:  0] SEC_HMC_TEMP_WR_TO_WR_DIFF_BG           = 0,
   parameter [  5:  0] SEC_HMC_CFG_WR_AP_TO_VALID              = 0,
   parameter [  5:  0] SEC_HMC_CFG_WR_TO_PCH                   = 0,
   parameter [  5:  0] SEC_HMC_CFG_WR_TO_RD                    = 0,
   parameter [  5:  0] SEC_HMC_CFG_WR_TO_RD_DIFF_BG            = 0,
   parameter [  5:  0] SEC_HMC_CFG_WR_TO_RD_DIFF_CHIP          = 0,
   parameter [  5:  0] SEC_HMC_CFG_WR_TO_WR                    = 0,
   parameter [  5:  0] SEC_HMC_CFG_WR_TO_WR_DIFF_BG            = 0,
   parameter [  5:  0] SEC_HMC_CFG_WR_TO_WR_DIFF_CHIP          = 0,
   parameter [  8:  0] SEC_HMC_CFG_ZQCL_TO_VALID               = 0,
   parameter [  6:  0] SEC_HMC_CFG_ZQCS_TO_VALID               = 0,
   parameter [  8:  0] SEC_HMC_CHIP_ID                         = 0,
   parameter [  1:  0] SEC_HMC_CID_ADDR_WIDTH                  = 0,
   parameter           SEC_HMC_3DS_EN                          = "",
   parameter [  3:  0] SEC_HMC_3DS_LR_NUM0                     = 0,
   parameter [  3:  0] SEC_HMC_3DS_LR_NUM1                     = 0,
   parameter [  3:  0] SEC_HMC_3DS_LR_NUM2                     = 0,
   parameter [  3:  0] SEC_HMC_3DS_LR_NUM3                     = 0,
   parameter           SEC_HMC_3DS_PR_STAG_ENABLE              = "",
   parameter [  6:  0] SEC_HMC_3DS_REF2REF_DLR                 = 0,
   parameter           SEC_HMC_3DSREF_ACK_ON_DONE              = "",
   
   parameter LANES_USAGE                             = 1'b0,
   parameter PINS_USAGE                              = 1'b0,
   parameter PINS_RATE                               = 1'b0,
   parameter DB_PINS_PROC_MODE                       = 1'b0,
   parameter PINS_DATA_IN_MODE                       = 1'b0,
   parameter PINS_OCT_MODE                           = 1'b0,
   parameter PINS_DCC_SPLIT                          = 1'b0,
   parameter CENTER_TIDS                             = 1'b0,
   parameter HMC_TIDS                                = 1'b0,
   parameter LANE_TIDS                               = 1'b0,
   parameter DBC_PIPE_LATS                           = 1'b0,
   parameter DB_PTR_PIPELINE_DEPTHS                  = 1'b0,
   parameter DB_SEQ_RD_EN_FULL_PIPELINES             = 1'b0,
   parameter PREAMBLE_MODE                           = "",
   parameter DBI_WR_ENABLE                           = "",
   parameter DBI_RD_ENABLE                           = "",
   parameter SWAP_DQS_A_B                            = "",
   parameter DQS_PACK_MODE                           = "",
   parameter OCT_SIZE                                = "",
   parameter DQSA_LGC_MODE                           = "",
   parameter DQSB_LGC_MODE                           = "",
   parameter [6:0] DBC_WB_RESERVED_ENTRY             = 4,
   parameter DLL_MODE                                = "",
   parameter [9:0] DLL_CODEWORD                      = 0,
   parameter PORT_MEM_DQ_WIDTH                       = 1,
   parameter PORT_MEM_DQS_WIDTH                      = 1,
   parameter PORT_DFT_ND_PA_DPRIO_REG_ADDR_WIDTH     = 1,
   parameter PORT_DFT_ND_PA_DPRIO_WRITEDATA_WIDTH    = 1,
   parameter PORT_DFT_ND_PA_DPRIO_READDATA_WIDTH     = 1,
   
   parameter PORT_MEM_A_PINLOC                       = 0,
   parameter PORT_MEM_BA_PINLOC                      = 0,
   parameter PORT_MEM_BG_PINLOC                      = 0,
   parameter PORT_MEM_C_PINLOC                       = 0,
   parameter PORT_MEM_CS_N_PINLOC                    = 0,
   parameter PORT_MEM_ACT_N_PINLOC                   = 0,
   parameter PORT_MEM_DQ_PINLOC                      = 0,
   parameter PORT_MEM_DM_PINLOC                      = 0,
   parameter PORT_MEM_DBI_N_PINLOC                   = 0, 
   parameter PORT_MEM_RAS_N_PINLOC                   = 0,
   parameter PORT_MEM_CAS_N_PINLOC                   = 0,
   parameter PORT_MEM_WE_N_PINLOC                    = 0,
   parameter PORT_MEM_REF_N_PINLOC                   = 0,
   
   parameter PORT_MEM_WPS_N_PINLOC                   = 0,
   parameter PORT_MEM_RPS_N_PINLOC                   = 0,
   parameter PORT_MEM_BWS_N_PINLOC                   = 0,
   parameter PORT_MEM_DQA_PINLOC                     = 0,
   parameter PORT_MEM_DQB_PINLOC                     = 0,
   parameter PORT_MEM_Q_PINLOC                       = 0,
   parameter PORT_MEM_D_PINLOC                       = 0,
   parameter PORT_MEM_RWA_N_PINLOC                   = 0,
   parameter PORT_MEM_RWB_N_PINLOC                   = 0,
   parameter PORT_MEM_QKA_PINLOC                     = 0,
   parameter PORT_MEM_QKB_PINLOC                     = 0,
   parameter PORT_MEM_LDA_N_PINLOC                   = 0,
   parameter PORT_MEM_LDB_N_PINLOC                   = 0,
   parameter PORT_MEM_CK_PINLOC                      = 0,
   parameter PORT_MEM_DINVA_PINLOC                   = 0,
   parameter PORT_MEM_DINVB_PINLOC                   = 0,
   parameter PORT_MEM_AINV_PINLOC                    = 0,
   parameter PORT_MEM_DQS_PINLOC                     = 0,
   parameter PORT_MEM_QK_PINLOC                      = 0,
   parameter PORT_MEM_CQ_PINLOC                      = 0,
   
   parameter PORT_MEM_A_WIDTH                        = 0,
   parameter PORT_MEM_BA_WIDTH                       = 0,
   parameter PORT_MEM_BG_WIDTH                       = 0,
   parameter PORT_MEM_C_WIDTH                        = 0,
   parameter PORT_MEM_CS_N_WIDTH                     = 0,
   parameter PORT_MEM_ACT_N_WIDTH                    = 0,
   parameter PORT_MEM_DBI_N_WIDTH                    = 0,
   parameter PORT_MEM_RAS_N_WIDTH                    = 0,
   parameter PORT_MEM_CAS_N_WIDTH                    = 0,
   parameter PORT_MEM_WE_N_WIDTH                     = 0,
   parameter PORT_MEM_DM_WIDTH                       = 0,
   parameter PORT_MEM_REF_N_WIDTH                    = 0,
   parameter PORT_MEM_WPS_N_WIDTH                    = 0,
   parameter PORT_MEM_RPS_N_WIDTH                    = 0,
   parameter PORT_MEM_BWS_N_WIDTH                    = 0,
   parameter PORT_MEM_DQA_WIDTH                      = 0,
   parameter PORT_MEM_DQB_WIDTH                      = 0,
   parameter PORT_MEM_Q_WIDTH                        = 0,
   parameter PORT_MEM_D_WIDTH                        = 0,
   parameter PORT_MEM_RWA_N_WIDTH                    = 0,
   parameter PORT_MEM_RWB_N_WIDTH                    = 0,
   parameter PORT_MEM_QKA_WIDTH                      = 0,
   parameter PORT_MEM_QKB_WIDTH                      = 0,
   parameter PORT_MEM_LDA_N_WIDTH                    = 0,
   parameter PORT_MEM_LDB_N_WIDTH                    = 0,
   parameter PORT_MEM_CK_WIDTH                       = 0,
   parameter PORT_MEM_DINVA_WIDTH                    = 0,
   parameter PORT_MEM_DINVB_WIDTH                    = 0,
   parameter PORT_MEM_AINV_WIDTH                     = 0,
   parameter DIAG_USE_ABSTRACT_PHY                   = 0,
   parameter DIAG_ABSTRACT_PHY_WLAT                  = 0,
   parameter DIAG_ABSTRACT_PHY_RLAT                  = 0,
   parameter ABPHY_WRITE_PROTOCOL                    = 1,
   parameter DIAG_SIM_MEM_BYPASS_DQ_WIDTH                     = 1,
   parameter DIAG_SIM_MEM_BYPASS_ADDR_WIDTH                   = 1,
   parameter PHY_CONFIG_ENUM                         = "",
   parameter MEM_ROW_ADDR_WIDTH                      = 0,
   parameter MEM_COL_ADDR_WIDTH                      = 0,
   parameter HMC_CFG_ADDR_ORDER                      = "",
   parameter HMC_CFG_CS_ADDR_WIDTH                   = "",
   parameter HMC_CFG_ROW_ADDR_WIDTH                  = ""
) (
   // Reset related
   input logic                                                                                   core2seq_reset_req,           // For abstract phy support
   
   // Signals for various signals from PLL
   input  logic                                                                                  pll_locked,                   // Indicates PLL lock status
   input  logic                                                                                  pll_dll_clk,                  // PLL -> DLL output clock
   input  logic [7:0]                                                                            phy_clk_phs,                  // FR PHY clock signals (8 phases, 45-deg apart)
   input  logic [1:0]                                                                            phy_clk,                      // {phy_clk[1], phy_clk[0]}
   input  logic                                                                                  phy_fb_clk_to_tile,           // PHY feedback clock (to tile)
   output logic                                                                                  phy_fb_clk_to_pll_abphy,      // PHY feedback clock (to PLL)

   // Core clock signals from/to the Clock Phase Alignment (CPA) block
   output logic [1:0]                                                                            core_clks_from_cpa_pri_abphy,      // Core clock signals from the CPA of primary interface
   output logic [1:0]                                                                            core_clks_locked_cpa_pri_abphy,    // Core clock locked signals from the CPA of primary interface
   input  logic [1:0]                                                                            core_clks_fb_to_cpa_pri,           // Core clock feedback signals to the CPA of primary interface
   output logic [1:0]                                                                            core_clks_from_cpa_sec_abphy,      // Core clock signals from the CPA of secondary interface (ping-pong only)
   output logic [1:0]                                                                            core_clks_locked_cpa_sec_abphy,    // Core clock locked signals from the CPA of secondary interface (ping-pong only)
   input  logic [1:0]                                                                            core_clks_fb_to_cpa_sec,           // Core clock feedback signals to the CPA of secondary interface (ping-pong only)

   // Avalon interfaces between core and HMC
   input  logic [62:0]                                                                           core2ctl_avl_0,
   input  logic [62:0]                                                                           core2ctl_avl_1,
   input  logic                                                                                  core2ctl_avl_rd_data_ready_0,
   input  logic                                                                                  core2ctl_avl_rd_data_ready_1,
   output logic                                                                                  ctl2core_avl_cmd_ready_0_abphy,
   output logic                                                                                  ctl2core_avl_cmd_ready_1_abphy,
   output logic [12:0]                                                                           ctl2core_avl_rdata_id_0_abphy,
   output logic [12:0]                                                                           ctl2core_avl_rdata_id_1_abphy,
   input  logic                                                                                  core2l_wr_data_vld_ast_0,
   input  logic                                                                                  core2l_wr_data_vld_ast_1,
   input  logic                                                                                  core2l_rd_data_rdy_ast_0,
   input  logic                                                                                  core2l_rd_data_rdy_ast_1,

   // Avalon interfaces between core and lanes
   output logic [NUM_OF_RTL_TILES-1:0][LANES_PER_TILE-1:0]                                       l2core_rd_data_vld_avl0_abphy,
   output logic [NUM_OF_RTL_TILES-1:0][LANES_PER_TILE-1:0]                                       l2core_wr_data_rdy_ast_abphy,

   // ECC signals between core and lanes
   input  logic [12:0]                                                                           core2l_wr_ecc_info_0,
   input  logic [12:0]                                                                           core2l_wr_ecc_info_1,
   output logic [NUM_OF_RTL_TILES-1:0][LANES_PER_TILE-1:0][11:0]                                 l2core_wb_pointer_for_ecc_abphy,

   // Signals between core and data lanes
   input  logic [NUM_OF_RTL_TILES-1:0][LANES_PER_TILE-1:0][PINS_PER_LANE * 8 - 1:0]              core2l_data,
   output logic [NUM_OF_RTL_TILES-1:0][LANES_PER_TILE-1:0][PINS_PER_LANE * 8 - 1:0]              l2core_data_abphy,
   input  logic [NUM_OF_RTL_TILES-1:0][LANES_PER_TILE-1:0][PINS_PER_LANE * 4 - 1:0]              core2l_oe,
   input  logic [NUM_OF_RTL_TILES-1:0][LANES_PER_TILE-1:0][3:0]                                  core2l_rdata_en_full,
   input  logic [NUM_OF_RTL_TILES-1:0][LANES_PER_TILE-1:0][15:0]                                 core2l_mrnk_read,
   input  logic [NUM_OF_RTL_TILES-1:0][LANES_PER_TILE-1:0][15:0]                                 core2l_mrnk_write,
   output logic [NUM_OF_RTL_TILES-1:0][LANES_PER_TILE-1:0][3:0]                                  l2core_rdata_valid_abphy,
   output logic [NUM_OF_RTL_TILES-1:0][LANES_PER_TILE-1:0][5:0]                                  l2core_afi_rlat_abphy,
   output logic [NUM_OF_RTL_TILES-1:0][LANES_PER_TILE-1:0][5:0]                                  l2core_afi_wlat_abphy,

   // AFI signals between tile and core
   input  [17:0]                                                                                 c2t_afi,
   output [26:0]                                                                                 t2c_afi_abphy,

   // Side-band signals between core and HMC
   input  logic [41:0]                                                                           core2ctl_sideband_0,
   output logic [13:0]                                                                           ctl2core_sideband_0_abphy,
   input  logic [41:0]                                                                           core2ctl_sideband_1,
   output logic [13:0]                                                                           ctl2core_sideband_1_abphy,

   // MMR signals between core and HMC
   output logic [33:0]                                                                           ctl2core_mmr_0_abphy,
   input  logic [50:0]                                                                           core2ctl_mmr_0,
   output logic [33:0]                                                                           ctl2core_mmr_1_abphy,
   input  logic [50:0]                                                                           core2ctl_mmr_1,

   // Signals between I/O buffers and lanes/tiles
   output logic [PINS_IN_RTL_TILES-1:0]                                                          l2b_data_abphy,            // lane-to-buffer data
   output logic [PINS_IN_RTL_TILES-1:0]                                                          l2b_oe_abphy,              // lane-to-buffer output-enable
   output logic [PINS_IN_RTL_TILES-1:0]                                                          l2b_dtc_abphy,             // lane-to-buffer dynamic-termination-control
   output logic [PINS_IN_RTL_TILES-1:0]                                                          l2b_e_a_abphy,             
   output logic [PINS_IN_RTL_TILES-1:0]                                                          l2b_e_b_abphy,             
   input  logic [PINS_IN_RTL_TILES-1:0]                                                          b2l_data,                  // buffer-to-lane data
   input  logic [LANES_IN_RTL_TILES-1:0]                                                         b2t_dqs,                   // buffer-to-tile DQS
   input  logic [LANES_IN_RTL_TILES-1:0]                                                         b2t_dqsb,                  // buffer-to-tile DQSb

   // Avalon-MM bus for the calibration commands between io_aux and tiles
   input  logic                                                                                  cal_bus_clk,
   input  logic                                                                                  cal_bus_avl_write,
   input  logic [19:0]                                                                           cal_bus_avl_address,
   input  logic [31:0]                                                                           cal_bus_avl_write_data,

   // Ports for internal test and debug
   input  logic                                                                                  pa_dprio_clk,
   input  logic                                                                                  pa_dprio_read,
   input  logic [PORT_DFT_ND_PA_DPRIO_REG_ADDR_WIDTH-1:0]                                        pa_dprio_reg_addr,
   input  logic                                                                                  pa_dprio_rst_n,
   input  logic                                                                                  pa_dprio_write,
   input  logic [PORT_DFT_ND_PA_DPRIO_WRITEDATA_WIDTH-1:0]                                       pa_dprio_writedata,
   output logic                                                                                  pa_dprio_block_select_abphy,
   output logic [PORT_DFT_ND_PA_DPRIO_READDATA_WIDTH-1:0]                                        pa_dprio_readdata_abphy,
   
   input logic                                                                                   afi_cal_success,
   output logic                                                                                  runAbstractPhySim
);
   timeunit 1ns;
   timeprecision 1ps;

   // Enum that defines whether a lane is used or not, and in what mode.
   // This enum type is used to encode the LANES_USAGE_MODE parameter
   // passed into the io_tiles module.
   typedef enum bit [2:0] {
      LANE_USAGE_UNUSED  = 3'b000,
      LANE_USAGE_AC_HMC  = 3'b001,
      LANE_USAGE_AC_CORE = 3'b010,
      LANE_USAGE_RDATA   = 3'b011,
      LANE_USAGE_WDATA   = 3'b100,
      LANE_USAGE_WRDATA  = 3'b101
   } LANE_USAGE;

   // Enum that defines whether a pin is used by EMIF
   // This enum type is used to encode the PINS_USAGE parameter
   // passed into the io_tiles module.
   typedef enum bit [0:0] {
      PIN_USAGE_UNUSED   = 1'b0,
      PIN_USAGE_USED     = 1'b1
   } PIN_USAGE;

   // Enum that defines whether an EMIF pin operates at SDR or DDR.
   // This enum type is used to encode the PINS_RATE parameter
   // passed into the io_tiles module.
   typedef enum bit [0:0] {
      PIN_RATE_DDR       = 1'b0,
      PIN_RATE_SDR       = 1'b1
   } PIN_RATE;

   // Enum that defines the direction of an EMIF pin.
   typedef enum bit [0:0] {
      PIN_OCT_STATIC_OFF = 1'b0,
      PIN_OCT_DYNAMIC    = 1'b1
   } PIN_OCT_MODE;

   // Enum that defines the write data buffer procedural mode of an EMIF pin.
   // This enum type is used to encode the DB_PINS_PROC_MODE parameter
   // passed into the io_tiles module.
   typedef enum bit [4:0] {
      DB_PIN_PROC_MODE_AC_CORE   = 5'b00000,
      DB_PIN_PROC_MODE_WDB_AC    = 5'b00001,
      DB_PIN_PROC_MODE_WDB_DQ    = 5'b00010,
      DB_PIN_PROC_MODE_WDB_DM    = 5'b00011,
      DB_PIN_PROC_MODE_WDB_CLK   = 5'b00100,
      DB_PIN_PROC_MODE_WDB_CLKB  = 5'b00101,
      DB_PIN_PROC_MODE_WDB_DQS   = 5'b00110,
      DB_PIN_PROC_MODE_WDB_DQSB  = 5'b00111,
      DB_PIN_PROC_MODE_DQS       = 5'b01000,
      DB_PIN_PROC_MODE_DQSB      = 5'b01001,
      DB_PIN_PROC_MODE_DQ        = 5'b01010,
      DB_PIN_PROC_MODE_DM        = 5'b01011,
      DB_PIN_PROC_MODE_DBI       = 5'b01100,
      DB_PIN_PROC_MODE_CLK       = 5'b01101,
      DB_PIN_PROC_MODE_CLKB      = 5'b01110,
      DB_PIN_PROC_MODE_DQS_DDR4  = 5'b01111,
      DB_PIN_PROC_MODE_DQSB_DDR4 = 5'b10000,
      DB_PIN_PROC_MODE_RDQ       = 5'b10001,
      DB_PIN_PROC_MODE_RDQS      = 5'b10010,
      DB_PIN_PROC_MODE_GPIO      = 5'b11111
   } DB_PIN_PROC_MODE;

   // Enum that defines the pin data in mode of an EMIF pin.
   // This enum type is used to encode the PINS_DATA_IN_MODE parameter
   // passed into the io_tiles module.
   typedef enum bit [2:0] {
      PIN_DATA_IN_MODE_DISABLED             = 3'b000,
      PIN_DATA_IN_MODE_SSTL_IN              = 3'b001,
      PIN_DATA_IN_MODE_LOOPBACK_IN          = 3'b010,
      PIN_DATA_IN_MODE_XOR_LOOPBACK_IN      = 3'b011,
      PIN_DATA_IN_MODE_DIFF_IN              = 3'b100,
      PIN_DATA_IN_MODE_DIFF_IN_AVL_OUT      = 3'b101,
      PIN_DATA_IN_MODE_DIFF_IN_X12_OUT      = 3'b110,
      PIN_DATA_IN_MODE_DIFF_IN_AVL_X12_OUT  = 3'b111
   } PIN_DATA_IN_MODE;

   // Is HMC rate converter or dual-port feature turned on?
   // This can be inferred from the clock rates at core/periphery boundary and in HMC.
   localparam USE_HMC_RC_OR_DP = (C2P_P2C_CLK_RATIO == PHY_HMC_CLK_RATIO) ? 0 : 1;

   // The phase alignment blocks have synchronization signals between them
   logic [(NUM_OF_RTL_TILES * (LANES_PER_TILE + 1)):0] pa_sync_data_up_chain;
   logic [(NUM_OF_RTL_TILES * (LANES_PER_TILE + 1)):0] pa_sync_data_dn_chain;
   logic [(NUM_OF_RTL_TILES * (LANES_PER_TILE + 1)):0] pa_sync_clk_up_chain;
   logic [(NUM_OF_RTL_TILES * (LANES_PER_TILE + 1)):0] pa_sync_clk_dn_chain;
   assign pa_sync_data_dn_chain[NUM_OF_RTL_TILES * (LANES_PER_TILE + 1)] = 1'b1;
   assign pa_sync_clk_dn_chain [NUM_OF_RTL_TILES * (LANES_PER_TILE + 1)] = 1'b1;
   assign pa_sync_data_up_chain[0] = 1'b1;
   assign pa_sync_clk_up_chain [0] = 1'b1;

   // The Avalon command bus signal daisy-chains one tile to another
   // from bottom-to-top starting from the I/O aux.
   
   // Avalon-MM bus for the calibration commands between io_aux and tiles
   wire                                                                                    cal_bus_clk_force;
   wire                                                                                    cal_bus_avl_read;
   wire                                                                                    cal_bus_avl_write_force;
   wire   [19:0]                                                                           cal_bus_avl_address_force;
   wire   [31:0]                                                                           cal_bus_avl_read_data;
   wire   [31:0]                                                                           cal_bus_avl_write_data_force;
   
   assign cal_bus_avl_read = 'd0;
   assign cal_bus_avl_read_data = 'd0;
   
   logic [(NUM_OF_RTL_TILES * (LANES_PER_TILE + 1)):0][54:0] cal_bus_avl_up_chain;
   assign cal_bus_avl_up_chain[0][19:0]  = cal_bus_avl_address_force;
   assign cal_bus_avl_up_chain[0][51:20] = cal_bus_avl_write_data_force;
   assign cal_bus_avl_up_chain[0][52]    = cal_bus_avl_write_force;
   assign cal_bus_avl_up_chain[0][53]    = cal_bus_avl_read;
   assign cal_bus_avl_up_chain[0][54]    = cal_bus_clk_force;

   // The Avalon read data signal daisy-chains one tile to another
   // from top-to-bottom ending at the I/O aux.
   logic [(NUM_OF_RTL_TILES * (LANES_PER_TILE + 1)):0][31:0] cal_bus_avl_read_data_dn_chain;
   assign cal_bus_avl_read_data_dn_chain[NUM_OF_RTL_TILES * (LANES_PER_TILE + 1)] = 32'b0;

   // Broadcast signals that daisy-chain all lanes in upward and downward directions.
   logic [(NUM_OF_RTL_TILES * LANES_PER_TILE):0][1:0] broadcast_up_chain;
   logic [(NUM_OF_RTL_TILES * LANES_PER_TILE):0][1:0] broadcast_dn_chain;
   assign broadcast_dn_chain[NUM_OF_RTL_TILES * LANES_PER_TILE] = 2'b11;
   assign broadcast_up_chain[0] = 2'b11;

   // HMC-to-DBC signals going from tiles to lanes and between tiles
   logic [NUM_OF_RTL_TILES:0][50:0] all_tiles_ctl2dbc0_dn_chain;
   logic [NUM_OF_RTL_TILES:0][50:0] all_tiles_ctl2dbc1_up_chain;
   assign all_tiles_ctl2dbc0_dn_chain[NUM_OF_RTL_TILES] = {51{1'b1}};
   assign all_tiles_ctl2dbc1_up_chain[0] = {51{1'b1}};

   // Ping-Pong signals going up the column
   logic [NUM_OF_RTL_TILES:0][50:0] all_tiles_ping_pong_up_chain;
   assign all_tiles_ping_pong_up_chain[0] = {50{1'b1}};

   // PHY clock signals going from tiles to lanes
   logic [NUM_OF_RTL_TILES-1:0][LANES_PER_TILE-1:0][7:0] all_tiles_t2l_phy_clk_phs;
   logic [NUM_OF_RTL_TILES-1:0][LANES_PER_TILE-1:0][1:0] all_tiles_t2l_phy_clk;

   // DLL clock from tile_ctrl to lanes
   logic [NUM_OF_RTL_TILES-1:0][LANES_PER_TILE-1:0] all_tiles_dll_clk_out;

   // Outputs from the CPA inside each tile
   // In the following arrays, only elements at tile index PRI_AC_TILE_INDEX, corresponding to the addr/cmd tile, are used
   // In ping-pong configuration, the CPA inside the primary HMC tile is used, hence no need to account for secondary tile
   logic [NUM_OF_RTL_TILES-1:0][1:0] all_tiles_core_clks_out;
   logic [NUM_OF_RTL_TILES-1:0][1:0] all_tiles_core_clks_fb_in;
   logic [NUM_OF_RTL_TILES-1:0][1:0] all_tiles_core_clks_locked;

   assign core_clks_from_cpa_pri_abphy = all_tiles_core_clks_out[PRI_AC_TILE_INDEX];
   assign core_clks_locked_cpa_pri_abphy = all_tiles_core_clks_locked[PRI_AC_TILE_INDEX];
   assign all_tiles_core_clks_fb_in[PRI_AC_TILE_INDEX] = core_clks_fb_to_cpa_pri;

   assign core_clks_from_cpa_sec_abphy = PHY_PING_PONG_EN ? all_tiles_core_clks_out[SEC_AC_TILE_INDEX] : '0;
   assign core_clks_locked_cpa_sec_abphy = PHY_PING_PONG_EN ? all_tiles_core_clks_locked[SEC_AC_TILE_INDEX] : '0;
   generate
      if (PHY_PING_PONG_EN) begin
         assign all_tiles_core_clks_fb_in[SEC_AC_TILE_INDEX] = core_clks_fb_to_cpa_sec;
      end
   endgenerate

   // Outputs from PHY clock tree back to PLL
   // Physically, this connection needs to happen in every tile but
   // in RTL we only make this connection for the A/C tile (since we
   // only have one logical PLL)
   logic [NUM_OF_RTL_TILES-1:0] all_tiles_phy_fb_clk_to_pll;
   assign phy_fb_clk_to_pll_abphy = all_tiles_phy_fb_clk_to_pll[PRI_AC_TILE_INDEX];

   // Avalon signals between HMC and core
   // In the following arrays, only elements at tile index *_AC_TILE_INDEX, corresponding to the addr/cmd tile, are used
   logic [NUM_OF_RTL_TILES-1:0]       all_tiles_ctl2core_avl_cmd_ready;
   logic [NUM_OF_RTL_TILES-1:0][12:0] all_tiles_ctl2core_avl_rdata_id;

   assign ctl2core_avl_cmd_ready_0_abphy = all_tiles_ctl2core_avl_cmd_ready[PRI_AC_TILE_INDEX];
   assign ctl2core_avl_rdata_id_0_abphy  = all_tiles_ctl2core_avl_rdata_id[PRI_AC_TILE_INDEX];

   assign ctl2core_avl_cmd_ready_1_abphy = all_tiles_ctl2core_avl_cmd_ready[SEC_AC_TILE_INDEX];
   assign ctl2core_avl_rdata_id_1_abphy  = all_tiles_ctl2core_avl_rdata_id[SEC_AC_TILE_INDEX];

   // AFI signals between tile and core
   // In the following arrays, only elements at tile index PRI_AC_TILE_INDEX, corresponding to the addr/cmd tile, are used
   // Ping-Pong PHY doesn't support AFI interface so there's no need to account for SEC_AC_TILE_INDEX
   logic [NUM_OF_RTL_TILES-1:0][17:0] all_tiles_c2t_afi;
   logic [NUM_OF_RTL_TILES-1:0][26:0] all_tiles_t2c_afi;

   assign all_tiles_c2t_afi[PRI_AC_TILE_INDEX] = c2t_afi;
   assign t2c_afi_abphy = all_tiles_t2c_afi[PRI_AC_TILE_INDEX];

   // Sideband signals between HMC and core
   // In the following arrays, only elements at tile index *_AC_TILE_INDEX, corresponding to the addr/cmd tile, are used
   logic [NUM_OF_RTL_TILES-1:0][13:0] all_tiles_ctl2core_sideband;

   assign ctl2core_sideband_0_abphy = all_tiles_ctl2core_sideband[PRI_AC_TILE_INDEX];
   assign ctl2core_sideband_1_abphy = all_tiles_ctl2core_sideband[SEC_AC_TILE_INDEX];

   // MMR signals between HMC and core
   // In the following arrays, only elements at tile index *_AC_TILE_INDEX, corresponding to the addr/cmd tile, are used
   logic [NUM_OF_RTL_TILES-1:0][33:0] all_tiles_ctl2core_mmr;

   assign ctl2core_mmr_0_abphy = all_tiles_ctl2core_mmr[PRI_AC_TILE_INDEX];
   assign ctl2core_mmr_1_abphy = all_tiles_ctl2core_mmr[SEC_AC_TILE_INDEX];

   // CPA DPRIO signals (for internal debug)
   // In the following arrays, only elements at tile index PRI_AC_TILE_INDEX, corresponding to the addr/cmd tile, are used
   logic [NUM_OF_RTL_TILES-1:0]                                          all_tiles_pa_dprio_block_select;
   logic [NUM_OF_RTL_TILES-1:0][PORT_DFT_ND_PA_DPRIO_READDATA_WIDTH-1:0] all_tiles_pa_dprio_readdata;

   assign pa_dprio_readdata_abphy = all_tiles_pa_dprio_readdata[PRI_AC_TILE_INDEX];
   assign pa_dprio_block_select_abphy = all_tiles_pa_dprio_block_select[PRI_AC_TILE_INDEX];

   localparam QDR4_CTRL_AFI_WLAT_WIDTH = ((USER_CLK_RATIO == 4) ? 2 : ((USER_CLK_RATIO == 2) ? 3 : 4));

   wire      [96*NUM_OF_RTL_TILES*LANES_PER_TILE-1:0]                          ac_hmc_par;        
   wire      [96*NUM_OF_RTL_TILES*LANES_PER_TILE-1:0]                          dq_data_to_mem;       
   wire      [96*NUM_OF_RTL_TILES*LANES_PER_TILE-1:0]                          dq_data_from_mem;     
   wire      [3:0]                                                             rdata_valid_local [NUM_OF_RTL_TILES-1:0][LANES_PER_TILE-1:0];
   wire      [48*NUM_OF_RTL_TILES*LANES_PER_TILE-1:0]                          dq_oe;

   integer                                                                     add_2 [NUM_OF_RTL_TILES-1:0][LANES_PER_TILE-1:0];

`define _abphy_get_pin_index(_loc, _port_i) ( _loc[ (_port_i + 1) * 10 +: 10 ] )
`define _abphy_get_tile(_loc, _port_i) (  `_abphy_get_pin_index(_loc, _port_i) / (PINS_PER_LANE * LANES_PER_TILE) )
`define _abphy_get_lane(_loc, _port_i) ( (`_abphy_get_pin_index(_loc, _port_i) / PINS_PER_LANE) % LANES_PER_TILE ) 
   
   // synthesis translate_off
   initial begin
     runAbstractPhySim  = 1;
     if (DIAG_USE_ABSTRACT_PHY == 1) begin : force_reset
       force core2seq_reset_req = 1;
       #95;
       force core2seq_reset_req = 0;
       #95;
       release core2seq_reset_req;
     end
   end
   
   reg afi_cal_success_delay;
   initial begin
     afi_cal_success_delay = 0;
     @ ( posedge afi_cal_success );
     repeat (20) @ ( posedge cal_bus_clk );
     afi_cal_success_delay = 1;
   end
   
   integer min_wlat,wlat,wlat_offset,rlat,qdr4_ctrl_wlat_msb;
   initial begin
     
     @ (negedge core2seq_reset_req);
     if ( core2seq_reset_req !==1'b0 )
       @ (negedge core2seq_reset_req);
     min_wlat              = 2;

     if ( NUM_OF_HMC_PORTS>0 ) begin
       if ( SEC_AC_TILE_INDEX>-1 ) begin
         if ( ((NUM_OF_RTL_TILES+1)-SEC_AC_TILE_INDEX)>min_wlat ) begin
           min_wlat       = (NUM_OF_RTL_TILES+1)-SEC_AC_TILE_INDEX;
         end
         if ( (SEC_AC_TILE_INDEX+1)>min_wlat ) begin
           min_wlat       = SEC_AC_TILE_INDEX+1;
         end
       end
       if ( ((NUM_OF_RTL_TILES+1)-PRI_AC_TILE_INDEX)>min_wlat ) begin
         min_wlat         = (NUM_OF_RTL_TILES+1)-PRI_AC_TILE_INDEX;
       end
       if ( (PRI_AC_TILE_INDEX+1)>min_wlat ) begin
         min_wlat         = PRI_AC_TILE_INDEX+1;
       end
     end

     if ( DIAG_ABSTRACT_PHY_WLAT<min_wlat ) begin
       wlat             = min_wlat;
     end
     else begin
       wlat             = DIAG_ABSTRACT_PHY_WLAT;;
     end
     rlat               = DIAG_ABSTRACT_PHY_RLAT;;
     if ( rlat<(wlat+6) ) 
       rlat             = wlat+6;

     wlat             = wlat + 1;
     
     if (PROTOCOL_ENUM == "PROTOCOL_QDR4") begin
       assert (wlat >> QDR4_CTRL_AFI_WLAT_WIDTH == 0) else $fatal(1, "Abstract PHY write latency (%d) for QDR-IV exceeds signal width", wlat);
       qdr4_ctrl_wlat_msb = (wlat >> (QDR4_CTRL_AFI_WLAT_WIDTH-1)) & 1;
       if ( qdr4_ctrl_wlat_msb==1 )
         wlat             = (1 << (QDR4_CTRL_AFI_WLAT_WIDTH-1)) - 1;
     end
     else if (PROTOCOL_ENUM == "PROTOCOL_QDR2" && wlat>3)
       wlat             = 3;

     if ( MEM_ABPHY_VERBOSE!=0 ) $display("AbPHY:  Minimum Write Latency  = %1d", min_wlat);
     if ( MEM_ABPHY_VERBOSE!=0 ) $display("AbPHY:  Write Latency          = %1d", wlat);
     if ( MEM_ABPHY_VERBOSE!=0 ) $display("AbPHY:  Read Latency           = %1d", rlat);
   end
   
   ////////////////////////////////////////////////////////////////////////////
   // Generate tiles and lanes.
   ////////////////////////////////////////////////////////////////////////////
   generate
      genvar tile_i, lane_i;
      for (tile_i = 0; tile_i < NUM_OF_RTL_TILES; ++tile_i)
      begin: tile_gen

         // DQS bus from tile to lanes
         logic [1:0]       t2l_dqsbus_x4 [LANES_PER_TILE-1:0];
         logic [1:0]       t2l_dqsbus_x8 [LANES_PER_TILE-1:0];
         logic [1:0]       t2l_dqsbus_x18 [LANES_PER_TILE-1:0];
         logic [1:0]       t2l_dqsbus_x36 [LANES_PER_TILE-1:0];

         // HMC AFI signals going to lanes.
         logic [3:0][95:0] t2l_ac_hmc;

         // HMC to Data buffer control blocks in the lanes
         logic [17:0]      t2l_cfg_dbc [LANES_PER_TILE-1:0];

         fourteennm_tile_ctrl # (
            .silicon_rev                              (SILICON_REV),
            .hps_ctrl_en                              (IS_HPS ? "hps_ctrl_en" : "hps_ctrl_dis"),
            .pa_filter_code                           (`_get_pa_filter_code),
            .pa_phase_offset_0                        (12'b0),                                             // Output clock phase degree = phase_offset / 128 * 360
            .pa_phase_offset_1                        (12'b0),                                             // Output clock phase degree = phase_offset / 128 * 360
            .pa_exponent_0                            (`_get_pa_exponent_0),                               // Output clock freq = VCO Freq / 2^exponent
            .pa_exponent_1                            (`_get_pa_exponent_1),                               // Output clock freq = VCO Freq / 2^exponent
            .pa_feedback_divider_c0                   (`_get_pa_feedback_divider_c0),                      // Core clock 0 divider (either 1 or 2)
            .pa_feedback_divider_c1                   ("div_by_1"),                                        // Core clock 1 divider (always 1)
            .pa_feedback_divider_p0                   (`_get_pa_feedback_divider_p0),                      // PHY clock 0 divider (either 1 or 2)
            .pa_feedback_divider_p1                   ("div_by_1"),                                        // PHY clock 1 divider (always 1)
            .pa_feedback_mux_sel_0                    ("fb2_p_clk"),                                       // Use phy_clk[2] as feedback
            .pa_feedback_mux_sel_1                    (DIAG_CPA_OUT_1_EN ? "fb0_p_clk" : "fb2_p_clk"),     // Use phy_clk[2] as feedback, unless in dual-CPA characterization mode
            .pa_freq_track_speed                      (4'hd),
            .pa_track_speed                           (`_get_pa_track_speed),
            .pa_sync_control                          ("no_sync"),
            .pa_sync_latency                          (4'b0000),
            .pa_coreclk_override                      ("non_override"),                                    // Override mechanism to use test clock as input
            .pa_couple_enable                         ("couple_en"),
            .pa_dprio_base_addr                       (9'b000000000),
            .pa_hps_clk_en                            (IS_HPS ? "fb_clk_hps" : "fb_clk_core"),             // HPS or not?
            .physeq_tile_id                           (`_get_center_tid(tile_i)),                          // io_center tile ID - actual value is set by fitter based on placement
            .physeq_bc_id_ena                         ("bc_enable"),                                       // Enable broadcast mechanism
            .physeq_avl_ena                           ("avl_enable"),                                      // Enable Avalon interface
            .physeq_hmc_or_core                       (`_get_hmc_or_core),                                 // Is HMC used?
            .physeq_trk_mgr_mrnk_mode                 ("one_rank"),
            .physeq_trk_mgr_read_monitor_ena          ("disable"),                                         // Must be disabled to avoid an issue with tracking manager (ICD)
            .physeq_hmc_id                            (`_get_hmc_tid(tile_i)),                             // HMC tile ID - actual value is set by fitter based on placement
            .physeq_reset_auto_release                (DIAG_SEQ_RESET_AUTO_RELEASE),                       // Reset sequencer controlled via Avalon by Nios
            .physeq_rwlat_mode                        ("avl_vlu"),                                         // wlat/rlat set dynamically via Avalon by Nios (instead of through CSR)
            .physeq_afi_rlat_vlu                      (6'b000000),                                         // Unused - wlat set dynamically via Avalon by Nios
            .physeq_afi_wlat_vlu                      (6'b000000),                                         // Unused - rlat set dynamically via Avalon by Nios
            .physeq_core_clk_sel                      (USE_HMC_RC_OR_DP ? "clk1" : "clk0"),                // Use clk1 in rate-converter or dual-port mode, and clk0 otherwise
            .physeq_seq_feature                       (21'b000000000000000000000),
            .hmc_tile_id                              (tile_i[4:0]),                                       // HMC ID (0 for T0, 1 for T1, etc) - actual value set by Fitter based on placement
            .hmc_mem_type                             (`_get_hmc_ctrl_mem_type),
            .hmc_dimm_type                            (HMC_CTRL_DIMM_TYPE),
            .hmc_ac_pos                               (AC_PIN_MAP_SCHEME),
            .hmc_ctrl_burst_length                    (`_get_hmc_burst_length),
            .hmc_dbc0_burst_length                    (`_get_hmc_burst_length),
            .hmc_dbc1_burst_length                    (`_get_hmc_burst_length),
            .hmc_dbc2_burst_length                    (`_get_hmc_burst_length),
            .hmc_dbc3_burst_length                    (`_get_hmc_burst_length),
            .hmc_ctrl_enable_dm                       (MEM_DATA_MASK_EN ? "enable" : "disable"),
            .hmc_dbc0_enable_dm                       (MEM_DATA_MASK_EN ? "enable" : "disable"),
            .hmc_dbc1_enable_dm                       (MEM_DATA_MASK_EN ? "enable" : "disable"),
            .hmc_dbc2_enable_dm                       (MEM_DATA_MASK_EN ? "enable" : "disable"),
            .hmc_dbc3_enable_dm                       (MEM_DATA_MASK_EN ? "enable" : "disable"),
            .hmc_ctrl_output_regd                     ("disable"),                                     // Engineering option. Unused.
            .hmc_dbc0_output_regd                     ("disable"),                                     // Engineering option. Unused.
            .hmc_dbc1_output_regd                     ("disable"),                                     // Engineering option. Unused.
            .hmc_dbc2_output_regd                     ("disable"),                                     // Engineering option. Unused.
            .hmc_dbc3_output_regd                     ("disable"),                                     // Engineering option. Unused.
            .hmc_ctrl2dbc_switch0                     (`_get_ctrl2dbc_switch_0(tile_i)),
            .hmc_ctrl2dbc_switch1                     (`_get_ctrl2dbc_switch_1(tile_i)),
            .hmc_dbc0_ctrl_sel                        (`_get_ctrl2dbc_sel_0(tile_i)),
            .hmc_dbc1_ctrl_sel                        (`_get_ctrl2dbc_sel_1(tile_i)),
            .hmc_dbc2_ctrl_sel                        (`_get_ctrl2dbc_sel_2(tile_i)),
            .hmc_dbc3_ctrl_sel                        (`_get_ctrl2dbc_sel_3(tile_i)),
            .hmc_dbc2ctrl_sel                         (`_get_hmc_dbc2ctrl_sel(tile_i)),
            .hmc_dbc0_pipe_lat                        (3'(`_get_dbc_pipe_lat(tile_i, 0))),
            .hmc_dbc1_pipe_lat                        (3'(`_get_dbc_pipe_lat(tile_i, 1))),
            .hmc_dbc2_pipe_lat                        (3'(`_get_dbc_pipe_lat(tile_i, 2))),
            .hmc_dbc3_pipe_lat                        (3'(`_get_dbc_pipe_lat(tile_i, 3))),
            .hmc_ctrl_cmd_rate                        (`_get_hmc_cmd_rate),
            .hmc_dbc0_cmd_rate                        (`_get_dbc0_cmd_rate),
            .hmc_dbc1_cmd_rate                        (`_get_dbc1_cmd_rate),
            .hmc_dbc2_cmd_rate                        (`_get_dbc2_cmd_rate),
            .hmc_dbc3_cmd_rate                        (`_get_dbc3_cmd_rate),
            .hmc_ctrl_in_protocol                     (`_get_hmc_protocol),
            .hmc_dbc0_in_protocol                     (`_get_dbc0_protocol),
            .hmc_dbc1_in_protocol                     (`_get_dbc1_protocol),
            .hmc_dbc2_in_protocol                     (`_get_dbc2_protocol),
            .hmc_dbc3_in_protocol                     (`_get_dbc3_protocol),
            .hmc_ctrl_dualport_en                     ("disable"),                                               // No dual-port mode support
            .hmc_dbc0_dualport_en                     ("disable"),                                               // No dual-port mode support
            .hmc_dbc1_dualport_en                     ("disable"),                                               // No dual-port mode support
            .hmc_dbc2_dualport_en                     ("disable"),                                               // No dual-port mode support
            .hmc_dbc3_dualport_en                     ("disable"),                                               // No dual-port mode support
            .hmc_ctl_width_ratio                      (PHY_HMC_CLK_RATIO == 2 ? 32'd4 : 32'd8),                  // Virtual setting. Unused
            .hmc_ac_tile_reg_ena                      ("disable"),                                               // Intended for hard circuitry timing closure, but currently not necessary
            .hmc_arbiter_reg_ena                      ("disable"),                                               // Unused
            .hmc_ctl2dbc_reg_ena                      ("disable"),                                               // Unused
            .hmc_ctl2dbc_tile_reg_ena                 ("disable"),                                               // Intended for hard circuitry timing closure, but currently not necessary
            .hmc_rb_ptr_reg_ena                       ("disable"),                                               // Intended for hard circuitry timing closure, but currently not necessary
            .hmc_wb_ptr_reg_ena                       ("disable"),                                               // Intended for hard circuitry timing closure, but currently not necessary
            .hmc_avl_scg_en                           ("disable"),                                               // Static clock gating
            .hmc_dbc_sw_scg_en                        ("disable"),                                               // Static clock gating
            .hmc_core_scg_en                          ("disable"),                                               // Static clock gating
            .hmc_dbg_scg_en                           ("disable"),                                               // Static clock gating
            .hmc_scg_en                               ("disable"),                                               // Static clock gating
            .hmc_mmr_scg_en                           ("disable"),                                               // Static clock gating
            .hmc_pipe_scg_en                          ("disable"),                                               // Static clock gating
            .hmc_seq_scg_en                           ("disable"),                                               // Static clock gating
            .hmc_powermode_ac                         (tile_i == PRI_AC_TILE_INDEX ? "ac_tile" : "data_tile"),   //
            .hmc_powermode_dc                         ("powerup"),                                               // Power-up this HMC
            .hmc_ck_inv                               ("disable"),
            .hmc_wdata_driver_sel                     ("disable"),
            .hmc_prbs_ctrl_sel                        ("disable"),
            .hmc_loopback_en                          ("disable"),
            .hmc_cmd_driver_sel                       ("disable"),
            .hmc_dbg_ctrl                             (32'b00000000000000000000000000000000),
            .hmc_dbg_mode                             (4'b0000),
            .hmc_dbg_out_sel                          (16'b0000000000000000),
            .hmc_bist_cmd0_u                          (32'b00000000000000000000000000000000),
            .hmc_bist_cmd0_l                          (32'b00000000000000000000000000000000),
            .hmc_bist_cmd1_u                          (32'b00000000000000000000000000000000),
            .hmc_bist_cmd1_l                          (32'b00000000000000000000000000000000),
            .hmc_dfx_bypass_en                        ("disable"),
            .hmc_self_rfsh_dqstrk_en                  ("disable"),
            .cfg_cb_3ds_mixed_height_ref_ack_disable  ("disable"),                         // Set to 0 (same as "disable") to enable fix (case:384958)
            .cfg_cb_3ds_mixed_height_req_fix          ("disable"),                         // Set to 0 (same as "disable") to enable fix (case:384958)
            .hmc_cb_seq_en_fix_en_n                   ("enable"),                          // Set to 0 (same as "enable") to enable fix  (case:384958)
            .hmc_cb_tbp_reload_fix_en_n               (`_get_hmc_cb_tbp_reload_fix_en_n),  
            .cfg_cb_memclk_gate_default               ("disable"),                         // Set to 0 (same as "disable") to enable fix (case:384958)
            .cfg_cb_en_cmd_valid_ungate_fix           ("enable"),                          // Set to 1 (same as "enable") to enable fix  (case:384958)
            .cfg_cb_en_mrnk_rd_fix                    ("enable"),                          // Set to 1 (same as "enable") to enable fix  (case:384958)
            .cfg_cb_pdqs_perf_fix_disable             ("disable"),                         // Set to 0 (same as "disable") to enable fix (case:384958)
            
            .hmc_pingpong_mode                (`_sel_hmc_default(tile_i, PRI_HMC_CFG_PING_PONG_MODE        , SEC_HMC_CFG_PING_PONG_MODE ,"pingpong_off")),  // Ping-Pong PHY mode
            .hmc_cs_addr_width                (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_CS_ADDR_WIDTH            , SEC_HMC_CFG_CS_ADDR_WIDTH                 )),  // Address width in bits required to access every CS in interface
            .hmc_col_addr_width               (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_COL_ADDR_WIDTH           , SEC_HMC_CFG_COL_ADDR_WIDTH                )),  // Column address width
            .hmc_row_addr_width               (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_ROW_ADDR_WIDTH           , SEC_HMC_CFG_ROW_ADDR_WIDTH                )),  // Row address width
            .hmc_bank_addr_width              (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_BANK_ADDR_WIDTH          , SEC_HMC_CFG_BANK_ADDR_WIDTH               )),  // Bank address width
            .hmc_bank_group_addr_width        (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_BANK_GROUP_ADDR_WIDTH    , SEC_HMC_CFG_BANK_GROUP_ADDR_WIDTH         )),  // Bank group address width
            .hmc_addr_order                   (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_ADDR_ORDER               , SEC_HMC_CFG_ADDR_ORDER                    )),  // Mapping of Avalon address to physical address of the memory device
            .hmc_arbiter_type                 (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_ARBITER_TYPE             , SEC_HMC_CFG_ARBITER_TYPE                  )),  // Arbiter Type
            .hmc_open_page_en                 (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_OPEN_PAGE_EN             , SEC_HMC_CFG_OPEN_PAGE_EN                  )),  // Unused
            .hmc_ctrl_rc_en                   (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_CTRL_ENABLE_RC           , SEC_HMC_CFG_CTRL_ENABLE_RC                )),  // Enable rate-conversion feature
            .hmc_dbc0_rc_en                   (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_DBC0_ENABLE_RC           , SEC_HMC_CFG_DBC0_ENABLE_RC                )),  // Enable rate-conversion feature
            .hmc_dbc1_rc_en                   (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_DBC1_ENABLE_RC           , SEC_HMC_CFG_DBC1_ENABLE_RC                )),  // Enable rate-conversion feature
            .hmc_dbc2_rc_en                   (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_DBC2_ENABLE_RC           , SEC_HMC_CFG_DBC2_ENABLE_RC                )),  // Enable rate-conversion feature
            .hmc_dbc3_rc_en                   (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_DBC3_ENABLE_RC           , SEC_HMC_CFG_DBC3_ENABLE_RC                )),  // Enable rate-conversion feature
            .hmc_ctrl_enable_ecc              (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_CTRL_ENABLE_ECC          , SEC_HMC_CFG_CTRL_ENABLE_ECC               )),  // Enable ECC
            .hmc_dbc0_enable_ecc              (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_DBC0_ENABLE_ECC          , SEC_HMC_CFG_DBC0_ENABLE_ECC               )),  // Enable ECC
            .hmc_dbc1_enable_ecc              (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_DBC1_ENABLE_ECC          , SEC_HMC_CFG_DBC1_ENABLE_ECC               )),  // Enable ECC
            .hmc_dbc2_enable_ecc              (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_DBC2_ENABLE_ECC          , SEC_HMC_CFG_DBC2_ENABLE_ECC               )),  // Enable ECC
            .hmc_dbc3_enable_ecc              (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_DBC3_ENABLE_ECC          , SEC_HMC_CFG_DBC3_ENABLE_ECC               )),  // Enable ECC
            .hmc_reorder_data                 (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_REORDER_DATA             , SEC_HMC_CFG_REORDER_DATA                  )),  // Enable command reodering
            .hmc_reorder_read                 (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_REORDER_READ             , SEC_HMC_CFG_REORDER_READ                  )),  // Enable read command reordering if command reordering is enabled
            .hmc_ctrl_reorder_rdata           (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_CTRL_REORDER_RDATA       , SEC_HMC_CFG_CTRL_REORDER_RDATA            )),  // Enable in-order read data return when read command reordering is enabled
            .hmc_dbc0_reorder_rdata           (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_DBC0_REORDER_RDATA       , SEC_HMC_CFG_DBC0_REORDER_RDATA            )),  // Enable in-order read data return when read command reordering is enabled
            .hmc_dbc1_reorder_rdata           (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_DBC1_REORDER_RDATA       , SEC_HMC_CFG_DBC1_REORDER_RDATA            )),  // Enable in-order read data return when read command reordering is enabled
            .hmc_dbc2_reorder_rdata           (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_DBC2_REORDER_RDATA       , SEC_HMC_CFG_DBC2_REORDER_RDATA            )),  // Enable in-order read data return when read command reordering is enabled
            .hmc_dbc3_reorder_rdata           (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_DBC3_REORDER_RDATA       , SEC_HMC_CFG_DBC3_REORDER_RDATA            )),  // Enable in-order read data return when read command reordering is enabled
            .hmc_ctrl_slot_offset             (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_CTRL_SLOT_OFFSET         , SEC_HMC_CFG_CTRL_SLOT_OFFSET              )),  // Command slot offset
            .hmc_dbc0_slot_offset             (`_sel_hmc_lane(tile_i, 0, PRI_HMC_CFG_DBC0_SLOT_OFFSET      , SEC_HMC_CFG_DBC0_SLOT_OFFSET              )),  // Command slot offset
            .hmc_dbc1_slot_offset             (`_sel_hmc_lane(tile_i, 1, PRI_HMC_CFG_DBC1_SLOT_OFFSET      , SEC_HMC_CFG_DBC1_SLOT_OFFSET              )),  // Command slot offset
            .hmc_dbc2_slot_offset             (`_sel_hmc_lane(tile_i, 2, PRI_HMC_CFG_DBC2_SLOT_OFFSET      , SEC_HMC_CFG_DBC2_SLOT_OFFSET              )),  // Command slot offset
            .hmc_dbc3_slot_offset             (`_sel_hmc_lane(tile_i, 3, PRI_HMC_CFG_DBC3_SLOT_OFFSET      , SEC_HMC_CFG_DBC3_SLOT_OFFSET              )),  // Command slot offset
            .hmc_ctrl_slot_rotate_en          (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_CTRL_SLOT_ROTATE_EN      , SEC_HMC_CFG_CTRL_SLOT_ROTATE_EN           )),  // Command slot rotation
            .hmc_dbc0_slot_rotate_en          (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_DBC0_SLOT_ROTATE_EN      , SEC_HMC_CFG_DBC0_SLOT_ROTATE_EN           )),  // Command slot rotation
            .hmc_dbc1_slot_rotate_en          (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_DBC1_SLOT_ROTATE_EN      , SEC_HMC_CFG_DBC1_SLOT_ROTATE_EN           )),  // Command slot rotation
            .hmc_dbc2_slot_rotate_en          (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_DBC2_SLOT_ROTATE_EN      , SEC_HMC_CFG_DBC2_SLOT_ROTATE_EN           )),  // Command slot rotation
            .hmc_dbc3_slot_rotate_en          (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_DBC3_SLOT_ROTATE_EN      , SEC_HMC_CFG_DBC3_SLOT_ROTATE_EN           )),  // Command slot rotation
            .hmc_col_cmd_slot                 (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_COL_CMD_SLOT             , SEC_HMC_CFG_COL_CMD_SLOT                  )),  // Command slot for column commands
            .hmc_row_cmd_slot                 (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_ROW_CMD_SLOT             , SEC_HMC_CFG_ROW_CMD_SLOT                  )),  // Command slot for row commands
            .hmc_row_to_col_offset            (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_ROW_TO_COL_OFFSET        , SEC_HMC_CFG_ROW_TO_COL_OFFSET             )),  // Command slot offset from row to col command
            .hmc_row_to_row_offset            (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_ROW_TO_ROW_OFFSET        , SEC_HMC_CFG_ROW_TO_ROW_OFFSET             )),  // Command slot offset from row to row command
            .hmc_col_to_col_offset            (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_COL_TO_COL_OFFSET        , SEC_HMC_CFG_COL_TO_COL_OFFSET             )),  // Command slot offset from col to col command
            .hmc_col_to_diff_col_offset       (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_COL_TO_DIFF_COL_OFFSET   , SEC_HMC_CFG_COL_TO_DIFF_COL_OFFSET        )),  // Command slot offset from col to col command (different columns)
            .hmc_col_to_row_offset            (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_COL_TO_ROW_OFFSET        , SEC_HMC_CFG_COL_TO_ROW_OFFSET             )),  // Command slot offset from col to row command
            .hmc_sideband_offset              (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_SIDEBAND_OFFSET          , SEC_HMC_CFG_SIDEBAND_OFFSET               )),  // Command slot offset for sideband commands
            .hmc_cs_chip                      (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_CS_TO_CHIP_MAPPING       , SEC_HMC_CFG_CS_TO_CHIP_MAPPING            )),  // Chip select mapping scheme
            .hmc_ctl_odt_enabled              (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_CTL_ODT_ENABLED          , SEC_HMC_CFG_CTL_ODT_ENABLED               )),  // ODT enabled
            .hmc_rd_odt_on                    (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_RD_ODT_ON                , SEC_HMC_CFG_RD_ODT_ON                     )),  // Indicates number of memory clock cycle gap between read command and ODT signal rising edge
            .hmc_rd_odt_period                (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_RD_ODT_PERIOD            , SEC_HMC_CFG_RD_ODT_PERIOD                 )),  // Indicates number of memory clock cycle read ODT signal should stay asserted after rising edge
            .hmc_read_odt_chip                (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_READ_ODT_CHIP            , SEC_HMC_CFG_READ_ODT_CHIP                 )),  // ODT scheme setting for read command
            .hmc_wr_odt_on                    (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_WR_ODT_ON                , SEC_HMC_CFG_WR_ODT_ON                     )),  // Indicates number of memory clock cycle gap between write command and ODT signal rising edge
            .hmc_wr_odt_period                (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_WR_ODT_PERIOD            , SEC_HMC_CFG_WR_ODT_PERIOD                 )),  // Indicates number of memory clock cycle write ODT signal should stay asserted after rising edge
            .hmc_write_odt_chip               (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_WRITE_ODT_CHIP           , SEC_HMC_CFG_WRITE_ODT_CHIP                )),  // ODT scheme setting for write command
            .hmc_cmd_fifo_reserve_en          (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_CMD_FIFO_RESERVE_EN      , SEC_HMC_CFG_CMD_FIFO_RESERVE_EN           )),  // Command FIFO reserve enable
            .hmc_rb_reserved_entry            (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_RB_RESERVED_ENTRY        , SEC_HMC_CFG_RB_RESERVED_ENTRY             )),  // Number of entries reserved in read buffer before almost full is asserted. Should be set to 4 + 2 * user_pipe_stages
            .hmc_wb_reserved_entry            (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_WB_RESERVED_ENTRY        , SEC_HMC_CFG_WB_RESERVED_ENTRY             )),  // Number of entries reserved in write buffer before almost full is asserted. Should be set to 4 + 2 * user_pipe_stages
            .hmc_starve_limit                 (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_STARVE_LIMIT             , SEC_HMC_CFG_STARVE_LIMIT                  )),  // When command reordering is enabled, specifies the number of commands that can be served before a starved command is starved.
            .hmc_phy_delay_mismatch           (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_PHY_DELAY_MISMATCH       , SEC_HMC_CFG_PHY_DELAY_MISMATCH            )),
            .hmc_dqstrk_en                    (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_DQSTRK_EN                , SEC_HMC_CFG_DQSTRK_EN                     )),  // Enable DQS tracking
            .hmc_dqstrk_to_valid              (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_DQSTRK_TO_VALID          , SEC_HMC_CFG_DQSTRK_TO_VALID               )),
            .hmc_dqstrk_to_valid_last         (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_DQSTRK_TO_VALID_LAST     , SEC_HMC_CFG_DQSTRK_TO_VALID_LAST          )),
            .hmc_ctl_short_dqstrk_en          (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_CTL_SHORT_DQSTRK_EN      , SEC_HMC_CFG_CTL_SHORT_DQSTRK_EN           )),
            .hmc_period_dqstrk_ctrl_en        (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_PERIOD_DQSTRK_CTRL_EN    , SEC_HMC_CFG_PERIOD_DQSTRK_CTRL_EN         )),
            .hmc_period_dqstrk_interval       (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_PERIOD_DQSTRK_INTERVAL   , SEC_HMC_CFG_PERIOD_DQSTRK_INTERVAL        )),
            .hmc_short_dqstrk_ctrl_en         (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_SHORT_DQSTRK_CTRL_EN     , SEC_HMC_CFG_SHORT_DQSTRK_CTRL_EN          )),
            .hmc_enable_fast_exit_ppd         (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_ENABLE_FAST_EXIT_PPD     , SEC_HMC_CFG_ENABLE_FAST_EXIT_PPD          )),
            .hmc_user_rfsh_en                 (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_USER_RFSH_EN             , SEC_HMC_CFG_USER_RFSH_EN                  )),  // Setting to enable user refresh
            .hmc_geardn_en                    (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_GEAR_DOWN_EN             , SEC_HMC_CFG_GEAR_DOWN_EN                  )),  // Gear-down (DDR4)
            .hmc_mem_auto_pd_cycles           (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_MEM_AUTO_PD_CYCLES       , SEC_HMC_CFG_MEM_AUTO_PD_CYCLES            )),
            .hmc_mem_clk_disable_entry_cycles (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_MEM_CLK_DISABLE_ENTRY_CYC, SEC_HMC_CFG_MEM_CLK_DISABLE_ENTRY_CYC     )),  // Set to a the number of clocks after the execution of an self-refresh to stop the clock.  This register is generally set based on PHY design latency and should generally not be changed
            .hmc_memclkgate_setting           (`_sel_hmc_tile(tile_i, PRI_HMC_MEMCLKGATE_SETTING           , SEC_HMC_MEMCLKGATE_SETTING                )),
            .hmc_tcl                          (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_TCL                      , SEC_HMC_CFG_TCL                           )),  // Memory CAS latency
            .hmc_16_act_to_act                (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_16_ACT_TO_ACT            , SEC_HMC_CFG_16_ACT_TO_ACT                 )),  // The 16-activate window timing parameter (RLD3) (e.g. tSAW)
            .hmc_4_act_to_act                 (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_4_ACT_TO_ACT             , SEC_HMC_CFG_4_ACT_TO_ACT                  )),  // The four-activate window timing parameter. (e.g. tFAW)
            .hmc_mem_if_al                    (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_AL                    , SEC_HMC_MEM_IF_AL                         )),
            .hmc_mem_if_cs_per_dimm           (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_CS_PER_DIMM           , SEC_HMC_MEM_IF_CS_PER_DIMM                )),
            .hmc_mem_if_rd_preamble           (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_RD_PREAMBLE           , SEC_HMC_MEM_IF_RD_PREAMBLE                )),
            .hmc_mem_if_tccd                  (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TCCD                  , SEC_HMC_MEM_IF_TCCD                       )),
            .hmc_mem_if_tccd_s                (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TCCD_S                , SEC_HMC_MEM_IF_TCCD_S                     )),
            .hmc_mem_if_tckesr                (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TCKESR                , SEC_HMC_MEM_IF_TCKESR                     )),
            .hmc_mem_if_tcksrx                (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TCKSRX                , SEC_HMC_MEM_IF_TCKSRX                     )),
            .hmc_mem_if_tcl                   (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TCL                   , SEC_HMC_MEM_IF_TCL                        )),
            .hmc_mem_if_tcwl                  (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TCWL                  , SEC_HMC_MEM_IF_TCWL                       )),
            .hmc_mem_if_tdqsckmax             (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TDQSCKMAX             , SEC_HMC_MEM_IF_TDQSCKMAX                  )),
            .hmc_mem_if_tfaw                  (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TFAW                  , SEC_HMC_MEM_IF_TFAW                       )),
            .hmc_mem_if_tmod                  (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TMOD                  , SEC_HMC_MEM_IF_TMOD                       )),
            .hmc_mem_if_tpl                   (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TPL                   , SEC_HMC_MEM_IF_TPL                        )),
            .hmc_mem_if_tras                  (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TRAS                  , SEC_HMC_MEM_IF_TRAS                       )),
            .hmc_mem_if_trc                   (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TRC                   , SEC_HMC_MEM_IF_TRC                        )),
            .hmc_mem_if_trcd                  (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TRCD                  , SEC_HMC_MEM_IF_TRCD                       )),
            .hmc_mem_if_trefi                 (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TREFI                 , SEC_HMC_MEM_IF_TREFI                      )),
            .hmc_mem_if_trfc                  (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TRFC                  , SEC_HMC_MEM_IF_TRFC                       )),
            .hmc_mem_if_trp                   (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TRP                   , SEC_HMC_MEM_IF_TRP                        )),
            .hmc_mem_if_trrd                  (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TRRD                  , SEC_HMC_MEM_IF_TRRD                       )),
            .hmc_mem_if_trrd_s                (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TRRD_S                , SEC_HMC_MEM_IF_TRRD_S                     )),
            .hmc_mem_if_trtp                  (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TRTP                  , SEC_HMC_MEM_IF_TRTP                       )),
            .hmc_mem_if_twr                   (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TWR                   , SEC_HMC_MEM_IF_TWR                        )),
            .hmc_mem_if_twr_crc_dm            (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TWR_CRC_DM            , SEC_HMC_MEM_IF_TWR_CRC_DM                 )),
            .hmc_mem_if_twtr                  (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TWTR                  , SEC_HMC_MEM_IF_TWTR                       )),
            .hmc_mem_if_twtr_l_crc_dm         (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TWTR_L_CRC_DM         , SEC_HMC_MEM_IF_TWTR_L_CRC_DM              )),
            .hmc_mem_if_twtr_s                (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TWTR_S                , SEC_HMC_MEM_IF_TWTR_S                     )),
            .hmc_mem_if_twtr_s_crc_dm         (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TWTR_S_CRC_DM         , SEC_HMC_MEM_IF_TWTR_S_CRC_DM              )),
            .hmc_mem_if_txp                   (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TXP                   , SEC_HMC_MEM_IF_TXP                        )),
            .hmc_mem_if_txpdll                (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TXPDLL                , SEC_HMC_MEM_IF_TXPDLL                     )),
            .hmc_mem_if_txsr                  (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TXSR                  , SEC_HMC_MEM_IF_TXSR                       )),
            .hmc_mem_if_tzqcs                 (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TZQCS                 , SEC_HMC_MEM_IF_TZQCS                      )),
            .hmc_mem_if_tzqoper               (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_TZQOPER               , SEC_HMC_MEM_IF_TZQOPER                    )),
            .hmc_mem_if_wr_crc                (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_WR_CRC                , SEC_HMC_MEM_IF_WR_CRC                     )),
            .hmc_mem_if_wr_preamble           (`_sel_hmc_tile(tile_i, PRI_HMC_MEM_IF_WR_PREAMBLE           , SEC_HMC_MEM_IF_WR_PREAMBLE                )),
            .hmc_act_to_act                   (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_ACT_TO_ACT               , SEC_HMC_CFG_ACT_TO_ACT                    )),  // Active to activate timing on same bank (e.g. tRC)
            .hmc_act_to_act_diff_bank         (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_ACT_TO_ACT_DIFF_BANK     , SEC_HMC_CFG_ACT_TO_ACT_DIFF_BANK          )),  // Active to activate timing on different banks, for DDR4 same bank group (e.g. tRRD)
            .hmc_act_to_act_diff_bg           (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_ACT_TO_ACT_DIFF_BG       , SEC_HMC_CFG_ACT_TO_ACT_DIFF_BG            )),  // Active to activate timing on different bank groups, DDR4 only
            .hmc_act_to_pch                   (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_ACT_TO_PCH               , SEC_HMC_CFG_ACT_TO_PCH                    )),  // Active to precharge (e.g. tRAS)
            .hmc_act_to_rdwr                  (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_ACT_TO_RDWR              , SEC_HMC_CFG_ACT_TO_RDWR                   )),  // Activate to Read/write command timing (e.g. tRCD)
            .hmc_arf_period                   (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_ARF_PERIOD               , SEC_HMC_CFG_ARF_PERIOD                    )),  // Auto-refresh period (e.g. tREFI)
            .hmc_arf_to_valid                 (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_ARF_TO_VALID             , SEC_HMC_CFG_ARF_TO_VALID                  )),  // Auto Refresh to valid DRAM command window.
            .hmc_mmr_cmd_to_valid             (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_MMR_CMD_TO_VALID         , SEC_HMC_CFG_MMR_CMD_TO_VALID              )),  // MMR cmd to valid delay
            .hmc_mpr_to_valid                 (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_MPR_TO_VALID             , SEC_HMC_CFG_MPR_TO_VALID                  )),  // Multi Purpose Register Read to Valid
            .hmc_mps_dqstrk_disable           (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_MPS_DQSTRK_DISABLE       , SEC_HMC_CFG_MPS_DQSTRK_DISABLE            )),  // Setting to disable DQS Tracking after Maximum Power Saving exit
            .hmc_mps_exit_cke_to_cs           (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_MPS_EXIT_CKE_TO_CS       , SEC_HMC_CFG_MPS_EXIT_CKE_TO_CS            )),  // Max Power Saving CKE to CS
            .hmc_mps_exit_cs_to_cke           (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_MPS_EXIT_CS_TO_CKE       , SEC_HMC_CFG_MPS_EXIT_CS_TO_CKE            )),  // Max Power Saving CS to CKE
            .hmc_mps_to_valid                 (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_MPS_TO_VALID             , SEC_HMC_CFG_MPS_TO_VALID                  )),  // Max Power Saving to Valid
            .hmc_mps_zqcal_disable            (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_MPS_ZQCAL_DISABLE        , SEC_HMC_CFG_MPS_ZQCAL_DISABLE             )),  // Setting to disable ZQ Calibration after Maximum Power Saving exit
            .hmc_mrr_to_valid                 (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_MRR_TO_VALID             , SEC_HMC_CFG_MRR_TO_VALID                  )),  // Mode Register Read to Valid
            .hmc_mrs_to_valid                 (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_MRS_TO_VALID             , SEC_HMC_CFG_MRS_TO_VALID                  )),  // Mode Register Setting to valid (e.g. tMRD)
            .hmc_pch_all_to_valid             (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_PCH_ALL_TO_VALID         , SEC_HMC_CFG_PCH_ALL_TO_VALID              )),  // Precharge all to banks being ready for bank activation command.
            .hmc_pch_to_valid                 (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_PCH_TO_VALID             , SEC_HMC_CFG_PCH_TO_VALID                  )),  // Precharge to valid command timing. (e.g. tRP)
            .hmc_pdn_period                   (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_PDN_PERIOD               , SEC_HMC_CFG_PDN_PERIOD                    )),  // Number of controller cycles before automatic power down.
            .hmc_pdn_to_valid                 (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_PDN_TO_VALID             , SEC_HMC_CFG_PDN_TO_VALID                  )),  // Power down to valid bank command window.
            .hmc_power_saving_exit_cycles     (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_POWER_SAVING_EXIT_CYC    , SEC_HMC_CFG_POWER_SAVING_EXIT_CYC         )),  // The minimum number of cycles to stay in a low power state. This applies to both power down and self-refresh and should be set to the greater of tPD and tCKESR
            .hmc_rd_ap_to_valid               (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_RD_AP_TO_VALID           , SEC_HMC_CFG_RD_AP_TO_VALID                )),  // Read command with autoprecharge to data valid timing
            .hmc_rd_to_pch                    (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_RD_TO_PCH                , SEC_HMC_CFG_RD_TO_PCH                     )),  // Read to precharge command timing (e.g. tRTP)
            .hmc_rd_to_rd                     (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_RD_TO_RD                 , SEC_HMC_CFG_RD_TO_RD                      )),  // Read to read command timing on same bank (e.g. tCCD)
            .hmc_rd_to_rd_diff_bg             (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_RD_TO_RD_DIFF_BG         , SEC_HMC_CFG_RD_TO_RD_DIFF_BG              )),  // Read to read command timing on different chips
            .hmc_rd_to_rd_diff_chip           (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_RD_TO_RD_DIFF_CHIP       , SEC_HMC_CFG_RD_TO_RD_DIFF_CHIP            )),  // Read to read command timing on different chips
            .hmc_rd_to_wr                     (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_RD_TO_WR                 , SEC_HMC_CFG_RD_TO_WR                      )),  // Read to write command timing on same bank
            .hmc_rd_to_wr_diff_bg             (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_RD_TO_WR_DIFF_BG         , SEC_HMC_CFG_RD_TO_WR_DIFF_BG              )),  // Read to write command timing on different bank groups
            .hmc_rd_to_wr_diff_chip           (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_RD_TO_WR_DIFF_CHIP       , SEC_HMC_CFG_RD_TO_WR_DIFF_CHIP            )),  // Read to write command timing on different chips
            .hmc_rfsh_warn_threshold          (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_RFSH_WARN_THRESHOLD      , SEC_HMC_CFG_RFSH_WARN_THRESHOLD           )),
            .hmc_rld3_multibank_ref_delay     (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_RLD3_MULTIBANK_REF_DELAY , SEC_HMC_CFG_RLD3_MULTIBANK_REF_DELAY      )),  // RLD3 multi-bank ref delay
            .hmc_rld3_refresh_seq0            (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_RLD3_REFRESH_SEQ0        , SEC_HMC_CFG_RLD3_REFRESH_SEQ0             )),  // Banks to refresh for RLD3 in sequence 0. Must not be more than 4 banks
            .hmc_rld3_refresh_seq1            (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_RLD3_REFRESH_SEQ1        , SEC_HMC_CFG_RLD3_REFRESH_SEQ1             )),  // Banks to refresh for RLD3 in sequence 1. Must not be more than 4 banks
            .hmc_rld3_refresh_seq2            (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_RLD3_REFRESH_SEQ2        , SEC_HMC_CFG_RLD3_REFRESH_SEQ2             )),  // Banks to refresh for RLD3 in sequence 2. Must not be more than 4 banks
            .hmc_rld3_refresh_seq3            (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_RLD3_REFRESH_SEQ3        , SEC_HMC_CFG_RLD3_REFRESH_SEQ3             )),  // Banks to refresh for RLD3 in sequence 3. Must not be more than 4 banks
            .hmc_sb_cg_disable                (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_SB_CG_DISABLE            , SEC_HMC_CFG_SB_CG_DISABLE                 )),  // Setting to disable mem_ck gating during self refresh and deep power down
            .hmc_sb_ddr4_mr3                  (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_SB_DDR4_MR3              , SEC_HMC_CFG_SB_DDR4_MR3                   )),  // DDR4 MR3
            .hmc_sb_ddr4_mr4                  (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_SB_DDR4_MR4              , SEC_HMC_CFG_SB_DDR4_MR4                   )),  // DDR4 MR4
            .hmc_sb_ddr4_mr5                  (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_SB_DDR4_MR5              , SEC_HMC_CFG_SB_DDR4_MR5                   )),  // DDR4 MR5
            .hmc_ddr4_mps_addrmirror          (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_DDR4_MPS_ADDRMIRROR      , SEC_HMC_CFG_DDR4_MPS_ADDRMIRROR           )),  // DDR4 MPS Address Mirror
            .hmc_srf_autoexit_en              (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_SRF_AUTOEXIT_EN          , SEC_HMC_CFG_SRF_AUTOEXIT_EN               )),  // Setting to enable controller to exit Self Refresh when new command is detected
            .hmc_srf_entry_exit_block         (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_SRF_ENTRY_EXIT_BLOCK     , SEC_HMC_CFG_SRF_ENTRY_EXIT_BLOCK          )),  // Blocking arbiter from issuing commands
            .hmc_srf_to_valid                 (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_SRF_TO_VALID             , SEC_HMC_CFG_SRF_TO_VALID                  )),  // Self-refresh to valid bank command window. (e.g. tRFC)
            .hmc_srf_to_zq_cal                (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_SRF_TO_ZQ_CAL            , SEC_HMC_CFG_SRF_TO_ZQ_CAL                 )),  // Self refresh to ZQ calibration window
            .hmc_srf_zqcal_disable            (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_SRF_ZQCAL_DISABLE        , SEC_HMC_CFG_SRF_ZQCAL_DISABLE             )),  // Setting to disable ZQ Calibration after self refresh
            .hmc_temp_4_act_to_act            (`_sel_hmc_tile(tile_i, PRI_HMC_TEMP_4_ACT_TO_ACT            , SEC_HMC_TEMP_4_ACT_TO_ACT                 )),
            .hmc_temp_rd_to_rd_diff_bg        (`_sel_hmc_tile(tile_i, PRI_HMC_TEMP_RD_TO_RD_DIFF_BG        , SEC_HMC_TEMP_RD_TO_RD_DIFF_BG             )),
            .hmc_temp_wr_to_rd                (`_sel_hmc_tile(tile_i, PRI_HMC_TEMP_WR_TO_RD                , SEC_HMC_TEMP_WR_TO_RD                     )),
            .hmc_temp_wr_to_rd_diff_bg        (`_sel_hmc_tile(tile_i, PRI_HMC_TEMP_WR_TO_RD_DIFF_BG        , SEC_HMC_TEMP_WR_TO_RD_DIFF_BG             )),
            .hmc_temp_wr_to_rd_diff_chip      (`_sel_hmc_tile(tile_i, PRI_HMC_TEMP_WR_TO_RD_DIFF_CHIP      , SEC_HMC_TEMP_WR_TO_RD_DIFF_CHIP           )),
            .hmc_temp_wr_to_wr_diff_bg        (`_sel_hmc_tile(tile_i, PRI_HMC_TEMP_WR_TO_WR_DIFF_BG        , SEC_HMC_TEMP_WR_TO_WR_DIFF_BG             )),
            .hmc_wr_ap_to_valid               (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_WR_AP_TO_VALID           , SEC_HMC_CFG_WR_AP_TO_VALID                )),  // Write with autoprecharge to valid command timing.
            .hmc_wr_to_pch                    (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_WR_TO_PCH                , SEC_HMC_CFG_WR_TO_PCH                     )),  // Write to precharge command timing. (e.g. tWR)
            .hmc_wr_to_rd                     (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_WR_TO_RD                 , SEC_HMC_CFG_WR_TO_RD                      )),  // Write to read command timing. (e.g. tWTR)
            .hmc_wr_to_rd_diff_bg             (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_WR_TO_RD_DIFF_BG         , SEC_HMC_CFG_WR_TO_RD_DIFF_BG              )),  // Write to read command timing on different bank groups
            .hmc_wr_to_rd_diff_chip           (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_WR_TO_RD_DIFF_CHIP       , SEC_HMC_CFG_WR_TO_RD_DIFF_CHIP            )),  // Write to read command timing on different chips.
            .hmc_wr_to_wr                     (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_WR_TO_WR                 , SEC_HMC_CFG_WR_TO_WR                      )),  // Write to write command timing on same bank. (e.g. tCCD)
            .hmc_wr_to_wr_diff_bg             (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_WR_TO_WR_DIFF_BG         , SEC_HMC_CFG_WR_TO_WR_DIFF_BG              )),  // Write to write command timing on different bank groups.
            .hmc_wr_to_wr_diff_chip           (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_WR_TO_WR_DIFF_CHIP       , SEC_HMC_CFG_WR_TO_WR_DIFF_CHIP            )),  // Write to write command timing on different chips.
            .hmc_zqcl_to_valid                (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_ZQCL_TO_VALID            , SEC_HMC_CFG_ZQCL_TO_VALID                 )),  // Long ZQ calibration to valid
            .hmc_zqcs_to_valid                (`_sel_hmc_tile(tile_i, PRI_HMC_CFG_ZQCS_TO_VALID            , SEC_HMC_CFG_ZQCS_TO_VALID                 )),  // Short ZQ calibration to valid
            .hmc_chip_id                      (`_sel_hmc_tile(tile_i, PRI_HMC_CHIP_ID                      , SEC_HMC_CHIP_ID                           )),
            .hmc_cid_addr_width               (`_sel_hmc_tile(tile_i, PRI_HMC_CID_ADDR_WIDTH               , SEC_HMC_CID_ADDR_WIDTH                    )),
            .hmc_3ds_en                       (`_sel_hmc_tile(tile_i, PRI_HMC_3DS_EN                       , SEC_HMC_3DS_EN                            )),
            .hmc_3ds_lr_num0                  (`_sel_hmc_tile(tile_i, PRI_HMC_3DS_LR_NUM0                  , SEC_HMC_3DS_LR_NUM0                       )),
            .hmc_3ds_lr_num1                  (`_sel_hmc_tile(tile_i, PRI_HMC_3DS_LR_NUM1                  , SEC_HMC_3DS_LR_NUM1                       )),
            .hmc_3ds_lr_num2                  (`_sel_hmc_tile(tile_i, PRI_HMC_3DS_LR_NUM2                  , SEC_HMC_3DS_LR_NUM2                       )),
            .hmc_3ds_lr_num3                  (`_sel_hmc_tile(tile_i, PRI_HMC_3DS_LR_NUM3                  , SEC_HMC_3DS_LR_NUM3                       )),
            .hmc_3ds_pr_stag_enable           (`_sel_hmc_tile(tile_i, PRI_HMC_3DS_PR_STAG_ENABLE           , SEC_HMC_3DS_PR_STAG_ENABLE                )),
            .hmc_3ds_ref2ref_dlr              (`_sel_hmc_tile(tile_i, PRI_HMC_3DS_REF2REF_DLR              , SEC_HMC_3DS_REF2REF_DLR                   )),
            .hmc_3dsref_ack_on_done           (`_sel_hmc_tile(tile_i, PRI_HMC_3DSREF_ACK_ON_DONE           , SEC_HMC_3DSREF_ACK_ON_DONE                )),
            
            .mode                             ("tile_ddr")

         ) tile_ctrl_inst (

            // Reset
            .global_reset_n                   (1'b1),

            // PLL -> Tiles
            .pll_locked_in                    (pll_locked),
            .pll_vco_in                       (phy_clk_phs),                        // FR clocks routed on PHY clock tree
            .phy_clk_in                       (phy_clk),                            // PHY clock tree inputs

            // Clock Phase Alignment
            .pa_core_clk_in                   (all_tiles_core_clks_fb_in[tile_i]),  // Input to CPA through feedback path
            .pa_core_clk_out                  (all_tiles_core_clks_out[tile_i]),    // Output from CPA to core clock networks
            .pa_locked                        (all_tiles_core_clks_locked[tile_i]), // Lock signal from CPA to core
            .pa_reset_n                       (1'b1),                               // Connected to global reset from core in non-HPS mode
            .pa_core_in                       (12'b000000000000),                   // Control code word
            .pa_fbclk_in                      (phy_fb_clk_to_tile),                 // PLL signal going into PHY feedback clock
            .pa_sync_data_bot_in              (pa_sync_data_up_chain[`_get_chain_index_for_tile(tile_i)]),
            .pa_sync_data_top_out             (pa_sync_data_up_chain[`_get_chain_index_for_tile(tile_i) + 1]),
            .pa_sync_data_top_in              (pa_sync_data_dn_chain[`_get_chain_index_for_tile(tile_i) + 1]),
            .pa_sync_data_bot_out             (pa_sync_data_dn_chain[`_get_chain_index_for_tile(tile_i)]),
            .pa_sync_clk_bot_in               (pa_sync_clk_up_chain [`_get_chain_index_for_tile(tile_i)]),
            .pa_sync_clk_top_out              (pa_sync_clk_up_chain [`_get_chain_index_for_tile(tile_i) + 1]),
            .pa_sync_clk_top_in               (pa_sync_clk_dn_chain [`_get_chain_index_for_tile(tile_i) + 1]),
            .pa_sync_clk_bot_out              (pa_sync_clk_dn_chain [`_get_chain_index_for_tile(tile_i)]),
            .pa_dprio_rst_n                   ((tile_i == PRI_AC_TILE_INDEX ? pa_dprio_rst_n : 1'b0)),
            .pa_dprio_clk                     ((tile_i == PRI_AC_TILE_INDEX ? pa_dprio_clk : 1'b0)),
            .pa_dprio_read                    ((tile_i == PRI_AC_TILE_INDEX ? pa_dprio_read : 1'b0)),
            .pa_dprio_reg_addr                ((tile_i == PRI_AC_TILE_INDEX ? pa_dprio_reg_addr : 9'b0)),
            .pa_dprio_write                   ((tile_i == PRI_AC_TILE_INDEX ? pa_dprio_write : 1'b0)),
            .pa_dprio_writedata               ((tile_i == PRI_AC_TILE_INDEX ? pa_dprio_writedata : 8'b0)),
            .pa_dprio_block_select            (all_tiles_pa_dprio_block_select[tile_i]),
            .pa_dprio_readdata                (all_tiles_pa_dprio_readdata[tile_i]),

            // PHY clock signals going from tiles to lanes
            .phy_clk_out0                     ({all_tiles_t2l_phy_clk[tile_i][0], all_tiles_t2l_phy_clk_phs[tile_i][0]}), // PHY clocks to lane 0
            .phy_clk_out1                     ({all_tiles_t2l_phy_clk[tile_i][1], all_tiles_t2l_phy_clk_phs[tile_i][1]}), // PHY clocks to lane 1
            .phy_clk_out2                     ({all_tiles_t2l_phy_clk[tile_i][2], all_tiles_t2l_phy_clk_phs[tile_i][2]}), // PHY clocks to lane 2
            .phy_clk_out3                     ({all_tiles_t2l_phy_clk[tile_i][3], all_tiles_t2l_phy_clk_phs[tile_i][3]}), // PHY clocks to lane 3
            .phy_fbclk_out                    (all_tiles_phy_fb_clk_to_pll[tile_i]),                                      // PHY clock signal going into the M counter of PLL to complete the feedback loop

            // DLL Interface
            .dll_clk_in                       (pll_dll_clk),                       // PLL clock feeding to DLL
            .dll_clk_out0                     (all_tiles_dll_clk_out[tile_i][0]),  // DLL clock to lane 0
            .dll_clk_out1                     (all_tiles_dll_clk_out[tile_i][1]),  // DLL clock to lane 1
            .dll_clk_out2                     (all_tiles_dll_clk_out[tile_i][2]),  // DLL clock to lane 2
            .dll_clk_out3                     (all_tiles_dll_clk_out[tile_i][3]),  // DLL clock to lane 3

            // Calibration bus between Nios and sequencer (a.k.a slow Avalon-MM bus)
            .cal_avl_in                       (cal_bus_avl_up_chain          [`_get_chain_index_for_tile(tile_i)]),
            .cal_avl_out                      (cal_bus_avl_up_chain          [`_get_chain_index_for_tile(tile_i) + 1]),
            .cal_avl_rdata_in                 (cal_bus_avl_read_data_dn_chain[`_get_chain_index_for_tile(tile_i) + 1]),
            .cal_avl_rdata_out                (cal_bus_avl_read_data_dn_chain[`_get_chain_index_for_tile(tile_i)]),

            .core2ctl_avl                     (`_sel_hmc_default(tile_i, core2ctl_avl_0, core2ctl_avl_1, 63'b0)),
            .core2ctl_avl_rd_data_ready       (`_sel_hmc_default(tile_i, core2ctl_avl_rd_data_ready_0, core2ctl_avl_rd_data_ready_1, 1'b0)),
            .ctl2core_avl_cmd_ready           (all_tiles_ctl2core_avl_cmd_ready[tile_i]),
            .ctl2core_avl_rdata_id            (all_tiles_ctl2core_avl_rdata_id[tile_i]),

            .core2ctl_sideband                (`_sel_hmc_default(tile_i, core2ctl_sideband_0, core2ctl_sideband_1, 42'b0)),
            .ctl2core_sideband                (all_tiles_ctl2core_sideband[tile_i]),

            // Interface between HMC and lanes
            .afi_cmd_bus                      (t2l_ac_hmc),

            // DQS buses
            // There are 8 x4 DQS buses per tile, with two pairs of input DQS per lane.
            .dqs_in_x4_a_0                    (DQS_BUS_MODE_ENUM == "DQS_BUS_MODE_X4" ? b2t_dqs[(tile_i * LANES_PER_TILE) + 0]  : 1'b0),
            .dqs_in_x4_a_1                    (DQS_BUS_MODE_ENUM == "DQS_BUS_MODE_X4" ? b2t_dqs[(tile_i * LANES_PER_TILE) + 1]  : 1'b0),
            .dqs_in_x4_a_2                    (DQS_BUS_MODE_ENUM == "DQS_BUS_MODE_X4" ? b2t_dqs[(tile_i * LANES_PER_TILE) + 2]  : 1'b0),
            .dqs_in_x4_a_3                    (DQS_BUS_MODE_ENUM == "DQS_BUS_MODE_X4" ? b2t_dqs[(tile_i * LANES_PER_TILE) + 3]  : 1'b0),
            .dqs_in_x4_b_0                    (DQS_BUS_MODE_ENUM == "DQS_BUS_MODE_X4" ? b2t_dqsb[(tile_i * LANES_PER_TILE) + 0] : 1'b0),
            .dqs_in_x4_b_1                    (DQS_BUS_MODE_ENUM == "DQS_BUS_MODE_X4" ? b2t_dqsb[(tile_i * LANES_PER_TILE) + 1] : 1'b0),
            .dqs_in_x4_b_2                    (DQS_BUS_MODE_ENUM == "DQS_BUS_MODE_X4" ? b2t_dqsb[(tile_i * LANES_PER_TILE) + 2] : 1'b0),
            .dqs_in_x4_b_3                    (DQS_BUS_MODE_ENUM == "DQS_BUS_MODE_X4" ? b2t_dqsb[(tile_i * LANES_PER_TILE) + 3] : 1'b0),
            .dqs_out_x4_a_lane0               (t2l_dqsbus_x4[0][0]),
            .dqs_out_x4_b_lane0               (t2l_dqsbus_x4[0][1]),
            .dqs_out_x4_a_lane1               (t2l_dqsbus_x4[1][0]),
            .dqs_out_x4_b_lane1               (t2l_dqsbus_x4[1][1]),
            .dqs_out_x4_a_lane2               (t2l_dqsbus_x4[2][0]),
            .dqs_out_x4_b_lane2               (t2l_dqsbus_x4[2][1]),
            .dqs_out_x4_a_lane3               (t2l_dqsbus_x4[3][0]),
            .dqs_out_x4_b_lane3               (t2l_dqsbus_x4[3][1]),

            // There are 4 x8/x9 DQS buses per tile, with one pair of input DQS per lane.
            .dqs_in_x8_0                      (DQS_BUS_MODE_ENUM == "DQS_BUS_MODE_X8_X9" ? {b2t_dqsb[(tile_i * LANES_PER_TILE) + 0], b2t_dqs[(tile_i * LANES_PER_TILE) + 0]} : 2'b0),
            .dqs_in_x8_1                      (DQS_BUS_MODE_ENUM == "DQS_BUS_MODE_X8_X9" ? {b2t_dqsb[(tile_i * LANES_PER_TILE) + 1], b2t_dqs[(tile_i * LANES_PER_TILE) + 1]} : 2'b0),
            .dqs_in_x8_2                      (DQS_BUS_MODE_ENUM == "DQS_BUS_MODE_X8_X9" ? {b2t_dqsb[(tile_i * LANES_PER_TILE) + 2], b2t_dqs[(tile_i * LANES_PER_TILE) + 2]} : 2'b0),
            .dqs_in_x8_3                      (DQS_BUS_MODE_ENUM == "DQS_BUS_MODE_X8_X9" ? {b2t_dqsb[(tile_i * LANES_PER_TILE) + 3], b2t_dqs[(tile_i * LANES_PER_TILE) + 3]} : 2'b0),
            .dqs_out_x8_lane0                 (t2l_dqsbus_x8[0]),
            .dqs_out_x8_lane1                 (t2l_dqsbus_x8[1]),
            .dqs_out_x8_lane2                 (t2l_dqsbus_x8[2]),
            .dqs_out_x8_lane3                 (t2l_dqsbus_x8[3]),

            // There are 2 x16/x18 DQS buses per tile, and the input DQS must originate from lane 1 and 3 (RevA), lane 0 and 2 (Follow-on)
            .dqs_in_x18_0                     (DQS_BUS_MODE_ENUM == "DQS_BUS_MODE_X16_X18" ? {b2t_dqsb[(tile_i * LANES_PER_TILE) + `_get_x18_0_lane], b2t_dqs[(tile_i * LANES_PER_TILE) + `_get_x18_0_lane]} : 2'b0),
            .dqs_in_x18_1                     (DQS_BUS_MODE_ENUM == "DQS_BUS_MODE_X16_X18" ? {b2t_dqsb[(tile_i * LANES_PER_TILE) + `_get_x18_1_lane], b2t_dqs[(tile_i * LANES_PER_TILE) + `_get_x18_1_lane]} : 2'b0),
            .dqs_out_x18_lane0                (t2l_dqsbus_x18[0]),
            .dqs_out_x18_lane1                (t2l_dqsbus_x18[1]),
            .dqs_out_x18_lane2                (t2l_dqsbus_x18[2]),
            .dqs_out_x18_lane3                (t2l_dqsbus_x18[3]),

            // There is 1 x32/x36 DQS bus per tile, and the input DQS must originate from lane 1
            .dqs_in_x36                       (DQS_BUS_MODE_ENUM == "DQS_BUS_MODE_X32_X36" ? {b2t_dqsb[(tile_i * LANES_PER_TILE) + 1], b2t_dqs[(tile_i * LANES_PER_TILE) + 1]} : 2'b0),
            .dqs_out_x36_lane0                (t2l_dqsbus_x36[0]),
            .dqs_out_x36_lane1                (t2l_dqsbus_x36[1]),
            .dqs_out_x36_lane2                (t2l_dqsbus_x36[2]),
            .dqs_out_x36_lane3                (t2l_dqsbus_x36[3]),

            // Data buffer control signals
            .ctl2dbc0                         (all_tiles_ctl2dbc0_dn_chain[tile_i]),
            .ctl2dbc1                         (all_tiles_ctl2dbc1_up_chain[tile_i + 1]),
            .ctl2dbc_in_up                    (all_tiles_ctl2dbc0_dn_chain[tile_i + 1]),
            .ctl2dbc_in_down                  (all_tiles_ctl2dbc1_up_chain[tile_i]),
            .cfg_dbc0                         (t2l_cfg_dbc[0]),
            .cfg_dbc1                         (t2l_cfg_dbc[1]),
            .cfg_dbc2                         (t2l_cfg_dbc[2]),
            .cfg_dbc3                         (t2l_cfg_dbc[3]),
            .dbc2core_wr_data_rdy0            (l2core_wr_data_rdy_ast_abphy[tile_i][0]),
            .dbc2core_wr_data_rdy1            (l2core_wr_data_rdy_ast_abphy[tile_i][1]),
            .dbc2core_wr_data_rdy2            (l2core_wr_data_rdy_ast_abphy[tile_i][2]),
            .dbc2core_wr_data_rdy3            (l2core_wr_data_rdy_ast_abphy[tile_i][3]),

            // Ping-Pong PHY related signals
            .ping_pong_in                     (all_tiles_ping_pong_up_chain[tile_i]),
            .ping_pong_out                    (all_tiles_ping_pong_up_chain[tile_i + 1]),

            // MMR-related signals
            .mmr_in                           (`_sel_hmc_default(tile_i, core2ctl_mmr_0, core2ctl_mmr_1, 51'b0)),
            .mmr_out                          (all_tiles_ctl2core_mmr[tile_i]),

            // Miscellaneous signals
            .afi_core2ctl                     (all_tiles_c2t_afi[tile_i]),
            .afi_ctl2core                     (all_tiles_t2c_afi[tile_i]),
            .seq2core_reset_n                 (),
            .ctl_mem_clk_disable              (),
            .rdata_en_full_core               (4'b0),   
            .mrnk_read_core                   (16'b0),  
            .test_dbg_in                      (48'b000000000000000000000000000000000000000000000000),
            .test_dbg_out                     ()        
         );

         initial begin
           @ (negedge core2seq_reset_req);
           if ( core2seq_reset_req !==1'b0 )
             @ (negedge core2seq_reset_req);
           #100;
           force tile_gen[tile_i].tile_ctrl_inst.inst.genblk1.inst.hmc_inst.iophyseq_inst.avl_tile_inst.cmd_phy_rst_n=1;
           force tile_gen[tile_i].tile_ctrl_inst.inst.genblk1.inst.hmc_inst.iophyseq_inst.avl_tile_inst.cmd_ctl_rst_n=1;
           force tile_gen[tile_i].tile_ctrl_inst.inst.genblk1.inst.hmc_inst.iophyseq_inst.avl_tile_inst.cmd_ctldbc_rst_n=1;
           force tile_gen[tile_i].tile_ctrl_inst.inst.genblk1.inst.hmc_inst.iophyseq_inst.avl_tile_inst.cmd_rst_n=1;
           force tile_gen[tile_i].tile_ctrl_inst.inst.genblk1.inst.hmc_inst.iophyseq_inst.iophyseq_phy_manager_inst.afi_seq2core='h60;
           if ( PHY_PING_PONG_EN==1 && tile_i==SEC_AC_TILE_INDEX ) begin
             force tile_gen[tile_i].tile_ctrl_inst.inst.genblk1.inst.hmc_inst.iophyseq_inst.iophyseq_phy_manager_inst.phy_afi_wlat=wlat+2;
             force tile_gen[tile_i].tile_ctrl_inst.inst.genblk1.inst.hmc_inst.iophyseq_inst.iophyseq_phy_manager_inst.phy_afi_rlat=rlat+2;
           end
           else begin
             force tile_gen[tile_i].tile_ctrl_inst.inst.genblk1.inst.hmc_inst.iophyseq_inst.iophyseq_phy_manager_inst.phy_afi_wlat=wlat;
             force tile_gen[tile_i].tile_ctrl_inst.inst.genblk1.inst.hmc_inst.iophyseq_inst.iophyseq_phy_manager_inst.phy_afi_rlat=rlat;
           end
           #100;
           force tile_gen[tile_i].tile_ctrl_inst.inst.genblk1.inst.hmc_inst.iophyseq_inst.iophyseq_phy_manager_inst.phy_cal_success=1;
         end
         
         for (lane_i = 0; lane_i < LANES_PER_TILE; ++lane_i)
         begin: lane_gen

            assign ac_hmc_par[lane_i*96+tile_i*4*96+95:lane_i*96+tile_i*4*96] = `_get_ac_hmc(tile_i, lane_i);
            assign dq_data_to_mem[lane_i*96+tile_i*4*96+95:lane_i*96+tile_i*4*96]    =  
                          tile_gen[tile_i].lane_gen[lane_i].lane_inst.lane_inst.inst.inst.u_io_12_lane_bcm.data_to_ioreg;
            assign dq_oe[lane_i*48+tile_i*4*48+47:lane_i*48+tile_i*4*48]      =  
                          tile_gen[tile_i].lane_gen[lane_i].lane_inst.lane_inst.inst.inst.u_io_12_lane_bcm.oeb_to_ioreg;
            assign tile_gen[tile_i].lane_gen[lane_i].lane_inst.lane_inst.inst.inst.u_io_12_lane_bcm.data_from_ioreg_abphy = 
                          dq_data_from_mem[lane_i*96+tile_i*4*96+95:lane_i*96+tile_i*4*96];
            assign tile_gen[tile_i].lane_gen[lane_i].lane_inst.lane_inst.inst.inst.u_io_12_lane_bcm.rdata_valid_local=
                          rdata_valid_local[tile_i][lane_i];

            assign tile_gen[tile_i].lane_gen[lane_i].lane_inst.lane_inst.inst.inst.u_io_12_lane_bcm.afi_cal_success = afi_cal_success_delay;
            
            integer i,j;
            initial begin
              add_2[tile_i][lane_i]                = 0;
              if ( PHY_PING_PONG_EN==1 ) begin
                for ( i=(PORT_MEM_DQ_WIDTH/2); i<PORT_MEM_DQ_WIDTH; i++ ) begin
                  if ( tile_i==`_abphy_get_tile(PORT_MEM_DQ_PINLOC, i) && 
                              lane_i==`_abphy_get_lane(PORT_MEM_DQ_PINLOC, i) ) begin
                    add_2[tile_i][lane_i]          = 2;
                  end
                end
              end
              
              @ (negedge core2seq_reset_req);
              if ( core2seq_reset_req !==1'b0 )
                @ (negedge core2seq_reset_req);
              #100;
               force tile_gen[tile_i].lane_gen[lane_i].lane_inst.lane_inst.inst.inst.u_io_12_lane_bcm.data_buffer.avl_lane_inst.cmd_phy_rst_n=1;;
               force tile_gen[tile_i].lane_gen[lane_i].lane_inst.lane_inst.inst.inst.u_io_12_lane_bcm.data_buffer.avl_lane_inst.cmd_dbc_rst_n=1;;
               force tile_gen[tile_i].lane_gen[lane_i].lane_inst.lane_inst.inst.inst.u_io_12_lane_bcm.data_buffer.avl_lane_inst.cmd_rst_n=1;
               force tile_gen[tile_i].lane_gen[lane_i].lane_inst.lane_inst.inst.inst.u_io_12_lane_bcm.data_buffer.io_data_buffer_wlat_rlat_avl_ovrd_inst.afi_rlat[5:0]=rlat+add_2[tile_i][lane_i];
               force tile_gen[tile_i].lane_gen[lane_i].lane_inst.lane_inst.inst.inst.u_io_12_lane_bcm.data_buffer.io_data_buffer_wlat_rlat_avl_ovrd_inst.afi_wlat[5:0]=wlat+add_2[tile_i][lane_i];
            end
            
            (* altera_attribute = "-name MAX_WIRES_FOR_CORE_PERIPHERY_TRANSFER  1; -name MAX_WIRES_FOR_PERIPHERY_CORE_TRANSFER  1" *)
            altera_emif_arch_nd_io_lane_remap_abphy #(
               .fast_interpolator_sim                       (DIAG_FAST_SIM),
               .a_filter_code                               (`_get_a_filter_code),
               .mode_rate_in                                (`_get_lane_mode_rate_in),
               .mode_rate_out                               (PLL_VCO_TO_MEM_CLK_FREQ_RATIO),
               .pipe_latency                                (8'b00000000),               // Don't-care - always set by calibration software
               .phy_clk_sel                                 (0),                          // Always use phy_clk[0]

               .pair_0_ddr4_mode                            (`_get_pin_pair_mode),
               .pair_1_ddr4_mode                            (`_get_pin_pair_mode),
               .pair_2_ddr4_mode                            (`_get_pin_pair_mode),
               .pair_3_ddr4_mode                            (`_get_pin_pair_mode),
               .pair_4_ddr4_mode                            (`_get_pin_pair_mode),
               .pair_5_ddr4_mode                            (`_get_pin_pair_mode),

               .pair_0_dcc_split_mode                       (`_get_pin_dcc_split_raw(tile_i, lane_i, 0)),
               .pair_1_dcc_split_mode                       (`_get_pin_dcc_split_raw(tile_i, lane_i, 2)),
               .pair_2_dcc_split_mode                       (`_get_pin_dcc_split_raw(tile_i, lane_i, 4)),
               .pair_3_dcc_split_mode                       (`_get_pin_dcc_split_raw(tile_i, lane_i, 6)),
               .pair_4_dcc_split_mode                       (`_get_pin_dcc_split_raw(tile_i, lane_i, 8)),
               .pair_5_dcc_split_mode                       (`_get_pin_dcc_split_raw(tile_i, lane_i, 10)),

               .silicon_rev                                 (SILICON_REV),
               .dqs_enable_delay                            (6'b000000),                 // Don't-care - always set by calibration software
               .rd_valid_delay                              (7'b0000000),                // Don't-care - always set by calibration software
               .avl_base_addr                               (`_get_lane_tid(tile_i, lane_i)),
               .avl_ena                                     ("true"),

               .pin_0_initial_out                           ("initial_out_z"),
               .pin_0_output_phase                          (13'b0000000000000),
               .pin_0_mode_ddr                              (`_get_pin_ddr_str         (tile_i, lane_i, 0)),
               .pin_0_oct_mode                              (`_get_pin_oct_mode_str    (tile_i, lane_i, 0)),
               .pin_0_data_in_mode                          (`_get_pin_data_in_mode_str(tile_i, lane_i, 0)),
               .pin_0_dqs_mode                              (`_get_pin_dqs_mode_str    (tile_i, lane_i, 0)),
               .pin_1_initial_out                           ("initial_out_z"),
               .pin_1_output_phase                          (13'b0000000000000),
               .pin_1_mode_ddr                              (`_get_pin_ddr_str         (tile_i, lane_i, 1)),
               .pin_1_oct_mode                              (`_get_pin_oct_mode_str    (tile_i, lane_i, 1)),
               .pin_1_data_in_mode                          (`_get_pin_data_in_mode_str(tile_i, lane_i, 1)),
               .pin_1_dqs_mode                              (`_get_pin_dqs_mode_str    (tile_i, lane_i, 1)),
               .pin_2_initial_out                           ("initial_out_z"),
               .pin_2_output_phase                          (13'b0000000000000),
               .pin_2_mode_ddr                              (`_get_pin_ddr_str         (tile_i, lane_i, 2)),
               .pin_2_oct_mode                              (`_get_pin_oct_mode_str    (tile_i, lane_i, 2)),
               .pin_2_data_in_mode                          (`_get_pin_data_in_mode_str(tile_i, lane_i, 2)),
               .pin_2_dqs_mode                              (`_get_pin_dqs_mode_str    (tile_i, lane_i, 2)),
               .pin_3_initial_out                           ("initial_out_z"),
               .pin_3_output_phase                          (13'b0000000000000),
               .pin_3_mode_ddr                              (`_get_pin_ddr_str         (tile_i, lane_i, 3)),
               .pin_3_oct_mode                              (`_get_pin_oct_mode_str    (tile_i, lane_i, 3)),
               .pin_3_data_in_mode                          (`_get_pin_data_in_mode_str(tile_i, lane_i, 3)),
               .pin_3_dqs_mode                              (`_get_pin_dqs_mode_str    (tile_i, lane_i, 3)),
               .pin_4_initial_out                           ("initial_out_z"),
               .pin_4_output_phase                          (13'b0000000000000),
               .pin_4_mode_ddr                              (`_get_pin_ddr_str         (tile_i, lane_i, 4)),
               .pin_4_oct_mode                              (`_get_pin_oct_mode_str    (tile_i, lane_i, 4)),
               .pin_4_data_in_mode                          (`_get_pin_data_in_mode_str(tile_i, lane_i, 4)),
               .pin_4_dqs_mode                              (`_get_pin_dqs_mode_str    (tile_i, lane_i, 4)),
               .pin_5_initial_out                           ("initial_out_z"),
               .pin_5_output_phase                          (13'b0000000000000),
               .pin_5_mode_ddr                              (`_get_pin_ddr_str         (tile_i, lane_i, 5)),
               .pin_5_oct_mode                              (`_get_pin_oct_mode_str    (tile_i, lane_i, 5)),
               .pin_5_data_in_mode                          (`_get_pin_data_in_mode_str(tile_i, lane_i, 5)),
               .pin_5_dqs_mode                              (`_get_pin_dqs_mode_str    (tile_i, lane_i, 5)),
               .pin_6_initial_out                           ("initial_out_z"),
               .pin_6_output_phase                          (13'b0000000000000),
               .pin_6_mode_ddr                              (`_get_pin_ddr_str         (tile_i, lane_i, 6)),
               .pin_6_oct_mode                              (`_get_pin_oct_mode_str    (tile_i, lane_i, 6)),
               .pin_6_data_in_mode                          (`_get_pin_data_in_mode_str(tile_i, lane_i, 6)),
               .pin_6_dqs_mode                              (`_get_pin_dqs_mode_str    (tile_i, lane_i, 6)),
               .pin_7_initial_out                           ("initial_out_z"),
               .pin_7_output_phase                          (13'b0000000000000),
               .pin_7_mode_ddr                              (`_get_pin_ddr_str         (tile_i, lane_i, 7)),
               .pin_7_oct_mode                              (`_get_pin_oct_mode_str    (tile_i, lane_i, 7)),
               .pin_7_data_in_mode                          (`_get_pin_data_in_mode_str(tile_i, lane_i, 7)),
               .pin_7_dqs_mode                              (`_get_pin_dqs_mode_str    (tile_i, lane_i, 7)),
               .pin_8_initial_out                           ("initial_out_z"),
               .pin_8_output_phase                          (13'b0000000000000),
               .pin_8_mode_ddr                              (`_get_pin_ddr_str         (tile_i, lane_i, 8)),
               .pin_8_oct_mode                              (`_get_pin_oct_mode_str    (tile_i, lane_i, 8)),
               .pin_8_data_in_mode                          (`_get_pin_data_in_mode_str(tile_i, lane_i, 8)),
               .pin_8_dqs_mode                              (`_get_pin_dqs_mode_str    (tile_i, lane_i, 8)),
               .pin_9_initial_out                           ("initial_out_z"),
               .pin_9_output_phase                          (13'b0000000000000),
               .pin_9_mode_ddr                              (`_get_pin_ddr_str         (tile_i, lane_i, 9)),
               .pin_9_oct_mode                              (`_get_pin_oct_mode_str    (tile_i, lane_i, 9)),
               .pin_9_data_in_mode                          (`_get_pin_data_in_mode_str(tile_i, lane_i, 9)),
               .pin_9_dqs_mode                              (`_get_pin_dqs_mode_str    (tile_i, lane_i, 9)),
               .pin_10_initial_out                          ("initial_out_z"),
               .pin_10_output_phase                         (13'b0000000000000),
               .pin_10_mode_ddr                             (`_get_pin_ddr_str         (tile_i, lane_i, 10)),
               .pin_10_oct_mode                             (`_get_pin_oct_mode_str    (tile_i, lane_i, 10)),
               .pin_10_data_in_mode                         (`_get_pin_data_in_mode_str(tile_i, lane_i, 10)),
               .pin_10_dqs_mode                             (`_get_pin_dqs_mode_str    (tile_i, lane_i, 10)),
               .pin_11_initial_out                          ("initial_out_z"),
               .pin_11_output_phase                         (13'b0000000000000),
               .pin_11_mode_ddr                             (`_get_pin_ddr_str         (tile_i, lane_i, 11)),
               .pin_11_oct_mode                             (`_get_pin_oct_mode_str    (tile_i, lane_i, 11)),
               .pin_11_data_in_mode                         (`_get_pin_data_in_mode_str(tile_i, lane_i, 11)),
               .pin_11_dqs_mode                             (`_get_pin_dqs_mode_str    (tile_i, lane_i, 11)),

               .db_boardcast_en                             ("true"),
               .db_hmc_or_core                              (`_get_hmc_or_core),
               .db_dbi_sel                                  ("db_dbi_sel_uint11"),   
               .db_dbi_wr_en                                (`_get_dbi_wr_en(tile_i, lane_i)),
               .db_dbi_rd_en                                (`_get_dbi_rd_en(tile_i, lane_i)),
               .db_rwlat_mode                               ("avl_vlu"),                                         // wlat/rlat set dynamically via Avalon by Nios (instead of through CSR)
               .db_afi_wlat_vlu                             (6'b000000),                                         // Unused - wlat set dynamically via Avalon by Nios
               .db_afi_rlat_vlu                             (6'b000000),                                         // Unused - rlat set dynamically via Avalon by Nios
               .db_ptr_pipeline_depth                       (`_get_db_ptr_pipe_depth_str(tile_i, lane_i)),       // Additional latency to compensate for distance from HMC
               .db_preamble_mode                            (PREAMBLE_MODE),
               .db_reset_auto_release                       (DIAG_DB_RESET_AUTO_RELEASE),                         // Reset sequencer controlled via Avalon by Nios
               .db_data_alignment_mode                      (`_get_db_data_alignment_mode),          // Data alignment mode (enabled IFF HMC)
               .db_db2core_registered                       ("registered"),
               .dbc_core_clk_sel                            (USE_HMC_RC_OR_DP ? "dbc_core_clk_sel_uint1" : "dbc_core_clk_sel_uint0"),              // Use phy_clk1 if HMC dual-port or rate-converter is used, use phy_clk0 otherwise
               .db_core_or_hmc2db_registered                ("false"),
               .db_seq_rd_en_full_pipeline                  (`_get_db_seq_rd_en_full_pipeline_str(tile_i, lane_i)),  // Additional latency to compensate for distance from sequencer
               .dbc_wb_reserved_entry                       (DBC_WB_RESERVED_ENTRY),

               .db_pin_0_mode                               (`_get_db_pin_proc_mode_str(tile_i, lane_i, 0)),
               .db_pin_1_mode                               (`_get_db_pin_proc_mode_str(tile_i, lane_i, 1)),
               .db_pin_2_mode                               (`_get_db_pin_proc_mode_str(tile_i, lane_i, 2)),
               .db_pin_3_mode                               (`_get_db_pin_proc_mode_str(tile_i, lane_i, 3)),
               .db_pin_4_mode                               (`_get_db_pin_proc_mode_str(tile_i, lane_i, 4)),
               .db_pin_5_mode                               (`_get_db_pin_proc_mode_str(tile_i, lane_i, 5)),
               .db_pin_6_mode                               (`_get_db_pin_proc_mode_str(tile_i, lane_i, 6)),
               .db_pin_7_mode                               (`_get_db_pin_proc_mode_str(tile_i, lane_i, 7)),
               .db_pin_8_mode                               (`_get_db_pin_proc_mode_str(tile_i, lane_i, 8)),
               .db_pin_9_mode                               (`_get_db_pin_proc_mode_str(tile_i, lane_i, 9)),
               .db_pin_10_mode                              (`_get_db_pin_proc_mode_str(tile_i, lane_i, 10)),
               .db_pin_11_mode                              (`_get_db_pin_proc_mode_str(tile_i, lane_i, 11)),

               .dll_rst_en                                  (DIAG_USE_ABSTRACT_PHY ? "dll_rst_dis" : IS_HPS ? "dll_rst_dis" : "dll_rst_en"),
               .dll_en                                      ("dll_en"),
               .dll_core_updnen                             ("core_updn_dis"),
               .dll_ctlsel                                  (DLL_MODE),
               .dll_ctl_static                              (DLL_CODEWORD),
               .hps_ctrl_en                                 (IS_HPS ? "true" : "false"),
               .dqs_lgc_pvt_input_delay_a                   (10'b00000_00000),                      // Phase shift to center read clock/strobe signal in read window (DQS-A bus). Overriden by Nios during calibration.
               .dqs_lgc_pvt_input_delay_b                   (10'b00000_00000),                      // Phase shift to center read clock/strobe signal in read window (DQS-B bus). Overriden by Nios during calibration.
               .dqs_lgc_enable_toggler                      (`_get_preamble_track_dqs_enable_mode), // Tracking Mode
               .dqs_lgc_phase_shift_b                       (13'b00000_0000_0000),                  // Delay to read clock/strobe gating signal. Overriden by Nios during calibration.
               .dqs_lgc_phase_shift_a                       (13'b00000_0000_0000),                  // Delay to read clock/strobe gating signal. Overriden by Nios during calibration.
               .dqs_lgc_pack_mode                           (DQS_PACK_MODE),
               .oct_size                                    (`_get_oct_size),
               .dqs_lgc_pst_preamble_mode                   (`_get_pst_preamble_mode),
               .dqs_lgc_pst_en_shrink                       (`_get_pst_en_shrink),
               .dqs_lgc_broadcast_enable                    ("disable_broadcast"),
               .dqs_lgc_burst_length                        (`_get_dqs_lgc_burst_length),
               .dqs_lgc_ddr4_search                         (`_get_ddr4_search),
               .dqs_lgc_count_threshold                     (7'b0011000),
               .pingpong_primary                            (`_sel_hmc_lane(tile_i, lane_i, "true", "false")),
               .pingpong_secondary                          (`_sel_hmc_lane(tile_i, lane_i, "false", "true")),

               .vfifo_burst_length                          (`_get_vfifo_burst_length),

               .dqs_lgc_dqs_a_interp_en                     (DQSA_LGC_MODE),                             // This enables read capture using an internal clock - never used by EMIF
               .dqs_lgc_dqs_b_interp_en                     (DQSB_LGC_MODE),                             // This enables read capture using an internal clock - never used by EMIF
               .mrnk_write_mode                             (`_get_mrnk_write_mode(tile_i, lane_i))

            ) lane_inst (

               // PLL/DLL/PVT interface
               .pll_locked                               (pll_locked),
               .dll_ref_clk                              (all_tiles_dll_clk_out[tile_i][lane_i]),
               .core_dll                                 (),    
               .dll_core                                 (),    
               .ioereg_locked                            (),

               // Clocks
               .phy_clk                                  (all_tiles_t2l_phy_clk[tile_i][lane_i]),
               .phy_clk_phs                              (all_tiles_t2l_phy_clk_phs[tile_i][lane_i]),

               // Clock Phase Alignment
               .sync_data_bot_in                         (pa_sync_data_up_chain[`_get_chain_index_for_lane(tile_i, lane_i)]),
               .sync_data_top_out                        (pa_sync_data_up_chain[`_get_chain_index_for_lane(tile_i, lane_i) + 1]),
               .sync_data_top_in                         (pa_sync_data_dn_chain[`_get_chain_index_for_lane(tile_i, lane_i) + 1]),
               .sync_data_bot_out                        (pa_sync_data_dn_chain[`_get_chain_index_for_lane(tile_i, lane_i)]),
               .sync_clk_bot_in                          (pa_sync_clk_up_chain [`_get_chain_index_for_lane(tile_i, lane_i)]),
               .sync_clk_top_out                         (pa_sync_clk_up_chain [`_get_chain_index_for_lane(tile_i, lane_i) + 1]),
               .sync_clk_top_in                          (pa_sync_clk_dn_chain [`_get_chain_index_for_lane(tile_i, lane_i) + 1]),
               .sync_clk_bot_out                         (pa_sync_clk_dn_chain [`_get_chain_index_for_lane(tile_i, lane_i)]),

               // DQS bus from tile. Connections are only made for the data lanes (as captured by the macro)
               .dqs_in                                   (`_get_dqsin(tile_i, lane_i)),

               // Interface to I/O buffers
               .oct_enable                               (l2b_dtc_abphy [tile_i * PINS_PER_LANE * LANES_PER_TILE + lane_i * PINS_PER_LANE +: PINS_PER_LANE]),
               .data_oe                                  (l2b_oe_abphy  [tile_i * PINS_PER_LANE * LANES_PER_TILE + lane_i * PINS_PER_LANE +: PINS_PER_LANE]),
               .data_out                                 (l2b_data_abphy[tile_i * PINS_PER_LANE * LANES_PER_TILE + lane_i * PINS_PER_LANE +: PINS_PER_LANE]),
               .data_in                                  (b2l_data[tile_i * PINS_PER_LANE * LANES_PER_TILE + lane_i * PINS_PER_LANE +: PINS_PER_LANE]),
               .emif_phy_out_a                           (l2b_e_a_abphy[tile_i * PINS_PER_LANE * LANES_PER_TILE + lane_i * PINS_PER_LANE +: PINS_PER_LANE]),
               .emif_phy_out_b                           (l2b_e_b_abphy[tile_i * PINS_PER_LANE * LANES_PER_TILE + lane_i * PINS_PER_LANE +: PINS_PER_LANE]),

               // Interface to core
               .data_from_core                           (core2l_data[tile_i][lane_i]),
               .data_to_core                             (l2core_data_abphy[tile_i][lane_i]),
               // core2l_oe is inverted before feeding into the lane because
               // oe_invert is always set to true as required by HMC and sequencer
               .oe_from_core                             (~core2l_oe[tile_i][lane_i]),
               .rdata_en_full_core                       ((`_get_lane_usage(tile_i, lane_i) == LANE_USAGE_RDATA || `_get_lane_usage(tile_i, lane_i) == LANE_USAGE_WRDATA) ? core2l_rdata_en_full[tile_i][lane_i] : 4'b0),
               .mrnk_read_core                           ((`_get_lane_usage(tile_i, lane_i) == LANE_USAGE_RDATA || `_get_lane_usage(tile_i, lane_i) == LANE_USAGE_WRDATA) ? core2l_mrnk_read[tile_i][lane_i]     : 16'b0),
               .mrnk_write_core                          ((`_get_lane_usage(tile_i, lane_i) == LANE_USAGE_WDATA || `_get_lane_usage(tile_i, lane_i) == LANE_USAGE_WRDATA) ? core2l_mrnk_write[tile_i][lane_i]    : 16'b0),
               .rdata_valid_core                         (l2core_rdata_valid_abphy[tile_i][lane_i]),
               .afi_wlat_core                            (l2core_afi_wlat_abphy[tile_i][lane_i]),
               .afi_rlat_core                            (l2core_afi_rlat_abphy[tile_i][lane_i]),

               // Data Buffer Interface to Core
               .dbc2core_rd_data_vld0                    (l2core_rd_data_vld_avl0_abphy[tile_i][lane_i]),
               .dbc2core_rd_data_vld1                    (),
               .core2dbc_wr_data_vld0                    (`_get_core2dbc_wr_data_vld(tile_i, lane_i)),
               .core2dbc_wr_data_vld1                    (1'b0),
               .dbc2core_wr_data_rdy                     (l2core_wr_data_rdy_ast_abphy [tile_i][lane_i]),
               .core2dbc_rd_data_rdy                     (`_get_core2dbc_rd_data_rdy(tile_i, lane_i)),
               .dbc2core_wb_pointer                      (l2core_wb_pointer_for_ecc_abphy[tile_i][lane_i]),
               .core2dbc_wr_ecc_info                     (`_get_core2dbc_wr_ecc_info(tile_i, lane_i)),
               .dbc2core_rd_type                         (),

               // Calibration bus between Nios and sequencer (a.k.a slow Avalon-MM bus)
               .reset_n                                  (1'b1),
               .cal_avl_in                               (cal_bus_avl_up_chain          [`_get_chain_index_for_lane(tile_i, lane_i)]),
               .cal_avl_out                              (cal_bus_avl_up_chain          [`_get_chain_index_for_lane(tile_i, lane_i) + 1]),
               .cal_avl_readdata_in                      (cal_bus_avl_read_data_dn_chain[`_get_chain_index_for_lane(tile_i, lane_i) + 1]),
               .cal_avl_readdata_out                     (cal_bus_avl_read_data_dn_chain[`_get_chain_index_for_lane(tile_i, lane_i)]),

               // HMC interface
               .ac_hmc                                   (`_get_ac_hmc(tile_i, lane_i)),
               .ctl2dbc0                                 (all_tiles_ctl2dbc0_dn_chain[tile_i]),
               .ctl2dbc1                                 (all_tiles_ctl2dbc1_up_chain[tile_i + 1]),
               .cfg_dbc                                  (t2l_cfg_dbc[lane_i]),
               .dbc2ctl                                  (),

               // Broadcast signals
               .broadcast_in_bot                         (broadcast_up_chain[`_get_broadcast_chain_index(tile_i, lane_i)]),
               .broadcast_out_top                        (broadcast_up_chain[`_get_broadcast_chain_index(tile_i, lane_i) + 1]),
               .broadcast_in_top                         (broadcast_dn_chain[`_get_broadcast_chain_index(tile_i, lane_i) + 1]),
               .broadcast_out_bot                        (broadcast_dn_chain[`_get_broadcast_chain_index(tile_i, lane_i)]),

               // Unused signals
               .dft_phy_clk                              ()
            );
         end
      end
   endgenerate
   
   mem_array_abphy #(
     .MEM_ABPHY_VERBOSE                         (MEM_ABPHY_VERBOSE),
     .DIAG_SIM_MEMORY_PRELOAD                   (DIAG_SIM_MEMORY_PRELOAD),
     .DIAG_SIM_MEMORY_PRELOAD_PRI_ABPHY_FILE    (DIAG_SIM_MEMORY_PRELOAD_PRI_ABPHY_FILE),
     .DIAG_SIM_MEMORY_PRELOAD_SEC_ABPHY_FILE    (DIAG_SIM_MEMORY_PRELOAD_SEC_ABPHY_FILE),
     .NUM_OF_RTL_TILES                          (NUM_OF_RTL_TILES),
     .LANES_PER_TILE                            (LANES_PER_TILE),
     .USER_CLK_RATIO                            (USER_CLK_RATIO),
     .PINS_RATE                                 (PINS_RATE),
     .MEM_DATA_MASK_EN                          (MEM_DATA_MASK_EN),
     .PHY_HMC_CLK_RATIO                         (PHY_HMC_CLK_RATIO),
     .NUM_OF_HMC_PORTS                          (NUM_OF_HMC_PORTS),
     .PORT_MEM_A_PINLOC                         (PORT_MEM_A_PINLOC),
     .PORT_MEM_BA_PINLOC                        (PORT_MEM_BA_PINLOC),
     .PORT_MEM_BG_PINLOC                        (PORT_MEM_BG_PINLOC),
     .PORT_MEM_C_PINLOC                         (PORT_MEM_C_PINLOC),
     .PORT_MEM_CS_N_PINLOC                      (PORT_MEM_CS_N_PINLOC),
     .PORT_MEM_ACT_N_PINLOC                     (PORT_MEM_ACT_N_PINLOC),
     .PORT_MEM_DQ_PINLOC                        (PORT_MEM_DQ_PINLOC),
     .PORT_MEM_DBI_N_PINLOC                     (PORT_MEM_DBI_N_PINLOC),
     .PORT_MEM_RAS_N_PINLOC                     (PORT_MEM_RAS_N_PINLOC),
     .PORT_MEM_CAS_N_PINLOC                     (PORT_MEM_CAS_N_PINLOC),
     .PORT_MEM_WE_N_PINLOC                      (PORT_MEM_WE_N_PINLOC),
     .PORT_MEM_DQ_WIDTH                         (PORT_MEM_DQ_WIDTH),
     .PORT_MEM_DM_WIDTH                         (PORT_MEM_DM_WIDTH),
     .PORT_MEM_DM_PINLOC                        (PORT_MEM_DM_PINLOC),
     .PORT_MEM_REF_N_PINLOC                     (PORT_MEM_REF_N_PINLOC),
     .PORT_MEM_WPS_N_PINLOC                     (PORT_MEM_WPS_N_PINLOC),
     .PORT_MEM_RPS_N_PINLOC                     (PORT_MEM_RPS_N_PINLOC),
     .PORT_MEM_BWS_N_PINLOC                     (PORT_MEM_BWS_N_PINLOC),
     .PORT_MEM_DQA_PINLOC                       (PORT_MEM_DQA_PINLOC),
     .PORT_MEM_DQB_PINLOC                       (PORT_MEM_DQB_PINLOC),
     .PORT_MEM_Q_PINLOC                         (PORT_MEM_Q_PINLOC),
     .PORT_MEM_D_PINLOC                         (PORT_MEM_D_PINLOC),
     .PORT_MEM_RWA_N_PINLOC                     (PORT_MEM_RWA_N_PINLOC),
     .PORT_MEM_RWB_N_PINLOC                     (PORT_MEM_RWB_N_PINLOC),
     .PORT_MEM_QKA_PINLOC                       (PORT_MEM_QKA_PINLOC),
     .PORT_MEM_QKB_PINLOC                       (PORT_MEM_QKB_PINLOC),
     .PORT_MEM_LDA_N_PINLOC                     (PORT_MEM_LDA_N_PINLOC),
     .PORT_MEM_LDB_N_PINLOC                     (PORT_MEM_LDB_N_PINLOC),
     .PORT_MEM_CK_PINLOC                        (PORT_MEM_CK_PINLOC),
     .PORT_MEM_DINVA_PINLOC                     (PORT_MEM_DINVA_PINLOC),
     .PORT_MEM_DINVB_PINLOC                     (PORT_MEM_DINVB_PINLOC),
     .PORT_MEM_AINV_PINLOC                      (PORT_MEM_AINV_PINLOC),
     .PORT_MEM_A_WIDTH                          (PORT_MEM_A_WIDTH),
     .PORT_MEM_BA_WIDTH                         (PORT_MEM_BA_WIDTH),
     .PORT_MEM_BG_WIDTH                         (PORT_MEM_BG_WIDTH),
     .PORT_MEM_C_WIDTH                          (PORT_MEM_C_WIDTH),
     .PORT_MEM_CS_N_WIDTH                       (PORT_MEM_CS_N_WIDTH),
     .PORT_MEM_ACT_N_WIDTH                      (PORT_MEM_ACT_N_WIDTH),
     .PORT_MEM_DBI_N_WIDTH                      (PORT_MEM_DBI_N_WIDTH),
     .PORT_MEM_RAS_N_WIDTH                      (PORT_MEM_RAS_N_WIDTH),
     .PORT_MEM_CAS_N_WIDTH                      (PORT_MEM_CAS_N_WIDTH),
     .PORT_MEM_WE_N_WIDTH                       (PORT_MEM_WE_N_WIDTH),
     .PORT_MEM_REF_N_WIDTH                      (PORT_MEM_REF_N_WIDTH),
     .PORT_MEM_WPS_N_WIDTH                      (PORT_MEM_WPS_N_WIDTH),
     .PORT_MEM_RPS_N_WIDTH                      (PORT_MEM_RPS_N_WIDTH),
     .PORT_MEM_BWS_N_WIDTH                      (PORT_MEM_BWS_N_WIDTH),
     .PORT_MEM_DQA_WIDTH                        (PORT_MEM_DQA_WIDTH),
     .PORT_MEM_DQB_WIDTH                        (PORT_MEM_DQB_WIDTH),
     .PORT_MEM_Q_WIDTH                          (PORT_MEM_Q_WIDTH),
     .PORT_MEM_D_WIDTH                          (PORT_MEM_D_WIDTH),
     .PORT_MEM_RWA_N_WIDTH                      (PORT_MEM_RWA_N_WIDTH),
     .PORT_MEM_RWB_N_WIDTH                      (PORT_MEM_RWB_N_WIDTH),
     .PORT_MEM_QKA_WIDTH                        (PORT_MEM_QKA_WIDTH),
     .PORT_MEM_QKB_WIDTH                        (PORT_MEM_QKB_WIDTH),
     .PORT_MEM_LDA_N_WIDTH                      (PORT_MEM_LDA_N_WIDTH),
     .PORT_MEM_LDB_N_WIDTH                      (PORT_MEM_LDB_N_WIDTH),
     .PORT_MEM_CK_WIDTH                         (PORT_MEM_CK_WIDTH),
     .PORT_MEM_DINVA_WIDTH                      (PORT_MEM_DINVA_WIDTH),
     .PORT_MEM_DINVB_WIDTH                      (PORT_MEM_DINVB_WIDTH),
     .PORT_MEM_AINV_WIDTH                       (PORT_MEM_AINV_WIDTH),
     .PHY_PING_PONG_EN                          (PHY_PING_PONG_EN),
     .PROTOCOL_ENUM                             (PROTOCOL_ENUM),
     .DBI_WR_ENABLE                             (DBI_WR_ENABLE),
     .DBI_RD_ENABLE                             (DBI_RD_ENABLE),
     .PRI_HMC_CFG_MEM_IF_COLADDR_WIDTH          (PRI_HMC_CFG_COL_ADDR_WIDTH),
     .PRI_HMC_CFG_MEM_IF_ROWADDR_WIDTH          (PRI_HMC_CFG_ROW_ADDR_WIDTH), 
     .SEC_HMC_CFG_MEM_IF_COLADDR_WIDTH          (SEC_HMC_CFG_COL_ADDR_WIDTH), 
     .SEC_HMC_CFG_MEM_IF_ROWADDR_WIDTH          (SEC_HMC_CFG_ROW_ADDR_WIDTH),
     .MEM_BURST_LENGTH                          (MEM_BURST_LENGTH),
     .ABPHY_WRITE_PROTOCOL                      (ABPHY_WRITE_PROTOCOL),
     .DIAG_SIM_MEM_BYPASS_DQ_WIDTH                       (DIAG_SIM_MEM_BYPASS_DQ_WIDTH),   
     .DIAG_SIM_MEM_BYPASS_ADDR_WIDTH                     (DIAG_SIM_MEM_BYPASS_ADDR_WIDTH),
     .PHY_CONFIG_ENUM                           (PHY_CONFIG_ENUM),
     .MEM_ROW_ADDR_WIDTH                        (MEM_ROW_ADDR_WIDTH),
     .MEM_COL_ADDR_WIDTH                        (MEM_COL_ADDR_WIDTH),
     .HMC_CFG_ADDR_ORDER                        (HMC_CFG_ADDR_ORDER),   
     .HMC_CFG_CS_ADDR_WIDTH                     (HMC_CFG_CS_ADDR_WIDTH),
     .HMC_CFG_ROW_ADDR_WIDTH                    (HMC_CFG_ROW_ADDR_WIDTH)
   ) mem_array_abphy_inst (
     .phy_clk                                   (all_tiles_t2l_phy_clk[0][0][0]),
     .reset_n                                   (~core2seq_reset_req),
     .select_ac_hmc                             (),
     .afi_rlat                                  (l2core_afi_rlat_abphy),
     .afi_wlat                                  (l2core_afi_wlat_abphy),
     .ac_hmc                                    (ac_hmc_par),
     .dq_data_to_mem                            (dq_data_to_mem),
     .dq_oe                                     (dq_oe),
     .rdata_valid_local                         (rdata_valid_local),
     .afi_cal_success                           (afi_cal_success),
     .dq_data_from_mem                          (dq_data_from_mem),
     .runAbstractPhySim                         (runAbstractPhySim)
   );
   
   assign cal_bus_clk_force=0;
   assign cal_bus_avl_write_force=0;
   assign cal_bus_avl_address_force=0;
   assign cal_bus_avl_write_data_force=0;
   
   
   initial begin
   end
   // synthesis translate_on
   
endmodule

`undef _get_pin_dqs_mode_str
`undef _get_hmc_ctrl_mem_type
`undef _get_dqsin
`undef _get_preamble_track_dqs_enable_mode
`undef _get_pst_preamble_mode
`undef _get_pin_pair_mode
`undef _get_pst_en_shrink
`undef _get_x18_0_lane
`undef _get_x18_1_lane
