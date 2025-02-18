module hbm_bottom_example_design (
		input  wire         pll_ref_clk,                 //         pll_ref_clk.clk
		input  wire         ext_core_clk,                //        ext_core_clk.clk
		input  wire         ext_core_clk_locked,         // ext_core_clk_locked.export
		input  wire         wmcrst_n_in,                 //         wmcrst_n_in.reset_n
		input  wire         hbm_only_reset_in,           //   hbm_only_reset_in.reset
		output wire         local_cal_success,           //              status.local_cal_success
		output wire         local_cal_fail,              //                    .local_cal_fail
		output wire [2:0]   cal_lat,                     //             cal_lat.cal_lat
		output wire         ck_t_0,                      //               mem_0.ck_t
		output wire         ck_c_0,                      //                    .ck_c
		output wire         cke_0,                       //                    .cke
		output wire [7:0]   c_0,                         //                    .c
		output wire [5:0]   r_0,                         //                    .r
		inout  wire [127:0] dq_0,                        //                    .dq
		inout  wire [15:0]  dm_0,                        //                    .dm
		inout  wire [15:0]  dbi_0,                       //                    .dbi
		inout  wire [3:0]   par_0,                       //                    .par
		inout  wire [3:0]   derr_0,                      //                    .derr
		input  wire [3:0]   rdqs_t_0,                    //                    .rdqs_t
		input  wire [3:0]   rdqs_c_0,                    //                    .rdqs_c
		output wire [3:0]   wdqs_t_0,                    //                    .wdqs_t
		output wire [3:0]   wdqs_c_0,                    //                    .wdqs_c
		inout  wire [7:0]   rd_0,                        //                    .rd
		output wire         rr_0,                        //                    .rr
		output wire         rc_0,                        //                    .rc
		input  wire         aerr_0,                      //                    .aerr
		input  wire         cattrip,                     //          m2u_bridge.cattrip
		input  wire [2:0]   temp,                        //                    .temp
		input  wire [7:0]   wso,                         //                    .wso
		output wire         reset_n,                     //                    .reset_n
		output wire         wrst_n,                      //                    .wrst_n
		output wire         wrck,                        //                    .wrck
		output wire         shiftwr,                     //                    .shiftwr
		output wire         capturewr,                   //                    .capturewr
		output wire         updatewr,                    //                    .updatewr
		output wire         selectwir,                   //                    .selectwir
		output wire         wsi,                         //                    .wsi
		output wire         wmc_clk_0_clk,               //           wmc_clk_0.clk
		output wire         phy_clk_0_clk,               //           phy_clk_0.clk
		output wire         wmcrst_n_0_reset_n,          //          wmcrst_n_0.reset_n
		input  wire [8:0]   axi_0_0_awid,                //             axi_0_0.awid
		input  wire [28:0]  axi_0_0_awaddr,              //                    .awaddr
		input  wire [7:0]   axi_0_0_awlen,               //                    .awlen
		input  wire [2:0]   axi_0_0_awsize,              //                    .awsize
		input  wire [1:0]   axi_0_0_awburst,             //                    .awburst
		input  wire [2:0]   axi_0_0_awprot,              //                    .awprot
		input  wire [3:0]   axi_0_0_awqos,               //                    .awqos
		input  wire [0:0]   axi_0_0_awuser,              //                    .awuser
		input  wire         axi_0_0_awvalid,             //                    .awvalid
		output wire         axi_0_0_awready,             //                    .awready
		input  wire [255:0] axi_0_0_wdata,               //                    .wdata
		input  wire [31:0]  axi_0_0_wstrb,               //                    .wstrb
		input  wire         axi_0_0_wlast,               //                    .wlast
		input  wire         axi_0_0_wvalid,              //                    .wvalid
		output wire         axi_0_0_wready,              //                    .wready
		output wire [8:0]   axi_0_0_bid,                 //                    .bid
		output wire [1:0]   axi_0_0_bresp,               //                    .bresp
		output wire         axi_0_0_bvalid,              //                    .bvalid
		input  wire         axi_0_0_bready,              //                    .bready
		input  wire [8:0]   axi_0_0_arid,                //                    .arid
		input  wire [28:0]  axi_0_0_araddr,              //                    .araddr
		input  wire [7:0]   axi_0_0_arlen,               //                    .arlen
		input  wire [2:0]   axi_0_0_arsize,              //                    .arsize
		input  wire [1:0]   axi_0_0_arburst,             //                    .arburst
		input  wire [2:0]   axi_0_0_arprot,              //                    .arprot
		input  wire [3:0]   axi_0_0_arqos,               //                    .arqos
		input  wire [0:0]   axi_0_0_aruser,              //                    .aruser
		input  wire         axi_0_0_arvalid,             //                    .arvalid
		output wire         axi_0_0_arready,             //                    .arready
		output wire [8:0]   axi_0_0_rid,                 //                    .rid
		output wire [255:0] axi_0_0_rdata,               //                    .rdata
		output wire [1:0]   axi_0_0_rresp,               //                    .rresp
		output wire         axi_0_0_rlast,               //                    .rlast
		output wire         axi_0_0_rvalid,              //                    .rvalid
		input  wire         axi_0_0_rready,              //                    .rready
		input  wire [8:0]   axi_0_1_awid,                //             axi_0_1.awid
		input  wire [28:0]  axi_0_1_awaddr,              //                    .awaddr
		input  wire [7:0]   axi_0_1_awlen,               //                    .awlen
		input  wire [2:0]   axi_0_1_awsize,              //                    .awsize
		input  wire [1:0]   axi_0_1_awburst,             //                    .awburst
		input  wire [2:0]   axi_0_1_awprot,              //                    .awprot
		input  wire [3:0]   axi_0_1_awqos,               //                    .awqos
		input  wire [0:0]   axi_0_1_awuser,              //                    .awuser
		input  wire         axi_0_1_awvalid,             //                    .awvalid
		output wire         axi_0_1_awready,             //                    .awready
		input  wire [255:0] axi_0_1_wdata,               //                    .wdata
		input  wire [31:0]  axi_0_1_wstrb,               //                    .wstrb
		input  wire         axi_0_1_wlast,               //                    .wlast
		input  wire         axi_0_1_wvalid,              //                    .wvalid
		output wire         axi_0_1_wready,              //                    .wready
		output wire [8:0]   axi_0_1_bid,                 //                    .bid
		output wire [1:0]   axi_0_1_bresp,               //                    .bresp
		output wire         axi_0_1_bvalid,              //                    .bvalid
		input  wire         axi_0_1_bready,              //                    .bready
		input  wire [8:0]   axi_0_1_arid,                //                    .arid
		input  wire [28:0]  axi_0_1_araddr,              //                    .araddr
		input  wire [7:0]   axi_0_1_arlen,               //                    .arlen
		input  wire [2:0]   axi_0_1_arsize,              //                    .arsize
		input  wire [1:0]   axi_0_1_arburst,             //                    .arburst
		input  wire [2:0]   axi_0_1_arprot,              //                    .arprot
		input  wire [3:0]   axi_0_1_arqos,               //                    .arqos
		input  wire [0:0]   axi_0_1_aruser,              //                    .aruser
		input  wire         axi_0_1_arvalid,             //                    .arvalid
		output wire         axi_0_1_arready,             //                    .arready
		output wire [8:0]   axi_0_1_rid,                 //                    .rid
		output wire [255:0] axi_0_1_rdata,               //                    .rdata
		output wire [1:0]   axi_0_1_rresp,               //                    .rresp
		output wire         axi_0_1_rlast,               //                    .rlast
		output wire         axi_0_1_rvalid,              //                    .rvalid
		input  wire         axi_0_1_rready,              //                    .rready
		output wire         axi_extra_0_0_ruser_err_dbe, //       axi_extra_0_0.ruser_err_dbe
		output wire [31:0]  axi_extra_0_0_ruser_data,    //                    .ruser_data
		input  wire [31:0]  axi_extra_0_0_wuser_data,    //                    .wuser_data
		input  wire [3:0]   axi_extra_0_0_wuser_strb,    //                    .wuser_strb
		output wire         axi_extra_0_1_ruser_err_dbe, //       axi_extra_0_1.ruser_err_dbe
		output wire [31:0]  axi_extra_0_1_ruser_data,    //                    .ruser_data
		input  wire [31:0]  axi_extra_0_1_wuser_data,    //                    .wuser_data
		input  wire [3:0]   axi_extra_0_1_wuser_strb,    //                    .wuser_strb
		input  wire [15:0]  apb_0_ur_paddr,              //               apb_0.ur_paddr
		input  wire         apb_0_ur_psel,               //                    .ur_psel
		input  wire         apb_0_ur_penable,            //                    .ur_penable
		input  wire         apb_0_ur_pwrite,             //                    .ur_pwrite
		input  wire [15:0]  apb_0_ur_pwdata,             //                    .ur_pwdata
		input  wire [1:0]   apb_0_ur_pstrb,              //                    .ur_pstrb
		output wire         apb_0_ur_prready,            //                    .ur_prready
		output wire [15:0]  apb_0_ur_prdata              //                    .ur_prdata
	);
endmodule

