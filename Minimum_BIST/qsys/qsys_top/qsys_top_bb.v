module qsys_top (
		input  wire [1:0]  bmc_to_pcie_irq_generator_0_ext_irq_interface_irq_in,                  // bmc_to_pcie_irq_generator_0_ext_irq_interface.irq_in
		output wire        pcie_irq_irq,                                                          //                                      pcie_irq.irq
		input  wire [1:0]  pcie_to_bmc_irq_generator_0_ext_irq_interface_irq_in,                  // pcie_to_bmc_irq_generator_0_ext_irq_interface.irq_in
		output wire        bmc_irq_irq,                                                           //                                       bmc_irq.irq
		output wire        pcie_user_clk_clk,                                                     //                                 pcie_user_clk.clk
		input  wire        config_clk_clk,                                                        //                                    config_clk.clk
		input  wire        config_rstn_reset_n,                                                   //                                   config_rstn.reset_n
		input  wire        avmm_master_waitrequest,                                               //                                   avmm_master.waitrequest
		input  wire [31:0] avmm_master_readdata,                                                  //                                              .readdata
		input  wire        avmm_master_readdatavalid,                                             //                                              .readdatavalid
		output wire [0:0]  avmm_master_burstcount,                                                //                                              .burstcount
		output wire [31:0] avmm_master_writedata,                                                 //                                              .writedata
		output wire [11:0] avmm_master_address,                                                   //                                              .address
		output wire        avmm_master_write,                                                     //                                              .write
		output wire        avmm_master_read,                                                      //                                              .read
		output wire [3:0]  avmm_master_byteenable,                                                //                                              .byteenable
		output wire        avmm_master_debugaccess,                                               //                                              .debugaccess
		input  wire        pcie_refclk_clk,                                                       //                                   pcie_refclk.clk
		input  wire        pcie_npor_npor,                                                        //                                     pcie_npor.npor
		input  wire        pcie_npor_pin_perst,                                                   //                                              .pin_perst
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_ninit_done_ninit_done,              // qsys_top_pcie_s10_hip_avmm_gen3x16_ninit_done.ninit_done
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_flr_ctrl_flr_pf_done,               //   qsys_top_pcie_s10_hip_avmm_gen3x16_flr_ctrl.flr_pf_done
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_flr_ctrl_flr_pf_active,             //                                              .flr_pf_active
		input  wire        pcie_hip_ctrl_simu_mode_pipe,                                          //                                 pcie_hip_ctrl.simu_mode_pipe
		input  wire [66:0] pcie_hip_ctrl_test_in,                                                 //                                              .test_in
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_sim_pipe_pclk_in,          //   qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe.sim_pipe_pclk_in
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_sim_pipe_rate,             //                                              .sim_pipe_rate
		output wire [5:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_sim_ltssmstate,            //                                              .sim_ltssmstate
		output wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdata0,                   //                                              .txdata0
		output wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdata1,                   //                                              .txdata1
		output wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdata2,                   //                                              .txdata2
		output wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdata3,                   //                                              .txdata3
		output wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdata4,                   //                                              .txdata4
		output wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdata5,                   //                                              .txdata5
		output wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdata6,                   //                                              .txdata6
		output wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdata7,                   //                                              .txdata7
		output wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdata8,                   //                                              .txdata8
		output wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdata9,                   //                                              .txdata9
		output wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdata10,                  //                                              .txdata10
		output wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdata11,                  //                                              .txdata11
		output wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdata12,                  //                                              .txdata12
		output wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdata13,                  //                                              .txdata13
		output wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdata14,                  //                                              .txdata14
		output wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdata15,                  //                                              .txdata15
		output wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdatak0,                  //                                              .txdatak0
		output wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdatak1,                  //                                              .txdatak1
		output wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdatak2,                  //                                              .txdatak2
		output wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdatak3,                  //                                              .txdatak3
		output wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdatak4,                  //                                              .txdatak4
		output wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdatak5,                  //                                              .txdatak5
		output wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdatak6,                  //                                              .txdatak6
		output wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdatak7,                  //                                              .txdatak7
		output wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdatak8,                  //                                              .txdatak8
		output wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdatak9,                  //                                              .txdatak9
		output wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdatak10,                 //                                              .txdatak10
		output wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdatak11,                 //                                              .txdatak11
		output wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdatak12,                 //                                              .txdatak12
		output wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdatak13,                 //                                              .txdatak13
		output wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdatak14,                 //                                              .txdatak14
		output wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdatak15,                 //                                              .txdatak15
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txcompl0,                  //                                              .txcompl0
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txcompl1,                  //                                              .txcompl1
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txcompl2,                  //                                              .txcompl2
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txcompl3,                  //                                              .txcompl3
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txcompl4,                  //                                              .txcompl4
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txcompl5,                  //                                              .txcompl5
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txcompl6,                  //                                              .txcompl6
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txcompl7,                  //                                              .txcompl7
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txcompl8,                  //                                              .txcompl8
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txcompl9,                  //                                              .txcompl9
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txcompl10,                 //                                              .txcompl10
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txcompl11,                 //                                              .txcompl11
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txcompl12,                 //                                              .txcompl12
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txcompl13,                 //                                              .txcompl13
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txcompl14,                 //                                              .txcompl14
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txcompl15,                 //                                              .txcompl15
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txelecidle0,               //                                              .txelecidle0
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txelecidle1,               //                                              .txelecidle1
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txelecidle2,               //                                              .txelecidle2
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txelecidle3,               //                                              .txelecidle3
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txelecidle4,               //                                              .txelecidle4
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txelecidle5,               //                                              .txelecidle5
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txelecidle6,               //                                              .txelecidle6
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txelecidle7,               //                                              .txelecidle7
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txelecidle8,               //                                              .txelecidle8
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txelecidle9,               //                                              .txelecidle9
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txelecidle10,              //                                              .txelecidle10
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txelecidle11,              //                                              .txelecidle11
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txelecidle12,              //                                              .txelecidle12
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txelecidle13,              //                                              .txelecidle13
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txelecidle14,              //                                              .txelecidle14
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txelecidle15,              //                                              .txelecidle15
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdetectrx0,               //                                              .txdetectrx0
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdetectrx1,               //                                              .txdetectrx1
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdetectrx2,               //                                              .txdetectrx2
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdetectrx3,               //                                              .txdetectrx3
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdetectrx4,               //                                              .txdetectrx4
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdetectrx5,               //                                              .txdetectrx5
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdetectrx6,               //                                              .txdetectrx6
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdetectrx7,               //                                              .txdetectrx7
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdetectrx8,               //                                              .txdetectrx8
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdetectrx9,               //                                              .txdetectrx9
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdetectrx10,              //                                              .txdetectrx10
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdetectrx11,              //                                              .txdetectrx11
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdetectrx12,              //                                              .txdetectrx12
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdetectrx13,              //                                              .txdetectrx13
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdetectrx14,              //                                              .txdetectrx14
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdetectrx15,              //                                              .txdetectrx15
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_powerdown0,                //                                              .powerdown0
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_powerdown1,                //                                              .powerdown1
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_powerdown2,                //                                              .powerdown2
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_powerdown3,                //                                              .powerdown3
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_powerdown4,                //                                              .powerdown4
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_powerdown5,                //                                              .powerdown5
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_powerdown6,                //                                              .powerdown6
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_powerdown7,                //                                              .powerdown7
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_powerdown8,                //                                              .powerdown8
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_powerdown9,                //                                              .powerdown9
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_powerdown10,               //                                              .powerdown10
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_powerdown11,               //                                              .powerdown11
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_powerdown12,               //                                              .powerdown12
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_powerdown13,               //                                              .powerdown13
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_powerdown14,               //                                              .powerdown14
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_powerdown15,               //                                              .powerdown15
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txmargin0,                 //                                              .txmargin0
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txmargin1,                 //                                              .txmargin1
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txmargin2,                 //                                              .txmargin2
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txmargin3,                 //                                              .txmargin3
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txmargin4,                 //                                              .txmargin4
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txmargin5,                 //                                              .txmargin5
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txmargin6,                 //                                              .txmargin6
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txmargin7,                 //                                              .txmargin7
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txmargin8,                 //                                              .txmargin8
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txmargin9,                 //                                              .txmargin9
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txmargin10,                //                                              .txmargin10
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txmargin11,                //                                              .txmargin11
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txmargin12,                //                                              .txmargin12
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txmargin13,                //                                              .txmargin13
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txmargin14,                //                                              .txmargin14
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txmargin15,                //                                              .txmargin15
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdeemph0,                 //                                              .txdeemph0
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdeemph1,                 //                                              .txdeemph1
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdeemph2,                 //                                              .txdeemph2
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdeemph3,                 //                                              .txdeemph3
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdeemph4,                 //                                              .txdeemph4
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdeemph5,                 //                                              .txdeemph5
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdeemph6,                 //                                              .txdeemph6
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdeemph7,                 //                                              .txdeemph7
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdeemph8,                 //                                              .txdeemph8
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdeemph9,                 //                                              .txdeemph9
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdeemph10,                //                                              .txdeemph10
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdeemph11,                //                                              .txdeemph11
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdeemph12,                //                                              .txdeemph12
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdeemph13,                //                                              .txdeemph13
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdeemph14,                //                                              .txdeemph14
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdeemph15,                //                                              .txdeemph15
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txswing0,                  //                                              .txswing0
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txswing1,                  //                                              .txswing1
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txswing2,                  //                                              .txswing2
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txswing3,                  //                                              .txswing3
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txswing4,                  //                                              .txswing4
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txswing5,                  //                                              .txswing5
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txswing6,                  //                                              .txswing6
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txswing7,                  //                                              .txswing7
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txswing8,                  //                                              .txswing8
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txswing9,                  //                                              .txswing9
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txswing10,                 //                                              .txswing10
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txswing11,                 //                                              .txswing11
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txswing12,                 //                                              .txswing12
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txswing13,                 //                                              .txswing13
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txswing14,                 //                                              .txswing14
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txswing15,                 //                                              .txswing15
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txsynchd0,                 //                                              .txsynchd0
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txsynchd1,                 //                                              .txsynchd1
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txsynchd2,                 //                                              .txsynchd2
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txsynchd3,                 //                                              .txsynchd3
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txsynchd4,                 //                                              .txsynchd4
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txsynchd5,                 //                                              .txsynchd5
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txsynchd6,                 //                                              .txsynchd6
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txsynchd7,                 //                                              .txsynchd7
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txsynchd8,                 //                                              .txsynchd8
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txsynchd9,                 //                                              .txsynchd9
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txsynchd10,                //                                              .txsynchd10
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txsynchd11,                //                                              .txsynchd11
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txsynchd12,                //                                              .txsynchd12
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txsynchd13,                //                                              .txsynchd13
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txsynchd14,                //                                              .txsynchd14
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txsynchd15,                //                                              .txsynchd15
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txblkst0,                  //                                              .txblkst0
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txblkst1,                  //                                              .txblkst1
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txblkst2,                  //                                              .txblkst2
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txblkst3,                  //                                              .txblkst3
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txblkst4,                  //                                              .txblkst4
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txblkst5,                  //                                              .txblkst5
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txblkst6,                  //                                              .txblkst6
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txblkst7,                  //                                              .txblkst7
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txblkst8,                  //                                              .txblkst8
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txblkst9,                  //                                              .txblkst9
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txblkst10,                 //                                              .txblkst10
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txblkst11,                 //                                              .txblkst11
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txblkst12,                 //                                              .txblkst12
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txblkst13,                 //                                              .txblkst13
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txblkst14,                 //                                              .txblkst14
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txblkst15,                 //                                              .txblkst15
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdataskip0,               //                                              .txdataskip0
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdataskip1,               //                                              .txdataskip1
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdataskip2,               //                                              .txdataskip2
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdataskip3,               //                                              .txdataskip3
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdataskip4,               //                                              .txdataskip4
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdataskip5,               //                                              .txdataskip5
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdataskip6,               //                                              .txdataskip6
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdataskip7,               //                                              .txdataskip7
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdataskip8,               //                                              .txdataskip8
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdataskip9,               //                                              .txdataskip9
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdataskip10,              //                                              .txdataskip10
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdataskip11,              //                                              .txdataskip11
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdataskip12,              //                                              .txdataskip12
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdataskip13,              //                                              .txdataskip13
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdataskip14,              //                                              .txdataskip14
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_txdataskip15,              //                                              .txdataskip15
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rate0,                     //                                              .rate0
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rate1,                     //                                              .rate1
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rate2,                     //                                              .rate2
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rate3,                     //                                              .rate3
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rate4,                     //                                              .rate4
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rate5,                     //                                              .rate5
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rate6,                     //                                              .rate6
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rate7,                     //                                              .rate7
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rate8,                     //                                              .rate8
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rate9,                     //                                              .rate9
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rate10,                    //                                              .rate10
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rate11,                    //                                              .rate11
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rate12,                    //                                              .rate12
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rate13,                    //                                              .rate13
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rate14,                    //                                              .rate14
		output wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rate15,                    //                                              .rate15
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxpolarity0,               //                                              .rxpolarity0
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxpolarity1,               //                                              .rxpolarity1
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxpolarity2,               //                                              .rxpolarity2
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxpolarity3,               //                                              .rxpolarity3
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxpolarity4,               //                                              .rxpolarity4
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxpolarity5,               //                                              .rxpolarity5
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxpolarity6,               //                                              .rxpolarity6
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxpolarity7,               //                                              .rxpolarity7
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxpolarity8,               //                                              .rxpolarity8
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxpolarity9,               //                                              .rxpolarity9
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxpolarity10,              //                                              .rxpolarity10
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxpolarity11,              //                                              .rxpolarity11
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxpolarity12,              //                                              .rxpolarity12
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxpolarity13,              //                                              .rxpolarity13
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxpolarity14,              //                                              .rxpolarity14
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxpolarity15,              //                                              .rxpolarity15
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentrxpreset0,          //                                              .currentrxpreset0
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentrxpreset1,          //                                              .currentrxpreset1
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentrxpreset2,          //                                              .currentrxpreset2
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentrxpreset3,          //                                              .currentrxpreset3
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentrxpreset4,          //                                              .currentrxpreset4
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentrxpreset5,          //                                              .currentrxpreset5
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentrxpreset6,          //                                              .currentrxpreset6
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentrxpreset7,          //                                              .currentrxpreset7
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentrxpreset8,          //                                              .currentrxpreset8
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentrxpreset9,          //                                              .currentrxpreset9
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentrxpreset10,         //                                              .currentrxpreset10
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentrxpreset11,         //                                              .currentrxpreset11
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentrxpreset12,         //                                              .currentrxpreset12
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentrxpreset13,         //                                              .currentrxpreset13
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentrxpreset14,         //                                              .currentrxpreset14
		output wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentrxpreset15,         //                                              .currentrxpreset15
		output wire [17:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentcoeff0,             //                                              .currentcoeff0
		output wire [17:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentcoeff1,             //                                              .currentcoeff1
		output wire [17:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentcoeff2,             //                                              .currentcoeff2
		output wire [17:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentcoeff3,             //                                              .currentcoeff3
		output wire [17:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentcoeff4,             //                                              .currentcoeff4
		output wire [17:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentcoeff5,             //                                              .currentcoeff5
		output wire [17:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentcoeff6,             //                                              .currentcoeff6
		output wire [17:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentcoeff7,             //                                              .currentcoeff7
		output wire [17:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentcoeff8,             //                                              .currentcoeff8
		output wire [17:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentcoeff9,             //                                              .currentcoeff9
		output wire [17:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentcoeff10,            //                                              .currentcoeff10
		output wire [17:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentcoeff11,            //                                              .currentcoeff11
		output wire [17:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentcoeff12,            //                                              .currentcoeff12
		output wire [17:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentcoeff13,            //                                              .currentcoeff13
		output wire [17:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentcoeff14,            //                                              .currentcoeff14
		output wire [17:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_currentcoeff15,            //                                              .currentcoeff15
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqeval0,                 //                                              .rxeqeval0
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqeval1,                 //                                              .rxeqeval1
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqeval2,                 //                                              .rxeqeval2
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqeval3,                 //                                              .rxeqeval3
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqeval4,                 //                                              .rxeqeval4
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqeval5,                 //                                              .rxeqeval5
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqeval6,                 //                                              .rxeqeval6
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqeval7,                 //                                              .rxeqeval7
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqeval8,                 //                                              .rxeqeval8
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqeval9,                 //                                              .rxeqeval9
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqeval10,                //                                              .rxeqeval10
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqeval11,                //                                              .rxeqeval11
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqeval12,                //                                              .rxeqeval12
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqeval13,                //                                              .rxeqeval13
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqeval14,                //                                              .rxeqeval14
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqeval15,                //                                              .rxeqeval15
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqinprogress0,           //                                              .rxeqinprogress0
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqinprogress1,           //                                              .rxeqinprogress1
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqinprogress2,           //                                              .rxeqinprogress2
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqinprogress3,           //                                              .rxeqinprogress3
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqinprogress4,           //                                              .rxeqinprogress4
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqinprogress5,           //                                              .rxeqinprogress5
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqinprogress6,           //                                              .rxeqinprogress6
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqinprogress7,           //                                              .rxeqinprogress7
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqinprogress8,           //                                              .rxeqinprogress8
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqinprogress9,           //                                              .rxeqinprogress9
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqinprogress10,          //                                              .rxeqinprogress10
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqinprogress11,          //                                              .rxeqinprogress11
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqinprogress12,          //                                              .rxeqinprogress12
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqinprogress13,          //                                              .rxeqinprogress13
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqinprogress14,          //                                              .rxeqinprogress14
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxeqinprogress15,          //                                              .rxeqinprogress15
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_invalidreq0,               //                                              .invalidreq0
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_invalidreq1,               //                                              .invalidreq1
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_invalidreq2,               //                                              .invalidreq2
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_invalidreq3,               //                                              .invalidreq3
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_invalidreq4,               //                                              .invalidreq4
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_invalidreq5,               //                                              .invalidreq5
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_invalidreq6,               //                                              .invalidreq6
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_invalidreq7,               //                                              .invalidreq7
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_invalidreq8,               //                                              .invalidreq8
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_invalidreq9,               //                                              .invalidreq9
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_invalidreq10,              //                                              .invalidreq10
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_invalidreq11,              //                                              .invalidreq11
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_invalidreq12,              //                                              .invalidreq12
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_invalidreq13,              //                                              .invalidreq13
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_invalidreq14,              //                                              .invalidreq14
		output wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_invalidreq15,              //                                              .invalidreq15
		input  wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdata0,                   //                                              .rxdata0
		input  wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdata1,                   //                                              .rxdata1
		input  wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdata2,                   //                                              .rxdata2
		input  wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdata3,                   //                                              .rxdata3
		input  wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdata4,                   //                                              .rxdata4
		input  wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdata5,                   //                                              .rxdata5
		input  wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdata6,                   //                                              .rxdata6
		input  wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdata7,                   //                                              .rxdata7
		input  wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdata8,                   //                                              .rxdata8
		input  wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdata9,                   //                                              .rxdata9
		input  wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdata10,                  //                                              .rxdata10
		input  wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdata11,                  //                                              .rxdata11
		input  wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdata12,                  //                                              .rxdata12
		input  wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdata13,                  //                                              .rxdata13
		input  wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdata14,                  //                                              .rxdata14
		input  wire [31:0] qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdata15,                  //                                              .rxdata15
		input  wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdatak0,                  //                                              .rxdatak0
		input  wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdatak1,                  //                                              .rxdatak1
		input  wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdatak2,                  //                                              .rxdatak2
		input  wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdatak3,                  //                                              .rxdatak3
		input  wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdatak4,                  //                                              .rxdatak4
		input  wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdatak5,                  //                                              .rxdatak5
		input  wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdatak6,                  //                                              .rxdatak6
		input  wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdatak7,                  //                                              .rxdatak7
		input  wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdatak8,                  //                                              .rxdatak8
		input  wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdatak9,                  //                                              .rxdatak9
		input  wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdatak10,                 //                                              .rxdatak10
		input  wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdatak11,                 //                                              .rxdatak11
		input  wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdatak12,                 //                                              .rxdatak12
		input  wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdatak13,                 //                                              .rxdatak13
		input  wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdatak14,                 //                                              .rxdatak14
		input  wire [3:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdatak15,                 //                                              .rxdatak15
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_phystatus0,                //                                              .phystatus0
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_phystatus1,                //                                              .phystatus1
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_phystatus2,                //                                              .phystatus2
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_phystatus3,                //                                              .phystatus3
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_phystatus4,                //                                              .phystatus4
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_phystatus5,                //                                              .phystatus5
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_phystatus6,                //                                              .phystatus6
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_phystatus7,                //                                              .phystatus7
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_phystatus8,                //                                              .phystatus8
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_phystatus9,                //                                              .phystatus9
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_phystatus10,               //                                              .phystatus10
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_phystatus11,               //                                              .phystatus11
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_phystatus12,               //                                              .phystatus12
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_phystatus13,               //                                              .phystatus13
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_phystatus14,               //                                              .phystatus14
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_phystatus15,               //                                              .phystatus15
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxvalid0,                  //                                              .rxvalid0
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxvalid1,                  //                                              .rxvalid1
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxvalid2,                  //                                              .rxvalid2
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxvalid3,                  //                                              .rxvalid3
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxvalid4,                  //                                              .rxvalid4
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxvalid5,                  //                                              .rxvalid5
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxvalid6,                  //                                              .rxvalid6
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxvalid7,                  //                                              .rxvalid7
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxvalid8,                  //                                              .rxvalid8
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxvalid9,                  //                                              .rxvalid9
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxvalid10,                 //                                              .rxvalid10
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxvalid11,                 //                                              .rxvalid11
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxvalid12,                 //                                              .rxvalid12
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxvalid13,                 //                                              .rxvalid13
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxvalid14,                 //                                              .rxvalid14
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxvalid15,                 //                                              .rxvalid15
		input  wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxstatus0,                 //                                              .rxstatus0
		input  wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxstatus1,                 //                                              .rxstatus1
		input  wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxstatus2,                 //                                              .rxstatus2
		input  wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxstatus3,                 //                                              .rxstatus3
		input  wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxstatus4,                 //                                              .rxstatus4
		input  wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxstatus5,                 //                                              .rxstatus5
		input  wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxstatus6,                 //                                              .rxstatus6
		input  wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxstatus7,                 //                                              .rxstatus7
		input  wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxstatus8,                 //                                              .rxstatus8
		input  wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxstatus9,                 //                                              .rxstatus9
		input  wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxstatus10,                //                                              .rxstatus10
		input  wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxstatus11,                //                                              .rxstatus11
		input  wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxstatus12,                //                                              .rxstatus12
		input  wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxstatus13,                //                                              .rxstatus13
		input  wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxstatus14,                //                                              .rxstatus14
		input  wire [2:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxstatus15,                //                                              .rxstatus15
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxelecidle0,               //                                              .rxelecidle0
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxelecidle1,               //                                              .rxelecidle1
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxelecidle2,               //                                              .rxelecidle2
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxelecidle3,               //                                              .rxelecidle3
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxelecidle4,               //                                              .rxelecidle4
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxelecidle5,               //                                              .rxelecidle5
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxelecidle6,               //                                              .rxelecidle6
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxelecidle7,               //                                              .rxelecidle7
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxelecidle8,               //                                              .rxelecidle8
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxelecidle9,               //                                              .rxelecidle9
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxelecidle10,              //                                              .rxelecidle10
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxelecidle11,              //                                              .rxelecidle11
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxelecidle12,              //                                              .rxelecidle12
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxelecidle13,              //                                              .rxelecidle13
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxelecidle14,              //                                              .rxelecidle14
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxelecidle15,              //                                              .rxelecidle15
		input  wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxsynchd0,                 //                                              .rxsynchd0
		input  wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxsynchd1,                 //                                              .rxsynchd1
		input  wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxsynchd2,                 //                                              .rxsynchd2
		input  wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxsynchd3,                 //                                              .rxsynchd3
		input  wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxsynchd4,                 //                                              .rxsynchd4
		input  wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxsynchd5,                 //                                              .rxsynchd5
		input  wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxsynchd6,                 //                                              .rxsynchd6
		input  wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxsynchd7,                 //                                              .rxsynchd7
		input  wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxsynchd8,                 //                                              .rxsynchd8
		input  wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxsynchd9,                 //                                              .rxsynchd9
		input  wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxsynchd10,                //                                              .rxsynchd10
		input  wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxsynchd11,                //                                              .rxsynchd11
		input  wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxsynchd12,                //                                              .rxsynchd12
		input  wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxsynchd13,                //                                              .rxsynchd13
		input  wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxsynchd14,                //                                              .rxsynchd14
		input  wire [1:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxsynchd15,                //                                              .rxsynchd15
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxblkst0,                  //                                              .rxblkst0
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxblkst1,                  //                                              .rxblkst1
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxblkst2,                  //                                              .rxblkst2
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxblkst3,                  //                                              .rxblkst3
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxblkst4,                  //                                              .rxblkst4
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxblkst5,                  //                                              .rxblkst5
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxblkst6,                  //                                              .rxblkst6
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxblkst7,                  //                                              .rxblkst7
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxblkst8,                  //                                              .rxblkst8
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxblkst9,                  //                                              .rxblkst9
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxblkst10,                 //                                              .rxblkst10
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxblkst11,                 //                                              .rxblkst11
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxblkst12,                 //                                              .rxblkst12
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxblkst13,                 //                                              .rxblkst13
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxblkst14,                 //                                              .rxblkst14
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxblkst15,                 //                                              .rxblkst15
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdataskip0,               //                                              .rxdataskip0
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdataskip1,               //                                              .rxdataskip1
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdataskip2,               //                                              .rxdataskip2
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdataskip3,               //                                              .rxdataskip3
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdataskip4,               //                                              .rxdataskip4
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdataskip5,               //                                              .rxdataskip5
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdataskip6,               //                                              .rxdataskip6
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdataskip7,               //                                              .rxdataskip7
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdataskip8,               //                                              .rxdataskip8
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdataskip9,               //                                              .rxdataskip9
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdataskip10,              //                                              .rxdataskip10
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdataskip11,              //                                              .rxdataskip11
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdataskip12,              //                                              .rxdataskip12
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdataskip13,              //                                              .rxdataskip13
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdataskip14,              //                                              .rxdataskip14
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_rxdataskip15,              //                                              .rxdataskip15
		input  wire [5:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_dirfeedback0,              //                                              .dirfeedback0
		input  wire [5:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_dirfeedback1,              //                                              .dirfeedback1
		input  wire [5:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_dirfeedback2,              //                                              .dirfeedback2
		input  wire [5:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_dirfeedback3,              //                                              .dirfeedback3
		input  wire [5:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_dirfeedback4,              //                                              .dirfeedback4
		input  wire [5:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_dirfeedback5,              //                                              .dirfeedback5
		input  wire [5:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_dirfeedback6,              //                                              .dirfeedback6
		input  wire [5:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_dirfeedback7,              //                                              .dirfeedback7
		input  wire [5:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_dirfeedback8,              //                                              .dirfeedback8
		input  wire [5:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_dirfeedback9,              //                                              .dirfeedback9
		input  wire [5:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_dirfeedback10,             //                                              .dirfeedback10
		input  wire [5:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_dirfeedback11,             //                                              .dirfeedback11
		input  wire [5:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_dirfeedback12,             //                                              .dirfeedback12
		input  wire [5:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_dirfeedback13,             //                                              .dirfeedback13
		input  wire [5:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_dirfeedback14,             //                                              .dirfeedback14
		input  wire [5:0]  qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_dirfeedback15,             //                                              .dirfeedback15
		input  wire        qsys_top_pcie_s10_hip_avmm_gen3x16_hip_pipe_sim_pipe_mask_tx_pll_lock, //                                              .sim_pipe_mask_tx_pll_lock
		input  wire        pcie_serial_rx_in0,                                                    //                                   pcie_serial.rx_in0
		input  wire        pcie_serial_rx_in1,                                                    //                                              .rx_in1
		input  wire        pcie_serial_rx_in2,                                                    //                                              .rx_in2
		input  wire        pcie_serial_rx_in3,                                                    //                                              .rx_in3
		input  wire        pcie_serial_rx_in4,                                                    //                                              .rx_in4
		input  wire        pcie_serial_rx_in5,                                                    //                                              .rx_in5
		input  wire        pcie_serial_rx_in6,                                                    //                                              .rx_in6
		input  wire        pcie_serial_rx_in7,                                                    //                                              .rx_in7
		input  wire        pcie_serial_rx_in8,                                                    //                                              .rx_in8
		input  wire        pcie_serial_rx_in9,                                                    //                                              .rx_in9
		input  wire        pcie_serial_rx_in10,                                                   //                                              .rx_in10
		input  wire        pcie_serial_rx_in11,                                                   //                                              .rx_in11
		input  wire        pcie_serial_rx_in12,                                                   //                                              .rx_in12
		input  wire        pcie_serial_rx_in13,                                                   //                                              .rx_in13
		input  wire        pcie_serial_rx_in14,                                                   //                                              .rx_in14
		input  wire        pcie_serial_rx_in15,                                                   //                                              .rx_in15
		output wire        pcie_serial_tx_out0,                                                   //                                              .tx_out0
		output wire        pcie_serial_tx_out1,                                                   //                                              .tx_out1
		output wire        pcie_serial_tx_out2,                                                   //                                              .tx_out2
		output wire        pcie_serial_tx_out3,                                                   //                                              .tx_out3
		output wire        pcie_serial_tx_out4,                                                   //                                              .tx_out4
		output wire        pcie_serial_tx_out5,                                                   //                                              .tx_out5
		output wire        pcie_serial_tx_out6,                                                   //                                              .tx_out6
		output wire        pcie_serial_tx_out7,                                                   //                                              .tx_out7
		output wire        pcie_serial_tx_out8,                                                   //                                              .tx_out8
		output wire        pcie_serial_tx_out9,                                                   //                                              .tx_out9
		output wire        pcie_serial_tx_out10,                                                  //                                              .tx_out10
		output wire        pcie_serial_tx_out11,                                                  //                                              .tx_out11
		output wire        pcie_serial_tx_out12,                                                  //                                              .tx_out12
		output wire        pcie_serial_tx_out13,                                                  //                                              .tx_out13
		output wire        pcie_serial_tx_out14,                                                  //                                              .tx_out14
		output wire        pcie_serial_tx_out15,                                                  //                                              .tx_out15
		input  wire        spi_mosi_to_the_spislave_inst_for_spichain,                            //                                           spi.mosi_to_the_spislave_inst_for_spichain
		input  wire        spi_nss_to_the_spislave_inst_for_spichain,                             //                                              .nss_to_the_spislave_inst_for_spichain
		input  wire        spi_sclk_to_the_spislave_inst_for_spichain,                            //                                              .sclk_to_the_spislave_inst_for_spichain
		inout  wire        spi_miso_to_and_from_the_spislave_inst_for_spichain,                   //                                              .miso_to_and_from_the_spislave_inst_for_spichain
		output wire        pcie_user_rst_reset,                                                   //                                 pcie_user_rst.reset
		input  wire [31:0] system_arbiter_0_hps_gp_if_gp_out,                                     //                    system_arbiter_0_hps_gp_if.gp_out
		output wire [31:0] system_arbiter_0_hps_gp_if_gp_in,                                      //                                              .gp_in
		inout  wire [7:0]  conf_d_conf_d,                                                         //                                        conf_d.conf_d
		output wire        soft_recfg_req_n_soft_reconfigure_req_n,                               //                              soft_recfg_req_n.soft_reconfigure_req_n
		output wire [3:0]  conf_c_out_conf_c_out,                                                 //                                    conf_c_out.conf_c_out
		input  wire [3:0]  conf_c_in_conf_c_in                                                    //                                     conf_c_in.conf_c_in
	);
endmodule

