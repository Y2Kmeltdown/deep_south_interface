module tg_bottom0_1 (
		input  wire         wmc_clk_in,          //  wmc_clk_in.clk
		input  wire         wmcrst_n_in,         // wmcrst_n_in.reset_n
		input  wire         ninit_done,          //  ninit_done.ninit_done
		output wire [8:0]   awid,                //         axi.awid
		output wire [28:0]  awaddr,              //            .awaddr
		output wire [7:0]   awlen,               //            .awlen
		output wire [2:0]   awsize,              //            .awsize
		output wire [1:0]   awburst,             //            .awburst
		output wire [2:0]   awprot,              //            .awprot
		output wire [3:0]   awqos,               //            .awqos
		output wire [0:0]   awuser_ap,           //            .awuser
		output wire         awvalid,             //            .awvalid
		input  wire         awready,             //            .awready
		output wire [255:0] wdata,               //            .wdata
		output wire [31:0]  wstrb,               //            .wstrb
		output wire         wlast,               //            .wlast
		output wire         wvalid,              //            .wvalid
		input  wire         wready,              //            .wready
		input  wire [8:0]   bid,                 //            .bid
		input  wire [1:0]   bresp,               //            .bresp
		input  wire         bvalid,              //            .bvalid
		output wire         bready,              //            .bready
		output wire [8:0]   arid,                //            .arid
		output wire [28:0]  araddr,              //            .araddr
		output wire [7:0]   arlen,               //            .arlen
		output wire [2:0]   arsize,              //            .arsize
		output wire [1:0]   arburst,             //            .arburst
		output wire [2:0]   arprot,              //            .arprot
		output wire [3:0]   arqos,               //            .arqos
		output wire [0:0]   aruser_ap,           //            .aruser
		output wire         arvalid,             //            .arvalid
		input  wire         arready,             //            .arready
		input  wire [8:0]   rid,                 //            .rid
		input  wire [255:0] rdata,               //            .rdata
		input  wire [1:0]   rresp,               //            .rresp
		input  wire         rlast,               //            .rlast
		input  wire         rvalid,              //            .rvalid
		output wire         rready,              //            .rready
		input  wire         ruser_err_dbe,       //   axi_extra.ruser_err_dbe
		input  wire [31:0]  ruser_data,          //            .ruser_data
		output wire [31:0]  wuser_data,          //            .wuser_data
		output wire [3:0]   wuser_strb,          //            .wuser_strb
		output wire         traffic_gen_pass,    //   tg_status.traffic_gen_pass
		output wire         traffic_gen_fail,    //            .traffic_gen_fail
		output wire         traffic_gen_timeout  //            .traffic_gen_timeout
	);
endmodule

