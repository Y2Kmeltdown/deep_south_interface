// (C) 2001-2019 Intel Corporation. All rights reserved.
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
// Top-level wrapper of the AXI Traffic Generator.
///////////////////////////////////////////////////////////////////////////////

`define _get_pnf_id(_prefix, _i)  (  (((_i)==0) ? `"_prefix``0`" : \
                                     (((_i)==1) ? `"_prefix``1`" : \
                                     (((_i)==2) ? `"_prefix``2`" : \
                                     (((_i)==3) ? `"_prefix``3`" : \
                                     (((_i)==4) ? `"_prefix``4`" : \
                                     (((_i)==5) ? `"_prefix``5`" : \
                                     (((_i)==6) ? `"_prefix``6`" : \
                                     (((_i)==7) ? `"_prefix``7`" : `"_prefix``8`")))))))))

module altera_hbm_tg_axi_top # (
   parameter PROTOCOL_ENUM                           = "",
   parameter MEGAFUNC_DEVICE_FAMILY                  = "",
   parameter USE_SIMPLE_TG                           = 0,
   // SHORT -> Suitable for simulation only.
   // MEDIUM -> Generates more traffic for simple hardware testing in seconds.
   // INFINITE -> Generates traffic continuously and indefinitely.
   parameter TEST_DURATION                           = "SHORT",

   // Run the default traffic pattern
   parameter DIAG_RUN_DEFAULT_PATTERN             = 1,

   // Run the user test stage after a reset
   parameter DIAG_RUN_USER_STAGE                  = 0,

   // Run the repeated writes/repeated reads test stage
   parameter DIAG_RUN_REPEAT_STAGE                = 0,

   // Run the stress pattern stage
   parameter DIAG_RUN_STRESS_STAGE                = 0,

   // Use Efficiency Monitor
   parameter DIAG_EFFICIENCY_MONITOR              = 0,

   // Configure TG in efficiency test mode, which issues reads independently of writes.
   // In this mode we don't care about data checking, only achieving high efficiency.
   parameter DIAG_EFFICIENCY_TEST_MODE            = 0,

   // Issue block sequential pattern only
   parameter DIAG_MIXED_TRAFFIC                   = 0,

   // Internal test mode
   parameter ENABLE_TEST_MODE                     = 1, //TEST ONLY
   parameter DIAG_HBMC_TEST_PATTERN               = 0,

   // Word address width (as opposed to AWADDR/ARADDR WIDTH which are symbol width)
   parameter WORD_ADDR_WIDTH                      = 1,

   // Indicates whether byte-enable signal is used
   parameter USE_BYTE_EN                          = 1,

   // Needed to determine address map
   parameter USE_HARD_CTRL                        = 1,

   // Indicates whether MMR(APB) feature is used
   parameter USE_MMR_EN                           = 0,

   // Indicates whether MMR(APB) is connected
   parameter MMR_LINK                             = 0,

   // Indicates whether diag write parity feature is used
   parameter DIAG_WR_PAR                          = 0,

   // Indicates whether diag read parity feature is used
   parameter DIAG_RD_PAR                          = 0,

   // Indicates whether diag single bit error correction is used
   parameter DIAG_SBE_CORRECT                     = 0,

   // Indicates whether out-of-order reads are supported
   parameter DIAG_TG_OOO_EN                       = 1,

   // Indicates whether the TG will generate different read/write AXI IDs for each transaction.
   // Otherwise, all transactions will have ID 0.
   parameter DIAG_TG_GENERATE_RW_IDS              = 1,

   // Randomizes bready and rready
   parameter DIAG_TEST_RANDOM_AXI_READY           = 0,

   // Specifies alignment criteria for Avalon-MM word addresses and burst count
   parameter WORD_ADDRESS_DIVISIBLE_BY            = 1,
   parameter BURST_COUNT_DIVISIBLE_BY             = 1,

   // Specifies the number of core clock cycles to perform
   // a data transaction.  Depends on BL8 mode.
   parameter BURST_LEN                            = 1,

   // Enable user data ports
   parameter USER_DATA_EN                         = 1,

   parameter PORT_AXI_AWID_WIDTH           = 0,
   parameter PORT_AXI_AWADDR_WIDTH         = 0,
   parameter PORT_AXI_AWLEN_WIDTH          = 0,
   parameter PORT_AXI_AWSIZE_WIDTH         = 0,
   parameter PORT_AXI_AWBURST_WIDTH        = 0,
   parameter PORT_AXI_AWPROT_WIDTH         = 0,
   parameter PORT_AXI_AWQOS_WIDTH          = 0,
   parameter PORT_AXI_AWUSER_AP_WIDTH      = 0,
   parameter PORT_AXI_WDATA_WIDTH          = 0,
   parameter PORT_AXI_WSTRB_WIDTH          = 0,
   parameter PORT_AXI_BID_WIDTH            = 0,
   parameter PORT_AXI_BRESP_WIDTH          = 0,
   parameter PORT_AXI_ARID_WIDTH           = 0,
   parameter PORT_AXI_ARADDR_WIDTH         = 0,
   parameter PORT_AXI_ARLEN_WIDTH          = 0,
   parameter PORT_AXI_ARSIZE_WIDTH         = 0,
   parameter PORT_AXI_ARBURST_WIDTH        = 0,
   parameter PORT_AXI_ARPROT_WIDTH         = 0,
   parameter PORT_AXI_ARQOS_WIDTH          = 0,
   parameter PORT_AXI_ARUSER_AP_WIDTH      = 0,
   parameter PORT_AXI_RID_WIDTH            = 0,
   parameter PORT_AXI_RDATA_WIDTH          = 0,
   parameter PORT_AXI_RRESP_WIDTH          = 0,

   parameter PORT_AXI_EXTRA_RUSER_DATA_WIDTH = 0,
   parameter PORT_AXI_EXTRA_WUSER_DATA_WIDTH = 0,
   parameter PORT_AXI_EXTRA_WUSER_STRB_WIDTH = 0,

   parameter PORT_EFFMON_CSR_ADDRESS_WIDTH = 0,
   parameter PORT_EFFMON_CSR_RDATA_WIDTH   = 0,
   parameter PORT_EFFMON_CSR_WDATA_WIDTH   = 0,

   // Definition of port widths for "tg_cfg" interface
   parameter PORT_TG_CFG_ADDRESS_WIDTH      = 1,
   parameter PORT_TG_CFG_RDATA_WIDTH        = 1,
   parameter PORT_TG_CFG_WDATA_WIDTH        = 1,

   parameter MEM_TTL_DATA_WIDTH = 1,
   parameter MEM_TTL_NUM_OF_WRITE_GROUPS = 1,
   parameter MEM_STACK_ID_WIDTH = 0,
   parameter MEM_COL_ADDR_WIDTH = 1,
   parameter MEM_BANK_ADDR_WIDTH = 1,
   parameter MEM_ROW_ADDR_WIDTH = 1,
   parameter MEM_BANK_GROUP_WIDTH = 1,

   parameter STACK_ID_LSB   = 1,
   parameter ROW_ADDR_LSB   = 1,
   parameter BANK_ADDR_LSB  = 1,
   parameter COL_ADDR_LSB   = 1,
   parameter BANK_GROUP_LSB = 1,

   parameter SEED_OFFSET = 0,
   //Enable LFSR based on HBM JESD235A polynomial
   parameter DIAG_HBM_LFSR   = 0,

   parameter AVL_TO_DQ_WIDTH_RATIO = 1,

   parameter DIAG_INFI_TG_ERR_TEST = 0,

   parameter PORT_APB_PADDR_WIDTH = 10,
   parameter PORT_APB_PWDATA_WIDTH = 32,
   parameter PORT_APB_PSTRB_WIDTH = 4,
   parameter PORT_APB_PRDATA_WIDTH = 32,

   // AXI backpressure latency
   parameter BACKPRESSURE_LATENCY  = 0,
   parameter PIPELINE_RRESP        = 0,
   parameter PIPELINE_BRESP        = 0,
   // Efficiency test configurations
   parameter EFFICIENCY_FACTOR_NUM = 1,
   parameter EFFICIENCY_FACTOR_DEN = 1,
   parameter CFG_TG_READ_COUNT     = 0,
   parameter CFG_TG_WRITE_COUNT    = 0,
   parameter CFG_TG_SEQUENCE       = "",
   parameter TG_USE_EFFICIENCY_PATTERN = 0,
   parameter ENABLE_DATA_CHECK     = 0,
   parameter C2P_CLK_RATIO         = 1,
   parameter CORE_CLK_FREQ_MHZ     = 200,
   parameter USER_RFSH_ALL_EN      = 0
) (
   input                   wmc_clk_in,
   input                   wmcrst_n_in,

   input                   ninit_done,

   output [PORT_AXI_AWID_WIDTH-1:0]      awid,
   output [PORT_AXI_AWADDR_WIDTH-1:0]    awaddr,
   output [PORT_AXI_AWLEN_WIDTH-1:0]     awlen,
   output [PORT_AXI_AWSIZE_WIDTH-1:0]    awsize,
   output [PORT_AXI_AWBURST_WIDTH-1:0]   awburst,
   output [PORT_AXI_AWPROT_WIDTH-1:0]    awprot,
   output [PORT_AXI_AWQOS_WIDTH-1:0]     awqos,
   output [PORT_AXI_AWUSER_AP_WIDTH-1:0] awuser_ap,
   output                                awvalid,
   input                                 awready,

   output [PORT_AXI_WDATA_WIDTH-1:0]  wdata,
   output [PORT_AXI_WSTRB_WIDTH-1:0]  wstrb,
   output                             wlast,
   output                             wvalid,
   input                              wready,

   input [PORT_AXI_BID_WIDTH-1:0]     bid,
   input [PORT_AXI_BRESP_WIDTH-1:0]   bresp,
   input                              bvalid,
   output                             bready,

   output [PORT_AXI_ARID_WIDTH-1:0]      arid,
   output [PORT_AXI_ARADDR_WIDTH-1:0]    araddr,
   output [PORT_AXI_ARLEN_WIDTH-1:0]     arlen,
   output [PORT_AXI_ARSIZE_WIDTH-1:0]    arsize,
   output [PORT_AXI_ARBURST_WIDTH-1:0]   arburst,
   output [PORT_AXI_ARPROT_WIDTH-1:0]    arprot,
   output [PORT_AXI_ARQOS_WIDTH-1:0]     arqos,
   output [PORT_AXI_ARUSER_AP_WIDTH-1:0] aruser_ap,
   output                                arvalid,
   input                                 arready,

   input [PORT_AXI_RID_WIDTH-1:0]   rid,
   input [PORT_AXI_RDATA_WIDTH-1:0] rdata,
   input [PORT_AXI_RRESP_WIDTH-1:0] rresp,
   input                            rlast,
   input                            rvalid,
   output                           rready,

   input                                        ruser_err_dbe,
   input  [PORT_AXI_EXTRA_RUSER_DATA_WIDTH-1:0] ruser_data,
   output [PORT_AXI_EXTRA_WUSER_DATA_WIDTH-1:0] wuser_data,
   output [PORT_AXI_EXTRA_WUSER_STRB_WIDTH-1:0] wuser_strb,

   //Ports for MMR Register Interface (APB)
   output [PORT_APB_PADDR_WIDTH-1:0]             ur_paddr,
   output                   ur_psel,
   output                   ur_penable,
   output                   ur_pwrite,
   output [PORT_APB_PWDATA_WIDTH-1:0]            ur_pwdata,
   output [PORT_APB_PSTRB_WIDTH-1:0]             ur_pstrb,
   input                    ur_prready,
   input [PORT_APB_PRDATA_WIDTH-1:0]             ur_prdata,

   //Ports for "tg_cfg" interface
   output logic                                               tg_cfg_waitrequest,
   input  logic                                               tg_cfg_read,
   input  logic                                               tg_cfg_write,
   input  logic [PORT_TG_CFG_ADDRESS_WIDTH-1:0]               tg_cfg_address,
   output logic [PORT_TG_CFG_RDATA_WIDTH-1:0]                 tg_cfg_readdata,
   input  logic [PORT_TG_CFG_WDATA_WIDTH-1:0]                 tg_cfg_writedata,
   output logic                                               tg_cfg_readdatavalid,

   // Efficiency monitor CSR interface
   input   logic                                      effmon_csr_waitrequest,
   output  logic                                      effmon_csr_read,
   output  logic                                      effmon_csr_write,
   output  logic [PORT_EFFMON_CSR_ADDRESS_WIDTH-1:0]  effmon_csr_address,
   input   logic [PORT_EFFMON_CSR_RDATA_WIDTH-1:0]    effmon_csr_readdata,
   output  logic [PORT_EFFMON_CSR_WDATA_WIDTH-1:0]    effmon_csr_writedata,
   input   logic                                      effmon_csr_readdatavalid,

   //Ports for "tg_status" interfaces
   output logic                                               traffic_gen_pass,
   output logic                                               traffic_gen_fail,
   output logic                                               traffic_gen_timeout
);
   timeunit 1ns;
   timeprecision 1ps;

   localparam NUM_OF_PATTERNS = 1;
   localparam STATIC_RATIO_1  = 0;
   localparam NUM_EFFECTIVE_ADDRESSES = 2**(WORD_ADDR_WIDTH-((BURST_LEN == 2)? 1: 0));
   localparam RD_RATIO_1 = (NUM_OF_PATTERNS >= 1 )? CFG_TG_READ_COUNT:0; localparam WR_RATIO_1 = (NUM_OF_PATTERNS >= 1 )? CFG_TG_WRITE_COUNT:0; 
   localparam RD_RATIO_2 = (NUM_OF_PATTERNS >= 2 )? 5000:0; localparam WR_RATIO_2 = (NUM_OF_PATTERNS >= 2 )? 2500:0; 
   localparam RD_RATIO_3 = (NUM_OF_PATTERNS >= 3 )? 5000:0; localparam WR_RATIO_3 = (NUM_OF_PATTERNS >= 3 )? 2500:0; 
   localparam RD_RATIO_4 = (NUM_OF_PATTERNS >= 4 )? 5000:0; localparam WR_RATIO_4 = (NUM_OF_PATTERNS >= 4 )? 2500:0; 
   localparam RD_RATIO_5 = (NUM_OF_PATTERNS >= 5 )? 5000:0; localparam WR_RATIO_5 = (NUM_OF_PATTERNS >= 5 )? 2500:0; 
   localparam RD_RATIO_6 = (NUM_OF_PATTERNS >= 6 )? 5000:0; localparam WR_RATIO_6 = (NUM_OF_PATTERNS >= 6 )? 2500:0; 
   localparam RD_RATIO_7 = (NUM_OF_PATTERNS >= 7 )? 5000:0; localparam WR_RATIO_7 = (NUM_OF_PATTERNS >= 7 )? 2500:0; 
   localparam RD_RATIO_8 = (NUM_OF_PATTERNS >= 8 )? 5000:0; localparam WR_RATIO_8 = (NUM_OF_PATTERNS >= 8 )? 2500:0; 
   localparam RD_RATIO_9 = (NUM_OF_PATTERNS >= 9 )? 5000:0; localparam WR_RATIO_9 = (NUM_OF_PATTERNS >= 9 )? 2500:0; 
   localparam RD_RATIO_10= (NUM_OF_PATTERNS >= 10)? 5000:0; localparam WR_RATIO_10= (NUM_OF_PATTERNS >= 10)? 2500:0; 
   localparam RD_RATIO_11= (NUM_OF_PATTERNS >= 11)? 5000:0; localparam WR_RATIO_11= (NUM_OF_PATTERNS >= 11)? 2500:0; 
   localparam RD_RATIO_12= (NUM_OF_PATTERNS >= 12)? 5000:0; localparam WR_RATIO_12= (NUM_OF_PATTERNS >= 12)? 2500:0; 
   localparam RD_RATIO_13= (NUM_OF_PATTERNS >= 13)? 5000:0; localparam WR_RATIO_13= (NUM_OF_PATTERNS >= 13)? 2500:0; 
   localparam RD_RATIO_14= (NUM_OF_PATTERNS >= 14)? 5000:0; localparam WR_RATIO_14= (NUM_OF_PATTERNS >= 14)? 2500:0; 
   localparam RD_RATIO_15= (NUM_OF_PATTERNS >= 15)? 5000:0; localparam WR_RATIO_15= (NUM_OF_PATTERNS >= 15)? 2500:0; 
   localparam RD_RATIO_16= (NUM_OF_PATTERNS >= 16)? 5000:0; localparam WR_RATIO_16= (NUM_OF_PATTERNS >= 16)? 2500:0; 
   localparam RD_RATIO_17= (NUM_OF_PATTERNS >= 17)? 5000:0; localparam WR_RATIO_17= (NUM_OF_PATTERNS >= 17)? 2500:0; 
   localparam RD_RATIO_18= (NUM_OF_PATTERNS >= 18)? 5000:0; localparam WR_RATIO_18= (NUM_OF_PATTERNS >= 18)? 2500:0; 
   localparam RD_RATIO_19= (NUM_OF_PATTERNS >= 19)? 5000:0; localparam WR_RATIO_19= (NUM_OF_PATTERNS >= 19)? 2500:0; 
/*
   localparam RD_RATIO_1 = (NUM_OF_PATTERNS >= 1 )? 2520*340*5   :0; localparam WR_RATIO_1 = (NUM_OF_PATTERNS >= 1 )? 2520*340*5/2 :0; 
   localparam RD_RATIO_2 = (NUM_OF_PATTERNS >= 2 )? 2520*340*5   :0; localparam WR_RATIO_2 = (NUM_OF_PATTERNS >= 2 )? 2520*340*5/3 :0; 
   localparam RD_RATIO_3 = (NUM_OF_PATTERNS >= 3 )? 2520*340*5   :0; localparam WR_RATIO_3 = (NUM_OF_PATTERNS >= 3 )? 2520*340*5/4 :0; 
   localparam RD_RATIO_4 = (NUM_OF_PATTERNS >= 4 )? 2520*340*5   :0; localparam WR_RATIO_4 = (NUM_OF_PATTERNS >= 4 )? 2520*340*5/5 :0; 
   localparam RD_RATIO_5 = (NUM_OF_PATTERNS >= 5 )? 2520*340*5   :0; localparam WR_RATIO_5 = (NUM_OF_PATTERNS >= 5 )? 2520*340*5/6 :0; 
   localparam RD_RATIO_6 = (NUM_OF_PATTERNS >= 6 )? 2520*340*5   :0; localparam WR_RATIO_6 = (NUM_OF_PATTERNS >= 6 )? 2520*340*5/7 :0; 
   localparam RD_RATIO_7 = (NUM_OF_PATTERNS >= 7 )? 2520*340*5   :0; localparam WR_RATIO_7 = (NUM_OF_PATTERNS >= 7 )? 2520*340*5/9 :0; 
   localparam RD_RATIO_8 = (NUM_OF_PATTERNS >= 8 )? 2520*340*5   :0; localparam WR_RATIO_8 = (NUM_OF_PATTERNS >= 8 )? 2520*340*5/9 :0; 
   localparam RD_RATIO_9 = (NUM_OF_PATTERNS >= 9 )? 2520*340*5   :0; localparam WR_RATIO_9 = (NUM_OF_PATTERNS >= 9 )? 2520*340*5/10:0; 
   localparam RD_RATIO_10= (NUM_OF_PATTERNS >= 10)? 2520*340*5   :0; localparam WR_RATIO_10= (NUM_OF_PATTERNS >= 10)? 2520*340*5   :0; 
   localparam RD_RATIO_11= (NUM_OF_PATTERNS >= 11)? 2520*340*5/2 :0; localparam WR_RATIO_11= (NUM_OF_PATTERNS >= 11)? 2520*340*5   :0; 
   localparam RD_RATIO_12= (NUM_OF_PATTERNS >= 12)? 2520*340*5/3 :0; localparam WR_RATIO_12= (NUM_OF_PATTERNS >= 12)? 2520*340*5   :0; 
   localparam RD_RATIO_13= (NUM_OF_PATTERNS >= 13)? 2520*340*5/4 :0; localparam WR_RATIO_13= (NUM_OF_PATTERNS >= 13)? 2520*340*5   :0; 
   localparam RD_RATIO_14= (NUM_OF_PATTERNS >= 14)? 2520*340*5/5 :0; localparam WR_RATIO_14= (NUM_OF_PATTERNS >= 14)? 2520*340*5   :0; 
   localparam RD_RATIO_15= (NUM_OF_PATTERNS >= 15)? 2520*340*5/6 :0; localparam WR_RATIO_15= (NUM_OF_PATTERNS >= 15)? 2520*340*5   :0; 
   localparam RD_RATIO_16= (NUM_OF_PATTERNS >= 16)? 2520*340*5/7 :0; localparam WR_RATIO_16= (NUM_OF_PATTERNS >= 16)? 2520*340*5   :0; 
   localparam RD_RATIO_17= (NUM_OF_PATTERNS >= 17)? 2520*340*5/8 :0; localparam WR_RATIO_17= (NUM_OF_PATTERNS >= 17)? 2520*340*5   :0; 
   localparam RD_RATIO_18= (NUM_OF_PATTERNS >= 18)? 2520*340*5/9 :0; localparam WR_RATIO_18= (NUM_OF_PATTERNS >= 18)? 2520*340*5   :0; 
   localparam RD_RATIO_19= (NUM_OF_PATTERNS >= 19)? 2520*340*5/10:0; localparam WR_RATIO_19= (NUM_OF_PATTERNS >= 19)? 2520*340*5   :0; 
*/
   localparam SUM_RD = RD_RATIO_1 +  RD_RATIO_2 +  RD_RATIO_3 +  RD_RATIO_4  +
                       RD_RATIO_5 +  RD_RATIO_6 +  RD_RATIO_7 +  RD_RATIO_8  +
                       RD_RATIO_9 +  RD_RATIO_10+  RD_RATIO_11+  RD_RATIO_12 +
                       RD_RATIO_13+  RD_RATIO_14+  RD_RATIO_15+  RD_RATIO_16 +
                       RD_RATIO_17+  RD_RATIO_18+  RD_RATIO_19;
   localparam SUM_WR = WR_RATIO_1 +  WR_RATIO_2 +  WR_RATIO_3 +  WR_RATIO_4  +
                       WR_RATIO_5 +  WR_RATIO_6 +  WR_RATIO_7 +  WR_RATIO_8  +
                       WR_RATIO_9 +  WR_RATIO_10+  WR_RATIO_11+  WR_RATIO_12 +
                       WR_RATIO_13+  WR_RATIO_14+  WR_RATIO_15+  WR_RATIO_16 +
                       WR_RATIO_17+  WR_RATIO_18+  WR_RATIO_19;
   localparam INIT_WRITE_PHASE_LENGTH = STATIC_RATIO_1? NUM_EFFECTIVE_ADDRESSES: SUM_RD;

   wire [PORT_AXI_AWID_WIDTH-1:0]      awid_tg;
   wire [PORT_AXI_AWADDR_WIDTH-1:0]    awaddr_tg;
   wire [PORT_AXI_AWLEN_WIDTH-1:0]     awlen_tg;
   wire [PORT_AXI_AWSIZE_WIDTH-1:0]    awsize_tg;
   wire [PORT_AXI_AWBURST_WIDTH-1:0]   awburst_tg;
   wire [PORT_AXI_AWPROT_WIDTH-1:0]    awprot_tg;
   wire [PORT_AXI_AWQOS_WIDTH-1:0]     awqos_tg;
   wire [PORT_AXI_AWUSER_AP_WIDTH-1:0] awuser_ap_tg;
   wire                                awvalid_tg;
   wire                                awready_tg;
   wire [PORT_AXI_WDATA_WIDTH-1:0]     wdata_tg;
   wire [PORT_AXI_WSTRB_WIDTH-1:0]     wstrb_tg;
   wire                                wlast_tg;
   wire                                wvalid_tg;
   wire                                wready_tg;
   wire [PORT_AXI_BID_WIDTH-1:0]       bid_tg;
   wire [PORT_AXI_BRESP_WIDTH-1:0]     bresp_tg;
   wire                                bvalid_tg;
   wire                                bready_tg;
   wire [PORT_AXI_ARID_WIDTH-1:0]      arid_tg;
   wire [PORT_AXI_ARADDR_WIDTH-1:0]    araddr_tg;
   wire [PORT_AXI_ARLEN_WIDTH-1:0]     arlen_tg;
   wire [PORT_AXI_ARSIZE_WIDTH-1:0]    arsize_tg;
   wire [PORT_AXI_ARBURST_WIDTH-1:0]   arburst_tg;
   wire [PORT_AXI_ARPROT_WIDTH-1:0]    arprot_tg;
   wire [PORT_AXI_ARQOS_WIDTH-1:0]     arqos_tg;
   wire [PORT_AXI_ARUSER_AP_WIDTH-1:0] aruser_ap_tg;
   wire                                arvalid_tg;
   wire                                arready_tg;
   wire [PORT_AXI_RID_WIDTH-1:0]       rid_tg;
   wire [PORT_AXI_RDATA_WIDTH-1:0]     rdata_tg;
   wire [PORT_AXI_RRESP_WIDTH-1:0]     rresp_tg;
   wire                                rlast_tg;
   wire                                rvalid_tg;
   wire                                rready_tg;
   wire                                       ruser_err_dbe_tg;
   wire [PORT_AXI_EXTRA_RUSER_DATA_WIDTH-1:0] ruser_data_tg;
   wire [PORT_AXI_EXTRA_WUSER_DATA_WIDTH-1:0] wuser_data_tg;
   wire [PORT_AXI_EXTRA_WUSER_STRB_WIDTH-1:0] wuser_strb_tg;

   altera_hbm_tg_axi_backpressure #(
      .PORT_AXI_AWID_WIDTH              (PORT_AXI_AWID_WIDTH),
      .PORT_AXI_AWADDR_WIDTH            (PORT_AXI_AWADDR_WIDTH),
      .PORT_AXI_AWLEN_WIDTH             (PORT_AXI_AWLEN_WIDTH),
      .PORT_AXI_AWSIZE_WIDTH            (PORT_AXI_AWSIZE_WIDTH),
      .PORT_AXI_AWBURST_WIDTH           (PORT_AXI_AWBURST_WIDTH),
      .PORT_AXI_AWPROT_WIDTH            (PORT_AXI_AWPROT_WIDTH),
      .PORT_AXI_AWQOS_WIDTH             (PORT_AXI_AWQOS_WIDTH),
      .PORT_AXI_AWUSER_AP_WIDTH         (PORT_AXI_AWUSER_AP_WIDTH),
      .PORT_AXI_WDATA_WIDTH             (PORT_AXI_WDATA_WIDTH),
      .PORT_AXI_WSTRB_WIDTH             (PORT_AXI_WSTRB_WIDTH),
      .PORT_AXI_BID_WIDTH               (PORT_AXI_BID_WIDTH),
      .PORT_AXI_BRESP_WIDTH             (PORT_AXI_BRESP_WIDTH),
      .PORT_AXI_ARID_WIDTH              (PORT_AXI_ARID_WIDTH),
      .PORT_AXI_ARADDR_WIDTH            (PORT_AXI_ARADDR_WIDTH),
      .PORT_AXI_ARLEN_WIDTH             (PORT_AXI_ARLEN_WIDTH),
      .PORT_AXI_ARSIZE_WIDTH            (PORT_AXI_ARSIZE_WIDTH),
      .PORT_AXI_ARBURST_WIDTH           (PORT_AXI_ARBURST_WIDTH),
      .PORT_AXI_ARPROT_WIDTH            (PORT_AXI_ARPROT_WIDTH),
      .PORT_AXI_ARQOS_WIDTH             (PORT_AXI_ARQOS_WIDTH),
      .PORT_AXI_ARUSER_AP_WIDTH         (PORT_AXI_ARUSER_AP_WIDTH),
      .PORT_AXI_RID_WIDTH               (PORT_AXI_RID_WIDTH),
      .PORT_AXI_RDATA_WIDTH             (PORT_AXI_RDATA_WIDTH),
      .PORT_AXI_RRESP_WIDTH             (PORT_AXI_RRESP_WIDTH),
      .PORT_AXI_EXTRA_RUSER_DATA_WIDTH  (PORT_AXI_EXTRA_RUSER_DATA_WIDTH ),
      .PORT_AXI_EXTRA_WUSER_DATA_WIDTH  (PORT_AXI_EXTRA_WUSER_DATA_WIDTH ),
      .PORT_AXI_EXTRA_WUSER_STRB_WIDTH  (PORT_AXI_EXTRA_WUSER_STRB_WIDTH ),
      .BACKPRESSURE_LATENCY             (BACKPRESSURE_LATENCY),
      .PIPELINE_RRESP                   (PIPELINE_RRESP),
      .PIPELINE_BRESP                   (PIPELINE_BRESP)
   ) axi_backpressure_inst (
      .wmc_clk_in         (wmc_clk_in),
      .wmcrst_n_in        (wmcrst_n_in),
      .awid_tg            (awid_tg),
      .awaddr_tg          (awaddr_tg),
      .awlen_tg           (awlen_tg),
      .awsize_tg          (awsize_tg),
      .awburst_tg         (awburst_tg),
      .awprot_tg          (awprot_tg),
      .awqos_tg           (awqos_tg),
      .awuser_ap_tg       (awuser_ap_tg),
      .awvalid_tg         (awvalid_tg),
      .awready_tg         (awready_tg),
      .wdata_tg           (wdata_tg),
      .wstrb_tg           (wstrb_tg),
      .wlast_tg           (wlast_tg),
      .wvalid_tg          (wvalid_tg),
      .wready_tg          (wready_tg),
      .bid_tg             (bid_tg),
      .bresp_tg           (bresp_tg),
      .bvalid_tg          (bvalid_tg),
      .bready_tg          (bready_tg),
      .arid_tg            (arid_tg),
      .araddr_tg          (araddr_tg),
      .arlen_tg           (arlen_tg),
      .arsize_tg          (arsize_tg),
      .arburst_tg         (arburst_tg),
      .arprot_tg          (arprot_tg),
      .arqos_tg           (arqos_tg),
      .aruser_ap_tg       (aruser_ap_tg),
      .arvalid_tg         (arvalid_tg),
      .arready_tg         (arready_tg),
      .rid_tg             (rid_tg),
      .rdata_tg           (rdata_tg),
      .rresp_tg           (rresp_tg),
      .rlast_tg           (rlast_tg),
      .rvalid_tg          (rvalid_tg),
      .rready_tg          (rready_tg),
      .ruser_err_dbe_tg   (ruser_err_dbe_tg),
      .ruser_data_tg      (ruser_data_tg),
      .wuser_data_tg      (wuser_data_tg),
      .wuser_strb_tg      (wuser_strb_tg),

      .awid_hbm           (awid),
      .awaddr_hbm         (awaddr),
      .awlen_hbm          (awlen),
      .awsize_hbm         (awsize),
      .awburst_hbm        (awburst),
      .awprot_hbm         (awprot),
      .awqos_hbm          (awqos),
      .awuser_ap_hbm      (awuser_ap),
      .awvalid_hbm        (awvalid),
      .awready_hbm        (awready),
      .wdata_hbm          (wdata),
      .wstrb_hbm          (wstrb),
      .wlast_hbm          (wlast),
      .wvalid_hbm         (wvalid),
      .wready_hbm         (wready),
      .bid_hbm            (bid),
      .bresp_hbm          (bresp),
      .bvalid_hbm         (bvalid),
      .bready_hbm         (bready),
      .arid_hbm           (arid),
      .araddr_hbm         (araddr),
      .arlen_hbm          (arlen),
      .arsize_hbm         (arsize),
      .arburst_hbm        (arburst),
      .arprot_hbm         (arprot),
      .arqos_hbm          (arqos),
      .aruser_ap_hbm      (aruser_ap),
      .arvalid_hbm        (arvalid),
      .arready_hbm        (arready),
      .rid_hbm            (rid),
      .rdata_hbm          (rdata),
      .rresp_hbm          (rresp),
      .rlast_hbm          (rlast),
      .rvalid_hbm         (rvalid),
      .rready_hbm         (rready),
      .ruser_err_dbe_hbm  (ruser_err_dbe),
      .ruser_data_hbm     (ruser_data),
      .wuser_data_hbm     (wuser_data),
      .wuser_strb_hbm     (wuser_strb)
   );

   localparam TOTAL_DATA_WIDTH = PORT_AXI_WDATA_WIDTH + (USER_DATA_EN ? PORT_AXI_EXTRA_WUSER_DATA_WIDTH : 0);
   localparam TOTAL_STRB_WIDTH = PORT_AXI_WSTRB_WIDTH + (USER_DATA_EN ? PORT_AXI_EXTRA_WUSER_STRB_WIDTH : 0);
   localparam NUMBER_OF_DATA_GENERATORS = TOTAL_DATA_WIDTH / AVL_TO_DQ_WIDTH_RATIO;
   localparam NUMBER_OF_BYTE_EN_GENERATORS = TOTAL_STRB_WIDTH / AVL_TO_DQ_WIDTH_RATIO;
   logic [TOTAL_DATA_WIDTH-1:0] ref_data;

   logic [TOTAL_DATA_WIDTH-1:0]         pnf_per_bit_persist;
   logic                                    issp_reset_n;
   logic                                    reset_n_pre_sync;
   logic                                    reset_n_int;
   wire [TOTAL_DATA_WIDTH-1:0] wdata_int, rdata_int;
   wire [TOTAL_STRB_WIDTH-1:0] wstrb_int;
   assign rdata_int = USER_DATA_EN ? {ruser_data_tg, rdata_tg} : rdata_tg;
   assign wdata_tg = wdata_int[PORT_AXI_WDATA_WIDTH-1:0];
   assign wuser_data_tg = wdata_int[TOTAL_DATA_WIDTH-1 : TOTAL_DATA_WIDTH-PORT_AXI_EXTRA_WUSER_DATA_WIDTH];
   assign wstrb_tg = wstrb_int[PORT_AXI_WSTRB_WIDTH-1:0];
   assign wuser_strb_tg = wstrb_int[TOTAL_STRB_WIDTH-1 : TOTAL_STRB_WIDTH-PORT_AXI_EXTRA_WUSER_STRB_WIDTH];

   localparam AMM_CFG_ADDR_WIDTH       = 10;
   localparam RW_RPT_COUNT_WIDTH       = 8;
   localparam RW_OPERATION_COUNT_WIDTH = 28;
   localparam RW_LOOP_COUNT_WIDTH      = 28;
   localparam TOTAL_OP_COUNT_WIDTH     = RW_LOOP_COUNT_WIDTH + RW_OPERATION_COUNT_WIDTH + RW_RPT_COUNT_WIDTH;
   localparam BURSTCOUNT_WIDTH         = 4;
   localparam TEST_DURATION_LOCAL = DIAG_INFI_TG_ERR_TEST ? "INFINITE" : TEST_DURATION;
   //Enforce pattern lentgh to match memory burst length. This to allow the same set of write/expected
   //data to be repeated for the subsequent Write/Read. This important to ensure the repetition feature
   //to work correctly. If decided to make it longer than memory burst length, user need to ensure
   //repetition feature is not use or the loaded pattern will repeat itself for the next Write/Read
   localparam DIAG_TG_DATA_PATTERN_LENGTH   = BURST_LEN * AVL_TO_DQ_WIDTH_RATIO;
   localparam DIAG_TG_BE_PATTERN_LENGTH     = BURST_LEN * AVL_TO_DQ_WIDTH_RATIO;

   wire [PORT_TG_CFG_ADDRESS_WIDTH-1:0]  amm_cfg_address;
   wire [PORT_TG_CFG_WDATA_WIDTH-1:0]    amm_cfg_writedata;
   wire [PORT_TG_CFG_RDATA_WIDTH-1:0]    amm_cfg_readdata;
   wire amm_cfg_readdatavalid;
   wire amm_cfg_write;
   wire amm_cfg_read;
   wire amm_cfg_wait_req;

   wire [WORD_ADDR_WIDTH-1:0]       ast_exp_data_readaddr;
   wire [TOTAL_DATA_WIDTH-1:0]  ast_exp_data_writedata;
   wire [TOTAL_STRB_WIDTH-1:0]  ast_exp_data_byteenable;

   wire  ast_act_data_readdatavalid;
   wire [TOTAL_DATA_WIDTH-1:0]  ast_act_data_readdata;
   wire [PORT_AXI_RID_WIDTH-1:0]    ast_act_data_rid;
   wire [PORT_AXI_RID_WIDTH-1:0]    ast_act_data_rid_pl;

   //status signals
   wire                                 clear_first_fail;
   wire                                 byteenable_stage;
   wire [TOTAL_OP_COUNT_WIDTH-1:0]      failure_count;
   wire [TOTAL_DATA_WIDTH-1:0]      first_fail_expected_data;
   wire [TOTAL_DATA_WIDTH-1:0]      first_fail_read_data;
   wire                                 first_fail_read;
   wire                                 first_fail_write;

   //asserted when driver control block writes start to r/w gen
   wire tg_restart;

   wire all_tests_issued;
   wire reads_in_prog;
   wire restart_default_traffic;
   wire test_stage_fail;
   wire [WORD_ADDR_WIDTH-1:0] first_fail_addr;

   wire mmr_check_en;
   wire mmr_check_fail;
   wire mmr_check_done;
   wire initialization_phase;
   wire init_stage;
   generate
   if (USE_SIMPLE_TG) begin
        altera_hbm_tg_axi_driver_simple #(
            .TG_TEST_DURATION               (TEST_DURATION_LOCAL),
            .AMM_BURSTCOUNT_WIDTH           (BURSTCOUNT_WIDTH),
            .MEM_ADDR_WIDTH                 (WORD_ADDR_WIDTH),
            .WORD_ADDRESS_DIVISIBLE_BY      (WORD_ADDRESS_DIVISIBLE_BY),
            .BURST_LEN                      (BURST_LEN),
            .PORT_AXI_AWID_WIDTH            (PORT_AXI_AWID_WIDTH),
            .PORT_AXI_AWADDR_WIDTH          (PORT_AXI_AWADDR_WIDTH),
            .PORT_AXI_AWQOS_WIDTH           (PORT_AXI_AWQOS_WIDTH),
            .PORT_AXI_AWUSER_AP_WIDTH       (PORT_AXI_AWUSER_AP_WIDTH),
            .PORT_AXI_WDATA_WIDTH           (TOTAL_DATA_WIDTH),
            .PORT_AXI_WSTRB_WIDTH           (TOTAL_STRB_WIDTH),
            .PORT_AXI_BID_WIDTH             (PORT_AXI_BID_WIDTH),
            .PORT_AXI_BRESP_WIDTH           (PORT_AXI_BRESP_WIDTH),
            .PORT_AXI_ARID_WIDTH            (PORT_AXI_ARID_WIDTH),
            .PORT_AXI_ARADDR_WIDTH          (PORT_AXI_ARADDR_WIDTH),
            .PORT_AXI_ARQOS_WIDTH           (PORT_AXI_ARQOS_WIDTH),
            .PORT_AXI_ARUSER_AP_WIDTH       (PORT_AXI_ARUSER_AP_WIDTH),
            .PORT_AXI_RID_WIDTH             (PORT_AXI_RID_WIDTH),
            .PORT_AXI_RDATA_WIDTH           (TOTAL_DATA_WIDTH),
            .PORT_AXI_RRESP_WIDTH           (PORT_AXI_RRESP_WIDTH)
        ) traffic_gen_inst(
            .clk                            (wmc_clk_in),
            .reset_n                        (reset_n_int),

            .awid                           (awid_tg),
            .awaddr                         (awaddr_tg),
            .awqos                          (awqos_tg),
            .awuser_ap                      (awuser_ap_tg),
            .awvalid                        (awvalid_tg),
            .awready                        (awready_tg),

            .wdata                          (wdata_int),
            .wstrb                          (wstrb_int),
            .wlast                          (wlast_tg),
            .wvalid                         (wvalid_tg),
            .wready                         (wready_tg),

            .bid                            (bid_tg),
            .bresp                          (bresp_tg),
            .bvalid                         (bvalid_tg),
            .bready                         (bready_tg),

            .arid                           (arid_tg),
            .araddr                         (araddr_tg),
            .arqos                          (arqos_tg),
            .aruser_ap                      (aruser_ap_tg),
            .arvalid                        (arvalid_tg),
            .arready                        (arready_tg),

            .rid                            (rid_tg),
            .rdata                          (rdata_int),
            .rresp                          (rresp_tg),
            .rlast                          (rlast_tg),
            .rvalid                         (rvalid_tg),
            .rready                         (rready_tg),

            .pass                           (traffic_gen_pass),
            .fail                           (traffic_gen_fail),
            .pnf_per_bit                    (),
            .pnf_per_bit_persist            (pnf_per_bit_persist),
            .mmr_check_en                   (mmr_check_en)
       );
         assign ur_paddr = '0;
         assign ur_psel = '0;
         assign ur_penable = '0;
         assign ur_pwrite = '0;
         assign ur_pwdata = '0;
         assign ur_pstrb = '0;
   end else begin
   altera_hbm_tg_axi_bringup_dcb #(
      .NUMBER_OF_DATA_GENERATORS    (NUMBER_OF_DATA_GENERATORS),
      .NUMBER_OF_BYTE_EN_GENERATORS (NUMBER_OF_BYTE_EN_GENERATORS),
      .DATA_PATTERN_LENGTH          (DIAG_TG_DATA_PATTERN_LENGTH),
      .BYTE_EN_PATTERN_LENGTH       (DIAG_TG_BE_PATTERN_LENGTH),
      .USE_BYTE_EN                  (USE_BYTE_EN),
      .USE_MMR_EN                   (USE_MMR_EN),
      .MMR_LINK                     (MMR_LINK),
      .MEM_ADDR_WIDTH               (WORD_ADDR_WIDTH),
      .BURSTCOUNT_WIDTH             (BURSTCOUNT_WIDTH),
      .TG_TEST_DURATION             (TEST_DURATION_LOCAL),
      .PORT_TG_CFG_ADDRESS_WIDTH    (PORT_TG_CFG_ADDRESS_WIDTH),
      .PORT_TG_CFG_RDATA_WIDTH      (PORT_TG_CFG_RDATA_WIDTH),
      .PORT_TG_CFG_WDATA_WIDTH      (PORT_TG_CFG_WDATA_WIDTH),
      .WRITE_GROUP_WIDTH            (MEM_TTL_DATA_WIDTH / MEM_TTL_NUM_OF_WRITE_GROUPS),
      .DIAG_BYPASS_DEFAULT_PATTERN  (!DIAG_RUN_DEFAULT_PATTERN),
      .DIAG_BYPASS_USER_STAGE       (!DIAG_RUN_USER_STAGE),
      .DIAG_BYPASS_REPEAT_STAGE     (!DIAG_RUN_REPEAT_STAGE),
      .DIAG_BYPASS_STRESS_STAGE     (!DIAG_RUN_STRESS_STAGE),
      .DIAG_HBMC_TEST_MODE          (ENABLE_TEST_MODE),
      .DIAG_MIXED_TRAFFIC           (DIAG_MIXED_TRAFFIC),
      .SEED_OFFSET                  (SEED_OFFSET),
      .BURST_COUNT_DIVISIBLE_BY     (BURST_COUNT_DIVISIBLE_BY),
      .BURST_LEN                    (BURST_LEN),
      .DIAG_HBMC_TEST_PATTERN       (DIAG_HBMC_TEST_PATTERN),
      .NUM_OF_PATTERNS (NUM_OF_PATTERNS),
      .RD_RATIO_1  (RD_RATIO_1 ),
      .RD_RATIO_2  (RD_RATIO_2 ),
      .RD_RATIO_3  (RD_RATIO_3 ),
      .RD_RATIO_4  (RD_RATIO_4 ),
      .RD_RATIO_5  (RD_RATIO_5 ),
      .RD_RATIO_6  (RD_RATIO_6 ),
      .RD_RATIO_7  (RD_RATIO_7 ),
      .RD_RATIO_8  (RD_RATIO_8 ),
      .RD_RATIO_9  (RD_RATIO_9 ),
      .RD_RATIO_10 (RD_RATIO_10),
      .RD_RATIO_11 (RD_RATIO_11),
      .RD_RATIO_12 (RD_RATIO_12),
      .RD_RATIO_13 (RD_RATIO_13),
      .RD_RATIO_14 (RD_RATIO_14),
      .RD_RATIO_15 (RD_RATIO_15),
      .RD_RATIO_16 (RD_RATIO_16),
      .RD_RATIO_17 (RD_RATIO_17),
      .RD_RATIO_18 (RD_RATIO_18),
      .RD_RATIO_19 (RD_RATIO_19),
      .WR_RATIO_1  (WR_RATIO_1 ),
      .WR_RATIO_2  (WR_RATIO_2 ),
      .WR_RATIO_3  (WR_RATIO_3 ),
      .WR_RATIO_4  (WR_RATIO_4 ),
      .WR_RATIO_5  (WR_RATIO_5 ),
      .WR_RATIO_6  (WR_RATIO_6 ),
      .WR_RATIO_7  (WR_RATIO_7 ),
      .WR_RATIO_8  (WR_RATIO_8 ),
      .WR_RATIO_9  (WR_RATIO_9 ),
      .WR_RATIO_10 (WR_RATIO_10),
      .WR_RATIO_11 (WR_RATIO_11),
      .WR_RATIO_12 (WR_RATIO_12),
      .WR_RATIO_13 (WR_RATIO_13),
      .WR_RATIO_14 (WR_RATIO_14),
      .WR_RATIO_15 (WR_RATIO_15),
      .WR_RATIO_16 (WR_RATIO_16),
      .WR_RATIO_17 (WR_RATIO_17),
      .WR_RATIO_18 (WR_RATIO_18),
      .WR_RATIO_19 (WR_RATIO_19),
      .INIT_WRITE_PHASE_LENGTH (INIT_WRITE_PHASE_LENGTH),
      .STATIC_RATIO_1 (STATIC_RATIO_1),
      .TG_USE_EFFICIENCY_PATTERN      (TG_USE_EFFICIENCY_PATTERN)
   ) bu_dcb_inst (
      .clk                             (wmc_clk_in),
      .rst                             (~reset_n_int),
      .initialization_phase            (initialization_phase),
      .init_stage(init_stage),
      //trigger the driver control block when calibration has passed and ready is high
      .awready                         (awready_tg),
      .arready                         (arready_tg),

      .amm_cfg_in_waitrequest          (tg_cfg_waitrequest),
      .amm_cfg_in_address              (tg_cfg_address),
      .amm_cfg_in_writedata            (tg_cfg_writedata),
      .amm_cfg_in_write                (tg_cfg_write),
      .amm_cfg_in_read                 (tg_cfg_read),
      .amm_cfg_in_readdata             (tg_cfg_readdata),
      .amm_cfg_in_readdatavalid        (tg_cfg_readdatavalid),

      //configuration interface to/from traffic generator
      .amm_cfg_out_waitrequest          (amm_cfg_wait_req),
      .amm_cfg_out_address              (amm_cfg_address),
      .amm_cfg_out_writedata            (amm_cfg_writedata),
      .amm_cfg_out_write                (amm_cfg_write),
      .amm_cfg_out_read                 (amm_cfg_read),
      .amm_cfg_out_readdata             (amm_cfg_readdata),
      .amm_cfg_out_readdatavalid        (amm_cfg_readdatavalid),

      .restart_default_traffic          (restart_default_traffic),

      //configuration interface to/from mmr_test_stage
      .mmr_check_en                     (mmr_check_en),
      .mmr_check_done                   (mmr_check_done),
      .mmr_check_fail                   (mmr_check_fail),

      //status checker related signals for special tests
      .all_tests_issued             (all_tests_issued),
      .stage_failure                (test_stage_fail),
      .first_fail_addr              (first_fail_addr),
      .traffic_gen_fail             (traffic_gen_fail)
   );

   altera_hbm_tg_axi_traffic_gen #(
      .NUMBER_OF_DATA_GENERATORS      (NUMBER_OF_DATA_GENERATORS),
      .HBM_LFSR                       (DIAG_HBM_LFSR),
      .NUMBER_OF_BYTE_EN_GENERATORS   (NUMBER_OF_BYTE_EN_GENERATORS),
      .AMM_CFG_ADDR_WIDTH             (PORT_TG_CFG_ADDRESS_WIDTH),
      .AMM_CFG_DATA_WIDTH             (PORT_TG_CFG_WDATA_WIDTH),
      .DATA_RATE_WIDTH_RATIO          (AVL_TO_DQ_WIDTH_RATIO),
      .DIAG_TG_DATA_PATTERN_LENGTH    (DIAG_TG_DATA_PATTERN_LENGTH),
      .DIAG_TG_BYTE_EN_PATTERN_LENGTH (DIAG_TG_BE_PATTERN_LENGTH),
      .OP_COUNT_WIDTH                 (TOTAL_OP_COUNT_WIDTH),
      .RW_RPT_COUNT_WIDTH             (RW_RPT_COUNT_WIDTH),
      .RW_OPERATION_COUNT_WIDTH       (RW_OPERATION_COUNT_WIDTH),
      .RW_LOOP_COUNT_WIDTH            (RW_LOOP_COUNT_WIDTH),
      .MEM_ADDR_WIDTH                 (WORD_ADDR_WIDTH),
      .ROW_ADDR_WIDTH                 (MEM_ROW_ADDR_WIDTH),
      .ROW_ADDR_LSB                   (ROW_ADDR_LSB),
      .SID_ADDR_WIDTH                (MEM_STACK_ID_WIDTH),
      .SID_ADDR_LSB                  (STACK_ID_LSB),
      .BANK_ADDR_WIDTH                (MEM_BANK_ADDR_WIDTH),
      .BANK_ADDR_LSB                  (BANK_ADDR_LSB),
      .BANK_GROUP_LSB                 (BANK_GROUP_LSB),
      .BANK_GROUP_WIDTH               (MEM_BANK_GROUP_WIDTH),
      .AMM_BURSTCOUNT_WIDTH           (BURSTCOUNT_WIDTH),
      .MEM_DATA_WIDTH                 (TOTAL_DATA_WIDTH),
      .MEM_RDATA_WIDTH                (TOTAL_DATA_WIDTH),
      .MEM_BE_WIDTH                   (TOTAL_STRB_WIDTH),
      .USE_BYTE_EN                    (USE_BYTE_EN),
      .DIAG_TG_OOO_EN                 (DIAG_TG_OOO_EN),
      .DIAG_TG_GENERATE_RW_IDS        (DIAG_TG_GENERATE_RW_IDS),
      .DIAG_TEST_RANDOM_AXI_READY     (DIAG_TEST_RANDOM_AXI_READY),
      .WORD_ADDRESS_DIVISIBLE_BY      (WORD_ADDRESS_DIVISIBLE_BY),
      .BURST_COUNT_DIVISIBLE_BY       (BURST_COUNT_DIVISIBLE_BY),
      .DIAG_EFFICIENCY_MONITOR        (DIAG_EFFICIENCY_MONITOR),
      .DIAG_EFFICIENCY_TEST_MODE      (DIAG_EFFICIENCY_TEST_MODE),
      .DIAG_HBMC_TEST_MODE            (ENABLE_TEST_MODE),
      .BURST_LEN                      (BURST_LEN),
      .PORT_EFFMON_CSR_ADDRESS_WIDTH  (PORT_EFFMON_CSR_ADDRESS_WIDTH),
      .PORT_EFFMON_CSR_RDATA_WIDTH    (PORT_EFFMON_CSR_RDATA_WIDTH),
      .PORT_EFFMON_CSR_WDATA_WIDTH    (PORT_EFFMON_CSR_WDATA_WIDTH),
      .PORT_AXI_AWID_WIDTH            (PORT_AXI_AWID_WIDTH),
		.PORT_AXI_AWADDR_WIDTH          (PORT_AXI_AWADDR_WIDTH),
		.PORT_AXI_AWLEN_WIDTH           (PORT_AXI_AWLEN_WIDTH),
		.PORT_AXI_AWSIZE_WIDTH          (PORT_AXI_AWSIZE_WIDTH),
		.PORT_AXI_AWBURST_WIDTH         (PORT_AXI_AWBURST_WIDTH),
		.PORT_AXI_AWPROT_WIDTH          (PORT_AXI_AWPROT_WIDTH),
		.PORT_AXI_AWQOS_WIDTH           (PORT_AXI_AWQOS_WIDTH),
		.PORT_AXI_AWUSER_AP_WIDTH       (PORT_AXI_AWUSER_AP_WIDTH),
		.PORT_AXI_WDATA_WIDTH           (TOTAL_DATA_WIDTH),
		.PORT_AXI_WSTRB_WIDTH           (TOTAL_STRB_WIDTH),
		.PORT_AXI_BID_WIDTH             (PORT_AXI_BID_WIDTH),
		.PORT_AXI_BRESP_WIDTH           (PORT_AXI_BRESP_WIDTH),
		.PORT_AXI_ARID_WIDTH            (PORT_AXI_ARID_WIDTH),
		.PORT_AXI_ARADDR_WIDTH          (PORT_AXI_ARADDR_WIDTH),
		.PORT_AXI_ARLEN_WIDTH           (PORT_AXI_ARLEN_WIDTH),
		.PORT_AXI_ARSIZE_WIDTH          (PORT_AXI_ARSIZE_WIDTH),
		.PORT_AXI_ARBURST_WIDTH         (PORT_AXI_ARBURST_WIDTH),
		.PORT_AXI_ARPROT_WIDTH          (PORT_AXI_ARPROT_WIDTH),
		.PORT_AXI_ARQOS_WIDTH           (PORT_AXI_ARQOS_WIDTH),
		.PORT_AXI_ARUSER_AP_WIDTH       (PORT_AXI_ARUSER_AP_WIDTH),
		.PORT_AXI_RID_WIDTH             (PORT_AXI_RID_WIDTH),
		.PORT_AXI_RDATA_WIDTH           (TOTAL_DATA_WIDTH),
    .SEED_OFFSET                    (SEED_OFFSET),
    .EFFICIENCY_FACTOR_NUM          (EFFICIENCY_FACTOR_NUM),
    .EFFICIENCY_FACTOR_DEN          (EFFICIENCY_FACTOR_DEN),
    .SUM_RD                         (SUM_RD),
    .SUM_WR                         (SUM_WR),
    .STATIC_RATIO_1                 (STATIC_RATIO_1),
    .CFG_TG_SEQUENCE                (CFG_TG_SEQUENCE),
    .TG_USE_EFFICIENCY_PATTERN      (TG_USE_EFFICIENCY_PATTERN),
    .ENABLE_DATA_CHECK              (ENABLE_DATA_CHECK),
    .C2P_CLK_RATIO                  (C2P_CLK_RATIO)
   )
   traffic_gen_inst(
      .clk                  (wmc_clk_in),
      .rst                  (~reset_n_int),
      .tg_restart           (tg_restart),
      .initialization_phase (initialization_phase),
      .init_stage           (init_stage),
      .ref_data             (ref_data),
      // To controller
      .awid(awid_tg),
      .awaddr(awaddr_tg),
      .awqos(awqos_tg),
      .awuser_ap(awuser_ap_tg),
      .awvalid(awvalid_tg),
      .awready(awready_tg),

      //  Write Data Channels
      .wdata(wdata_int),
      .wstrb(wstrb_int),
      .wlast(wlast_tg),
      .wvalid(wvalid_tg),
      .wready(wready_tg),

      //  Write Response Channel
      .bid(bid_tg),
      .bresp(bresp_tg),
      .bvalid(bvalid_tg),
      .bready(bready_tg),

      //  Read Address Channels
      .arid(arid_tg),
      .araddr(araddr_tg),
      .arqos(arqos_tg),
      .aruser_ap(aruser_ap_tg),
      .arvalid(arvalid_tg),
      .arready(arready_tg),

      //  Read Data Channels
      .rid(rid_tg),
      .rdata(rdata_int),
      .rresp(rresp_tg),
      .rlast(rlast_tg),
      .rvalid(rvalid_tg),
      .rready(rready_tg),

      //Expected data for comparison in status checker
      .ast_exp_data_byteenable    (ast_exp_data_byteenable),
      .ast_exp_data_writedata     (ast_exp_data_writedata),
      .ast_exp_data_readaddr      (ast_exp_data_readaddr),

      //Actual data for comparison in status checker
      .ast_act_data_readdatavalid (ast_act_data_readdatavalid),
      .ast_act_data_readdata      (ast_act_data_readdata),
      .ast_act_data_rid           (ast_act_data_rid),
      .ast_act_data_rid_pl        (ast_act_data_rid_pl),

      //configuration interface to/from driver config block
      .amm_cfg_address            (amm_cfg_address),
      .amm_cfg_writedata          (amm_cfg_writedata),
      .amm_cfg_readdata           (amm_cfg_readdata),
      .amm_cfg_readdatavalid      (amm_cfg_readdatavalid),
      .amm_cfg_write              (amm_cfg_write),
      .amm_cfg_read               (amm_cfg_read),
      .amm_cfg_waitrequest        (amm_cfg_wait_req),

      // Efficiency monitor CSR interface
      .effmon_csr_waitrequest(effmon_csr_waitrequest),
      .effmon_csr_read(effmon_csr_read),
      .effmon_csr_write(effmon_csr_write),
      .effmon_csr_address(effmon_csr_address),
      .effmon_csr_readdata(effmon_csr_readdata),
      .effmon_csr_writedata(effmon_csr_writedata),
      .effmon_csr_readdatavalid(effmon_csr_readdatavalid),

      //status report
      .clear_first_fail           (clear_first_fail),
      .byteenable_stage           (byteenable_stage),
      .pnf_per_bit_persist        (pnf_per_bit_persist),
      .fail                       (test_stage_fail),
      .pass                       (traffic_gen_pass),
      .first_fail_addr            ({{(64-WORD_ADDR_WIDTH){1'b0}}, first_fail_addr}),
      .failure_count              ({{(64-TOTAL_OP_COUNT_WIDTH){1'b0}}, failure_count}),
      .first_fail_expected_data   (first_fail_expected_data),
      .first_fail_read_data       (first_fail_read_data),
      .first_fail_read            (first_fail_read),
      .first_fail_write           (first_fail_write),

      //extra signals used by the status checker
      .reads_in_prog              (reads_in_prog),

      .restart_default_traffic    (restart_default_traffic)
      );

      altera_hbm_tg_axi_status_checker # (
         .DATA_WIDTH                   (TOTAL_DATA_WIDTH),
         .ID_WIDTH                     (PORT_AXI_RID_WIDTH),
         .BE_WIDTH                     (TOTAL_STRB_WIDTH),
         .ADDR_WIDTH                   (WORD_ADDR_WIDTH),
         .OP_COUNT_WIDTH               (TOTAL_OP_COUNT_WIDTH),
         .TEST_DURATION                (TEST_DURATION_LOCAL),
         .INFI_TG_ERR_TEST             (DIAG_INFI_TG_ERR_TEST),
         .TG_USE_EFFICIENCY_PATTERN    (TG_USE_EFFICIENCY_PATTERN),
         .ENABLE_DATA_CHECK            (ENABLE_DATA_CHECK)
      ) status_checker_inst (
         .clk                        (wmc_clk_in),
         .rst                        (~reset_n_int),
         .tg_restart                 (1'b0),
         .enable                     (1'b1),
         .ref_data                   (ref_data),
         //Expected data for comparison in status checker
         .ast_exp_data_writedata     (ast_exp_data_writedata),
         .ast_exp_data_byteenable    (ast_exp_data_byteenable),
         .ast_exp_data_readaddr      (ast_exp_data_readaddr),

         //Actual data for comparison
         .ast_act_data_readdatavalid (ast_act_data_readdatavalid),
         .ast_act_data_readdata      (ast_act_data_readdata),
         .ast_act_data_rid           (ast_act_data_rid),
         .ast_act_data_rid_pl        (ast_act_data_rid_pl),


         //status report
         .clear_first_fail           (clear_first_fail),
         .pnf_per_bit_persist        (pnf_per_bit_persist),
         .fail                       (test_stage_fail),
         .pass                       (traffic_gen_pass),
         .first_fail_addr            (first_fail_addr),
         .failure_count              (failure_count),
         .first_fail_expected_data   (first_fail_expected_data),
         .first_fail_read_data       (first_fail_read_data),
         .first_fail_read            (first_fail_read),
         .first_fail_write           (first_fail_write),

         //driver control block info
         .all_tests_issued           (all_tests_issued),
         .byteenable_stage           (byteenable_stage),

         .reads_in_prog              (reads_in_prog),
         .timeout                    (traffic_gen_timeout)
      );


      altera_hbm_tg_axi_mmr_test_stage #(
         .USE_HARD_CTRL              (USE_HARD_CTRL),
         .DIAG_RD_PAR                (DIAG_RD_PAR),
         .DIAG_WR_PAR                (DIAG_WR_PAR),
         .DIAG_SBE_CORRECT           (DIAG_SBE_CORRECT),
         .PORT_APB_PADDR_WIDTH       (PORT_APB_PADDR_WIDTH),
         .PORT_APB_PWDATA_WIDTH      (PORT_APB_PWDATA_WIDTH),
         .PORT_APB_PSTRB_WIDTH       (PORT_APB_PSTRB_WIDTH),
         .PORT_APB_PRDATA_WIDTH      (PORT_APB_PRDATA_WIDTH),
	 .CORE_CLK_FREQ_MHZ          (CORE_CLK_FREQ_MHZ),
	 .USER_RFSH_ALL_EN           (USER_RFSH_ALL_EN),
	 .MMR_LINK                   (MMR_LINK)
      )mmr_checker_inst(
         .clk                        (wmc_clk_in),
         .rst                        (~reset_n_int),
         .enable                     (mmr_check_en),
         .fail                       (mmr_check_fail),
         .done                       (mmr_check_done),

          //Ports for MMR Register Interface (APB)
         .ur_paddr                   (ur_paddr),
         .ur_psel                    (ur_psel) ,
         .ur_penable                 (ur_penable) ,
         .ur_pwrite                  (ur_pwrite),
         .ur_pwdata                  (ur_pwdata) ,
         .ur_pstrb                   (ur_pstrb) ,
         .ur_prready                 (ur_prready) ,
         .ur_prdata                  (ur_prdata)
   );
   end
   endgenerate
   
   `ifdef ALTERA_EMIF_ENABLE_ISSP
      // acds/quartus/libraries/megafunctions/altsource_probe_body.vhd
      localparam MAX_PROBE_WIDTH = 511;
      localparam TTL_PNF_WIDTH = TOTAL_DATA_WIDTH;

      // This source is out of reset by default (for users who don't want to use this)
      altsource_probe #(
         .sld_auto_instance_index ("YES"),
         .sld_instance_index      (0),
         .instance_id             ("TGR"),
         .probe_width             (0),
         .source_width            (1),
         .source_initial_value    ("1"),
         .enable_metastability    ("NO")
      ) tg_reset_n_issp (
         .source  (issp_reset_n)
      );

      altsource_probe #(
         .sld_auto_instance_index ("YES"),
         .sld_instance_index      (0),
         .instance_id             ("TGST"),
         .probe_width             (3),
         .source_width            (0),
         .source_initial_value    ("0"),
         .enable_metastability    ("NO")
      ) tg_status (
         .probe  ({traffic_gen_timeout, traffic_gen_fail, traffic_gen_pass})
      );

   genvar i;
   generate
      for (i = 0; i < (TTL_PNF_WIDTH + MAX_PROBE_WIDTH - 1) / MAX_PROBE_WIDTH; i = i + 1)
      begin : gen_pnf
         altsource_probe #(
            .sld_auto_instance_index ("YES"),
            .sld_instance_index      (0),
            .instance_id             (`_get_pnf_id(PNF, i)),
            .probe_width             ((MAX_PROBE_WIDTH * (i+1)) > TTL_PNF_WIDTH ? TTL_PNF_WIDTH - (MAX_PROBE_WIDTH * i) : MAX_PROBE_WIDTH),
            .source_width            (0),
            .source_initial_value    ("0"),
            .enable_metastability    ("NO")
         ) tg_pnf (
            .probe  (pnf_per_bit_persist[((MAX_PROBE_WIDTH * (i+1) - 1) < TTL_PNF_WIDTH-1 ? (MAX_PROBE_WIDTH * (i+1) - 1) : TTL_PNF_WIDTH-1) : (MAX_PROBE_WIDTH * i)])
         );
      end
   endgenerate
   `else
      assign issp_reset_n = 1'b1;
   `endif

   // Reset from the wmcrst_n port or the in-system source
   assign reset_n_pre_sync = wmcrst_n_in & issp_reset_n & ~ninit_done;

   // Create synchronized versions of the resets
   altera_hbm_tg_axi_reset_sync # (
      .NUM_RESET_OUTPUT (1)
   ) reset_sync_inst (
      .reset_n      (reset_n_pre_sync),
      .clk          (wmc_clk_in),
      .reset_n_sync (reset_n_int)
   );

   // Tie off unused signals
   assign arburst_tg = '0;
   assign arlen_tg = '0;
   assign arprot_tg = '0;
   assign arsize_tg = BURST_LEN == 4 ? 3'b110 : 3'b101; 
   assign awburst_tg = '0;
   assign awlen_tg = '0;
   assign awprot_tg = '0;
   assign awsize_tg = BURST_LEN == 4 ? 3'b110 : 3'b101;

endmodule
