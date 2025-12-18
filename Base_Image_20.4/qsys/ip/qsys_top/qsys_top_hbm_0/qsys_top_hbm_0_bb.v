module qsys_top_hbm_0 (
		input  wire         pll_ref_clk,                //                pll_ref_clk.clk
		input  wire         ext_core_clk,               //               ext_core_clk.clk
		input  wire         ext_core_clk_locked,        //        ext_core_clk_locked.export
		input  wire         wmcrst_n_in,                //                wmcrst_n_in.reset_n
		input  wire         hbm_only_reset_in,          //          hbm_only_reset_in.reset
		output wire         local_cal_success,          //                     status.local_cal_success
		output wire         local_cal_fail,             //                           .local_cal_fail
		output wire [2:0]   cal_lat,                    //                    cal_lat.cal_lat
		output wire         ck_t_0,                     //                      mem_0.ck_t
		output wire         ck_c_0,                     //                           .ck_c
		output wire         cke_0,                      //                           .cke
		output wire [7:0]   c_0,                        //                           .c
		output wire [5:0]   r_0,                        //                           .r
		inout  wire [127:0] dq_0,                       //                           .dq
		inout  wire [15:0]  dm_0,                       //                           .dm
		inout  wire [15:0]  dbi_0,                      //                           .dbi
		inout  wire [3:0]   par_0,                      //                           .par
		inout  wire [3:0]   derr_0,                     //                           .derr
		input  wire [3:0]   rdqs_t_0,                   //                           .rdqs_t
		input  wire [3:0]   rdqs_c_0,                   //                           .rdqs_c
		output wire [3:0]   wdqs_t_0,                   //                           .wdqs_t
		output wire [3:0]   wdqs_c_0,                   //                           .wdqs_c
		inout  wire [7:0]   rd_0,                       //                           .rd
		output wire         rr_0,                       //                           .rr
		output wire         rc_0,                       //                           .rc
		input  wire         aerr_0,                     //                           .aerr
		output wire         ck_t_1,                     //                      mem_1.ck_t
		output wire         ck_c_1,                     //                           .ck_c
		output wire         cke_1,                      //                           .cke
		output wire [7:0]   c_1,                        //                           .c
		output wire [5:0]   r_1,                        //                           .r
		inout  wire [127:0] dq_1,                       //                           .dq
		inout  wire [15:0]  dm_1,                       //                           .dm
		inout  wire [15:0]  dbi_1,                      //                           .dbi
		inout  wire [3:0]   par_1,                      //                           .par
		inout  wire [3:0]   derr_1,                     //                           .derr
		input  wire [3:0]   rdqs_t_1,                   //                           .rdqs_t
		input  wire [3:0]   rdqs_c_1,                   //                           .rdqs_c
		output wire [3:0]   wdqs_t_1,                   //                           .wdqs_t
		output wire [3:0]   wdqs_c_1,                   //                           .wdqs_c
		inout  wire [7:0]   rd_1,                       //                           .rd
		output wire         rr_1,                       //                           .rr
		output wire         rc_1,                       //                           .rc
		input  wire         aerr_1,                     //                           .aerr
		output wire         ck_t_2,                     //                      mem_2.ck_t
		output wire         ck_c_2,                     //                           .ck_c
		output wire         cke_2,                      //                           .cke
		output wire [7:0]   c_2,                        //                           .c
		output wire [5:0]   r_2,                        //                           .r
		inout  wire [127:0] dq_2,                       //                           .dq
		inout  wire [15:0]  dm_2,                       //                           .dm
		inout  wire [15:0]  dbi_2,                      //                           .dbi
		inout  wire [3:0]   par_2,                      //                           .par
		inout  wire [3:0]   derr_2,                     //                           .derr
		input  wire [3:0]   rdqs_t_2,                   //                           .rdqs_t
		input  wire [3:0]   rdqs_c_2,                   //                           .rdqs_c
		output wire [3:0]   wdqs_t_2,                   //                           .wdqs_t
		output wire [3:0]   wdqs_c_2,                   //                           .wdqs_c
		inout  wire [7:0]   rd_2,                       //                           .rd
		output wire         rr_2,                       //                           .rr
		output wire         rc_2,                       //                           .rc
		input  wire         aerr_2,                     //                           .aerr
		output wire         ck_t_3,                     //                      mem_3.ck_t
		output wire         ck_c_3,                     //                           .ck_c
		output wire         cke_3,                      //                           .cke
		output wire [7:0]   c_3,                        //                           .c
		output wire [5:0]   r_3,                        //                           .r
		inout  wire [127:0] dq_3,                       //                           .dq
		inout  wire [15:0]  dm_3,                       //                           .dm
		inout  wire [15:0]  dbi_3,                      //                           .dbi
		inout  wire [3:0]   par_3,                      //                           .par
		inout  wire [3:0]   derr_3,                     //                           .derr
		input  wire [3:0]   rdqs_t_3,                   //                           .rdqs_t
		input  wire [3:0]   rdqs_c_3,                   //                           .rdqs_c
		output wire [3:0]   wdqs_t_3,                   //                           .wdqs_t
		output wire [3:0]   wdqs_c_3,                   //                           .wdqs_c
		inout  wire [7:0]   rd_3,                       //                           .rd
		output wire         rr_3,                       //                           .rr
		output wire         rc_3,                       //                           .rc
		input  wire         aerr_3,                     //                           .aerr
		output wire         ck_t_4,                     //                      mem_4.ck_t
		output wire         ck_c_4,                     //                           .ck_c
		output wire         cke_4,                      //                           .cke
		output wire [7:0]   c_4,                        //                           .c
		output wire [5:0]   r_4,                        //                           .r
		inout  wire [127:0] dq_4,                       //                           .dq
		inout  wire [15:0]  dm_4,                       //                           .dm
		inout  wire [15:0]  dbi_4,                      //                           .dbi
		inout  wire [3:0]   par_4,                      //                           .par
		inout  wire [3:0]   derr_4,                     //                           .derr
		input  wire [3:0]   rdqs_t_4,                   //                           .rdqs_t
		input  wire [3:0]   rdqs_c_4,                   //                           .rdqs_c
		output wire [3:0]   wdqs_t_4,                   //                           .wdqs_t
		output wire [3:0]   wdqs_c_4,                   //                           .wdqs_c
		inout  wire [7:0]   rd_4,                       //                           .rd
		output wire         rr_4,                       //                           .rr
		output wire         rc_4,                       //                           .rc
		input  wire         aerr_4,                     //                           .aerr
		output wire         ck_t_5,                     //                      mem_5.ck_t
		output wire         ck_c_5,                     //                           .ck_c
		output wire         cke_5,                      //                           .cke
		output wire [7:0]   c_5,                        //                           .c
		output wire [5:0]   r_5,                        //                           .r
		inout  wire [127:0] dq_5,                       //                           .dq
		inout  wire [15:0]  dm_5,                       //                           .dm
		inout  wire [15:0]  dbi_5,                      //                           .dbi
		inout  wire [3:0]   par_5,                      //                           .par
		inout  wire [3:0]   derr_5,                     //                           .derr
		input  wire [3:0]   rdqs_t_5,                   //                           .rdqs_t
		input  wire [3:0]   rdqs_c_5,                   //                           .rdqs_c
		output wire [3:0]   wdqs_t_5,                   //                           .wdqs_t
		output wire [3:0]   wdqs_c_5,                   //                           .wdqs_c
		inout  wire [7:0]   rd_5,                       //                           .rd
		output wire         rr_5,                       //                           .rr
		output wire         rc_5,                       //                           .rc
		input  wire         aerr_5,                     //                           .aerr
		output wire         ck_t_6,                     //                      mem_6.ck_t
		output wire         ck_c_6,                     //                           .ck_c
		output wire         cke_6,                      //                           .cke
		output wire [7:0]   c_6,                        //                           .c
		output wire [5:0]   r_6,                        //                           .r
		inout  wire [127:0] dq_6,                       //                           .dq
		inout  wire [15:0]  dm_6,                       //                           .dm
		inout  wire [15:0]  dbi_6,                      //                           .dbi
		inout  wire [3:0]   par_6,                      //                           .par
		inout  wire [3:0]   derr_6,                     //                           .derr
		input  wire [3:0]   rdqs_t_6,                   //                           .rdqs_t
		input  wire [3:0]   rdqs_c_6,                   //                           .rdqs_c
		output wire [3:0]   wdqs_t_6,                   //                           .wdqs_t
		output wire [3:0]   wdqs_c_6,                   //                           .wdqs_c
		inout  wire [7:0]   rd_6,                       //                           .rd
		output wire         rr_6,                       //                           .rr
		output wire         rc_6,                       //                           .rc
		input  wire         aerr_6,                     //                           .aerr
		output wire         ck_t_7,                     //                      mem_7.ck_t
		output wire         ck_c_7,                     //                           .ck_c
		output wire         cke_7,                      //                           .cke
		output wire [7:0]   c_7,                        //                           .c
		output wire [5:0]   r_7,                        //                           .r
		inout  wire [127:0] dq_7,                       //                           .dq
		inout  wire [15:0]  dm_7,                       //                           .dm
		inout  wire [15:0]  dbi_7,                      //                           .dbi
		inout  wire [3:0]   par_7,                      //                           .par
		inout  wire [3:0]   derr_7,                     //                           .derr
		input  wire [3:0]   rdqs_t_7,                   //                           .rdqs_t
		input  wire [3:0]   rdqs_c_7,                   //                           .rdqs_c
		output wire [3:0]   wdqs_t_7,                   //                           .wdqs_t
		output wire [3:0]   wdqs_c_7,                   //                           .wdqs_c
		inout  wire [7:0]   rd_7,                       //                           .rd
		output wire         rr_7,                       //                           .rr
		output wire         rc_7,                       //                           .rc
		input  wire         aerr_7,                     //                           .aerr
		input  wire         cattrip,                    //                 m2u_bridge.cattrip
		input  wire [2:0]   temp,                       //                           .temp
		input  wire [7:0]   wso,                        //                           .wso
		output wire         reset_n,                    //                           .reset_n
		output wire         wrst_n,                     //                           .wrst_n
		output wire         wrck,                       //                           .wrck
		output wire         shiftwr,                    //                           .shiftwr
		output wire         capturewr,                  //                           .capturewr
		output wire         updatewr,                   //                           .updatewr
		output wire         selectwir,                  //                           .selectwir
		output wire         wsi,                        //                           .wsi
		output wire         wmc_clk_0_clk,              //                  wmc_clk_0.clk
		output wire         wmc_clk_1_clk,              //                  wmc_clk_1.clk
		output wire         phy_clk_0_clk,              //                  phy_clk_0.clk
		output wire         phy_clk_1_clk,              //                  phy_clk_1.clk
		output wire         wmcrst_n_0_reset_n,         //                 wmcrst_n_0.reset_n
		output wire         wmcrst_n_1_reset_n,         //                 wmcrst_n_1.reset_n
		output wire         ctrl_amm_0_0_waitrequest_n, //               ctrl_amm_0_0.waitrequest_n
		input  wire         ctrl_amm_0_0_read,          //                           .read
		input  wire         ctrl_amm_0_0_write,         //                           .write
		input  wire [28:0]  ctrl_amm_0_0_address,       //                           .address
		output wire [255:0] ctrl_amm_0_0_readdata,      //                           .readdata
		input  wire [255:0] ctrl_amm_0_0_writedata,     //                           .writedata
		input  wire [6:0]   ctrl_amm_0_0_burstcount,    //                           .burstcount
		input  wire [31:0]  ctrl_amm_0_0_byteenable,    //                           .byteenable
		output wire         ctrl_amm_0_0_readdatavalid, //                           .readdatavalid
		output wire         ctrl_amm_0_1_waitrequest_n, //               ctrl_amm_0_1.waitrequest_n
		input  wire         ctrl_amm_0_1_read,          //                           .read
		input  wire         ctrl_amm_0_1_write,         //                           .write
		input  wire [28:0]  ctrl_amm_0_1_address,       //                           .address
		output wire [255:0] ctrl_amm_0_1_readdata,      //                           .readdata
		input  wire [255:0] ctrl_amm_0_1_writedata,     //                           .writedata
		input  wire [6:0]   ctrl_amm_0_1_burstcount,    //                           .burstcount
		input  wire [31:0]  ctrl_amm_0_1_byteenable,    //                           .byteenable
		output wire         ctrl_amm_0_1_readdatavalid, //                           .readdatavalid
		output wire         ctrl_amm_1_0_waitrequest_n, //               ctrl_amm_1_0.waitrequest_n
		input  wire         ctrl_amm_1_0_read,          //                           .read
		input  wire         ctrl_amm_1_0_write,         //                           .write
		input  wire [28:0]  ctrl_amm_1_0_address,       //                           .address
		output wire [255:0] ctrl_amm_1_0_readdata,      //                           .readdata
		input  wire [255:0] ctrl_amm_1_0_writedata,     //                           .writedata
		input  wire [6:0]   ctrl_amm_1_0_burstcount,    //                           .burstcount
		input  wire [31:0]  ctrl_amm_1_0_byteenable,    //                           .byteenable
		output wire         ctrl_amm_1_0_readdatavalid, //                           .readdatavalid
		output wire         ctrl_amm_1_1_waitrequest_n, //               ctrl_amm_1_1.waitrequest_n
		input  wire         ctrl_amm_1_1_read,          //                           .read
		input  wire         ctrl_amm_1_1_write,         //                           .write
		input  wire [28:0]  ctrl_amm_1_1_address,       //                           .address
		output wire [255:0] ctrl_amm_1_1_readdata,      //                           .readdata
		input  wire [255:0] ctrl_amm_1_1_writedata,     //                           .writedata
		input  wire [6:0]   ctrl_amm_1_1_burstcount,    //                           .burstcount
		input  wire [31:0]  ctrl_amm_1_1_byteenable,    //                           .byteenable
		output wire         ctrl_amm_1_1_readdatavalid, //                           .readdatavalid
		output wire         ctrl_ecc_readdataerror_0_0, // ctrl_ecc_readdataerror_0_0.ctrl_ecc_readdataerror
		output wire         ctrl_ecc_readdataerror_0_1, // ctrl_ecc_readdataerror_0_1.ctrl_ecc_readdataerror
		output wire         ctrl_ecc_readdataerror_1_0, // ctrl_ecc_readdataerror_1_0.ctrl_ecc_readdataerror
		output wire         ctrl_ecc_readdataerror_1_1, // ctrl_ecc_readdataerror_1_1.ctrl_ecc_readdataerror
		input  wire [15:0]  apb_0_ur_paddr,             //                      apb_0.ur_paddr
		input  wire         apb_0_ur_psel,              //                           .ur_psel
		input  wire         apb_0_ur_penable,           //                           .ur_penable
		input  wire         apb_0_ur_pwrite,            //                           .ur_pwrite
		input  wire [15:0]  apb_0_ur_pwdata,            //                           .ur_pwdata
		input  wire [1:0]   apb_0_ur_pstrb,             //                           .ur_pstrb
		output wire         apb_0_ur_prready,           //                           .ur_prready
		output wire [15:0]  apb_0_ur_prdata,            //                           .ur_prdata
		input  wire [15:0]  apb_1_ur_paddr,             //                      apb_1.ur_paddr
		input  wire         apb_1_ur_psel,              //                           .ur_psel
		input  wire         apb_1_ur_penable,           //                           .ur_penable
		input  wire         apb_1_ur_pwrite,            //                           .ur_pwrite
		input  wire [15:0]  apb_1_ur_pwdata,            //                           .ur_pwdata
		input  wire [1:0]   apb_1_ur_pstrb,             //                           .ur_pstrb
		output wire         apb_1_ur_prready,           //                           .ur_prready
		output wire [15:0]  apb_1_ur_prdata,            //                           .ur_prdata
		output wire         wmc_clk_2_clk,              //                  wmc_clk_2.clk
		output wire         wmc_clk_3_clk,              //                  wmc_clk_3.clk
		output wire         phy_clk_2_clk,              //                  phy_clk_2.clk
		output wire         phy_clk_3_clk,              //                  phy_clk_3.clk
		output wire         wmcrst_n_2_reset_n,         //                 wmcrst_n_2.reset_n
		output wire         wmcrst_n_3_reset_n,         //                 wmcrst_n_3.reset_n
		output wire         ctrl_amm_2_0_waitrequest_n, //               ctrl_amm_2_0.waitrequest_n
		input  wire         ctrl_amm_2_0_read,          //                           .read
		input  wire         ctrl_amm_2_0_write,         //                           .write
		input  wire [28:0]  ctrl_amm_2_0_address,       //                           .address
		output wire [255:0] ctrl_amm_2_0_readdata,      //                           .readdata
		input  wire [255:0] ctrl_amm_2_0_writedata,     //                           .writedata
		input  wire [6:0]   ctrl_amm_2_0_burstcount,    //                           .burstcount
		input  wire [31:0]  ctrl_amm_2_0_byteenable,    //                           .byteenable
		output wire         ctrl_amm_2_0_readdatavalid, //                           .readdatavalid
		output wire         ctrl_amm_2_1_waitrequest_n, //               ctrl_amm_2_1.waitrequest_n
		input  wire         ctrl_amm_2_1_read,          //                           .read
		input  wire         ctrl_amm_2_1_write,         //                           .write
		input  wire [28:0]  ctrl_amm_2_1_address,       //                           .address
		output wire [255:0] ctrl_amm_2_1_readdata,      //                           .readdata
		input  wire [255:0] ctrl_amm_2_1_writedata,     //                           .writedata
		input  wire [6:0]   ctrl_amm_2_1_burstcount,    //                           .burstcount
		input  wire [31:0]  ctrl_amm_2_1_byteenable,    //                           .byteenable
		output wire         ctrl_amm_2_1_readdatavalid, //                           .readdatavalid
		output wire         ctrl_amm_3_0_waitrequest_n, //               ctrl_amm_3_0.waitrequest_n
		input  wire         ctrl_amm_3_0_read,          //                           .read
		input  wire         ctrl_amm_3_0_write,         //                           .write
		input  wire [28:0]  ctrl_amm_3_0_address,       //                           .address
		output wire [255:0] ctrl_amm_3_0_readdata,      //                           .readdata
		input  wire [255:0] ctrl_amm_3_0_writedata,     //                           .writedata
		input  wire [6:0]   ctrl_amm_3_0_burstcount,    //                           .burstcount
		input  wire [31:0]  ctrl_amm_3_0_byteenable,    //                           .byteenable
		output wire         ctrl_amm_3_0_readdatavalid, //                           .readdatavalid
		output wire         ctrl_amm_3_1_waitrequest_n, //               ctrl_amm_3_1.waitrequest_n
		input  wire         ctrl_amm_3_1_read,          //                           .read
		input  wire         ctrl_amm_3_1_write,         //                           .write
		input  wire [28:0]  ctrl_amm_3_1_address,       //                           .address
		output wire [255:0] ctrl_amm_3_1_readdata,      //                           .readdata
		input  wire [255:0] ctrl_amm_3_1_writedata,     //                           .writedata
		input  wire [6:0]   ctrl_amm_3_1_burstcount,    //                           .burstcount
		input  wire [31:0]  ctrl_amm_3_1_byteenable,    //                           .byteenable
		output wire         ctrl_amm_3_1_readdatavalid, //                           .readdatavalid
		output wire         ctrl_ecc_readdataerror_2_0, // ctrl_ecc_readdataerror_2_0.ctrl_ecc_readdataerror
		output wire         ctrl_ecc_readdataerror_2_1, // ctrl_ecc_readdataerror_2_1.ctrl_ecc_readdataerror
		output wire         ctrl_ecc_readdataerror_3_0, // ctrl_ecc_readdataerror_3_0.ctrl_ecc_readdataerror
		output wire         ctrl_ecc_readdataerror_3_1, // ctrl_ecc_readdataerror_3_1.ctrl_ecc_readdataerror
		input  wire [15:0]  apb_2_ur_paddr,             //                      apb_2.ur_paddr
		input  wire         apb_2_ur_psel,              //                           .ur_psel
		input  wire         apb_2_ur_penable,           //                           .ur_penable
		input  wire         apb_2_ur_pwrite,            //                           .ur_pwrite
		input  wire [15:0]  apb_2_ur_pwdata,            //                           .ur_pwdata
		input  wire [1:0]   apb_2_ur_pstrb,             //                           .ur_pstrb
		output wire         apb_2_ur_prready,           //                           .ur_prready
		output wire [15:0]  apb_2_ur_prdata,            //                           .ur_prdata
		input  wire [15:0]  apb_3_ur_paddr,             //                      apb_3.ur_paddr
		input  wire         apb_3_ur_psel,              //                           .ur_psel
		input  wire         apb_3_ur_penable,           //                           .ur_penable
		input  wire         apb_3_ur_pwrite,            //                           .ur_pwrite
		input  wire [15:0]  apb_3_ur_pwdata,            //                           .ur_pwdata
		input  wire [1:0]   apb_3_ur_pstrb,             //                           .ur_pstrb
		output wire         apb_3_ur_prready,           //                           .ur_prready
		output wire [15:0]  apb_3_ur_prdata,            //                           .ur_prdata
		output wire         wmc_clk_4_clk,              //                  wmc_clk_4.clk
		output wire         wmc_clk_5_clk,              //                  wmc_clk_5.clk
		output wire         phy_clk_4_clk,              //                  phy_clk_4.clk
		output wire         phy_clk_5_clk,              //                  phy_clk_5.clk
		output wire         wmcrst_n_4_reset_n,         //                 wmcrst_n_4.reset_n
		output wire         wmcrst_n_5_reset_n,         //                 wmcrst_n_5.reset_n
		output wire         ctrl_amm_4_0_waitrequest_n, //               ctrl_amm_4_0.waitrequest_n
		input  wire         ctrl_amm_4_0_read,          //                           .read
		input  wire         ctrl_amm_4_0_write,         //                           .write
		input  wire [28:0]  ctrl_amm_4_0_address,       //                           .address
		output wire [255:0] ctrl_amm_4_0_readdata,      //                           .readdata
		input  wire [255:0] ctrl_amm_4_0_writedata,     //                           .writedata
		input  wire [6:0]   ctrl_amm_4_0_burstcount,    //                           .burstcount
		input  wire [31:0]  ctrl_amm_4_0_byteenable,    //                           .byteenable
		output wire         ctrl_amm_4_0_readdatavalid, //                           .readdatavalid
		output wire         ctrl_amm_4_1_waitrequest_n, //               ctrl_amm_4_1.waitrequest_n
		input  wire         ctrl_amm_4_1_read,          //                           .read
		input  wire         ctrl_amm_4_1_write,         //                           .write
		input  wire [28:0]  ctrl_amm_4_1_address,       //                           .address
		output wire [255:0] ctrl_amm_4_1_readdata,      //                           .readdata
		input  wire [255:0] ctrl_amm_4_1_writedata,     //                           .writedata
		input  wire [6:0]   ctrl_amm_4_1_burstcount,    //                           .burstcount
		input  wire [31:0]  ctrl_amm_4_1_byteenable,    //                           .byteenable
		output wire         ctrl_amm_4_1_readdatavalid, //                           .readdatavalid
		output wire         ctrl_amm_5_0_waitrequest_n, //               ctrl_amm_5_0.waitrequest_n
		input  wire         ctrl_amm_5_0_read,          //                           .read
		input  wire         ctrl_amm_5_0_write,         //                           .write
		input  wire [28:0]  ctrl_amm_5_0_address,       //                           .address
		output wire [255:0] ctrl_amm_5_0_readdata,      //                           .readdata
		input  wire [255:0] ctrl_amm_5_0_writedata,     //                           .writedata
		input  wire [6:0]   ctrl_amm_5_0_burstcount,    //                           .burstcount
		input  wire [31:0]  ctrl_amm_5_0_byteenable,    //                           .byteenable
		output wire         ctrl_amm_5_0_readdatavalid, //                           .readdatavalid
		output wire         ctrl_amm_5_1_waitrequest_n, //               ctrl_amm_5_1.waitrequest_n
		input  wire         ctrl_amm_5_1_read,          //                           .read
		input  wire         ctrl_amm_5_1_write,         //                           .write
		input  wire [28:0]  ctrl_amm_5_1_address,       //                           .address
		output wire [255:0] ctrl_amm_5_1_readdata,      //                           .readdata
		input  wire [255:0] ctrl_amm_5_1_writedata,     //                           .writedata
		input  wire [6:0]   ctrl_amm_5_1_burstcount,    //                           .burstcount
		input  wire [31:0]  ctrl_amm_5_1_byteenable,    //                           .byteenable
		output wire         ctrl_amm_5_1_readdatavalid, //                           .readdatavalid
		output wire         ctrl_ecc_readdataerror_4_0, // ctrl_ecc_readdataerror_4_0.ctrl_ecc_readdataerror
		output wire         ctrl_ecc_readdataerror_4_1, // ctrl_ecc_readdataerror_4_1.ctrl_ecc_readdataerror
		output wire         ctrl_ecc_readdataerror_5_0, // ctrl_ecc_readdataerror_5_0.ctrl_ecc_readdataerror
		output wire         ctrl_ecc_readdataerror_5_1, // ctrl_ecc_readdataerror_5_1.ctrl_ecc_readdataerror
		input  wire [15:0]  apb_4_ur_paddr,             //                      apb_4.ur_paddr
		input  wire         apb_4_ur_psel,              //                           .ur_psel
		input  wire         apb_4_ur_penable,           //                           .ur_penable
		input  wire         apb_4_ur_pwrite,            //                           .ur_pwrite
		input  wire [15:0]  apb_4_ur_pwdata,            //                           .ur_pwdata
		input  wire [1:0]   apb_4_ur_pstrb,             //                           .ur_pstrb
		output wire         apb_4_ur_prready,           //                           .ur_prready
		output wire [15:0]  apb_4_ur_prdata,            //                           .ur_prdata
		input  wire [15:0]  apb_5_ur_paddr,             //                      apb_5.ur_paddr
		input  wire         apb_5_ur_psel,              //                           .ur_psel
		input  wire         apb_5_ur_penable,           //                           .ur_penable
		input  wire         apb_5_ur_pwrite,            //                           .ur_pwrite
		input  wire [15:0]  apb_5_ur_pwdata,            //                           .ur_pwdata
		input  wire [1:0]   apb_5_ur_pstrb,             //                           .ur_pstrb
		output wire         apb_5_ur_prready,           //                           .ur_prready
		output wire [15:0]  apb_5_ur_prdata,            //                           .ur_prdata
		output wire         wmc_clk_6_clk,              //                  wmc_clk_6.clk
		output wire         wmc_clk_7_clk,              //                  wmc_clk_7.clk
		output wire         phy_clk_6_clk,              //                  phy_clk_6.clk
		output wire         phy_clk_7_clk,              //                  phy_clk_7.clk
		output wire         wmcrst_n_6_reset_n,         //                 wmcrst_n_6.reset_n
		output wire         wmcrst_n_7_reset_n,         //                 wmcrst_n_7.reset_n
		output wire         ctrl_amm_6_0_waitrequest_n, //               ctrl_amm_6_0.waitrequest_n
		input  wire         ctrl_amm_6_0_read,          //                           .read
		input  wire         ctrl_amm_6_0_write,         //                           .write
		input  wire [28:0]  ctrl_amm_6_0_address,       //                           .address
		output wire [255:0] ctrl_amm_6_0_readdata,      //                           .readdata
		input  wire [255:0] ctrl_amm_6_0_writedata,     //                           .writedata
		input  wire [6:0]   ctrl_amm_6_0_burstcount,    //                           .burstcount
		input  wire [31:0]  ctrl_amm_6_0_byteenable,    //                           .byteenable
		output wire         ctrl_amm_6_0_readdatavalid, //                           .readdatavalid
		output wire         ctrl_amm_6_1_waitrequest_n, //               ctrl_amm_6_1.waitrequest_n
		input  wire         ctrl_amm_6_1_read,          //                           .read
		input  wire         ctrl_amm_6_1_write,         //                           .write
		input  wire [28:0]  ctrl_amm_6_1_address,       //                           .address
		output wire [255:0] ctrl_amm_6_1_readdata,      //                           .readdata
		input  wire [255:0] ctrl_amm_6_1_writedata,     //                           .writedata
		input  wire [6:0]   ctrl_amm_6_1_burstcount,    //                           .burstcount
		input  wire [31:0]  ctrl_amm_6_1_byteenable,    //                           .byteenable
		output wire         ctrl_amm_6_1_readdatavalid, //                           .readdatavalid
		output wire         ctrl_amm_7_0_waitrequest_n, //               ctrl_amm_7_0.waitrequest_n
		input  wire         ctrl_amm_7_0_read,          //                           .read
		input  wire         ctrl_amm_7_0_write,         //                           .write
		input  wire [28:0]  ctrl_amm_7_0_address,       //                           .address
		output wire [255:0] ctrl_amm_7_0_readdata,      //                           .readdata
		input  wire [255:0] ctrl_amm_7_0_writedata,     //                           .writedata
		input  wire [6:0]   ctrl_amm_7_0_burstcount,    //                           .burstcount
		input  wire [31:0]  ctrl_amm_7_0_byteenable,    //                           .byteenable
		output wire         ctrl_amm_7_0_readdatavalid, //                           .readdatavalid
		output wire         ctrl_amm_7_1_waitrequest_n, //               ctrl_amm_7_1.waitrequest_n
		input  wire         ctrl_amm_7_1_read,          //                           .read
		input  wire         ctrl_amm_7_1_write,         //                           .write
		input  wire [28:0]  ctrl_amm_7_1_address,       //                           .address
		output wire [255:0] ctrl_amm_7_1_readdata,      //                           .readdata
		input  wire [255:0] ctrl_amm_7_1_writedata,     //                           .writedata
		input  wire [6:0]   ctrl_amm_7_1_burstcount,    //                           .burstcount
		input  wire [31:0]  ctrl_amm_7_1_byteenable,    //                           .byteenable
		output wire         ctrl_amm_7_1_readdatavalid, //                           .readdatavalid
		output wire         ctrl_ecc_readdataerror_6_0, // ctrl_ecc_readdataerror_6_0.ctrl_ecc_readdataerror
		output wire         ctrl_ecc_readdataerror_6_1, // ctrl_ecc_readdataerror_6_1.ctrl_ecc_readdataerror
		output wire         ctrl_ecc_readdataerror_7_0, // ctrl_ecc_readdataerror_7_0.ctrl_ecc_readdataerror
		output wire         ctrl_ecc_readdataerror_7_1, // ctrl_ecc_readdataerror_7_1.ctrl_ecc_readdataerror
		input  wire [15:0]  apb_6_ur_paddr,             //                      apb_6.ur_paddr
		input  wire         apb_6_ur_psel,              //                           .ur_psel
		input  wire         apb_6_ur_penable,           //                           .ur_penable
		input  wire         apb_6_ur_pwrite,            //                           .ur_pwrite
		input  wire [15:0]  apb_6_ur_pwdata,            //                           .ur_pwdata
		input  wire [1:0]   apb_6_ur_pstrb,             //                           .ur_pstrb
		output wire         apb_6_ur_prready,           //                           .ur_prready
		output wire [15:0]  apb_6_ur_prdata,            //                           .ur_prdata
		input  wire [15:0]  apb_7_ur_paddr,             //                      apb_7.ur_paddr
		input  wire         apb_7_ur_psel,              //                           .ur_psel
		input  wire         apb_7_ur_penable,           //                           .ur_penable
		input  wire         apb_7_ur_pwrite,            //                           .ur_pwrite
		input  wire [15:0]  apb_7_ur_pwdata,            //                           .ur_pwdata
		input  wire [1:0]   apb_7_ur_pstrb,             //                           .ur_pstrb
		output wire         apb_7_ur_prready,           //                           .ur_prready
		output wire [15:0]  apb_7_ur_prdata             //                           .ur_prdata
	);
endmodule

