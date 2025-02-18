module qsys_top_avmm_bridge_512_0 (
		input  wire         refclk,                    //            refclk.clk,                       Check User Guide for details
		output wire         coreclkout_hip,            //    coreclkout_hip.clk,                       Check User Guide for details
		input  wire         npor,                      //              npor.npor,                      Check User Guide for details
		input  wire         pin_perst,                 //                  .pin_perst,                 Check User Guide for details
		output wire         app_nreset_status,         // app_nreset_status.reset_n,                   Check User Guide for details
		input  wire         ninit_done,                //        ninit_done.ninit_done,                Check User Guide for details
		output wire [1:0]   bam_pfnum_o,               //       bam_conduit.pfnum,                     Check User Guide for details
		output wire [2:0]   bam_bar_o,                 //                  .barnum,                    Check User Guide for details
		input  wire         bam_waitrequest_i,         //        bam_master.waitrequest,               Check User Guide for details
		output wire [19:0]  bam_address_o,             //                  .address,                   Check User Guide for details
		output wire [63:0]  bam_byteenable_o,          //                  .byteenable,                Check User Guide for details
		output wire         bam_read_o,                //                  .read,                      Check User Guide for details
		input  wire [511:0] bam_readdata_i,            //                  .readdata,                  Check User Guide for details
		input  wire         bam_readdatavalid_i,       //                  .readdatavalid,             Check User Guide for details
		output wire         bam_write_o,               //                  .write,                     Check User Guide for details
		output wire [511:0] bam_writedata_o,           //                  .writedata,                 Check User Guide for details
		output wire [3:0]   bam_burstcount_o,          //                  .burstcount,                Check User Guide for details
		input  wire [1:0]   bam_response_i,            //                  .response,                  Check User Guide for details
		input  wire         bam_writeresponsevalid_i,  //                  .writeresponsevalid,        Check User Guide for details
		input  wire         flr_pf_done_i,             //          flr_ctrl.flr_pf_done,               Check User Guide for details
		output wire         flr_pf_active_o,           //                  .flr_pf_active,             Check User Guide for details
		output wire [3:0]   bus_master_enable_o,       // bus_master_enable.bus_master_enable,         Check User Guide for details
		input  wire         simu_mode_pipe,            //          hip_ctrl.simu_mode_pipe,            Check User Guide for details
		input  wire [66:0]  test_in,                   //                  .test_in,                   Check User Guide for details
		input  wire         sim_pipe_pclk_in,          //          hip_pipe.sim_pipe_pclk_in,          Check User Guide for details
		output wire [1:0]   sim_pipe_rate,             //                  .sim_pipe_rate,             Check User Guide for details
		output wire [5:0]   sim_ltssmstate,            //                  .sim_ltssmstate,            Check User Guide for details
		output wire [31:0]  txdata0,                   //                  .txdata0,                   Check User Guide for details
		output wire [31:0]  txdata1,                   //                  .txdata1,                   Check User Guide for details
		output wire [31:0]  txdata2,                   //                  .txdata2,                   Check User Guide for details
		output wire [31:0]  txdata3,                   //                  .txdata3,                   Check User Guide for details
		output wire [31:0]  txdata4,                   //                  .txdata4,                   Check User Guide for details
		output wire [31:0]  txdata5,                   //                  .txdata5,                   Check User Guide for details
		output wire [31:0]  txdata6,                   //                  .txdata6,                   Check User Guide for details
		output wire [31:0]  txdata7,                   //                  .txdata7,                   Check User Guide for details
		output wire [31:0]  txdata8,                   //                  .txdata8,                   Check User Guide for details
		output wire [31:0]  txdata9,                   //                  .txdata9,                   Check User Guide for details
		output wire [31:0]  txdata10,                  //                  .txdata10,                  Check User Guide for details
		output wire [31:0]  txdata11,                  //                  .txdata11,                  Check User Guide for details
		output wire [31:0]  txdata12,                  //                  .txdata12,                  Check User Guide for details
		output wire [31:0]  txdata13,                  //                  .txdata13,                  Check User Guide for details
		output wire [31:0]  txdata14,                  //                  .txdata14,                  Check User Guide for details
		output wire [31:0]  txdata15,                  //                  .txdata15,                  Check User Guide for details
		output wire [3:0]   txdatak0,                  //                  .txdatak0,                  Check User Guide for details
		output wire [3:0]   txdatak1,                  //                  .txdatak1,                  Check User Guide for details
		output wire [3:0]   txdatak2,                  //                  .txdatak2,                  Check User Guide for details
		output wire [3:0]   txdatak3,                  //                  .txdatak3,                  Check User Guide for details
		output wire [3:0]   txdatak4,                  //                  .txdatak4,                  Check User Guide for details
		output wire [3:0]   txdatak5,                  //                  .txdatak5,                  Check User Guide for details
		output wire [3:0]   txdatak6,                  //                  .txdatak6,                  Check User Guide for details
		output wire [3:0]   txdatak7,                  //                  .txdatak7,                  Check User Guide for details
		output wire [3:0]   txdatak8,                  //                  .txdatak8,                  Check User Guide for details
		output wire [3:0]   txdatak9,                  //                  .txdatak9,                  Check User Guide for details
		output wire [3:0]   txdatak10,                 //                  .txdatak10,                 Check User Guide for details
		output wire [3:0]   txdatak11,                 //                  .txdatak11,                 Check User Guide for details
		output wire [3:0]   txdatak12,                 //                  .txdatak12,                 Check User Guide for details
		output wire [3:0]   txdatak13,                 //                  .txdatak13,                 Check User Guide for details
		output wire [3:0]   txdatak14,                 //                  .txdatak14,                 Check User Guide for details
		output wire [3:0]   txdatak15,                 //                  .txdatak15,                 Check User Guide for details
		output wire         txcompl0,                  //                  .txcompl0,                  Check User Guide for details
		output wire         txcompl1,                  //                  .txcompl1,                  Check User Guide for details
		output wire         txcompl2,                  //                  .txcompl2,                  Check User Guide for details
		output wire         txcompl3,                  //                  .txcompl3,                  Check User Guide for details
		output wire         txcompl4,                  //                  .txcompl4,                  Check User Guide for details
		output wire         txcompl5,                  //                  .txcompl5,                  Check User Guide for details
		output wire         txcompl6,                  //                  .txcompl6,                  Check User Guide for details
		output wire         txcompl7,                  //                  .txcompl7,                  Check User Guide for details
		output wire         txcompl8,                  //                  .txcompl8,                  Check User Guide for details
		output wire         txcompl9,                  //                  .txcompl9,                  Check User Guide for details
		output wire         txcompl10,                 //                  .txcompl10,                 Check User Guide for details
		output wire         txcompl11,                 //                  .txcompl11,                 Check User Guide for details
		output wire         txcompl12,                 //                  .txcompl12,                 Check User Guide for details
		output wire         txcompl13,                 //                  .txcompl13,                 Check User Guide for details
		output wire         txcompl14,                 //                  .txcompl14,                 Check User Guide for details
		output wire         txcompl15,                 //                  .txcompl15,                 Check User Guide for details
		output wire         txelecidle0,               //                  .txelecidle0,               Check User Guide for details
		output wire         txelecidle1,               //                  .txelecidle1,               Check User Guide for details
		output wire         txelecidle2,               //                  .txelecidle2,               Check User Guide for details
		output wire         txelecidle3,               //                  .txelecidle3,               Check User Guide for details
		output wire         txelecidle4,               //                  .txelecidle4,               Check User Guide for details
		output wire         txelecidle5,               //                  .txelecidle5,               Check User Guide for details
		output wire         txelecidle6,               //                  .txelecidle6,               Check User Guide for details
		output wire         txelecidle7,               //                  .txelecidle7,               Check User Guide for details
		output wire         txelecidle8,               //                  .txelecidle8,               Check User Guide for details
		output wire         txelecidle9,               //                  .txelecidle9,               Check User Guide for details
		output wire         txelecidle10,              //                  .txelecidle10,              Check User Guide for details
		output wire         txelecidle11,              //                  .txelecidle11,              Check User Guide for details
		output wire         txelecidle12,              //                  .txelecidle12,              Check User Guide for details
		output wire         txelecidle13,              //                  .txelecidle13,              Check User Guide for details
		output wire         txelecidle14,              //                  .txelecidle14,              Check User Guide for details
		output wire         txelecidle15,              //                  .txelecidle15,              Check User Guide for details
		output wire         txdetectrx0,               //                  .txdetectrx0,               Check User Guide for details
		output wire         txdetectrx1,               //                  .txdetectrx1,               Check User Guide for details
		output wire         txdetectrx2,               //                  .txdetectrx2,               Check User Guide for details
		output wire         txdetectrx3,               //                  .txdetectrx3,               Check User Guide for details
		output wire         txdetectrx4,               //                  .txdetectrx4,               Check User Guide for details
		output wire         txdetectrx5,               //                  .txdetectrx5,               Check User Guide for details
		output wire         txdetectrx6,               //                  .txdetectrx6,               Check User Guide for details
		output wire         txdetectrx7,               //                  .txdetectrx7,               Check User Guide for details
		output wire         txdetectrx8,               //                  .txdetectrx8,               Check User Guide for details
		output wire         txdetectrx9,               //                  .txdetectrx9,               Check User Guide for details
		output wire         txdetectrx10,              //                  .txdetectrx10,              Check User Guide for details
		output wire         txdetectrx11,              //                  .txdetectrx11,              Check User Guide for details
		output wire         txdetectrx12,              //                  .txdetectrx12,              Check User Guide for details
		output wire         txdetectrx13,              //                  .txdetectrx13,              Check User Guide for details
		output wire         txdetectrx14,              //                  .txdetectrx14,              Check User Guide for details
		output wire         txdetectrx15,              //                  .txdetectrx15,              Check User Guide for details
		output wire [1:0]   powerdown0,                //                  .powerdown0,                Check User Guide for details
		output wire [1:0]   powerdown1,                //                  .powerdown1,                Check User Guide for details
		output wire [1:0]   powerdown2,                //                  .powerdown2,                Check User Guide for details
		output wire [1:0]   powerdown3,                //                  .powerdown3,                Check User Guide for details
		output wire [1:0]   powerdown4,                //                  .powerdown4,                Check User Guide for details
		output wire [1:0]   powerdown5,                //                  .powerdown5,                Check User Guide for details
		output wire [1:0]   powerdown6,                //                  .powerdown6,                Check User Guide for details
		output wire [1:0]   powerdown7,                //                  .powerdown7,                Check User Guide for details
		output wire [1:0]   powerdown8,                //                  .powerdown8,                Check User Guide for details
		output wire [1:0]   powerdown9,                //                  .powerdown9,                Check User Guide for details
		output wire [1:0]   powerdown10,               //                  .powerdown10,               Check User Guide for details
		output wire [1:0]   powerdown11,               //                  .powerdown11,               Check User Guide for details
		output wire [1:0]   powerdown12,               //                  .powerdown12,               Check User Guide for details
		output wire [1:0]   powerdown13,               //                  .powerdown13,               Check User Guide for details
		output wire [1:0]   powerdown14,               //                  .powerdown14,               Check User Guide for details
		output wire [1:0]   powerdown15,               //                  .powerdown15,               Check User Guide for details
		output wire [2:0]   txmargin0,                 //                  .txmargin0,                 Check User Guide for details
		output wire [2:0]   txmargin1,                 //                  .txmargin1,                 Check User Guide for details
		output wire [2:0]   txmargin2,                 //                  .txmargin2,                 Check User Guide for details
		output wire [2:0]   txmargin3,                 //                  .txmargin3,                 Check User Guide for details
		output wire [2:0]   txmargin4,                 //                  .txmargin4,                 Check User Guide for details
		output wire [2:0]   txmargin5,                 //                  .txmargin5,                 Check User Guide for details
		output wire [2:0]   txmargin6,                 //                  .txmargin6,                 Check User Guide for details
		output wire [2:0]   txmargin7,                 //                  .txmargin7,                 Check User Guide for details
		output wire [2:0]   txmargin8,                 //                  .txmargin8,                 Check User Guide for details
		output wire [2:0]   txmargin9,                 //                  .txmargin9,                 Check User Guide for details
		output wire [2:0]   txmargin10,                //                  .txmargin10,                Check User Guide for details
		output wire [2:0]   txmargin11,                //                  .txmargin11,                Check User Guide for details
		output wire [2:0]   txmargin12,                //                  .txmargin12,                Check User Guide for details
		output wire [2:0]   txmargin13,                //                  .txmargin13,                Check User Guide for details
		output wire [2:0]   txmargin14,                //                  .txmargin14,                Check User Guide for details
		output wire [2:0]   txmargin15,                //                  .txmargin15,                Check User Guide for details
		output wire         txdeemph0,                 //                  .txdeemph0,                 Check User Guide for details
		output wire         txdeemph1,                 //                  .txdeemph1,                 Check User Guide for details
		output wire         txdeemph2,                 //                  .txdeemph2,                 Check User Guide for details
		output wire         txdeemph3,                 //                  .txdeemph3,                 Check User Guide for details
		output wire         txdeemph4,                 //                  .txdeemph4,                 Check User Guide for details
		output wire         txdeemph5,                 //                  .txdeemph5,                 Check User Guide for details
		output wire         txdeemph6,                 //                  .txdeemph6,                 Check User Guide for details
		output wire         txdeemph7,                 //                  .txdeemph7,                 Check User Guide for details
		output wire         txdeemph8,                 //                  .txdeemph8,                 Check User Guide for details
		output wire         txdeemph9,                 //                  .txdeemph9,                 Check User Guide for details
		output wire         txdeemph10,                //                  .txdeemph10,                Check User Guide for details
		output wire         txdeemph11,                //                  .txdeemph11,                Check User Guide for details
		output wire         txdeemph12,                //                  .txdeemph12,                Check User Guide for details
		output wire         txdeemph13,                //                  .txdeemph13,                Check User Guide for details
		output wire         txdeemph14,                //                  .txdeemph14,                Check User Guide for details
		output wire         txdeemph15,                //                  .txdeemph15,                Check User Guide for details
		output wire         txswing0,                  //                  .txswing0,                  Check User Guide for details
		output wire         txswing1,                  //                  .txswing1,                  Check User Guide for details
		output wire         txswing2,                  //                  .txswing2,                  Check User Guide for details
		output wire         txswing3,                  //                  .txswing3,                  Check User Guide for details
		output wire         txswing4,                  //                  .txswing4,                  Check User Guide for details
		output wire         txswing5,                  //                  .txswing5,                  Check User Guide for details
		output wire         txswing6,                  //                  .txswing6,                  Check User Guide for details
		output wire         txswing7,                  //                  .txswing7,                  Check User Guide for details
		output wire         txswing8,                  //                  .txswing8,                  Check User Guide for details
		output wire         txswing9,                  //                  .txswing9,                  Check User Guide for details
		output wire         txswing10,                 //                  .txswing10,                 Check User Guide for details
		output wire         txswing11,                 //                  .txswing11,                 Check User Guide for details
		output wire         txswing12,                 //                  .txswing12,                 Check User Guide for details
		output wire         txswing13,                 //                  .txswing13,                 Check User Guide for details
		output wire         txswing14,                 //                  .txswing14,                 Check User Guide for details
		output wire         txswing15,                 //                  .txswing15,                 Check User Guide for details
		output wire [1:0]   txsynchd0,                 //                  .txsynchd0,                 Check User Guide for details
		output wire [1:0]   txsynchd1,                 //                  .txsynchd1,                 Check User Guide for details
		output wire [1:0]   txsynchd2,                 //                  .txsynchd2,                 Check User Guide for details
		output wire [1:0]   txsynchd3,                 //                  .txsynchd3,                 Check User Guide for details
		output wire [1:0]   txsynchd4,                 //                  .txsynchd4,                 Check User Guide for details
		output wire [1:0]   txsynchd5,                 //                  .txsynchd5,                 Check User Guide for details
		output wire [1:0]   txsynchd6,                 //                  .txsynchd6,                 Check User Guide for details
		output wire [1:0]   txsynchd7,                 //                  .txsynchd7,                 Check User Guide for details
		output wire [1:0]   txsynchd8,                 //                  .txsynchd8,                 Check User Guide for details
		output wire [1:0]   txsynchd9,                 //                  .txsynchd9,                 Check User Guide for details
		output wire [1:0]   txsynchd10,                //                  .txsynchd10,                Check User Guide for details
		output wire [1:0]   txsynchd11,                //                  .txsynchd11,                Check User Guide for details
		output wire [1:0]   txsynchd12,                //                  .txsynchd12,                Check User Guide for details
		output wire [1:0]   txsynchd13,                //                  .txsynchd13,                Check User Guide for details
		output wire [1:0]   txsynchd14,                //                  .txsynchd14,                Check User Guide for details
		output wire [1:0]   txsynchd15,                //                  .txsynchd15,                Check User Guide for details
		output wire         txblkst0,                  //                  .txblkst0,                  Check User Guide for details
		output wire         txblkst1,                  //                  .txblkst1,                  Check User Guide for details
		output wire         txblkst2,                  //                  .txblkst2,                  Check User Guide for details
		output wire         txblkst3,                  //                  .txblkst3,                  Check User Guide for details
		output wire         txblkst4,                  //                  .txblkst4,                  Check User Guide for details
		output wire         txblkst5,                  //                  .txblkst5,                  Check User Guide for details
		output wire         txblkst6,                  //                  .txblkst6,                  Check User Guide for details
		output wire         txblkst7,                  //                  .txblkst7,                  Check User Guide for details
		output wire         txblkst8,                  //                  .txblkst8,                  Check User Guide for details
		output wire         txblkst9,                  //                  .txblkst9,                  Check User Guide for details
		output wire         txblkst10,                 //                  .txblkst10,                 Check User Guide for details
		output wire         txblkst11,                 //                  .txblkst11,                 Check User Guide for details
		output wire         txblkst12,                 //                  .txblkst12,                 Check User Guide for details
		output wire         txblkst13,                 //                  .txblkst13,                 Check User Guide for details
		output wire         txblkst14,                 //                  .txblkst14,                 Check User Guide for details
		output wire         txblkst15,                 //                  .txblkst15,                 Check User Guide for details
		output wire         txdataskip0,               //                  .txdataskip0,               Check User Guide for details
		output wire         txdataskip1,               //                  .txdataskip1,               Check User Guide for details
		output wire         txdataskip2,               //                  .txdataskip2,               Check User Guide for details
		output wire         txdataskip3,               //                  .txdataskip3,               Check User Guide for details
		output wire         txdataskip4,               //                  .txdataskip4,               Check User Guide for details
		output wire         txdataskip5,               //                  .txdataskip5,               Check User Guide for details
		output wire         txdataskip6,               //                  .txdataskip6,               Check User Guide for details
		output wire         txdataskip7,               //                  .txdataskip7,               Check User Guide for details
		output wire         txdataskip8,               //                  .txdataskip8,               Check User Guide for details
		output wire         txdataskip9,               //                  .txdataskip9,               Check User Guide for details
		output wire         txdataskip10,              //                  .txdataskip10,              Check User Guide for details
		output wire         txdataskip11,              //                  .txdataskip11,              Check User Guide for details
		output wire         txdataskip12,              //                  .txdataskip12,              Check User Guide for details
		output wire         txdataskip13,              //                  .txdataskip13,              Check User Guide for details
		output wire         txdataskip14,              //                  .txdataskip14,              Check User Guide for details
		output wire         txdataskip15,              //                  .txdataskip15,              Check User Guide for details
		output wire [1:0]   rate0,                     //                  .rate0,                     Check User Guide for details
		output wire [1:0]   rate1,                     //                  .rate1,                     Check User Guide for details
		output wire [1:0]   rate2,                     //                  .rate2,                     Check User Guide for details
		output wire [1:0]   rate3,                     //                  .rate3,                     Check User Guide for details
		output wire [1:0]   rate4,                     //                  .rate4,                     Check User Guide for details
		output wire [1:0]   rate5,                     //                  .rate5,                     Check User Guide for details
		output wire [1:0]   rate6,                     //                  .rate6,                     Check User Guide for details
		output wire [1:0]   rate7,                     //                  .rate7,                     Check User Guide for details
		output wire [1:0]   rate8,                     //                  .rate8,                     Check User Guide for details
		output wire [1:0]   rate9,                     //                  .rate9,                     Check User Guide for details
		output wire [1:0]   rate10,                    //                  .rate10,                    Check User Guide for details
		output wire [1:0]   rate11,                    //                  .rate11,                    Check User Guide for details
		output wire [1:0]   rate12,                    //                  .rate12,                    Check User Guide for details
		output wire [1:0]   rate13,                    //                  .rate13,                    Check User Guide for details
		output wire [1:0]   rate14,                    //                  .rate14,                    Check User Guide for details
		output wire [1:0]   rate15,                    //                  .rate15,                    Check User Guide for details
		output wire         rxpolarity0,               //                  .rxpolarity0,               Check User Guide for details
		output wire         rxpolarity1,               //                  .rxpolarity1,               Check User Guide for details
		output wire         rxpolarity2,               //                  .rxpolarity2,               Check User Guide for details
		output wire         rxpolarity3,               //                  .rxpolarity3,               Check User Guide for details
		output wire         rxpolarity4,               //                  .rxpolarity4,               Check User Guide for details
		output wire         rxpolarity5,               //                  .rxpolarity5,               Check User Guide for details
		output wire         rxpolarity6,               //                  .rxpolarity6,               Check User Guide for details
		output wire         rxpolarity7,               //                  .rxpolarity7,               Check User Guide for details
		output wire         rxpolarity8,               //                  .rxpolarity8,               Check User Guide for details
		output wire         rxpolarity9,               //                  .rxpolarity9,               Check User Guide for details
		output wire         rxpolarity10,              //                  .rxpolarity10,              Check User Guide for details
		output wire         rxpolarity11,              //                  .rxpolarity11,              Check User Guide for details
		output wire         rxpolarity12,              //                  .rxpolarity12,              Check User Guide for details
		output wire         rxpolarity13,              //                  .rxpolarity13,              Check User Guide for details
		output wire         rxpolarity14,              //                  .rxpolarity14,              Check User Guide for details
		output wire         rxpolarity15,              //                  .rxpolarity15,              Check User Guide for details
		output wire [2:0]   currentrxpreset0,          //                  .currentrxpreset0,          Check User Guide for details
		output wire [2:0]   currentrxpreset1,          //                  .currentrxpreset1,          Check User Guide for details
		output wire [2:0]   currentrxpreset2,          //                  .currentrxpreset2,          Check User Guide for details
		output wire [2:0]   currentrxpreset3,          //                  .currentrxpreset3,          Check User Guide for details
		output wire [2:0]   currentrxpreset4,          //                  .currentrxpreset4,          Check User Guide for details
		output wire [2:0]   currentrxpreset5,          //                  .currentrxpreset5,          Check User Guide for details
		output wire [2:0]   currentrxpreset6,          //                  .currentrxpreset6,          Check User Guide for details
		output wire [2:0]   currentrxpreset7,          //                  .currentrxpreset7,          Check User Guide for details
		output wire [2:0]   currentrxpreset8,          //                  .currentrxpreset8,          Check User Guide for details
		output wire [2:0]   currentrxpreset9,          //                  .currentrxpreset9,          Check User Guide for details
		output wire [2:0]   currentrxpreset10,         //                  .currentrxpreset10,         Check User Guide for details
		output wire [2:0]   currentrxpreset11,         //                  .currentrxpreset11,         Check User Guide for details
		output wire [2:0]   currentrxpreset12,         //                  .currentrxpreset12,         Check User Guide for details
		output wire [2:0]   currentrxpreset13,         //                  .currentrxpreset13,         Check User Guide for details
		output wire [2:0]   currentrxpreset14,         //                  .currentrxpreset14,         Check User Guide for details
		output wire [2:0]   currentrxpreset15,         //                  .currentrxpreset15,         Check User Guide for details
		output wire [17:0]  currentcoeff0,             //                  .currentcoeff0,             Check User Guide for details
		output wire [17:0]  currentcoeff1,             //                  .currentcoeff1,             Check User Guide for details
		output wire [17:0]  currentcoeff2,             //                  .currentcoeff2,             Check User Guide for details
		output wire [17:0]  currentcoeff3,             //                  .currentcoeff3,             Check User Guide for details
		output wire [17:0]  currentcoeff4,             //                  .currentcoeff4,             Check User Guide for details
		output wire [17:0]  currentcoeff5,             //                  .currentcoeff5,             Check User Guide for details
		output wire [17:0]  currentcoeff6,             //                  .currentcoeff6,             Check User Guide for details
		output wire [17:0]  currentcoeff7,             //                  .currentcoeff7,             Check User Guide for details
		output wire [17:0]  currentcoeff8,             //                  .currentcoeff8,             Check User Guide for details
		output wire [17:0]  currentcoeff9,             //                  .currentcoeff9,             Check User Guide for details
		output wire [17:0]  currentcoeff10,            //                  .currentcoeff10,            Check User Guide for details
		output wire [17:0]  currentcoeff11,            //                  .currentcoeff11,            Check User Guide for details
		output wire [17:0]  currentcoeff12,            //                  .currentcoeff12,            Check User Guide for details
		output wire [17:0]  currentcoeff13,            //                  .currentcoeff13,            Check User Guide for details
		output wire [17:0]  currentcoeff14,            //                  .currentcoeff14,            Check User Guide for details
		output wire [17:0]  currentcoeff15,            //                  .currentcoeff15,            Check User Guide for details
		output wire         rxeqeval0,                 //                  .rxeqeval0,                 Check User Guide for details
		output wire         rxeqeval1,                 //                  .rxeqeval1,                 Check User Guide for details
		output wire         rxeqeval2,                 //                  .rxeqeval2,                 Check User Guide for details
		output wire         rxeqeval3,                 //                  .rxeqeval3,                 Check User Guide for details
		output wire         rxeqeval4,                 //                  .rxeqeval4,                 Check User Guide for details
		output wire         rxeqeval5,                 //                  .rxeqeval5,                 Check User Guide for details
		output wire         rxeqeval6,                 //                  .rxeqeval6,                 Check User Guide for details
		output wire         rxeqeval7,                 //                  .rxeqeval7,                 Check User Guide for details
		output wire         rxeqeval8,                 //                  .rxeqeval8,                 Check User Guide for details
		output wire         rxeqeval9,                 //                  .rxeqeval9,                 Check User Guide for details
		output wire         rxeqeval10,                //                  .rxeqeval10,                Check User Guide for details
		output wire         rxeqeval11,                //                  .rxeqeval11,                Check User Guide for details
		output wire         rxeqeval12,                //                  .rxeqeval12,                Check User Guide for details
		output wire         rxeqeval13,                //                  .rxeqeval13,                Check User Guide for details
		output wire         rxeqeval14,                //                  .rxeqeval14,                Check User Guide for details
		output wire         rxeqeval15,                //                  .rxeqeval15,                Check User Guide for details
		output wire         rxeqinprogress0,           //                  .rxeqinprogress0,           Check User Guide for details
		output wire         rxeqinprogress1,           //                  .rxeqinprogress1,           Check User Guide for details
		output wire         rxeqinprogress2,           //                  .rxeqinprogress2,           Check User Guide for details
		output wire         rxeqinprogress3,           //                  .rxeqinprogress3,           Check User Guide for details
		output wire         rxeqinprogress4,           //                  .rxeqinprogress4,           Check User Guide for details
		output wire         rxeqinprogress5,           //                  .rxeqinprogress5,           Check User Guide for details
		output wire         rxeqinprogress6,           //                  .rxeqinprogress6,           Check User Guide for details
		output wire         rxeqinprogress7,           //                  .rxeqinprogress7,           Check User Guide for details
		output wire         rxeqinprogress8,           //                  .rxeqinprogress8,           Check User Guide for details
		output wire         rxeqinprogress9,           //                  .rxeqinprogress9,           Check User Guide for details
		output wire         rxeqinprogress10,          //                  .rxeqinprogress10,          Check User Guide for details
		output wire         rxeqinprogress11,          //                  .rxeqinprogress11,          Check User Guide for details
		output wire         rxeqinprogress12,          //                  .rxeqinprogress12,          Check User Guide for details
		output wire         rxeqinprogress13,          //                  .rxeqinprogress13,          Check User Guide for details
		output wire         rxeqinprogress14,          //                  .rxeqinprogress14,          Check User Guide for details
		output wire         rxeqinprogress15,          //                  .rxeqinprogress15,          Check User Guide for details
		output wire         invalidreq0,               //                  .invalidreq0,               Check User Guide for details
		output wire         invalidreq1,               //                  .invalidreq1,               Check User Guide for details
		output wire         invalidreq2,               //                  .invalidreq2,               Check User Guide for details
		output wire         invalidreq3,               //                  .invalidreq3,               Check User Guide for details
		output wire         invalidreq4,               //                  .invalidreq4,               Check User Guide for details
		output wire         invalidreq5,               //                  .invalidreq5,               Check User Guide for details
		output wire         invalidreq6,               //                  .invalidreq6,               Check User Guide for details
		output wire         invalidreq7,               //                  .invalidreq7,               Check User Guide for details
		output wire         invalidreq8,               //                  .invalidreq8,               Check User Guide for details
		output wire         invalidreq9,               //                  .invalidreq9,               Check User Guide for details
		output wire         invalidreq10,              //                  .invalidreq10,              Check User Guide for details
		output wire         invalidreq11,              //                  .invalidreq11,              Check User Guide for details
		output wire         invalidreq12,              //                  .invalidreq12,              Check User Guide for details
		output wire         invalidreq13,              //                  .invalidreq13,              Check User Guide for details
		output wire         invalidreq14,              //                  .invalidreq14,              Check User Guide for details
		output wire         invalidreq15,              //                  .invalidreq15,              Check User Guide for details
		input  wire [31:0]  rxdata0,                   //                  .rxdata0,                   Check User Guide for details
		input  wire [31:0]  rxdata1,                   //                  .rxdata1,                   Check User Guide for details
		input  wire [31:0]  rxdata2,                   //                  .rxdata2,                   Check User Guide for details
		input  wire [31:0]  rxdata3,                   //                  .rxdata3,                   Check User Guide for details
		input  wire [31:0]  rxdata4,                   //                  .rxdata4,                   Check User Guide for details
		input  wire [31:0]  rxdata5,                   //                  .rxdata5,                   Check User Guide for details
		input  wire [31:0]  rxdata6,                   //                  .rxdata6,                   Check User Guide for details
		input  wire [31:0]  rxdata7,                   //                  .rxdata7,                   Check User Guide for details
		input  wire [31:0]  rxdata8,                   //                  .rxdata8,                   Check User Guide for details
		input  wire [31:0]  rxdata9,                   //                  .rxdata9,                   Check User Guide for details
		input  wire [31:0]  rxdata10,                  //                  .rxdata10,                  Check User Guide for details
		input  wire [31:0]  rxdata11,                  //                  .rxdata11,                  Check User Guide for details
		input  wire [31:0]  rxdata12,                  //                  .rxdata12,                  Check User Guide for details
		input  wire [31:0]  rxdata13,                  //                  .rxdata13,                  Check User Guide for details
		input  wire [31:0]  rxdata14,                  //                  .rxdata14,                  Check User Guide for details
		input  wire [31:0]  rxdata15,                  //                  .rxdata15,                  Check User Guide for details
		input  wire [3:0]   rxdatak0,                  //                  .rxdatak0,                  Check User Guide for details
		input  wire [3:0]   rxdatak1,                  //                  .rxdatak1,                  Check User Guide for details
		input  wire [3:0]   rxdatak2,                  //                  .rxdatak2,                  Check User Guide for details
		input  wire [3:0]   rxdatak3,                  //                  .rxdatak3,                  Check User Guide for details
		input  wire [3:0]   rxdatak4,                  //                  .rxdatak4,                  Check User Guide for details
		input  wire [3:0]   rxdatak5,                  //                  .rxdatak5,                  Check User Guide for details
		input  wire [3:0]   rxdatak6,                  //                  .rxdatak6,                  Check User Guide for details
		input  wire [3:0]   rxdatak7,                  //                  .rxdatak7,                  Check User Guide for details
		input  wire [3:0]   rxdatak8,                  //                  .rxdatak8,                  Check User Guide for details
		input  wire [3:0]   rxdatak9,                  //                  .rxdatak9,                  Check User Guide for details
		input  wire [3:0]   rxdatak10,                 //                  .rxdatak10,                 Check User Guide for details
		input  wire [3:0]   rxdatak11,                 //                  .rxdatak11,                 Check User Guide for details
		input  wire [3:0]   rxdatak12,                 //                  .rxdatak12,                 Check User Guide for details
		input  wire [3:0]   rxdatak13,                 //                  .rxdatak13,                 Check User Guide for details
		input  wire [3:0]   rxdatak14,                 //                  .rxdatak14,                 Check User Guide for details
		input  wire [3:0]   rxdatak15,                 //                  .rxdatak15,                 Check User Guide for details
		input  wire         phystatus0,                //                  .phystatus0,                Check User Guide for details
		input  wire         phystatus1,                //                  .phystatus1,                Check User Guide for details
		input  wire         phystatus2,                //                  .phystatus2,                Check User Guide for details
		input  wire         phystatus3,                //                  .phystatus3,                Check User Guide for details
		input  wire         phystatus4,                //                  .phystatus4,                Check User Guide for details
		input  wire         phystatus5,                //                  .phystatus5,                Check User Guide for details
		input  wire         phystatus6,                //                  .phystatus6,                Check User Guide for details
		input  wire         phystatus7,                //                  .phystatus7,                Check User Guide for details
		input  wire         phystatus8,                //                  .phystatus8,                Check User Guide for details
		input  wire         phystatus9,                //                  .phystatus9,                Check User Guide for details
		input  wire         phystatus10,               //                  .phystatus10,               Check User Guide for details
		input  wire         phystatus11,               //                  .phystatus11,               Check User Guide for details
		input  wire         phystatus12,               //                  .phystatus12,               Check User Guide for details
		input  wire         phystatus13,               //                  .phystatus13,               Check User Guide for details
		input  wire         phystatus14,               //                  .phystatus14,               Check User Guide for details
		input  wire         phystatus15,               //                  .phystatus15,               Check User Guide for details
		input  wire         rxvalid0,                  //                  .rxvalid0,                  Check User Guide for details
		input  wire         rxvalid1,                  //                  .rxvalid1,                  Check User Guide for details
		input  wire         rxvalid2,                  //                  .rxvalid2,                  Check User Guide for details
		input  wire         rxvalid3,                  //                  .rxvalid3,                  Check User Guide for details
		input  wire         rxvalid4,                  //                  .rxvalid4,                  Check User Guide for details
		input  wire         rxvalid5,                  //                  .rxvalid5,                  Check User Guide for details
		input  wire         rxvalid6,                  //                  .rxvalid6,                  Check User Guide for details
		input  wire         rxvalid7,                  //                  .rxvalid7,                  Check User Guide for details
		input  wire         rxvalid8,                  //                  .rxvalid8,                  Check User Guide for details
		input  wire         rxvalid9,                  //                  .rxvalid9,                  Check User Guide for details
		input  wire         rxvalid10,                 //                  .rxvalid10,                 Check User Guide for details
		input  wire         rxvalid11,                 //                  .rxvalid11,                 Check User Guide for details
		input  wire         rxvalid12,                 //                  .rxvalid12,                 Check User Guide for details
		input  wire         rxvalid13,                 //                  .rxvalid13,                 Check User Guide for details
		input  wire         rxvalid14,                 //                  .rxvalid14,                 Check User Guide for details
		input  wire         rxvalid15,                 //                  .rxvalid15,                 Check User Guide for details
		input  wire [2:0]   rxstatus0,                 //                  .rxstatus0,                 Check User Guide for details
		input  wire [2:0]   rxstatus1,                 //                  .rxstatus1,                 Check User Guide for details
		input  wire [2:0]   rxstatus2,                 //                  .rxstatus2,                 Check User Guide for details
		input  wire [2:0]   rxstatus3,                 //                  .rxstatus3,                 Check User Guide for details
		input  wire [2:0]   rxstatus4,                 //                  .rxstatus4,                 Check User Guide for details
		input  wire [2:0]   rxstatus5,                 //                  .rxstatus5,                 Check User Guide for details
		input  wire [2:0]   rxstatus6,                 //                  .rxstatus6,                 Check User Guide for details
		input  wire [2:0]   rxstatus7,                 //                  .rxstatus7,                 Check User Guide for details
		input  wire [2:0]   rxstatus8,                 //                  .rxstatus8,                 Check User Guide for details
		input  wire [2:0]   rxstatus9,                 //                  .rxstatus9,                 Check User Guide for details
		input  wire [2:0]   rxstatus10,                //                  .rxstatus10,                Check User Guide for details
		input  wire [2:0]   rxstatus11,                //                  .rxstatus11,                Check User Guide for details
		input  wire [2:0]   rxstatus12,                //                  .rxstatus12,                Check User Guide for details
		input  wire [2:0]   rxstatus13,                //                  .rxstatus13,                Check User Guide for details
		input  wire [2:0]   rxstatus14,                //                  .rxstatus14,                Check User Guide for details
		input  wire [2:0]   rxstatus15,                //                  .rxstatus15,                Check User Guide for details
		input  wire         rxelecidle0,               //                  .rxelecidle0,               Check User Guide for details
		input  wire         rxelecidle1,               //                  .rxelecidle1,               Check User Guide for details
		input  wire         rxelecidle2,               //                  .rxelecidle2,               Check User Guide for details
		input  wire         rxelecidle3,               //                  .rxelecidle3,               Check User Guide for details
		input  wire         rxelecidle4,               //                  .rxelecidle4,               Check User Guide for details
		input  wire         rxelecidle5,               //                  .rxelecidle5,               Check User Guide for details
		input  wire         rxelecidle6,               //                  .rxelecidle6,               Check User Guide for details
		input  wire         rxelecidle7,               //                  .rxelecidle7,               Check User Guide for details
		input  wire         rxelecidle8,               //                  .rxelecidle8,               Check User Guide for details
		input  wire         rxelecidle9,               //                  .rxelecidle9,               Check User Guide for details
		input  wire         rxelecidle10,              //                  .rxelecidle10,              Check User Guide for details
		input  wire         rxelecidle11,              //                  .rxelecidle11,              Check User Guide for details
		input  wire         rxelecidle12,              //                  .rxelecidle12,              Check User Guide for details
		input  wire         rxelecidle13,              //                  .rxelecidle13,              Check User Guide for details
		input  wire         rxelecidle14,              //                  .rxelecidle14,              Check User Guide for details
		input  wire         rxelecidle15,              //                  .rxelecidle15,              Check User Guide for details
		input  wire [1:0]   rxsynchd0,                 //                  .rxsynchd0,                 Check User Guide for details
		input  wire [1:0]   rxsynchd1,                 //                  .rxsynchd1,                 Check User Guide for details
		input  wire [1:0]   rxsynchd2,                 //                  .rxsynchd2,                 Check User Guide for details
		input  wire [1:0]   rxsynchd3,                 //                  .rxsynchd3,                 Check User Guide for details
		input  wire [1:0]   rxsynchd4,                 //                  .rxsynchd4,                 Check User Guide for details
		input  wire [1:0]   rxsynchd5,                 //                  .rxsynchd5,                 Check User Guide for details
		input  wire [1:0]   rxsynchd6,                 //                  .rxsynchd6,                 Check User Guide for details
		input  wire [1:0]   rxsynchd7,                 //                  .rxsynchd7,                 Check User Guide for details
		input  wire [1:0]   rxsynchd8,                 //                  .rxsynchd8,                 Check User Guide for details
		input  wire [1:0]   rxsynchd9,                 //                  .rxsynchd9,                 Check User Guide for details
		input  wire [1:0]   rxsynchd10,                //                  .rxsynchd10,                Check User Guide for details
		input  wire [1:0]   rxsynchd11,                //                  .rxsynchd11,                Check User Guide for details
		input  wire [1:0]   rxsynchd12,                //                  .rxsynchd12,                Check User Guide for details
		input  wire [1:0]   rxsynchd13,                //                  .rxsynchd13,                Check User Guide for details
		input  wire [1:0]   rxsynchd14,                //                  .rxsynchd14,                Check User Guide for details
		input  wire [1:0]   rxsynchd15,                //                  .rxsynchd15,                Check User Guide for details
		input  wire         rxblkst0,                  //                  .rxblkst0,                  Check User Guide for details
		input  wire         rxblkst1,                  //                  .rxblkst1,                  Check User Guide for details
		input  wire         rxblkst2,                  //                  .rxblkst2,                  Check User Guide for details
		input  wire         rxblkst3,                  //                  .rxblkst3,                  Check User Guide for details
		input  wire         rxblkst4,                  //                  .rxblkst4,                  Check User Guide for details
		input  wire         rxblkst5,                  //                  .rxblkst5,                  Check User Guide for details
		input  wire         rxblkst6,                  //                  .rxblkst6,                  Check User Guide for details
		input  wire         rxblkst7,                  //                  .rxblkst7,                  Check User Guide for details
		input  wire         rxblkst8,                  //                  .rxblkst8,                  Check User Guide for details
		input  wire         rxblkst9,                  //                  .rxblkst9,                  Check User Guide for details
		input  wire         rxblkst10,                 //                  .rxblkst10,                 Check User Guide for details
		input  wire         rxblkst11,                 //                  .rxblkst11,                 Check User Guide for details
		input  wire         rxblkst12,                 //                  .rxblkst12,                 Check User Guide for details
		input  wire         rxblkst13,                 //                  .rxblkst13,                 Check User Guide for details
		input  wire         rxblkst14,                 //                  .rxblkst14,                 Check User Guide for details
		input  wire         rxblkst15,                 //                  .rxblkst15,                 Check User Guide for details
		input  wire         rxdataskip0,               //                  .rxdataskip0,               Check User Guide for details
		input  wire         rxdataskip1,               //                  .rxdataskip1,               Check User Guide for details
		input  wire         rxdataskip2,               //                  .rxdataskip2,               Check User Guide for details
		input  wire         rxdataskip3,               //                  .rxdataskip3,               Check User Guide for details
		input  wire         rxdataskip4,               //                  .rxdataskip4,               Check User Guide for details
		input  wire         rxdataskip5,               //                  .rxdataskip5,               Check User Guide for details
		input  wire         rxdataskip6,               //                  .rxdataskip6,               Check User Guide for details
		input  wire         rxdataskip7,               //                  .rxdataskip7,               Check User Guide for details
		input  wire         rxdataskip8,               //                  .rxdataskip8,               Check User Guide for details
		input  wire         rxdataskip9,               //                  .rxdataskip9,               Check User Guide for details
		input  wire         rxdataskip10,              //                  .rxdataskip10,              Check User Guide for details
		input  wire         rxdataskip11,              //                  .rxdataskip11,              Check User Guide for details
		input  wire         rxdataskip12,              //                  .rxdataskip12,              Check User Guide for details
		input  wire         rxdataskip13,              //                  .rxdataskip13,              Check User Guide for details
		input  wire         rxdataskip14,              //                  .rxdataskip14,              Check User Guide for details
		input  wire         rxdataskip15,              //                  .rxdataskip15,              Check User Guide for details
		input  wire [5:0]   dirfeedback0,              //                  .dirfeedback0,              Check User Guide for details
		input  wire [5:0]   dirfeedback1,              //                  .dirfeedback1,              Check User Guide for details
		input  wire [5:0]   dirfeedback2,              //                  .dirfeedback2,              Check User Guide for details
		input  wire [5:0]   dirfeedback3,              //                  .dirfeedback3,              Check User Guide for details
		input  wire [5:0]   dirfeedback4,              //                  .dirfeedback4,              Check User Guide for details
		input  wire [5:0]   dirfeedback5,              //                  .dirfeedback5,              Check User Guide for details
		input  wire [5:0]   dirfeedback6,              //                  .dirfeedback6,              Check User Guide for details
		input  wire [5:0]   dirfeedback7,              //                  .dirfeedback7,              Check User Guide for details
		input  wire [5:0]   dirfeedback8,              //                  .dirfeedback8,              Check User Guide for details
		input  wire [5:0]   dirfeedback9,              //                  .dirfeedback9,              Check User Guide for details
		input  wire [5:0]   dirfeedback10,             //                  .dirfeedback10,             Check User Guide for details
		input  wire [5:0]   dirfeedback11,             //                  .dirfeedback11,             Check User Guide for details
		input  wire [5:0]   dirfeedback12,             //                  .dirfeedback12,             Check User Guide for details
		input  wire [5:0]   dirfeedback13,             //                  .dirfeedback13,             Check User Guide for details
		input  wire [5:0]   dirfeedback14,             //                  .dirfeedback14,             Check User Guide for details
		input  wire [5:0]   dirfeedback15,             //                  .dirfeedback15,             Check User Guide for details
		input  wire         sim_pipe_mask_tx_pll_lock, //                  .sim_pipe_mask_tx_pll_lock, Check User Guide for details
		input  wire         rx_in0,                    //        hip_serial.rx_in0,                    Check User Guide for details
		input  wire         rx_in1,                    //                  .rx_in1,                    Check User Guide for details
		input  wire         rx_in2,                    //                  .rx_in2,                    Check User Guide for details
		input  wire         rx_in3,                    //                  .rx_in3,                    Check User Guide for details
		input  wire         rx_in4,                    //                  .rx_in4,                    Check User Guide for details
		input  wire         rx_in5,                    //                  .rx_in5,                    Check User Guide for details
		input  wire         rx_in6,                    //                  .rx_in6,                    Check User Guide for details
		input  wire         rx_in7,                    //                  .rx_in7,                    Check User Guide for details
		input  wire         rx_in8,                    //                  .rx_in8,                    Check User Guide for details
		input  wire         rx_in9,                    //                  .rx_in9,                    Check User Guide for details
		input  wire         rx_in10,                   //                  .rx_in10,                   Check User Guide for details
		input  wire         rx_in11,                   //                  .rx_in11,                   Check User Guide for details
		input  wire         rx_in12,                   //                  .rx_in12,                   Check User Guide for details
		input  wire         rx_in13,                   //                  .rx_in13,                   Check User Guide for details
		input  wire         rx_in14,                   //                  .rx_in14,                   Check User Guide for details
		input  wire         rx_in15,                   //                  .rx_in15,                   Check User Guide for details
		output wire         tx_out0,                   //                  .tx_out0,                   Check User Guide for details
		output wire         tx_out1,                   //                  .tx_out1,                   Check User Guide for details
		output wire         tx_out2,                   //                  .tx_out2,                   Check User Guide for details
		output wire         tx_out3,                   //                  .tx_out3,                   Check User Guide for details
		output wire         tx_out4,                   //                  .tx_out4,                   Check User Guide for details
		output wire         tx_out5,                   //                  .tx_out5,                   Check User Guide for details
		output wire         tx_out6,                   //                  .tx_out6,                   Check User Guide for details
		output wire         tx_out7,                   //                  .tx_out7,                   Check User Guide for details
		output wire         tx_out8,                   //                  .tx_out8,                   Check User Guide for details
		output wire         tx_out9,                   //                  .tx_out9,                   Check User Guide for details
		output wire         tx_out10,                  //                  .tx_out10,                  Check User Guide for details
		output wire         tx_out11,                  //                  .tx_out11,                  Check User Guide for details
		output wire         tx_out12,                  //                  .tx_out12,                  Check User Guide for details
		output wire         tx_out13,                  //                  .tx_out13,                  Check User Guide for details
		output wire         tx_out14,                  //                  .tx_out14,                  Check User Guide for details
		output wire         tx_out15,                  //                  .tx_out15,                  Check User Guide for details
		output wire [1:0]   tl_cfg_func_o,             //         config_tl.tl_cfg_func,               Check User Guide for details
		output wire [3:0]   tl_cfg_add_o,              //                  .tl_cfg_add,                Check User Guide for details
		output wire [31:0]  tl_cfg_ctl_o               //                  .tl_cfg_ctl,                Check User Guide for details
	);
endmodule

