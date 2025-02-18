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


`timescale 1 ps/1 ps 
module qsys_top_avmm_bridge_512_0_altera_xcvr_pcie_hip_native_s10_191_xndluca (
  // Rate Switching from the master channel
  input  wire [1:0]         pipe_sw_done,             
  output wire [1:0]         pipe_sw,                  

  input  wire [16*80-1:0]    tx_parallel_data,
  output wire [16*80-1:0]    rx_parallel_data,
  input  wire [16-1:0]       tx_analogreset,           
  input  wire [16-1:0]       tx_digitalreset,          
  input  wire [16-1:0]       rx_analogreset,           
  input  wire [16-1:0]       rx_digitalreset,          
  input  wire [16-1:0]       tx_aibreset,              
  input  wire [16-1:0]       rx_aibreset,              
  output wire [16-1:0]       tx_reset_out,
  output wire [16-1:0]       rx_reset_out,
  output wire [16-1:0]       tx_transfer_ready,        
  output wire [16-1:0]       rx_transfer_ready,        
  output wire [16-1:0]       tx_cal_busy,              
  output wire [16-1:0]       rx_cal_busy,              
  input  wire [5:0]         tx_bonding_clocks,        
  input  wire               rx_cdr_refclk0,           
  output wire [16-1:0]       tx_serial_data,           
  input  wire [16-1:0]       rx_serial_data,           
  output wire [16-1:0]       rx_is_lockedtoref,        
  output wire [16-1:0]       rx_is_lockedtodata,       

  output wire [16-1:0]       tx_clkout,                
  output wire [16-1:0]       tx_clkout2,               
  output wire [16-1:0]       rx_clkout,                
  input  wire               pipe_hclk_in,             
  input  wire               tx_serial_clk0,             
  input  wire               tx_serial_clk1,             

  input  wire [16*3-1:0]     pipe_rx_eidleinfersel,    
  output wire [16-1:0]       pipe_rx_elecidle,         

  input  wire [16*101-1:0]   hip_aib_data_in,          
  output wire [16*132-1:0]   hip_aib_data_out,         
  input  wire [16*92-1:0]    hip_pcs_data_in,          
  output wire [16*62-1:0]    hip_pcs_data_out,         
  input  wire [16*4-1:0]     hip_aib_fsr_in,           
  input  wire [16*40-1:0]    hip_aib_ssr_in,           
  output wire [16*4-1:0]     hip_aib_fsr_out,          
  output wire [16*8-1:0]     hip_aib_ssr_out,          
  input  wire [16*2-1:0]     hip_in_reserved_out,   
  output wire [16-1:0]       hip_cal_done,
  output wire [16-1:0]       pld_pmaif_mask_tx_pll,
  output wire [16-1:0]       pcie_ctrl_testbus_b10,
 
        

  input  wire               reconfig_clk,
  input  wire               reconfig_reset,
  input  wire               reconfig_write,
  input  wire               reconfig_read,
  input  wire [11+4-1:0]       reconfig_address,
  // always expects 4-bit select address to match higher level interface
  input  wire [32-1:0]      reconfig_writedata,
  output wire [32-1:0]      reconfig_readdata,
  output wire               reconfig_waitrequest
);

// Localparams for reconfig
localparam ADDR_BITS          = 11;
localparam AVMM_WIDTH         = 32;
localparam CHANNEL_SEL_WIDTH  = 4;

// Wires for Clocks
wire [16-1:0]       tx_coreclkin;
wire [16-1:0]       rx_coreclkin;
wire [16-1:0]       tx_x2_coreclkin;

// Bonding PCS
wire [((16+1)*30)-1:0]  pcs_bonding_top_data_out;
wire [((16+1)*30)-1:0]  pcs_bonding_bot_data_out;
assign pcs_bonding_top_data_out [0+:30]                 = 30'b0;
assign pcs_bonding_bot_data_out [16*30+:30]  = 30'b0;

// Bonding AIB Core TX
wire [((16+1)*5)-1:0]   pld_aib_bond_tx_us_out;
wire [((16+1)*5)-1:0]   pld_aib_bond_tx_ds_out;
assign pld_aib_bond_tx_us_out   [0+:5]                  = 5'b0;
assign pld_aib_bond_tx_ds_out   [16*5+:5]    = 5'b0;

// Bonding AIB Core Rx
wire [((16+1)*5)-1:0]   pld_aib_bond_rx_us_out;
wire [((16+1)*5)-1:0]   pld_aib_bond_rx_ds_out;
assign pld_aib_bond_rx_us_out   [0+:5]                  = 5'b0;
assign pld_aib_bond_rx_ds_out   [16*5+:5]    = 5'b0;

// Bonding AIB HSSI TX
wire [((16+1)*7)-1:0]   hssi_aib_bond_tx_us_out;
wire [((16+1)*7)-1:0]   hssi_aib_bond_tx_ds_out;
assign hssi_aib_bond_tx_us_out  [0+:7]                  = 7'b0;
assign hssi_aib_bond_tx_ds_out  [7*16+:7]    = 7'b0;

// Bonding AIB HSSI RX
wire [((16+1)*8)-1:0]   hssi_aib_bond_rx_us_out;
wire [((16+1)*8)-1:0]   hssi_aib_bond_rx_ds_out;
assign hssi_aib_bond_rx_us_out  [0+:8]                  = 8'b0;
assign hssi_aib_bond_rx_ds_out  [8*16+:8]    = 8'b0;

///////////////////////////////////////////////////////////////
// Reconfig Channel Sharing
///////////////////////////////////////////////////////////////
wire [CHANNEL_SEL_WIDTH-1:0]          rcfg_if_sel;
wire [16-1:0]                          split_avmm_clk;
wire [16-1:0]                          split_avmm_reset;
wire [16-1:0]                          split_user_write;
wire [16-1:0]                          split_user_read;
wire [16-1:0]                          split_user_waitrequest;
wire [16*ADDR_BITS-1:0]                split_user_address;
wire [16*AVMM_WIDTH-1:0]               split_user_readdata;
wire [16*AVMM_WIDTH-1:0]               split_user_writedata;

///////////////////////////////////////////////////////////////
// Reset Sequencer
///////////////////////////////////////////////////////////////
wire                      clk;
wire                      reset_n;
wire  [16-1:0] tx_aibreset_out;
wire  [16-1:0] rx_aibreset_out;
altera_s10_xcvr_clkout_endpoint clock_endpoint ( 
  .clk_out                             (  clk                                       )
); 

//***************************************************************************
// Need to self-generate internal reset signal
//***************************************************************************
alt_xcvr_resync_std #(
	.SYNC_CHAIN_LENGTH(3),
	.INIT_VALUE(0)
) reset_n_generator (
	.clk	(clk),
	.reset	(1'b0),
	.d		(1'b1),
	.q		(reset_n)
);

alt_xcvr_native_dig_reset_seq
#(
  .CLK_FREQ_IN_HZ                      (  100000000                                 ),
  .DEFAULT_RESET_SEPARATION_NS         (  200                                       ),
  .RESET_SEPARATION_NS                 (  200                                       ),
  .PCS_RESET_EXTENSION_NS              (  200                                       ),
  .RESET_MODE                          (  "bonded"                                  ),
  .BONDING_MASTER                      (  0                                         ),
  .NUM_CHANNELS                        (  16                             ),
  .ENABLE_PCS_RESET                    (  0                                         ),
  .RESET_AIB_FIRST                     (  1                                         )
) altera_xcvr_pcie_hip_native_tx_aib_reset_seq (
  .clk                                 (  clk                                       ),
  .reset_n                             (  reset_n                                   ), // ???
  .release_aib_first                   (  1'b1                                      ), // double check with lee ping
  .reset_in                            (  tx_aibreset                               ), 
  .transfer_ready_in                   (  tx_transfer_ready                         ), // From?
  .aib_reset_out                       (  tx_aibreset_out                           ), // reset to AIB
  .pcs_reset_out                       (                                            ), // left hanging?
  .reset_out                           (  tx_reset_out                              )  // reset out to... top? is this the busy signal?
);

alt_xcvr_native_dig_reset_seq
#(
  .CLK_FREQ_IN_HZ                      (  100000000                                 ),
  .DEFAULT_RESET_SEPARATION_NS         (  200                                       ),
  .RESET_SEPARATION_NS                 (  200                                       ),
  .PCS_RESET_EXTENSION_NS              (  200                                       ),
  .RESET_MODE                          (  "bonded"                                  ),
  .BONDING_MASTER                      (  4                                         ),
  .NUM_CHANNELS                        (  16                             ),
  .ENABLE_PCS_RESET                    (  0                                         ),
  .RESET_AIB_FIRST                     (  1                                         )
) altera_xcvr_pcie_hip_native_rx_aib_reset_seq (
  .clk                                 (  clk                                       ),
  .reset_n                             (  reset_n                                   ), // ???
  .release_aib_first                   (  1'b1                                      ), 
  .reset_in                            (  rx_aibreset                               ), 
  .transfer_ready_in                   (  rx_transfer_ready                         ), // From?
  .aib_reset_out                       (  rx_aibreset_out                           ),
  .pcs_reset_out                       (                                            ), // left hanging?
  .reset_out                           (  rx_reset_out                              )  // reset out to... top? is this the busy signal?
);

///////////////////////////////////////////////////////////////
// Transceiver Channels
///////////////////////////////////////////////////////////////
genvar ig;
generate
// Generate interface select based on upper address bits
assign rcfg_if_sel          = reconfig_address      [ADDR_BITS+:CHANNEL_SEL_WIDTH];
assign reconfig_readdata    = split_user_readdata   [rcfg_if_sel*AVMM_WIDTH +: AVMM_WIDTH];
assign reconfig_waitrequest = split_user_waitrequest[rcfg_if_sel];

for(ig=0;ig<16;ig=ig+1) begin: g_shared_reconfig_interface
  // Split shared signals to independent channels
  assign split_avmm_clk        [ig]  = reconfig_clk;
  assign split_avmm_reset      [ig]  = reconfig_reset;

  assign split_user_write      [ig]  = reconfig_write & (rcfg_if_sel == ig);
  assign split_user_read       [ig]  = reconfig_read  & (rcfg_if_sel == ig);
  assign split_user_address    [ig*ADDR_BITS +: ADDR_BITS] = reconfig_address[0+:ADDR_BITS];
  assign split_user_writedata  [ig*AVMM_WIDTH+:AVMM_WIDTH] = reconfig_writedata;
end
endgenerate


///////////////////////////////////////////////////////////////
// Transceiver Channel Instance 0
// Generating Slave Channel
///////////////////////////////////////////////////////////////
assign tx_coreclkin[0]    = tx_clkout[0];
assign rx_coreclkin[0]    = tx_clkout[0];
assign tx_x2_coreclkin[0] = tx_clkout2[0];
wire [61:0]    int_hip_pcs_data_out_0;
assign hip_pcs_data_out[0*62+:62] = {int_hip_pcs_data_out_0[61],pipe_hclk_in,int_hip_pcs_data_out_0[59:0]};
qsys_top_avmm_bridge_512_0_altera_xcvr_pcie_hip_native_s10_altera_xcvr_native_s10_htile_191_sglyhua altera_xcvr_hip_channel_s10_ch0 (
  // Channel Signals
  /*input  wire [1:0]   */  .pipe_sw_done                    ( 2'b0                                    ),
  /*output wire [1:0]   */  .pipe_sw                         (                                         ),
  /*input  wire [79:0]  */  .tx_parallel_data                ( tx_parallel_data           [0*80+:80]   ),
  /*output wire [79:0]  */  .rx_parallel_data                ( rx_parallel_data           [0*80+:80]   ),
  /*input  wire [0:0]   */  .tx_analogreset                  ( tx_analogreset             [0]          ),
  /*input  wire [0:0]   */  .tx_digitalreset                 ( tx_digitalreset            [0]          ),
  /*input  wire [0:0]   */  .rx_analogreset                  ( rx_analogreset             [0]          ),
  /*input  wire [0:0]   */  .rx_digitalreset                 ( rx_digitalreset            [0]          ),
  /*input  wire [0:0]   */  .tx_aibreset                     ( tx_aibreset_out            [0]          ),
  /*input  wire [0:0]   */  .rx_aibreset                     ( rx_aibreset_out            [0]          ),
  /*output wire [0:0]   */  .tx_transfer_ready               ( tx_transfer_ready          [0]          ),
  /*output wire [0:0]   */  .rx_transfer_ready               ( rx_transfer_ready          [0]          ),
  /*output wire [0:0]   */  .tx_cal_busy                     ( tx_cal_busy                [0]          ),
  /*output wire [0:0]   */  .rx_cal_busy                     ( rx_cal_busy                [0]          ),
  /*input  wire         */  .rx_cdr_refclk0                  ( rx_cdr_refclk0                          ),
  /*output wire [0:0]   */  .tx_serial_data                  ( tx_serial_data             [0]          ),
  /*input  wire [0:0]   */  .rx_serial_data                  ( rx_serial_data             [0]          ),
  /*output wire [0:0]   */  .rx_is_lockedtoref               ( rx_is_lockedtoref          [0]          ),
  /*output wire [0:0]   */  .rx_is_lockedtodata              ( rx_is_lockedtodata         [0]          ),
  /*input  wire [0:0]   */  .tx_coreclkin                    ( tx_coreclkin               [0]          ),
  /*input  wire [0:0]   */  .rx_coreclkin                    ( rx_coreclkin               [0]          ),
  /*input  wire [0:0]   */  .tx_x2_coreclkin                 ( tx_x2_coreclkin            [0]          ),
  /*output wire [0:0]   */  .tx_clkout                       ( tx_clkout                  [0]          ),
  /*output wire [0:0]   */  .tx_clkout2                      ( tx_clkout2                 [0]          ),
  /*output wire [0:0]   */  .rx_clkout                       ( rx_clkout                  [0]          ),
  /*input  wire         */  .pipe_hclk_in                    ( pipe_hclk_in                            ),
  /*input  wire [5:0]   */  .tx_bonding_clocks               ( tx_bonding_clocks                         ),

  /*input  wire [2:0]   */  .pipe_rx_eidleinfersel           ( pipe_rx_eidleinfersel      [0*3+:3]     ),
  /*output wire [0:0]   */  .pipe_rx_elecidle                ( pipe_rx_elecidle           [0]          ),

  // Bonding PCS
  /*output wire [29:0]  */  .pcs_bonding_top_data_out        ( pcs_bonding_top_data_out   [(0+1)*30+:30]),
  /*input  wire [29:0]  */  .pcs_bonding_bot_data_in         ( pcs_bonding_top_data_out   [0*30+:30]    ), 
  /*output wire [29:0]  */  .pcs_bonding_bot_data_out        ( pcs_bonding_bot_data_out   [0*30+:30]    ), 
  /*input  wire [29:0]  */  .pcs_bonding_top_data_in         ( pcs_bonding_bot_data_out   [(0+1)*30+:30]),

  // Bonding AIB Core TX
  /*output wire [4:0]   */  .pld_aib_bond_tx_us_out          ( pld_aib_bond_tx_us_out     [(0+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_ds_in           ( pld_aib_bond_tx_us_out     [0*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_tx_ds_out          ( pld_aib_bond_tx_ds_out     [0*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_us_in           ( pld_aib_bond_tx_ds_out     [(0+1)*5+:5] ),

  // Bonding AIB Core Rx
  /*output wire [4:0]   */  .pld_aib_bond_rx_us_out          ( pld_aib_bond_rx_us_out     [(0+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_ds_in           ( pld_aib_bond_rx_us_out     [0*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_rx_ds_out          ( pld_aib_bond_rx_ds_out     [0*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_us_in           ( pld_aib_bond_rx_ds_out     [(0+1)*5+:5] ),

  // Bonding AIB HSSI TX
  /*output wire [6:0]   */  .hssi_aib_bond_tx_us_out         ( hssi_aib_bond_tx_us_out    [(0+1)*7+:7] ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_ds_in          ( hssi_aib_bond_tx_us_out    [0*7+:7]     ),
  /*output wire [6:0]   */  .hssi_aib_bond_tx_ds_out         ( hssi_aib_bond_tx_ds_out    [0*7+:7]     ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_us_in          ( hssi_aib_bond_tx_ds_out    [(0+1)*7+:7] ),

  // Bonding AIB HSSI RX
  /*output wire [7:0]   */  .hssi_aib_bond_rx_us_out         ( hssi_aib_bond_rx_us_out    [(0+1)*8+:8] ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_ds_in          ( hssi_aib_bond_rx_us_out    [0*8+:8]     ),
  /*output wire [7:0]   */  .hssi_aib_bond_rx_ds_out         ( hssi_aib_bond_rx_ds_out    [0*8+:8]     ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_us_in          ( hssi_aib_bond_rx_ds_out    [(0+1)*8+:8] ),

  // Reconfig Signals
                            .reconfig_clk                    ( split_avmm_clk             [0]          ),
                            .reconfig_reset                  ( split_avmm_reset           [0]          ),
                            .reconfig_read                   ( split_user_read            [0]          ),
                            .reconfig_write                  ( split_user_write           [0]          ),
                            .reconfig_address                ( split_user_address         [0*11+:11]   ),
                            .reconfig_readdata               ( split_user_readdata        [0*32+:32]   ),
                            .reconfig_writedata              ( split_user_writedata       [0*32+:32]   ),
                            .reconfig_waitrequest            ( split_user_waitrequest     [0]          ),

  // HIP Signals
  /*input  wire [100:0] */  .hip_aib_data_in                 ( hip_aib_data_in            [0*101+:101] ),
  /*output wire [131:0] */  .hip_aib_data_out                ( hip_aib_data_out           [0*132+:132] ),
  /*input  wire [91:0]  */  .hip_pcs_data_in                 ( hip_pcs_data_in            [0*92+:92]   ),
  /*output wire [61:0]  */  .hip_pcs_data_out                ( int_hip_pcs_data_out_0                  ),
  /*input  wire [3:0]   */  .hip_aib_fsr_in                  ( hip_aib_fsr_in             [0*4+:4]     ),
  /*input  wire [39:0]  */  .hip_aib_ssr_in                  ( hip_aib_ssr_in             [0*40+:40]   ),
  /*output wire [3:0]   */  .hip_aib_fsr_out                 ( hip_aib_fsr_out            [0*4+:4]     ),
  /*output wire [7:0]   */  .hip_aib_ssr_out                 ( hip_aib_ssr_out            [0*8+:8]     ),
  /*input  wire [1:0]   */  .hip_in_reserved_out             ( hip_in_reserved_out        [0*2+:2]     ),
  /*output wire [0:0]   */  .pld_pmaif_mask_tx_pll           ( pld_pmaif_mask_tx_pll      [0]          ),
  /*output wire [0:0]   */  .pldadapt_out_test_data_b10      ( pcie_ctrl_testbus_b10      [0]          ),
  /*output wire [0:0]   */  .hip_cal_done                    ( hip_cal_done               [0]          )

);

///////////////////////////////////////////////////////////////
// Transceiver Channel Instance 1
// Generating Slave Channel
///////////////////////////////////////////////////////////////
assign tx_coreclkin[1]    = tx_clkout[0];
assign rx_coreclkin[1]    = tx_clkout[0];
assign tx_x2_coreclkin[1] = tx_clkout2[0];
wire [61:0]    int_hip_pcs_data_out_1;
assign hip_pcs_data_out[1*62+:62] = int_hip_pcs_data_out_1;
qsys_top_avmm_bridge_512_0_altera_xcvr_pcie_hip_native_s10_altera_xcvr_native_s10_htile_191_ox327yy altera_xcvr_hip_channel_s10_ch1 (
  // Channel Signals
  /*input  wire [1:0]   */  .pipe_sw_done                    ( 2'b0                                    ),
  /*output wire [1:0]   */  .pipe_sw                         (                                         ),
  /*input  wire [79:0]  */  .tx_parallel_data                ( tx_parallel_data           [1*80+:80]   ),
  /*output wire [79:0]  */  .rx_parallel_data                ( rx_parallel_data           [1*80+:80]   ),
  /*input  wire [0:0]   */  .tx_analogreset                  ( tx_analogreset             [1]          ),
  /*input  wire [0:0]   */  .tx_digitalreset                 ( tx_digitalreset            [1]          ),
  /*input  wire [0:0]   */  .rx_analogreset                  ( rx_analogreset             [1]          ),
  /*input  wire [0:0]   */  .rx_digitalreset                 ( rx_digitalreset            [1]          ),
  /*input  wire [0:0]   */  .tx_aibreset                     ( tx_aibreset_out            [1]          ),
  /*input  wire [0:0]   */  .rx_aibreset                     ( rx_aibreset_out            [1]          ),
  /*output wire [0:0]   */  .tx_transfer_ready               ( tx_transfer_ready          [1]          ),
  /*output wire [0:0]   */  .rx_transfer_ready               ( rx_transfer_ready          [1]          ),
  /*output wire [0:0]   */  .tx_cal_busy                     ( tx_cal_busy                [1]          ),
  /*output wire [0:0]   */  .rx_cal_busy                     ( rx_cal_busy                [1]          ),
  /*input  wire         */  .rx_cdr_refclk0                  ( rx_cdr_refclk0                          ),
  /*output wire [0:0]   */  .tx_serial_data                  ( tx_serial_data             [1]          ),
  /*input  wire [0:0]   */  .rx_serial_data                  ( rx_serial_data             [1]          ),
  /*output wire [0:0]   */  .rx_is_lockedtoref               ( rx_is_lockedtoref          [1]          ),
  /*output wire [0:0]   */  .rx_is_lockedtodata              ( rx_is_lockedtodata         [1]          ),
  /*input  wire [0:0]   */  .tx_coreclkin                    ( tx_coreclkin               [1]          ),
  /*input  wire [0:0]   */  .rx_coreclkin                    ( rx_coreclkin               [1]          ),
  /*input  wire [0:0]   */  .tx_x2_coreclkin                 ( tx_x2_coreclkin            [1]          ),
  /*output wire [0:0]   */  .tx_clkout                       ( tx_clkout                  [1]          ),
  /*output wire [0:0]   */  .tx_clkout2                      ( tx_clkout2                 [1]          ),
  /*output wire [0:0]   */  .rx_clkout                       ( rx_clkout                  [1]          ),
  /*input  wire         */  .pipe_hclk_in                    ( pipe_hclk_in                            ),
  /*input  wire [5:0]   */  .tx_bonding_clocks               ( tx_bonding_clocks                         ),

  /*input  wire [2:0]   */  .pipe_rx_eidleinfersel           ( pipe_rx_eidleinfersel      [1*3+:3]     ),
  /*output wire [0:0]   */  .pipe_rx_elecidle                ( pipe_rx_elecidle           [1]          ),

  // Bonding PCS
  /*output wire [29:0]  */  .pcs_bonding_top_data_out        ( pcs_bonding_top_data_out   [(1+1)*30+:30]),
  /*input  wire [29:0]  */  .pcs_bonding_bot_data_in         ( pcs_bonding_top_data_out   [1*30+:30]    ), 
  /*output wire [29:0]  */  .pcs_bonding_bot_data_out        ( pcs_bonding_bot_data_out   [1*30+:30]    ), 
  /*input  wire [29:0]  */  .pcs_bonding_top_data_in         ( pcs_bonding_bot_data_out   [(1+1)*30+:30]),

  // Bonding AIB Core TX
  /*output wire [4:0]   */  .pld_aib_bond_tx_us_out          ( pld_aib_bond_tx_us_out     [(1+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_ds_in           ( pld_aib_bond_tx_us_out     [1*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_tx_ds_out          ( pld_aib_bond_tx_ds_out     [1*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_us_in           ( pld_aib_bond_tx_ds_out     [(1+1)*5+:5] ),

  // Bonding AIB Core Rx
  /*output wire [4:0]   */  .pld_aib_bond_rx_us_out          ( pld_aib_bond_rx_us_out     [(1+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_ds_in           ( pld_aib_bond_rx_us_out     [1*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_rx_ds_out          ( pld_aib_bond_rx_ds_out     [1*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_us_in           ( pld_aib_bond_rx_ds_out     [(1+1)*5+:5] ),

  // Bonding AIB HSSI TX
  /*output wire [6:0]   */  .hssi_aib_bond_tx_us_out         ( hssi_aib_bond_tx_us_out    [(1+1)*7+:7] ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_ds_in          ( hssi_aib_bond_tx_us_out    [1*7+:7]     ),
  /*output wire [6:0]   */  .hssi_aib_bond_tx_ds_out         ( hssi_aib_bond_tx_ds_out    [1*7+:7]     ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_us_in          ( hssi_aib_bond_tx_ds_out    [(1+1)*7+:7] ),

  // Bonding AIB HSSI RX
  /*output wire [7:0]   */  .hssi_aib_bond_rx_us_out         ( hssi_aib_bond_rx_us_out    [(1+1)*8+:8] ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_ds_in          ( hssi_aib_bond_rx_us_out    [1*8+:8]     ),
  /*output wire [7:0]   */  .hssi_aib_bond_rx_ds_out         ( hssi_aib_bond_rx_ds_out    [1*8+:8]     ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_us_in          ( hssi_aib_bond_rx_ds_out    [(1+1)*8+:8] ),

  // Reconfig Signals
                            .reconfig_clk                    ( split_avmm_clk             [1]          ),
                            .reconfig_reset                  ( split_avmm_reset           [1]          ),
                            .reconfig_read                   ( split_user_read            [1]          ),
                            .reconfig_write                  ( split_user_write           [1]          ),
                            .reconfig_address                ( split_user_address         [1*11+:11]   ),
                            .reconfig_readdata               ( split_user_readdata        [1*32+:32]   ),
                            .reconfig_writedata              ( split_user_writedata       [1*32+:32]   ),
                            .reconfig_waitrequest            ( split_user_waitrequest     [1]          ),

  // HIP Signals
  /*input  wire [100:0] */  .hip_aib_data_in                 ( hip_aib_data_in            [1*101+:101] ),
  /*output wire [131:0] */  .hip_aib_data_out                ( hip_aib_data_out           [1*132+:132] ),
  /*input  wire [91:0]  */  .hip_pcs_data_in                 ( hip_pcs_data_in            [1*92+:92]   ),
  /*output wire [61:0]  */  .hip_pcs_data_out                ( int_hip_pcs_data_out_1                  ),
  /*input  wire [3:0]   */  .hip_aib_fsr_in                  ( hip_aib_fsr_in             [1*4+:4]     ),
  /*input  wire [39:0]  */  .hip_aib_ssr_in                  ( hip_aib_ssr_in             [1*40+:40]   ),
  /*output wire [3:0]   */  .hip_aib_fsr_out                 ( hip_aib_fsr_out            [1*4+:4]     ),
  /*output wire [7:0]   */  .hip_aib_ssr_out                 ( hip_aib_ssr_out            [1*8+:8]     ),
  /*input  wire [1:0]   */  .hip_in_reserved_out             ( hip_in_reserved_out        [1*2+:2]     ),
  /*output wire [0:0]   */  .pld_pmaif_mask_tx_pll           ( pld_pmaif_mask_tx_pll      [1]          ),
  /*output wire [0:0]   */  .pldadapt_out_test_data_b10      ( pcie_ctrl_testbus_b10      [1]          ),
  /*output wire [0:0]   */  .hip_cal_done                    ( hip_cal_done               [1]          )

);

///////////////////////////////////////////////////////////////
// Transceiver Channel Instance 2
// Generating Slave Channel
///////////////////////////////////////////////////////////////
assign tx_coreclkin[2]    = tx_clkout[0];
assign rx_coreclkin[2]    = tx_clkout[0];
assign tx_x2_coreclkin[2] = tx_clkout2[0];
wire [61:0]    int_hip_pcs_data_out_2;
assign hip_pcs_data_out[2*62+:62] = int_hip_pcs_data_out_2;
qsys_top_avmm_bridge_512_0_altera_xcvr_pcie_hip_native_s10_altera_xcvr_native_s10_htile_191_yznx3ma altera_xcvr_hip_channel_s10_ch2 (
  // Channel Signals
  /*input  wire [1:0]   */  .pipe_sw_done                    ( 2'b0                                    ),
  /*output wire [1:0]   */  .pipe_sw                         (                                         ),
  /*input  wire [79:0]  */  .tx_parallel_data                ( tx_parallel_data           [2*80+:80]   ),
  /*output wire [79:0]  */  .rx_parallel_data                ( rx_parallel_data           [2*80+:80]   ),
  /*input  wire [0:0]   */  .tx_analogreset                  ( tx_analogreset             [2]          ),
  /*input  wire [0:0]   */  .tx_digitalreset                 ( tx_digitalreset            [2]          ),
  /*input  wire [0:0]   */  .rx_analogreset                  ( rx_analogreset             [2]          ),
  /*input  wire [0:0]   */  .rx_digitalreset                 ( rx_digitalreset            [2]          ),
  /*input  wire [0:0]   */  .tx_aibreset                     ( tx_aibreset_out            [2]          ),
  /*input  wire [0:0]   */  .rx_aibreset                     ( rx_aibreset_out            [2]          ),
  /*output wire [0:0]   */  .tx_transfer_ready               ( tx_transfer_ready          [2]          ),
  /*output wire [0:0]   */  .rx_transfer_ready               ( rx_transfer_ready          [2]          ),
  /*output wire [0:0]   */  .tx_cal_busy                     ( tx_cal_busy                [2]          ),
  /*output wire [0:0]   */  .rx_cal_busy                     ( rx_cal_busy                [2]          ),
  /*input  wire         */  .rx_cdr_refclk0                  ( rx_cdr_refclk0                          ),
  /*output wire [0:0]   */  .tx_serial_data                  ( tx_serial_data             [2]          ),
  /*input  wire [0:0]   */  .rx_serial_data                  ( rx_serial_data             [2]          ),
  /*output wire [0:0]   */  .rx_is_lockedtoref               ( rx_is_lockedtoref          [2]          ),
  /*output wire [0:0]   */  .rx_is_lockedtodata              ( rx_is_lockedtodata         [2]          ),
  /*input  wire [0:0]   */  .tx_coreclkin                    ( tx_coreclkin               [2]          ),
  /*input  wire [0:0]   */  .rx_coreclkin                    ( rx_coreclkin               [2]          ),
  /*input  wire [0:0]   */  .tx_x2_coreclkin                 ( tx_x2_coreclkin            [2]          ),
  /*output wire [0:0]   */  .tx_clkout                       ( tx_clkout                  [2]          ),
  /*output wire [0:0]   */  .tx_clkout2                      ( tx_clkout2                 [2]          ),
  /*output wire [0:0]   */  .rx_clkout                       ( rx_clkout                  [2]          ),
  /*input  wire         */  .pipe_hclk_in                    ( pipe_hclk_in                            ),
  /*input  wire [5:0]   */  .tx_bonding_clocks               ( tx_bonding_clocks                         ),

  /*input  wire [2:0]   */  .pipe_rx_eidleinfersel           ( pipe_rx_eidleinfersel      [2*3+:3]     ),
  /*output wire [0:0]   */  .pipe_rx_elecidle                ( pipe_rx_elecidle           [2]          ),

  // Bonding PCS
  /*output wire [29:0]  */  .pcs_bonding_top_data_out        ( pcs_bonding_top_data_out   [(2+1)*30+:30]),
  /*input  wire [29:0]  */  .pcs_bonding_bot_data_in         ( pcs_bonding_top_data_out   [2*30+:30]    ), 
  /*output wire [29:0]  */  .pcs_bonding_bot_data_out        ( pcs_bonding_bot_data_out   [2*30+:30]    ), 
  /*input  wire [29:0]  */  .pcs_bonding_top_data_in         ( pcs_bonding_bot_data_out   [(2+1)*30+:30]),

  // Bonding AIB Core TX
  /*output wire [4:0]   */  .pld_aib_bond_tx_us_out          ( pld_aib_bond_tx_us_out     [(2+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_ds_in           ( pld_aib_bond_tx_us_out     [2*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_tx_ds_out          ( pld_aib_bond_tx_ds_out     [2*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_us_in           ( pld_aib_bond_tx_ds_out     [(2+1)*5+:5] ),

  // Bonding AIB Core Rx
  /*output wire [4:0]   */  .pld_aib_bond_rx_us_out          ( pld_aib_bond_rx_us_out     [(2+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_ds_in           ( pld_aib_bond_rx_us_out     [2*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_rx_ds_out          ( pld_aib_bond_rx_ds_out     [2*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_us_in           ( pld_aib_bond_rx_ds_out     [(2+1)*5+:5] ),

  // Bonding AIB HSSI TX
  /*output wire [6:0]   */  .hssi_aib_bond_tx_us_out         ( hssi_aib_bond_tx_us_out    [(2+1)*7+:7] ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_ds_in          ( hssi_aib_bond_tx_us_out    [2*7+:7]     ),
  /*output wire [6:0]   */  .hssi_aib_bond_tx_ds_out         ( hssi_aib_bond_tx_ds_out    [2*7+:7]     ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_us_in          ( hssi_aib_bond_tx_ds_out    [(2+1)*7+:7] ),

  // Bonding AIB HSSI RX
  /*output wire [7:0]   */  .hssi_aib_bond_rx_us_out         ( hssi_aib_bond_rx_us_out    [(2+1)*8+:8] ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_ds_in          ( hssi_aib_bond_rx_us_out    [2*8+:8]     ),
  /*output wire [7:0]   */  .hssi_aib_bond_rx_ds_out         ( hssi_aib_bond_rx_ds_out    [2*8+:8]     ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_us_in          ( hssi_aib_bond_rx_ds_out    [(2+1)*8+:8] ),

  // Reconfig Signals
                            .reconfig_clk                    ( split_avmm_clk             [2]          ),
                            .reconfig_reset                  ( split_avmm_reset           [2]          ),
                            .reconfig_read                   ( split_user_read            [2]          ),
                            .reconfig_write                  ( split_user_write           [2]          ),
                            .reconfig_address                ( split_user_address         [2*11+:11]   ),
                            .reconfig_readdata               ( split_user_readdata        [2*32+:32]   ),
                            .reconfig_writedata              ( split_user_writedata       [2*32+:32]   ),
                            .reconfig_waitrequest            ( split_user_waitrequest     [2]          ),

  // HIP Signals
  /*input  wire [100:0] */  .hip_aib_data_in                 ( hip_aib_data_in            [2*101+:101] ),
  /*output wire [131:0] */  .hip_aib_data_out                ( hip_aib_data_out           [2*132+:132] ),
  /*input  wire [91:0]  */  .hip_pcs_data_in                 ( hip_pcs_data_in            [2*92+:92]   ),
  /*output wire [61:0]  */  .hip_pcs_data_out                ( int_hip_pcs_data_out_2                  ),
  /*input  wire [3:0]   */  .hip_aib_fsr_in                  ( hip_aib_fsr_in             [2*4+:4]     ),
  /*input  wire [39:0]  */  .hip_aib_ssr_in                  ( hip_aib_ssr_in             [2*40+:40]   ),
  /*output wire [3:0]   */  .hip_aib_fsr_out                 ( hip_aib_fsr_out            [2*4+:4]     ),
  /*output wire [7:0]   */  .hip_aib_ssr_out                 ( hip_aib_ssr_out            [2*8+:8]     ),
  /*input  wire [1:0]   */  .hip_in_reserved_out             ( hip_in_reserved_out        [2*2+:2]     ),
  /*output wire [0:0]   */  .pld_pmaif_mask_tx_pll           ( pld_pmaif_mask_tx_pll      [2]          ),
  /*output wire [0:0]   */  .pldadapt_out_test_data_b10      ( pcie_ctrl_testbus_b10      [2]          ),
  /*output wire [0:0]   */  .hip_cal_done                    ( hip_cal_done               [2]          )

);

///////////////////////////////////////////////////////////////
// Transceiver Channel Instance 3
// Generating Slave Channel
///////////////////////////////////////////////////////////////
assign tx_coreclkin[3]    = tx_clkout[0];
assign rx_coreclkin[3]    = tx_clkout[0];
assign tx_x2_coreclkin[3] = tx_clkout2[0];
wire [61:0]    int_hip_pcs_data_out_3;
assign hip_pcs_data_out[3*62+:62] = int_hip_pcs_data_out_3;
qsys_top_avmm_bridge_512_0_altera_xcvr_pcie_hip_native_s10_altera_xcvr_native_s10_htile_191_3iam5yy altera_xcvr_hip_channel_s10_ch3 (
  // Channel Signals
  /*input  wire [1:0]   */  .pipe_sw_done                    ( 2'b0                                    ),
  /*output wire [1:0]   */  .pipe_sw                         (                                         ),
  /*input  wire [79:0]  */  .tx_parallel_data                ( tx_parallel_data           [3*80+:80]   ),
  /*output wire [79:0]  */  .rx_parallel_data                ( rx_parallel_data           [3*80+:80]   ),
  /*input  wire [0:0]   */  .tx_analogreset                  ( tx_analogreset             [3]          ),
  /*input  wire [0:0]   */  .tx_digitalreset                 ( tx_digitalreset            [3]          ),
  /*input  wire [0:0]   */  .rx_analogreset                  ( rx_analogreset             [3]          ),
  /*input  wire [0:0]   */  .rx_digitalreset                 ( rx_digitalreset            [3]          ),
  /*input  wire [0:0]   */  .tx_aibreset                     ( tx_aibreset_out            [3]          ),
  /*input  wire [0:0]   */  .rx_aibreset                     ( rx_aibreset_out            [3]          ),
  /*output wire [0:0]   */  .tx_transfer_ready               ( tx_transfer_ready          [3]          ),
  /*output wire [0:0]   */  .rx_transfer_ready               ( rx_transfer_ready          [3]          ),
  /*output wire [0:0]   */  .tx_cal_busy                     ( tx_cal_busy                [3]          ),
  /*output wire [0:0]   */  .rx_cal_busy                     ( rx_cal_busy                [3]          ),
  /*input  wire         */  .rx_cdr_refclk0                  ( rx_cdr_refclk0                          ),
  /*output wire [0:0]   */  .tx_serial_data                  ( tx_serial_data             [3]          ),
  /*input  wire [0:0]   */  .rx_serial_data                  ( rx_serial_data             [3]          ),
  /*output wire [0:0]   */  .rx_is_lockedtoref               ( rx_is_lockedtoref          [3]          ),
  /*output wire [0:0]   */  .rx_is_lockedtodata              ( rx_is_lockedtodata         [3]          ),
  /*input  wire [0:0]   */  .tx_coreclkin                    ( tx_coreclkin               [3]          ),
  /*input  wire [0:0]   */  .rx_coreclkin                    ( rx_coreclkin               [3]          ),
  /*input  wire [0:0]   */  .tx_x2_coreclkin                 ( tx_x2_coreclkin            [3]          ),
  /*output wire [0:0]   */  .tx_clkout                       ( tx_clkout                  [3]          ),
  /*output wire [0:0]   */  .tx_clkout2                      ( tx_clkout2                 [3]          ),
  /*output wire [0:0]   */  .rx_clkout                       ( rx_clkout                  [3]          ),
  /*input  wire         */  .pipe_hclk_in                    ( pipe_hclk_in                            ),
  /*input  wire [5:0]   */  .tx_bonding_clocks               ( tx_bonding_clocks                         ),

  /*input  wire [2:0]   */  .pipe_rx_eidleinfersel           ( pipe_rx_eidleinfersel      [3*3+:3]     ),
  /*output wire [0:0]   */  .pipe_rx_elecidle                ( pipe_rx_elecidle           [3]          ),

  // Bonding PCS
  /*output wire [29:0]  */  .pcs_bonding_top_data_out        ( pcs_bonding_top_data_out   [(3+1)*30+:30]),
  /*input  wire [29:0]  */  .pcs_bonding_bot_data_in         ( pcs_bonding_top_data_out   [3*30+:30]    ), 
  /*output wire [29:0]  */  .pcs_bonding_bot_data_out        ( pcs_bonding_bot_data_out   [3*30+:30]    ), 
  /*input  wire [29:0]  */  .pcs_bonding_top_data_in         ( pcs_bonding_bot_data_out   [(3+1)*30+:30]),

  // Bonding AIB Core TX
  /*output wire [4:0]   */  .pld_aib_bond_tx_us_out          ( pld_aib_bond_tx_us_out     [(3+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_ds_in           ( pld_aib_bond_tx_us_out     [3*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_tx_ds_out          ( pld_aib_bond_tx_ds_out     [3*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_us_in           ( pld_aib_bond_tx_ds_out     [(3+1)*5+:5] ),

  // Bonding AIB Core Rx
  /*output wire [4:0]   */  .pld_aib_bond_rx_us_out          ( pld_aib_bond_rx_us_out     [(3+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_ds_in           ( pld_aib_bond_rx_us_out     [3*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_rx_ds_out          ( pld_aib_bond_rx_ds_out     [3*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_us_in           ( pld_aib_bond_rx_ds_out     [(3+1)*5+:5] ),

  // Bonding AIB HSSI TX
  /*output wire [6:0]   */  .hssi_aib_bond_tx_us_out         ( hssi_aib_bond_tx_us_out    [(3+1)*7+:7] ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_ds_in          ( hssi_aib_bond_tx_us_out    [3*7+:7]     ),
  /*output wire [6:0]   */  .hssi_aib_bond_tx_ds_out         ( hssi_aib_bond_tx_ds_out    [3*7+:7]     ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_us_in          ( hssi_aib_bond_tx_ds_out    [(3+1)*7+:7] ),

  // Bonding AIB HSSI RX
  /*output wire [7:0]   */  .hssi_aib_bond_rx_us_out         ( hssi_aib_bond_rx_us_out    [(3+1)*8+:8] ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_ds_in          ( hssi_aib_bond_rx_us_out    [3*8+:8]     ),
  /*output wire [7:0]   */  .hssi_aib_bond_rx_ds_out         ( hssi_aib_bond_rx_ds_out    [3*8+:8]     ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_us_in          ( hssi_aib_bond_rx_ds_out    [(3+1)*8+:8] ),

  // Reconfig Signals
                            .reconfig_clk                    ( split_avmm_clk             [3]          ),
                            .reconfig_reset                  ( split_avmm_reset           [3]          ),
                            .reconfig_read                   ( split_user_read            [3]          ),
                            .reconfig_write                  ( split_user_write           [3]          ),
                            .reconfig_address                ( split_user_address         [3*11+:11]   ),
                            .reconfig_readdata               ( split_user_readdata        [3*32+:32]   ),
                            .reconfig_writedata              ( split_user_writedata       [3*32+:32]   ),
                            .reconfig_waitrequest            ( split_user_waitrequest     [3]          ),

  // HIP Signals
  /*input  wire [100:0] */  .hip_aib_data_in                 ( hip_aib_data_in            [3*101+:101] ),
  /*output wire [131:0] */  .hip_aib_data_out                ( hip_aib_data_out           [3*132+:132] ),
  /*input  wire [91:0]  */  .hip_pcs_data_in                 ( hip_pcs_data_in            [3*92+:92]   ),
  /*output wire [61:0]  */  .hip_pcs_data_out                ( int_hip_pcs_data_out_3                  ),
  /*input  wire [3:0]   */  .hip_aib_fsr_in                  ( hip_aib_fsr_in             [3*4+:4]     ),
  /*input  wire [39:0]  */  .hip_aib_ssr_in                  ( hip_aib_ssr_in             [3*40+:40]   ),
  /*output wire [3:0]   */  .hip_aib_fsr_out                 ( hip_aib_fsr_out            [3*4+:4]     ),
  /*output wire [7:0]   */  .hip_aib_ssr_out                 ( hip_aib_ssr_out            [3*8+:8]     ),
  /*input  wire [1:0]   */  .hip_in_reserved_out             ( hip_in_reserved_out        [3*2+:2]     ),
  /*output wire [0:0]   */  .pld_pmaif_mask_tx_pll           ( pld_pmaif_mask_tx_pll      [3]          ),
  /*output wire [0:0]   */  .pldadapt_out_test_data_b10      ( pcie_ctrl_testbus_b10      [3]          ),
  /*output wire [0:0]   */  .hip_cal_done                    ( hip_cal_done               [3]          )

);

///////////////////////////////////////////////////////////////
// Transceiver Channel Instance 4
// Generating Slave Channel
///////////////////////////////////////////////////////////////
assign tx_coreclkin[4]    = tx_clkout[0];
assign rx_coreclkin[4]    = tx_clkout[0];
assign tx_x2_coreclkin[4] = 1'b0;
wire [61:0]    int_hip_pcs_data_out_4;
assign hip_pcs_data_out[4*62+:62] = int_hip_pcs_data_out_4;
qsys_top_avmm_bridge_512_0_altera_xcvr_pcie_hip_native_s10_altera_xcvr_native_s10_htile_191_6vamsfa altera_xcvr_hip_channel_s10_ch4 (
  // Channel Signals
  /*input  wire [1:0]   */  .pipe_sw_done                    ( 2'b0                                    ),
  /*output wire [1:0]   */  .pipe_sw                         (                                         ),
  /*input  wire [79:0]  */  .tx_parallel_data                ( tx_parallel_data           [4*80+:80]   ),
  /*output wire [79:0]  */  .rx_parallel_data                ( rx_parallel_data           [4*80+:80]   ),
  /*input  wire [0:0]   */  .tx_analogreset                  ( tx_analogreset             [4]          ),
  /*input  wire [0:0]   */  .tx_digitalreset                 ( tx_digitalreset            [4]          ),
  /*input  wire [0:0]   */  .rx_analogreset                  ( rx_analogreset             [4]          ),
  /*input  wire [0:0]   */  .rx_digitalreset                 ( rx_digitalreset            [4]          ),
  /*input  wire [0:0]   */  .tx_aibreset                     ( tx_aibreset_out            [4]          ),
  /*input  wire [0:0]   */  .rx_aibreset                     ( rx_aibreset_out            [4]          ),
  /*output wire [0:0]   */  .tx_transfer_ready               ( tx_transfer_ready          [4]          ),
  /*output wire [0:0]   */  .rx_transfer_ready               ( rx_transfer_ready          [4]          ),
  /*output wire [0:0]   */  .tx_cal_busy                     ( tx_cal_busy                [4]          ),
  /*output wire [0:0]   */  .rx_cal_busy                     ( rx_cal_busy                [4]          ),
  /*input  wire         */  .rx_cdr_refclk0                  ( rx_cdr_refclk0                          ),
  /*output wire [0:0]   */  .tx_serial_data                  ( tx_serial_data             [4]          ),
  /*input  wire [0:0]   */  .rx_serial_data                  ( rx_serial_data             [4]          ),
  /*output wire [0:0]   */  .rx_is_lockedtoref               ( rx_is_lockedtoref          [4]          ),
  /*output wire [0:0]   */  .rx_is_lockedtodata              ( rx_is_lockedtodata         [4]          ),
  /*input  wire [0:0]   */  .tx_coreclkin                    ( tx_coreclkin               [4]          ),
  /*input  wire [0:0]   */  .rx_coreclkin                    ( rx_coreclkin               [4]          ),
  /*input  wire [0:0]   */  .tx_x2_coreclkin                 ( tx_x2_coreclkin            [4]          ),
  /*output wire [0:0]   */  .tx_clkout                       ( tx_clkout                  [4]          ),
  /*output wire [0:0]   */  .tx_clkout2                      ( tx_clkout2                 [4]          ),
  /*output wire [0:0]   */  .rx_clkout                       ( rx_clkout                  [4]          ),
  /*input  wire         */  .pipe_hclk_in                    ( pipe_hclk_in                            ),
  /*input  wire [5:0]   */  .tx_bonding_clocks               ( tx_bonding_clocks                         ),

  /*input  wire [2:0]   */  .pipe_rx_eidleinfersel           ( pipe_rx_eidleinfersel      [4*3+:3]     ),
  /*output wire [0:0]   */  .pipe_rx_elecidle                ( pipe_rx_elecidle           [4]          ),

  // Bonding PCS
  /*output wire [29:0]  */  .pcs_bonding_top_data_out        ( pcs_bonding_top_data_out   [(4+1)*30+:30]),
  /*input  wire [29:0]  */  .pcs_bonding_bot_data_in         ( pcs_bonding_top_data_out   [4*30+:30]    ), 
  /*output wire [29:0]  */  .pcs_bonding_bot_data_out        ( pcs_bonding_bot_data_out   [4*30+:30]    ), 
  /*input  wire [29:0]  */  .pcs_bonding_top_data_in         ( pcs_bonding_bot_data_out   [(4+1)*30+:30]),

  // Bonding AIB Core TX
  /*output wire [4:0]   */  .pld_aib_bond_tx_us_out          ( pld_aib_bond_tx_us_out     [(4+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_ds_in           ( pld_aib_bond_tx_us_out     [4*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_tx_ds_out          ( pld_aib_bond_tx_ds_out     [4*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_us_in           ( pld_aib_bond_tx_ds_out     [(4+1)*5+:5] ),

  // Bonding AIB Core Rx
  /*output wire [4:0]   */  .pld_aib_bond_rx_us_out          ( pld_aib_bond_rx_us_out     [(4+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_ds_in           ( pld_aib_bond_rx_us_out     [4*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_rx_ds_out          ( pld_aib_bond_rx_ds_out     [4*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_us_in           ( pld_aib_bond_rx_ds_out     [(4+1)*5+:5] ),

  // Bonding AIB HSSI TX
  /*output wire [6:0]   */  .hssi_aib_bond_tx_us_out         ( hssi_aib_bond_tx_us_out    [(4+1)*7+:7] ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_ds_in          ( hssi_aib_bond_tx_us_out    [4*7+:7]     ),
  /*output wire [6:0]   */  .hssi_aib_bond_tx_ds_out         ( hssi_aib_bond_tx_ds_out    [4*7+:7]     ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_us_in          ( hssi_aib_bond_tx_ds_out    [(4+1)*7+:7] ),

  // Bonding AIB HSSI RX
  /*output wire [7:0]   */  .hssi_aib_bond_rx_us_out         ( hssi_aib_bond_rx_us_out    [(4+1)*8+:8] ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_ds_in          ( hssi_aib_bond_rx_us_out    [4*8+:8]     ),
  /*output wire [7:0]   */  .hssi_aib_bond_rx_ds_out         ( hssi_aib_bond_rx_ds_out    [4*8+:8]     ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_us_in          ( hssi_aib_bond_rx_ds_out    [(4+1)*8+:8] ),

  // Reconfig Signals
                            .reconfig_clk                    ( split_avmm_clk             [4]          ),
                            .reconfig_reset                  ( split_avmm_reset           [4]          ),
                            .reconfig_read                   ( split_user_read            [4]          ),
                            .reconfig_write                  ( split_user_write           [4]          ),
                            .reconfig_address                ( split_user_address         [4*11+:11]   ),
                            .reconfig_readdata               ( split_user_readdata        [4*32+:32]   ),
                            .reconfig_writedata              ( split_user_writedata       [4*32+:32]   ),
                            .reconfig_waitrequest            ( split_user_waitrequest     [4]          ),

  // HIP Signals
  /*input  wire [100:0] */  .hip_aib_data_in                 ( hip_aib_data_in            [4*101+:101] ),
  /*output wire [131:0] */  .hip_aib_data_out                ( hip_aib_data_out           [4*132+:132] ),
  /*input  wire [91:0]  */  .hip_pcs_data_in                 ( hip_pcs_data_in            [4*92+:92]   ),
  /*output wire [61:0]  */  .hip_pcs_data_out                ( int_hip_pcs_data_out_4                  ),
  /*input  wire [3:0]   */  .hip_aib_fsr_in                  ( hip_aib_fsr_in             [4*4+:4]     ),
  /*input  wire [39:0]  */  .hip_aib_ssr_in                  ( hip_aib_ssr_in             [4*40+:40]   ),
  /*output wire [3:0]   */  .hip_aib_fsr_out                 ( hip_aib_fsr_out            [4*4+:4]     ),
  /*output wire [7:0]   */  .hip_aib_ssr_out                 ( hip_aib_ssr_out            [4*8+:8]     ),
  /*input  wire [1:0]   */  .hip_in_reserved_out             ( hip_in_reserved_out        [4*2+:2]     ),
  /*output wire [0:0]   */  .pld_pmaif_mask_tx_pll           ( pld_pmaif_mask_tx_pll      [4]          ),
  /*output wire [0:0]   */  .pldadapt_out_test_data_b10      ( pcie_ctrl_testbus_b10      [4]          ),
  /*output wire [0:0]   */  .hip_cal_done                    ( hip_cal_done               [4]          )

);

///////////////////////////////////////////////////////////////
// Transceiver Channel Instance 5
// Generating Slave Channel
///////////////////////////////////////////////////////////////
assign tx_coreclkin[5]    = tx_clkout[0];
assign rx_coreclkin[5]    = tx_clkout[0];
assign tx_x2_coreclkin[5] = 1'b0;
wire [61:0]    int_hip_pcs_data_out_5;
assign hip_pcs_data_out[5*62+:62] = int_hip_pcs_data_out_5;
qsys_top_avmm_bridge_512_0_altera_xcvr_pcie_hip_native_s10_altera_xcvr_native_s10_htile_191_qxld3bq altera_xcvr_hip_channel_s10_ch5 (
  // Channel Signals
  /*input  wire [1:0]   */  .pipe_sw_done                    ( 2'b0                                    ),
  /*output wire [1:0]   */  .pipe_sw                         (                                         ),
  /*input  wire [79:0]  */  .tx_parallel_data                ( tx_parallel_data           [5*80+:80]   ),
  /*output wire [79:0]  */  .rx_parallel_data                ( rx_parallel_data           [5*80+:80]   ),
  /*input  wire [0:0]   */  .tx_analogreset                  ( tx_analogreset             [5]          ),
  /*input  wire [0:0]   */  .tx_digitalreset                 ( tx_digitalreset            [5]          ),
  /*input  wire [0:0]   */  .rx_analogreset                  ( rx_analogreset             [5]          ),
  /*input  wire [0:0]   */  .rx_digitalreset                 ( rx_digitalreset            [5]          ),
  /*input  wire [0:0]   */  .tx_aibreset                     ( tx_aibreset_out            [5]          ),
  /*input  wire [0:0]   */  .rx_aibreset                     ( rx_aibreset_out            [5]          ),
  /*output wire [0:0]   */  .tx_transfer_ready               ( tx_transfer_ready          [5]          ),
  /*output wire [0:0]   */  .rx_transfer_ready               ( rx_transfer_ready          [5]          ),
  /*output wire [0:0]   */  .tx_cal_busy                     ( tx_cal_busy                [5]          ),
  /*output wire [0:0]   */  .rx_cal_busy                     ( rx_cal_busy                [5]          ),
  /*input  wire         */  .rx_cdr_refclk0                  ( rx_cdr_refclk0                          ),
  /*output wire [0:0]   */  .tx_serial_data                  ( tx_serial_data             [5]          ),
  /*input  wire [0:0]   */  .rx_serial_data                  ( rx_serial_data             [5]          ),
  /*output wire [0:0]   */  .rx_is_lockedtoref               ( rx_is_lockedtoref          [5]          ),
  /*output wire [0:0]   */  .rx_is_lockedtodata              ( rx_is_lockedtodata         [5]          ),
  /*input  wire [0:0]   */  .tx_coreclkin                    ( tx_coreclkin               [5]          ),
  /*input  wire [0:0]   */  .rx_coreclkin                    ( rx_coreclkin               [5]          ),
  /*input  wire [0:0]   */  .tx_x2_coreclkin                 ( tx_x2_coreclkin            [5]          ),
  /*output wire [0:0]   */  .tx_clkout                       ( tx_clkout                  [5]          ),
  /*output wire [0:0]   */  .tx_clkout2                      ( tx_clkout2                 [5]          ),
  /*output wire [0:0]   */  .rx_clkout                       ( rx_clkout                  [5]          ),
  /*input  wire         */  .pipe_hclk_in                    ( pipe_hclk_in                            ),
  /*input  wire [5:0]   */  .tx_bonding_clocks               ( tx_bonding_clocks                         ),

  /*input  wire [2:0]   */  .pipe_rx_eidleinfersel           ( pipe_rx_eidleinfersel      [5*3+:3]     ),
  /*output wire [0:0]   */  .pipe_rx_elecidle                ( pipe_rx_elecidle           [5]          ),

  // Bonding PCS
  /*output wire [29:0]  */  .pcs_bonding_top_data_out        ( pcs_bonding_top_data_out   [(5+1)*30+:30]),
  /*input  wire [29:0]  */  .pcs_bonding_bot_data_in         ( pcs_bonding_top_data_out   [5*30+:30]    ), 
  /*output wire [29:0]  */  .pcs_bonding_bot_data_out        ( pcs_bonding_bot_data_out   [5*30+:30]    ), 
  /*input  wire [29:0]  */  .pcs_bonding_top_data_in         ( pcs_bonding_bot_data_out   [(5+1)*30+:30]),

  // Bonding AIB Core TX
  /*output wire [4:0]   */  .pld_aib_bond_tx_us_out          ( pld_aib_bond_tx_us_out     [(5+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_ds_in           ( pld_aib_bond_tx_us_out     [5*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_tx_ds_out          ( pld_aib_bond_tx_ds_out     [5*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_us_in           ( pld_aib_bond_tx_ds_out     [(5+1)*5+:5] ),

  // Bonding AIB Core Rx
  /*output wire [4:0]   */  .pld_aib_bond_rx_us_out          ( pld_aib_bond_rx_us_out     [(5+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_ds_in           ( pld_aib_bond_rx_us_out     [5*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_rx_ds_out          ( pld_aib_bond_rx_ds_out     [5*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_us_in           ( pld_aib_bond_rx_ds_out     [(5+1)*5+:5] ),

  // Bonding AIB HSSI TX
  /*output wire [6:0]   */  .hssi_aib_bond_tx_us_out         ( hssi_aib_bond_tx_us_out    [(5+1)*7+:7] ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_ds_in          ( hssi_aib_bond_tx_us_out    [5*7+:7]     ),
  /*output wire [6:0]   */  .hssi_aib_bond_tx_ds_out         ( hssi_aib_bond_tx_ds_out    [5*7+:7]     ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_us_in          ( hssi_aib_bond_tx_ds_out    [(5+1)*7+:7] ),

  // Bonding AIB HSSI RX
  /*output wire [7:0]   */  .hssi_aib_bond_rx_us_out         ( hssi_aib_bond_rx_us_out    [(5+1)*8+:8] ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_ds_in          ( hssi_aib_bond_rx_us_out    [5*8+:8]     ),
  /*output wire [7:0]   */  .hssi_aib_bond_rx_ds_out         ( hssi_aib_bond_rx_ds_out    [5*8+:8]     ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_us_in          ( hssi_aib_bond_rx_ds_out    [(5+1)*8+:8] ),

  // Reconfig Signals
                            .reconfig_clk                    ( split_avmm_clk             [5]          ),
                            .reconfig_reset                  ( split_avmm_reset           [5]          ),
                            .reconfig_read                   ( split_user_read            [5]          ),
                            .reconfig_write                  ( split_user_write           [5]          ),
                            .reconfig_address                ( split_user_address         [5*11+:11]   ),
                            .reconfig_readdata               ( split_user_readdata        [5*32+:32]   ),
                            .reconfig_writedata              ( split_user_writedata       [5*32+:32]   ),
                            .reconfig_waitrequest            ( split_user_waitrequest     [5]          ),

  // HIP Signals
  /*input  wire [100:0] */  .hip_aib_data_in                 ( hip_aib_data_in            [5*101+:101] ),
  /*output wire [131:0] */  .hip_aib_data_out                ( hip_aib_data_out           [5*132+:132] ),
  /*input  wire [91:0]  */  .hip_pcs_data_in                 ( hip_pcs_data_in            [5*92+:92]   ),
  /*output wire [61:0]  */  .hip_pcs_data_out                ( int_hip_pcs_data_out_5                  ),
  /*input  wire [3:0]   */  .hip_aib_fsr_in                  ( hip_aib_fsr_in             [5*4+:4]     ),
  /*input  wire [39:0]  */  .hip_aib_ssr_in                  ( hip_aib_ssr_in             [5*40+:40]   ),
  /*output wire [3:0]   */  .hip_aib_fsr_out                 ( hip_aib_fsr_out            [5*4+:4]     ),
  /*output wire [7:0]   */  .hip_aib_ssr_out                 ( hip_aib_ssr_out            [5*8+:8]     ),
  /*input  wire [1:0]   */  .hip_in_reserved_out             ( hip_in_reserved_out        [5*2+:2]     ),
  /*output wire [0:0]   */  .pld_pmaif_mask_tx_pll           ( pld_pmaif_mask_tx_pll      [5]          ),
  /*output wire [0:0]   */  .pldadapt_out_test_data_b10      ( pcie_ctrl_testbus_b10      [5]          ),
  /*output wire [0:0]   */  .hip_cal_done                    ( hip_cal_done               [5]          )

);

///////////////////////////////////////////////////////////////
// Transceiver Channel Instance 6
// Generating Slave Channel
///////////////////////////////////////////////////////////////
assign tx_coreclkin[6]    = tx_clkout[0];
assign rx_coreclkin[6]    = tx_clkout[0];
assign tx_x2_coreclkin[6] = 1'b0;
wire [61:0]    int_hip_pcs_data_out_6;
assign hip_pcs_data_out[6*62+:62] = {int_hip_pcs_data_out_6[61],pipe_hclk_in,int_hip_pcs_data_out_6[59:0]};
qsys_top_avmm_bridge_512_0_altera_xcvr_pcie_hip_native_s10_altera_xcvr_native_s10_htile_191_ibnjssq altera_xcvr_hip_channel_s10_ch6 (
  // Channel Signals
  /*input  wire [1:0]   */  .pipe_sw_done                    ( 2'b0                                    ),
  /*output wire [1:0]   */  .pipe_sw                         (                                         ),
  /*input  wire [79:0]  */  .tx_parallel_data                ( tx_parallel_data           [6*80+:80]   ),
  /*output wire [79:0]  */  .rx_parallel_data                ( rx_parallel_data           [6*80+:80]   ),
  /*input  wire [0:0]   */  .tx_analogreset                  ( tx_analogreset             [6]          ),
  /*input  wire [0:0]   */  .tx_digitalreset                 ( tx_digitalreset            [6]          ),
  /*input  wire [0:0]   */  .rx_analogreset                  ( rx_analogreset             [6]          ),
  /*input  wire [0:0]   */  .rx_digitalreset                 ( rx_digitalreset            [6]          ),
  /*input  wire [0:0]   */  .tx_aibreset                     ( tx_aibreset_out            [6]          ),
  /*input  wire [0:0]   */  .rx_aibreset                     ( rx_aibreset_out            [6]          ),
  /*output wire [0:0]   */  .tx_transfer_ready               ( tx_transfer_ready          [6]          ),
  /*output wire [0:0]   */  .rx_transfer_ready               ( rx_transfer_ready          [6]          ),
  /*output wire [0:0]   */  .tx_cal_busy                     ( tx_cal_busy                [6]          ),
  /*output wire [0:0]   */  .rx_cal_busy                     ( rx_cal_busy                [6]          ),
  /*input  wire         */  .rx_cdr_refclk0                  ( rx_cdr_refclk0                          ),
  /*output wire [0:0]   */  .tx_serial_data                  ( tx_serial_data             [6]          ),
  /*input  wire [0:0]   */  .rx_serial_data                  ( rx_serial_data             [6]          ),
  /*output wire [0:0]   */  .rx_is_lockedtoref               ( rx_is_lockedtoref          [6]          ),
  /*output wire [0:0]   */  .rx_is_lockedtodata              ( rx_is_lockedtodata         [6]          ),
  /*input  wire [0:0]   */  .tx_coreclkin                    ( tx_coreclkin               [6]          ),
  /*input  wire [0:0]   */  .rx_coreclkin                    ( rx_coreclkin               [6]          ),
  /*input  wire [0:0]   */  .tx_x2_coreclkin                 ( tx_x2_coreclkin            [6]          ),
  /*output wire [0:0]   */  .tx_clkout                       ( tx_clkout                  [6]          ),
  /*output wire [0:0]   */  .tx_clkout2                      ( tx_clkout2                 [6]          ),
  /*output wire [0:0]   */  .rx_clkout                       ( rx_clkout                  [6]          ),
  /*input  wire         */  .pipe_hclk_in                    ( pipe_hclk_in                            ),
  /*input  wire [5:0]   */  .tx_bonding_clocks               ( tx_bonding_clocks                         ),

  /*input  wire [2:0]   */  .pipe_rx_eidleinfersel           ( pipe_rx_eidleinfersel      [6*3+:3]     ),
  /*output wire [0:0]   */  .pipe_rx_elecidle                ( pipe_rx_elecidle           [6]          ),

  // Bonding PCS
  /*output wire [29:0]  */  .pcs_bonding_top_data_out        ( pcs_bonding_top_data_out   [(6+1)*30+:30]),
  /*input  wire [29:0]  */  .pcs_bonding_bot_data_in         ( pcs_bonding_top_data_out   [6*30+:30]    ), 
  /*output wire [29:0]  */  .pcs_bonding_bot_data_out        ( pcs_bonding_bot_data_out   [6*30+:30]    ), 
  /*input  wire [29:0]  */  .pcs_bonding_top_data_in         ( pcs_bonding_bot_data_out   [(6+1)*30+:30]),

  // Bonding AIB Core TX
  /*output wire [4:0]   */  .pld_aib_bond_tx_us_out          ( pld_aib_bond_tx_us_out     [(6+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_ds_in           ( pld_aib_bond_tx_us_out     [6*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_tx_ds_out          ( pld_aib_bond_tx_ds_out     [6*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_us_in           ( pld_aib_bond_tx_ds_out     [(6+1)*5+:5] ),

  // Bonding AIB Core Rx
  /*output wire [4:0]   */  .pld_aib_bond_rx_us_out          ( pld_aib_bond_rx_us_out     [(6+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_ds_in           ( pld_aib_bond_rx_us_out     [6*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_rx_ds_out          ( pld_aib_bond_rx_ds_out     [6*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_us_in           ( pld_aib_bond_rx_ds_out     [(6+1)*5+:5] ),

  // Bonding AIB HSSI TX
  /*output wire [6:0]   */  .hssi_aib_bond_tx_us_out         ( hssi_aib_bond_tx_us_out    [(6+1)*7+:7] ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_ds_in          ( hssi_aib_bond_tx_us_out    [6*7+:7]     ),
  /*output wire [6:0]   */  .hssi_aib_bond_tx_ds_out         ( hssi_aib_bond_tx_ds_out    [6*7+:7]     ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_us_in          ( hssi_aib_bond_tx_ds_out    [(6+1)*7+:7] ),

  // Bonding AIB HSSI RX
  /*output wire [7:0]   */  .hssi_aib_bond_rx_us_out         ( hssi_aib_bond_rx_us_out    [(6+1)*8+:8] ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_ds_in          ( hssi_aib_bond_rx_us_out    [6*8+:8]     ),
  /*output wire [7:0]   */  .hssi_aib_bond_rx_ds_out         ( hssi_aib_bond_rx_ds_out    [6*8+:8]     ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_us_in          ( hssi_aib_bond_rx_ds_out    [(6+1)*8+:8] ),

  // Reconfig Signals
                            .reconfig_clk                    ( split_avmm_clk             [6]          ),
                            .reconfig_reset                  ( split_avmm_reset           [6]          ),
                            .reconfig_read                   ( split_user_read            [6]          ),
                            .reconfig_write                  ( split_user_write           [6]          ),
                            .reconfig_address                ( split_user_address         [6*11+:11]   ),
                            .reconfig_readdata               ( split_user_readdata        [6*32+:32]   ),
                            .reconfig_writedata              ( split_user_writedata       [6*32+:32]   ),
                            .reconfig_waitrequest            ( split_user_waitrequest     [6]          ),

  // HIP Signals
  /*input  wire [100:0] */  .hip_aib_data_in                 ( hip_aib_data_in            [6*101+:101] ),
  /*output wire [131:0] */  .hip_aib_data_out                ( hip_aib_data_out           [6*132+:132] ),
  /*input  wire [91:0]  */  .hip_pcs_data_in                 ( hip_pcs_data_in            [6*92+:92]   ),
  /*output wire [61:0]  */  .hip_pcs_data_out                ( int_hip_pcs_data_out_6                  ),
  /*input  wire [3:0]   */  .hip_aib_fsr_in                  ( hip_aib_fsr_in             [6*4+:4]     ),
  /*input  wire [39:0]  */  .hip_aib_ssr_in                  ( hip_aib_ssr_in             [6*40+:40]   ),
  /*output wire [3:0]   */  .hip_aib_fsr_out                 ( hip_aib_fsr_out            [6*4+:4]     ),
  /*output wire [7:0]   */  .hip_aib_ssr_out                 ( hip_aib_ssr_out            [6*8+:8]     ),
  /*input  wire [1:0]   */  .hip_in_reserved_out             ( hip_in_reserved_out        [6*2+:2]     ),
  /*output wire [0:0]   */  .pld_pmaif_mask_tx_pll           ( pld_pmaif_mask_tx_pll      [6]          ),
  /*output wire [0:0]   */  .pldadapt_out_test_data_b10      ( pcie_ctrl_testbus_b10      [6]          ),
  /*output wire [0:0]   */  .hip_cal_done                    ( hip_cal_done               [6]          )

);

///////////////////////////////////////////////////////////////
// Transceiver Channel Instance 7
// Generating Master Channel
///////////////////////////////////////////////////////////////
assign tx_coreclkin[7]    = tx_clkout[0];
assign rx_coreclkin[7]    = tx_clkout[0];
assign tx_x2_coreclkin[7] = 1'b0;
wire [61:0]    int_hip_pcs_data_out_7;
assign hip_pcs_data_out[7*62+:62] = int_hip_pcs_data_out_7;
qsys_top_avmm_bridge_512_0_altera_xcvr_pcie_hip_native_s10_altera_xcvr_native_s10_htile_191_asbz3uq altera_xcvr_hip_channel_s10_ch7 (
  // Channel Signals
  /*input  wire [1:0]   */  .pipe_sw_done                    ( pipe_sw_done               [1:0]        ),
  /*output wire [1:0]   */  .pipe_sw                         ( pipe_sw                    [1:0]        ),
  /*input  wire [79:0]  */  .tx_parallel_data                ( tx_parallel_data           [7*80+:80]   ),
  /*output wire [79:0]  */  .rx_parallel_data                ( rx_parallel_data           [7*80+:80]   ),
  /*input  wire [0:0]   */  .tx_analogreset                  ( tx_analogreset             [7]          ),
  /*input  wire [0:0]   */  .tx_digitalreset                 ( tx_digitalreset            [7]          ),
  /*input  wire [0:0]   */  .rx_analogreset                  ( rx_analogreset             [7]          ),
  /*input  wire [0:0]   */  .rx_digitalreset                 ( rx_digitalreset            [7]          ),
  /*input  wire [0:0]   */  .tx_aibreset                     ( tx_aibreset_out            [7]          ),
  /*input  wire [0:0]   */  .rx_aibreset                     ( rx_aibreset_out            [7]          ),
  /*output wire [0:0]   */  .tx_transfer_ready               ( tx_transfer_ready          [7]          ),
  /*output wire [0:0]   */  .rx_transfer_ready               ( rx_transfer_ready          [7]          ),
  /*output wire [0:0]   */  .tx_cal_busy                     ( tx_cal_busy                [7]          ),
  /*output wire [0:0]   */  .rx_cal_busy                     ( rx_cal_busy                [7]          ),
  /*input  wire         */  .rx_cdr_refclk0                  ( rx_cdr_refclk0                          ),
  /*output wire [0:0]   */  .tx_serial_data                  ( tx_serial_data             [7]          ),
  /*input  wire [0:0]   */  .rx_serial_data                  ( rx_serial_data             [7]          ),
  /*output wire [0:0]   */  .rx_is_lockedtoref               ( rx_is_lockedtoref          [7]          ),
  /*output wire [0:0]   */  .rx_is_lockedtodata              ( rx_is_lockedtodata         [7]          ),
  /*input  wire [0:0]   */  .tx_coreclkin                    ( tx_coreclkin               [7]          ),
  /*input  wire [0:0]   */  .rx_coreclkin                    ( rx_coreclkin               [7]          ),
  /*input  wire [0:0]   */  .tx_x2_coreclkin                 ( tx_x2_coreclkin            [7]          ),
  /*output wire [0:0]   */  .tx_clkout                       ( tx_clkout                  [7]          ),
  /*output wire [0:0]   */  .tx_clkout2                      ( tx_clkout2                 [7]          ),
  /*output wire [0:0]   */  .rx_clkout                       ( rx_clkout                  [7]          ),
  /*input  wire         */  .pipe_hclk_in                    ( pipe_hclk_in                            ),
  /*input  wire [5:0]   */  .tx_bonding_clocks               ( tx_bonding_clocks                         ),

  /*input  wire [2:0]   */  .pipe_rx_eidleinfersel           ( pipe_rx_eidleinfersel      [7*3+:3]     ),
  /*output wire [0:0]   */  .pipe_rx_elecidle                ( pipe_rx_elecidle           [7]          ),

  // Bonding PCS
  /*output wire [29:0]  */  .pcs_bonding_top_data_out        ( pcs_bonding_top_data_out   [(7+1)*30+:30]),
  /*input  wire [29:0]  */  .pcs_bonding_bot_data_in         ( pcs_bonding_top_data_out   [7*30+:30]    ), 
  /*output wire [29:0]  */  .pcs_bonding_bot_data_out        ( pcs_bonding_bot_data_out   [7*30+:30]    ), 
  /*input  wire [29:0]  */  .pcs_bonding_top_data_in         ( pcs_bonding_bot_data_out   [(7+1)*30+:30]),

  // Bonding AIB Core TX
  /*output wire [4:0]   */  .pld_aib_bond_tx_us_out          ( pld_aib_bond_tx_us_out     [(7+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_ds_in           ( pld_aib_bond_tx_us_out     [7*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_tx_ds_out          ( pld_aib_bond_tx_ds_out     [7*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_us_in           ( pld_aib_bond_tx_ds_out     [(7+1)*5+:5] ),

  // Bonding AIB Core Rx
  /*output wire [4:0]   */  .pld_aib_bond_rx_us_out          ( pld_aib_bond_rx_us_out     [(7+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_ds_in           ( pld_aib_bond_rx_us_out     [7*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_rx_ds_out          ( pld_aib_bond_rx_ds_out     [7*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_us_in           ( pld_aib_bond_rx_ds_out     [(7+1)*5+:5] ),

  // Bonding AIB HSSI TX
  /*output wire [6:0]   */  .hssi_aib_bond_tx_us_out         ( hssi_aib_bond_tx_us_out    [(7+1)*7+:7] ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_ds_in          ( hssi_aib_bond_tx_us_out    [7*7+:7]     ),
  /*output wire [6:0]   */  .hssi_aib_bond_tx_ds_out         ( hssi_aib_bond_tx_ds_out    [7*7+:7]     ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_us_in          ( hssi_aib_bond_tx_ds_out    [(7+1)*7+:7] ),

  // Bonding AIB HSSI RX
  /*output wire [7:0]   */  .hssi_aib_bond_rx_us_out         ( hssi_aib_bond_rx_us_out    [(7+1)*8+:8] ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_ds_in          ( hssi_aib_bond_rx_us_out    [7*8+:8]     ),
  /*output wire [7:0]   */  .hssi_aib_bond_rx_ds_out         ( hssi_aib_bond_rx_ds_out    [7*8+:8]     ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_us_in          ( hssi_aib_bond_rx_ds_out    [(7+1)*8+:8] ),

  // Reconfig Signals
                            .reconfig_clk                    ( split_avmm_clk             [7]          ),
                            .reconfig_reset                  ( split_avmm_reset           [7]          ),
                            .reconfig_read                   ( split_user_read            [7]          ),
                            .reconfig_write                  ( split_user_write           [7]          ),
                            .reconfig_address                ( split_user_address         [7*11+:11]   ),
                            .reconfig_readdata               ( split_user_readdata        [7*32+:32]   ),
                            .reconfig_writedata              ( split_user_writedata       [7*32+:32]   ),
                            .reconfig_waitrequest            ( split_user_waitrequest     [7]          ),

  // HIP Signals
  /*input  wire [100:0] */  .hip_aib_data_in                 ( hip_aib_data_in            [7*101+:101] ),
  /*output wire [131:0] */  .hip_aib_data_out                ( hip_aib_data_out           [7*132+:132] ),
  /*input  wire [91:0]  */  .hip_pcs_data_in                 ( hip_pcs_data_in            [7*92+:92]   ),
  /*output wire [61:0]  */  .hip_pcs_data_out                ( int_hip_pcs_data_out_7                  ),
  /*input  wire [3:0]   */  .hip_aib_fsr_in                  ( hip_aib_fsr_in             [7*4+:4]     ),
  /*input  wire [39:0]  */  .hip_aib_ssr_in                  ( hip_aib_ssr_in             [7*40+:40]   ),
  /*output wire [3:0]   */  .hip_aib_fsr_out                 ( hip_aib_fsr_out            [7*4+:4]     ),
  /*output wire [7:0]   */  .hip_aib_ssr_out                 ( hip_aib_ssr_out            [7*8+:8]     ),
  /*input  wire [1:0]   */  .hip_in_reserved_out             ( hip_in_reserved_out        [7*2+:2]     ),
  /*output wire [0:0]   */  .pld_pmaif_mask_tx_pll           ( pld_pmaif_mask_tx_pll      [7]          ),
  /*output wire [0:0]   */  .pldadapt_out_test_data_b10      ( pcie_ctrl_testbus_b10      [7]          ),
  /*output wire [0:0]   */  .hip_cal_done                    ( hip_cal_done               [7]          )

);

///////////////////////////////////////////////////////////////
// Transceiver Channel Instance 8
// Generating Slave Channel
///////////////////////////////////////////////////////////////
assign tx_coreclkin[8]    = tx_clkout[8];
assign rx_coreclkin[8]    = tx_clkout[8];
assign tx_x2_coreclkin[8] = tx_clkout2[8];
wire [61:0]    int_hip_pcs_data_out_8;
assign hip_pcs_data_out[8*62+:62] = int_hip_pcs_data_out_8;
qsys_top_avmm_bridge_512_0_altera_xcvr_pcie_hip_native_s10_altera_xcvr_native_s10_htile_191_audvq4q altera_xcvr_hip_channel_s10_ch8 (
  // Channel Signals
  /*input  wire [1:0]   */  .pipe_sw_done                    ( 2'b0                                    ),
  /*output wire [1:0]   */  .pipe_sw                         (                                         ),
  /*input  wire [79:0]  */  .tx_parallel_data                ( tx_parallel_data           [8*80+:80]   ),
  /*output wire [79:0]  */  .rx_parallel_data                ( rx_parallel_data           [8*80+:80]   ),
  /*input  wire [0:0]   */  .tx_analogreset                  ( tx_analogreset             [8]          ),
  /*input  wire [0:0]   */  .tx_digitalreset                 ( tx_digitalreset            [8]          ),
  /*input  wire [0:0]   */  .rx_analogreset                  ( rx_analogreset             [8]          ),
  /*input  wire [0:0]   */  .rx_digitalreset                 ( rx_digitalreset            [8]          ),
  /*input  wire [0:0]   */  .tx_aibreset                     ( tx_aibreset_out            [8]          ),
  /*input  wire [0:0]   */  .rx_aibreset                     ( rx_aibreset_out            [8]          ),
  /*output wire [0:0]   */  .tx_transfer_ready               ( tx_transfer_ready          [8]          ),
  /*output wire [0:0]   */  .rx_transfer_ready               ( rx_transfer_ready          [8]          ),
  /*output wire [0:0]   */  .tx_cal_busy                     ( tx_cal_busy                [8]          ),
  /*output wire [0:0]   */  .rx_cal_busy                     ( rx_cal_busy                [8]          ),
  /*input  wire         */  .rx_cdr_refclk0                  ( rx_cdr_refclk0                          ),
  /*output wire [0:0]   */  .tx_serial_data                  ( tx_serial_data             [8]          ),
  /*input  wire [0:0]   */  .rx_serial_data                  ( rx_serial_data             [8]          ),
  /*output wire [0:0]   */  .rx_is_lockedtoref               ( rx_is_lockedtoref          [8]          ),
  /*output wire [0:0]   */  .rx_is_lockedtodata              ( rx_is_lockedtodata         [8]          ),
  /*input  wire [0:0]   */  .tx_coreclkin                    ( tx_coreclkin               [8]          ),
  /*input  wire [0:0]   */  .rx_coreclkin                    ( rx_coreclkin               [8]          ),
  /*input  wire [0:0]   */  .tx_x2_coreclkin                 ( tx_x2_coreclkin            [8]          ),
  /*output wire [0:0]   */  .tx_clkout                       ( tx_clkout                  [8]          ),
  /*output wire [0:0]   */  .tx_clkout2                      ( tx_clkout2                 [8]          ),
  /*output wire [0:0]   */  .rx_clkout                       ( rx_clkout                  [8]          ),
  /*input  wire         */  .pipe_hclk_in                    ( pipe_hclk_in                            ),
  /*input  wire [5:0]   */  .tx_bonding_clocks               ( tx_bonding_clocks                         ),

  /*input  wire [2:0]   */  .pipe_rx_eidleinfersel           ( pipe_rx_eidleinfersel      [8*3+:3]     ),
  /*output wire [0:0]   */  .pipe_rx_elecidle                ( pipe_rx_elecidle           [8]          ),

  // Bonding PCS
  /*output wire [29:0]  */  .pcs_bonding_top_data_out        ( pcs_bonding_top_data_out   [(8+1)*30+:30]),
  /*input  wire [29:0]  */  .pcs_bonding_bot_data_in         ( pcs_bonding_top_data_out   [8*30+:30]    ), 
  /*output wire [29:0]  */  .pcs_bonding_bot_data_out        ( pcs_bonding_bot_data_out   [8*30+:30]    ), 
  /*input  wire [29:0]  */  .pcs_bonding_top_data_in         ( pcs_bonding_bot_data_out   [(8+1)*30+:30]),

  // Bonding AIB Core TX
  /*output wire [4:0]   */  .pld_aib_bond_tx_us_out          ( pld_aib_bond_tx_us_out     [(8+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_ds_in           ( pld_aib_bond_tx_us_out     [8*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_tx_ds_out          ( pld_aib_bond_tx_ds_out     [8*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_us_in           ( pld_aib_bond_tx_ds_out     [(8+1)*5+:5] ),

  // Bonding AIB Core Rx
  /*output wire [4:0]   */  .pld_aib_bond_rx_us_out          ( pld_aib_bond_rx_us_out     [(8+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_ds_in           ( pld_aib_bond_rx_us_out     [8*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_rx_ds_out          ( pld_aib_bond_rx_ds_out     [8*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_us_in           ( pld_aib_bond_rx_ds_out     [(8+1)*5+:5] ),

  // Bonding AIB HSSI TX
  /*output wire [6:0]   */  .hssi_aib_bond_tx_us_out         ( hssi_aib_bond_tx_us_out    [(8+1)*7+:7] ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_ds_in          ( hssi_aib_bond_tx_us_out    [8*7+:7]     ),
  /*output wire [6:0]   */  .hssi_aib_bond_tx_ds_out         ( hssi_aib_bond_tx_ds_out    [8*7+:7]     ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_us_in          ( hssi_aib_bond_tx_ds_out    [(8+1)*7+:7] ),

  // Bonding AIB HSSI RX
  /*output wire [7:0]   */  .hssi_aib_bond_rx_us_out         ( hssi_aib_bond_rx_us_out    [(8+1)*8+:8] ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_ds_in          ( hssi_aib_bond_rx_us_out    [8*8+:8]     ),
  /*output wire [7:0]   */  .hssi_aib_bond_rx_ds_out         ( hssi_aib_bond_rx_ds_out    [8*8+:8]     ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_us_in          ( hssi_aib_bond_rx_ds_out    [(8+1)*8+:8] ),

  // Reconfig Signals
                            .reconfig_clk                    ( split_avmm_clk             [8]          ),
                            .reconfig_reset                  ( split_avmm_reset           [8]          ),
                            .reconfig_read                   ( split_user_read            [8]          ),
                            .reconfig_write                  ( split_user_write           [8]          ),
                            .reconfig_address                ( split_user_address         [8*11+:11]   ),
                            .reconfig_readdata               ( split_user_readdata        [8*32+:32]   ),
                            .reconfig_writedata              ( split_user_writedata       [8*32+:32]   ),
                            .reconfig_waitrequest            ( split_user_waitrequest     [8]          ),

  // HIP Signals
  /*input  wire [100:0] */  .hip_aib_data_in                 ( hip_aib_data_in            [8*101+:101] ),
  /*output wire [131:0] */  .hip_aib_data_out                ( hip_aib_data_out           [8*132+:132] ),
  /*input  wire [91:0]  */  .hip_pcs_data_in                 ( hip_pcs_data_in            [8*92+:92]   ),
  /*output wire [61:0]  */  .hip_pcs_data_out                ( int_hip_pcs_data_out_8                  ),
  /*input  wire [3:0]   */  .hip_aib_fsr_in                  ( hip_aib_fsr_in             [8*4+:4]     ),
  /*input  wire [39:0]  */  .hip_aib_ssr_in                  ( hip_aib_ssr_in             [8*40+:40]   ),
  /*output wire [3:0]   */  .hip_aib_fsr_out                 ( hip_aib_fsr_out            [8*4+:4]     ),
  /*output wire [7:0]   */  .hip_aib_ssr_out                 ( hip_aib_ssr_out            [8*8+:8]     ),
  /*input  wire [1:0]   */  .hip_in_reserved_out             ( hip_in_reserved_out        [8*2+:2]     ),
  /*output wire [0:0]   */  .pld_pmaif_mask_tx_pll           ( pld_pmaif_mask_tx_pll      [8]          ),
  /*output wire [0:0]   */  .pldadapt_out_test_data_b10      ( pcie_ctrl_testbus_b10      [8]          ),
  /*output wire [0:0]   */  .hip_cal_done                    ( hip_cal_done               [8]          )

);

///////////////////////////////////////////////////////////////
// Transceiver Channel Instance 9
// Generating Slave Channel
///////////////////////////////////////////////////////////////
assign tx_coreclkin[9]    = tx_clkout[8];
assign rx_coreclkin[9]    = tx_clkout[8];
assign tx_x2_coreclkin[9] = tx_clkout2[8];
wire [61:0]    int_hip_pcs_data_out_9;
assign hip_pcs_data_out[9*62+:62] = int_hip_pcs_data_out_9;
qsys_top_avmm_bridge_512_0_altera_xcvr_pcie_hip_native_s10_altera_xcvr_native_s10_htile_191_crnealq altera_xcvr_hip_channel_s10_ch9 (
  // Channel Signals
  /*input  wire [1:0]   */  .pipe_sw_done                    ( 2'b0                                    ),
  /*output wire [1:0]   */  .pipe_sw                         (                                         ),
  /*input  wire [79:0]  */  .tx_parallel_data                ( tx_parallel_data           [9*80+:80]   ),
  /*output wire [79:0]  */  .rx_parallel_data                ( rx_parallel_data           [9*80+:80]   ),
  /*input  wire [0:0]   */  .tx_analogreset                  ( tx_analogreset             [9]          ),
  /*input  wire [0:0]   */  .tx_digitalreset                 ( tx_digitalreset            [9]          ),
  /*input  wire [0:0]   */  .rx_analogreset                  ( rx_analogreset             [9]          ),
  /*input  wire [0:0]   */  .rx_digitalreset                 ( rx_digitalreset            [9]          ),
  /*input  wire [0:0]   */  .tx_aibreset                     ( tx_aibreset_out            [9]          ),
  /*input  wire [0:0]   */  .rx_aibreset                     ( rx_aibreset_out            [9]          ),
  /*output wire [0:0]   */  .tx_transfer_ready               ( tx_transfer_ready          [9]          ),
  /*output wire [0:0]   */  .rx_transfer_ready               ( rx_transfer_ready          [9]          ),
  /*output wire [0:0]   */  .tx_cal_busy                     ( tx_cal_busy                [9]          ),
  /*output wire [0:0]   */  .rx_cal_busy                     ( rx_cal_busy                [9]          ),
  /*input  wire         */  .rx_cdr_refclk0                  ( rx_cdr_refclk0                          ),
  /*output wire [0:0]   */  .tx_serial_data                  ( tx_serial_data             [9]          ),
  /*input  wire [0:0]   */  .rx_serial_data                  ( rx_serial_data             [9]          ),
  /*output wire [0:0]   */  .rx_is_lockedtoref               ( rx_is_lockedtoref          [9]          ),
  /*output wire [0:0]   */  .rx_is_lockedtodata              ( rx_is_lockedtodata         [9]          ),
  /*input  wire [0:0]   */  .tx_coreclkin                    ( tx_coreclkin               [9]          ),
  /*input  wire [0:0]   */  .rx_coreclkin                    ( rx_coreclkin               [9]          ),
  /*input  wire [0:0]   */  .tx_x2_coreclkin                 ( tx_x2_coreclkin            [9]          ),
  /*output wire [0:0]   */  .tx_clkout                       ( tx_clkout                  [9]          ),
  /*output wire [0:0]   */  .tx_clkout2                      ( tx_clkout2                 [9]          ),
  /*output wire [0:0]   */  .rx_clkout                       ( rx_clkout                  [9]          ),
  /*input  wire         */  .pipe_hclk_in                    ( pipe_hclk_in                            ),
  /*input  wire [5:0]   */  .tx_bonding_clocks               ( tx_bonding_clocks                         ),

  /*input  wire [2:0]   */  .pipe_rx_eidleinfersel           ( pipe_rx_eidleinfersel      [9*3+:3]     ),
  /*output wire [0:0]   */  .pipe_rx_elecidle                ( pipe_rx_elecidle           [9]          ),

  // Bonding PCS
  /*output wire [29:0]  */  .pcs_bonding_top_data_out        ( pcs_bonding_top_data_out   [(9+1)*30+:30]),
  /*input  wire [29:0]  */  .pcs_bonding_bot_data_in         ( pcs_bonding_top_data_out   [9*30+:30]    ), 
  /*output wire [29:0]  */  .pcs_bonding_bot_data_out        ( pcs_bonding_bot_data_out   [9*30+:30]    ), 
  /*input  wire [29:0]  */  .pcs_bonding_top_data_in         ( pcs_bonding_bot_data_out   [(9+1)*30+:30]),

  // Bonding AIB Core TX
  /*output wire [4:0]   */  .pld_aib_bond_tx_us_out          ( pld_aib_bond_tx_us_out     [(9+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_ds_in           ( pld_aib_bond_tx_us_out     [9*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_tx_ds_out          ( pld_aib_bond_tx_ds_out     [9*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_us_in           ( pld_aib_bond_tx_ds_out     [(9+1)*5+:5] ),

  // Bonding AIB Core Rx
  /*output wire [4:0]   */  .pld_aib_bond_rx_us_out          ( pld_aib_bond_rx_us_out     [(9+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_ds_in           ( pld_aib_bond_rx_us_out     [9*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_rx_ds_out          ( pld_aib_bond_rx_ds_out     [9*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_us_in           ( pld_aib_bond_rx_ds_out     [(9+1)*5+:5] ),

  // Bonding AIB HSSI TX
  /*output wire [6:0]   */  .hssi_aib_bond_tx_us_out         ( hssi_aib_bond_tx_us_out    [(9+1)*7+:7] ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_ds_in          ( hssi_aib_bond_tx_us_out    [9*7+:7]     ),
  /*output wire [6:0]   */  .hssi_aib_bond_tx_ds_out         ( hssi_aib_bond_tx_ds_out    [9*7+:7]     ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_us_in          ( hssi_aib_bond_tx_ds_out    [(9+1)*7+:7] ),

  // Bonding AIB HSSI RX
  /*output wire [7:0]   */  .hssi_aib_bond_rx_us_out         ( hssi_aib_bond_rx_us_out    [(9+1)*8+:8] ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_ds_in          ( hssi_aib_bond_rx_us_out    [9*8+:8]     ),
  /*output wire [7:0]   */  .hssi_aib_bond_rx_ds_out         ( hssi_aib_bond_rx_ds_out    [9*8+:8]     ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_us_in          ( hssi_aib_bond_rx_ds_out    [(9+1)*8+:8] ),

  // Reconfig Signals
                            .reconfig_clk                    ( split_avmm_clk             [9]          ),
                            .reconfig_reset                  ( split_avmm_reset           [9]          ),
                            .reconfig_read                   ( split_user_read            [9]          ),
                            .reconfig_write                  ( split_user_write           [9]          ),
                            .reconfig_address                ( split_user_address         [9*11+:11]   ),
                            .reconfig_readdata               ( split_user_readdata        [9*32+:32]   ),
                            .reconfig_writedata              ( split_user_writedata       [9*32+:32]   ),
                            .reconfig_waitrequest            ( split_user_waitrequest     [9]          ),

  // HIP Signals
  /*input  wire [100:0] */  .hip_aib_data_in                 ( hip_aib_data_in            [9*101+:101] ),
  /*output wire [131:0] */  .hip_aib_data_out                ( hip_aib_data_out           [9*132+:132] ),
  /*input  wire [91:0]  */  .hip_pcs_data_in                 ( hip_pcs_data_in            [9*92+:92]   ),
  /*output wire [61:0]  */  .hip_pcs_data_out                ( int_hip_pcs_data_out_9                  ),
  /*input  wire [3:0]   */  .hip_aib_fsr_in                  ( hip_aib_fsr_in             [9*4+:4]     ),
  /*input  wire [39:0]  */  .hip_aib_ssr_in                  ( hip_aib_ssr_in             [9*40+:40]   ),
  /*output wire [3:0]   */  .hip_aib_fsr_out                 ( hip_aib_fsr_out            [9*4+:4]     ),
  /*output wire [7:0]   */  .hip_aib_ssr_out                 ( hip_aib_ssr_out            [9*8+:8]     ),
  /*input  wire [1:0]   */  .hip_in_reserved_out             ( hip_in_reserved_out        [9*2+:2]     ),
  /*output wire [0:0]   */  .pld_pmaif_mask_tx_pll           ( pld_pmaif_mask_tx_pll      [9]          ),
  /*output wire [0:0]   */  .pldadapt_out_test_data_b10      ( pcie_ctrl_testbus_b10      [9]          ),
  /*output wire [0:0]   */  .hip_cal_done                    ( hip_cal_done               [9]          )

);

///////////////////////////////////////////////////////////////
// Transceiver Channel Instance 10
// Generating Slave Channel
///////////////////////////////////////////////////////////////
assign tx_coreclkin[10]    = tx_clkout[8];
assign rx_coreclkin[10]    = tx_clkout[8];
assign tx_x2_coreclkin[10] = tx_clkout2[8];
wire [61:0]    int_hip_pcs_data_out_10;
assign hip_pcs_data_out[10*62+:62] = int_hip_pcs_data_out_10;
qsys_top_avmm_bridge_512_0_altera_xcvr_pcie_hip_native_s10_altera_xcvr_native_s10_htile_191_yspgqfq altera_xcvr_hip_channel_s10_ch10 (
  // Channel Signals
  /*input  wire [1:0]   */  .pipe_sw_done                    ( 2'b0                                    ),
  /*output wire [1:0]   */  .pipe_sw                         (                                         ),
  /*input  wire [79:0]  */  .tx_parallel_data                ( tx_parallel_data           [10*80+:80]   ),
  /*output wire [79:0]  */  .rx_parallel_data                ( rx_parallel_data           [10*80+:80]   ),
  /*input  wire [0:0]   */  .tx_analogreset                  ( tx_analogreset             [10]          ),
  /*input  wire [0:0]   */  .tx_digitalreset                 ( tx_digitalreset            [10]          ),
  /*input  wire [0:0]   */  .rx_analogreset                  ( rx_analogreset             [10]          ),
  /*input  wire [0:0]   */  .rx_digitalreset                 ( rx_digitalreset            [10]          ),
  /*input  wire [0:0]   */  .tx_aibreset                     ( tx_aibreset_out            [10]          ),
  /*input  wire [0:0]   */  .rx_aibreset                     ( rx_aibreset_out            [10]          ),
  /*output wire [0:0]   */  .tx_transfer_ready               ( tx_transfer_ready          [10]          ),
  /*output wire [0:0]   */  .rx_transfer_ready               ( rx_transfer_ready          [10]          ),
  /*output wire [0:0]   */  .tx_cal_busy                     ( tx_cal_busy                [10]          ),
  /*output wire [0:0]   */  .rx_cal_busy                     ( rx_cal_busy                [10]          ),
  /*input  wire         */  .rx_cdr_refclk0                  ( rx_cdr_refclk0                          ),
  /*output wire [0:0]   */  .tx_serial_data                  ( tx_serial_data             [10]          ),
  /*input  wire [0:0]   */  .rx_serial_data                  ( rx_serial_data             [10]          ),
  /*output wire [0:0]   */  .rx_is_lockedtoref               ( rx_is_lockedtoref          [10]          ),
  /*output wire [0:0]   */  .rx_is_lockedtodata              ( rx_is_lockedtodata         [10]          ),
  /*input  wire [0:0]   */  .tx_coreclkin                    ( tx_coreclkin               [10]          ),
  /*input  wire [0:0]   */  .rx_coreclkin                    ( rx_coreclkin               [10]          ),
  /*input  wire [0:0]   */  .tx_x2_coreclkin                 ( tx_x2_coreclkin            [10]          ),
  /*output wire [0:0]   */  .tx_clkout                       ( tx_clkout                  [10]          ),
  /*output wire [0:0]   */  .tx_clkout2                      ( tx_clkout2                 [10]          ),
  /*output wire [0:0]   */  .rx_clkout                       ( rx_clkout                  [10]          ),
  /*input  wire         */  .pipe_hclk_in                    ( pipe_hclk_in                            ),
  /*input  wire [5:0]   */  .tx_bonding_clocks               ( tx_bonding_clocks                         ),

  /*input  wire [2:0]   */  .pipe_rx_eidleinfersel           ( pipe_rx_eidleinfersel      [10*3+:3]     ),
  /*output wire [0:0]   */  .pipe_rx_elecidle                ( pipe_rx_elecidle           [10]          ),

  // Bonding PCS
  /*output wire [29:0]  */  .pcs_bonding_top_data_out        ( pcs_bonding_top_data_out   [(10+1)*30+:30]),
  /*input  wire [29:0]  */  .pcs_bonding_bot_data_in         ( pcs_bonding_top_data_out   [10*30+:30]    ), 
  /*output wire [29:0]  */  .pcs_bonding_bot_data_out        ( pcs_bonding_bot_data_out   [10*30+:30]    ), 
  /*input  wire [29:0]  */  .pcs_bonding_top_data_in         ( pcs_bonding_bot_data_out   [(10+1)*30+:30]),

  // Bonding AIB Core TX
  /*output wire [4:0]   */  .pld_aib_bond_tx_us_out          ( pld_aib_bond_tx_us_out     [(10+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_ds_in           ( pld_aib_bond_tx_us_out     [10*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_tx_ds_out          ( pld_aib_bond_tx_ds_out     [10*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_us_in           ( pld_aib_bond_tx_ds_out     [(10+1)*5+:5] ),

  // Bonding AIB Core Rx
  /*output wire [4:0]   */  .pld_aib_bond_rx_us_out          ( pld_aib_bond_rx_us_out     [(10+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_ds_in           ( pld_aib_bond_rx_us_out     [10*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_rx_ds_out          ( pld_aib_bond_rx_ds_out     [10*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_us_in           ( pld_aib_bond_rx_ds_out     [(10+1)*5+:5] ),

  // Bonding AIB HSSI TX
  /*output wire [6:0]   */  .hssi_aib_bond_tx_us_out         ( hssi_aib_bond_tx_us_out    [(10+1)*7+:7] ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_ds_in          ( hssi_aib_bond_tx_us_out    [10*7+:7]     ),
  /*output wire [6:0]   */  .hssi_aib_bond_tx_ds_out         ( hssi_aib_bond_tx_ds_out    [10*7+:7]     ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_us_in          ( hssi_aib_bond_tx_ds_out    [(10+1)*7+:7] ),

  // Bonding AIB HSSI RX
  /*output wire [7:0]   */  .hssi_aib_bond_rx_us_out         ( hssi_aib_bond_rx_us_out    [(10+1)*8+:8] ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_ds_in          ( hssi_aib_bond_rx_us_out    [10*8+:8]     ),
  /*output wire [7:0]   */  .hssi_aib_bond_rx_ds_out         ( hssi_aib_bond_rx_ds_out    [10*8+:8]     ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_us_in          ( hssi_aib_bond_rx_ds_out    [(10+1)*8+:8] ),

  // Reconfig Signals
                            .reconfig_clk                    ( split_avmm_clk             [10]          ),
                            .reconfig_reset                  ( split_avmm_reset           [10]          ),
                            .reconfig_read                   ( split_user_read            [10]          ),
                            .reconfig_write                  ( split_user_write           [10]          ),
                            .reconfig_address                ( split_user_address         [10*11+:11]   ),
                            .reconfig_readdata               ( split_user_readdata        [10*32+:32]   ),
                            .reconfig_writedata              ( split_user_writedata       [10*32+:32]   ),
                            .reconfig_waitrequest            ( split_user_waitrequest     [10]          ),

  // HIP Signals
  /*input  wire [100:0] */  .hip_aib_data_in                 ( hip_aib_data_in            [10*101+:101] ),
  /*output wire [131:0] */  .hip_aib_data_out                ( hip_aib_data_out           [10*132+:132] ),
  /*input  wire [91:0]  */  .hip_pcs_data_in                 ( hip_pcs_data_in            [10*92+:92]   ),
  /*output wire [61:0]  */  .hip_pcs_data_out                ( int_hip_pcs_data_out_10                  ),
  /*input  wire [3:0]   */  .hip_aib_fsr_in                  ( hip_aib_fsr_in             [10*4+:4]     ),
  /*input  wire [39:0]  */  .hip_aib_ssr_in                  ( hip_aib_ssr_in             [10*40+:40]   ),
  /*output wire [3:0]   */  .hip_aib_fsr_out                 ( hip_aib_fsr_out            [10*4+:4]     ),
  /*output wire [7:0]   */  .hip_aib_ssr_out                 ( hip_aib_ssr_out            [10*8+:8]     ),
  /*input  wire [1:0]   */  .hip_in_reserved_out             ( hip_in_reserved_out        [10*2+:2]     ),
  /*output wire [0:0]   */  .pld_pmaif_mask_tx_pll           ( pld_pmaif_mask_tx_pll      [10]          ),
  /*output wire [0:0]   */  .pldadapt_out_test_data_b10      ( pcie_ctrl_testbus_b10      [10]          ),
  /*output wire [0:0]   */  .hip_cal_done                    ( hip_cal_done               [10]          )

);

///////////////////////////////////////////////////////////////
// Transceiver Channel Instance 11
// Generating Slave Channel
///////////////////////////////////////////////////////////////
assign tx_coreclkin[11]    = tx_clkout[8];
assign rx_coreclkin[11]    = tx_clkout[8];
assign tx_x2_coreclkin[11] = tx_clkout2[8];
wire [61:0]    int_hip_pcs_data_out_11;
assign hip_pcs_data_out[11*62+:62] = int_hip_pcs_data_out_11;
qsys_top_avmm_bridge_512_0_altera_xcvr_pcie_hip_native_s10_altera_xcvr_native_s10_htile_191_ae2ggla altera_xcvr_hip_channel_s10_ch11 (
  // Channel Signals
  /*input  wire [1:0]   */  .pipe_sw_done                    ( 2'b0                                    ),
  /*output wire [1:0]   */  .pipe_sw                         (                                         ),
  /*input  wire [79:0]  */  .tx_parallel_data                ( tx_parallel_data           [11*80+:80]   ),
  /*output wire [79:0]  */  .rx_parallel_data                ( rx_parallel_data           [11*80+:80]   ),
  /*input  wire [0:0]   */  .tx_analogreset                  ( tx_analogreset             [11]          ),
  /*input  wire [0:0]   */  .tx_digitalreset                 ( tx_digitalreset            [11]          ),
  /*input  wire [0:0]   */  .rx_analogreset                  ( rx_analogreset             [11]          ),
  /*input  wire [0:0]   */  .rx_digitalreset                 ( rx_digitalreset            [11]          ),
  /*input  wire [0:0]   */  .tx_aibreset                     ( tx_aibreset_out            [11]          ),
  /*input  wire [0:0]   */  .rx_aibreset                     ( rx_aibreset_out            [11]          ),
  /*output wire [0:0]   */  .tx_transfer_ready               ( tx_transfer_ready          [11]          ),
  /*output wire [0:0]   */  .rx_transfer_ready               ( rx_transfer_ready          [11]          ),
  /*output wire [0:0]   */  .tx_cal_busy                     ( tx_cal_busy                [11]          ),
  /*output wire [0:0]   */  .rx_cal_busy                     ( rx_cal_busy                [11]          ),
  /*input  wire         */  .rx_cdr_refclk0                  ( rx_cdr_refclk0                          ),
  /*output wire [0:0]   */  .tx_serial_data                  ( tx_serial_data             [11]          ),
  /*input  wire [0:0]   */  .rx_serial_data                  ( rx_serial_data             [11]          ),
  /*output wire [0:0]   */  .rx_is_lockedtoref               ( rx_is_lockedtoref          [11]          ),
  /*output wire [0:0]   */  .rx_is_lockedtodata              ( rx_is_lockedtodata         [11]          ),
  /*input  wire [0:0]   */  .tx_coreclkin                    ( tx_coreclkin               [11]          ),
  /*input  wire [0:0]   */  .rx_coreclkin                    ( rx_coreclkin               [11]          ),
  /*input  wire [0:0]   */  .tx_x2_coreclkin                 ( tx_x2_coreclkin            [11]          ),
  /*output wire [0:0]   */  .tx_clkout                       ( tx_clkout                  [11]          ),
  /*output wire [0:0]   */  .tx_clkout2                      ( tx_clkout2                 [11]          ),
  /*output wire [0:0]   */  .rx_clkout                       ( rx_clkout                  [11]          ),
  /*input  wire         */  .pipe_hclk_in                    ( pipe_hclk_in                            ),
  /*input  wire [5:0]   */  .tx_bonding_clocks               ( tx_bonding_clocks                         ),

  /*input  wire [2:0]   */  .pipe_rx_eidleinfersel           ( pipe_rx_eidleinfersel      [11*3+:3]     ),
  /*output wire [0:0]   */  .pipe_rx_elecidle                ( pipe_rx_elecidle           [11]          ),

  // Bonding PCS
  /*output wire [29:0]  */  .pcs_bonding_top_data_out        ( pcs_bonding_top_data_out   [(11+1)*30+:30]),
  /*input  wire [29:0]  */  .pcs_bonding_bot_data_in         ( pcs_bonding_top_data_out   [11*30+:30]    ), 
  /*output wire [29:0]  */  .pcs_bonding_bot_data_out        ( pcs_bonding_bot_data_out   [11*30+:30]    ), 
  /*input  wire [29:0]  */  .pcs_bonding_top_data_in         ( pcs_bonding_bot_data_out   [(11+1)*30+:30]),

  // Bonding AIB Core TX
  /*output wire [4:0]   */  .pld_aib_bond_tx_us_out          ( pld_aib_bond_tx_us_out     [(11+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_ds_in           ( pld_aib_bond_tx_us_out     [11*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_tx_ds_out          ( pld_aib_bond_tx_ds_out     [11*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_us_in           ( pld_aib_bond_tx_ds_out     [(11+1)*5+:5] ),

  // Bonding AIB Core Rx
  /*output wire [4:0]   */  .pld_aib_bond_rx_us_out          ( pld_aib_bond_rx_us_out     [(11+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_ds_in           ( pld_aib_bond_rx_us_out     [11*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_rx_ds_out          ( pld_aib_bond_rx_ds_out     [11*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_us_in           ( pld_aib_bond_rx_ds_out     [(11+1)*5+:5] ),

  // Bonding AIB HSSI TX
  /*output wire [6:0]   */  .hssi_aib_bond_tx_us_out         ( hssi_aib_bond_tx_us_out    [(11+1)*7+:7] ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_ds_in          ( hssi_aib_bond_tx_us_out    [11*7+:7]     ),
  /*output wire [6:0]   */  .hssi_aib_bond_tx_ds_out         ( hssi_aib_bond_tx_ds_out    [11*7+:7]     ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_us_in          ( hssi_aib_bond_tx_ds_out    [(11+1)*7+:7] ),

  // Bonding AIB HSSI RX
  /*output wire [7:0]   */  .hssi_aib_bond_rx_us_out         ( hssi_aib_bond_rx_us_out    [(11+1)*8+:8] ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_ds_in          ( hssi_aib_bond_rx_us_out    [11*8+:8]     ),
  /*output wire [7:0]   */  .hssi_aib_bond_rx_ds_out         ( hssi_aib_bond_rx_ds_out    [11*8+:8]     ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_us_in          ( hssi_aib_bond_rx_ds_out    [(11+1)*8+:8] ),

  // Reconfig Signals
                            .reconfig_clk                    ( split_avmm_clk             [11]          ),
                            .reconfig_reset                  ( split_avmm_reset           [11]          ),
                            .reconfig_read                   ( split_user_read            [11]          ),
                            .reconfig_write                  ( split_user_write           [11]          ),
                            .reconfig_address                ( split_user_address         [11*11+:11]   ),
                            .reconfig_readdata               ( split_user_readdata        [11*32+:32]   ),
                            .reconfig_writedata              ( split_user_writedata       [11*32+:32]   ),
                            .reconfig_waitrequest            ( split_user_waitrequest     [11]          ),

  // HIP Signals
  /*input  wire [100:0] */  .hip_aib_data_in                 ( hip_aib_data_in            [11*101+:101] ),
  /*output wire [131:0] */  .hip_aib_data_out                ( hip_aib_data_out           [11*132+:132] ),
  /*input  wire [91:0]  */  .hip_pcs_data_in                 ( hip_pcs_data_in            [11*92+:92]   ),
  /*output wire [61:0]  */  .hip_pcs_data_out                ( int_hip_pcs_data_out_11                  ),
  /*input  wire [3:0]   */  .hip_aib_fsr_in                  ( hip_aib_fsr_in             [11*4+:4]     ),
  /*input  wire [39:0]  */  .hip_aib_ssr_in                  ( hip_aib_ssr_in             [11*40+:40]   ),
  /*output wire [3:0]   */  .hip_aib_fsr_out                 ( hip_aib_fsr_out            [11*4+:4]     ),
  /*output wire [7:0]   */  .hip_aib_ssr_out                 ( hip_aib_ssr_out            [11*8+:8]     ),
  /*input  wire [1:0]   */  .hip_in_reserved_out             ( hip_in_reserved_out        [11*2+:2]     ),
  /*output wire [0:0]   */  .pld_pmaif_mask_tx_pll           ( pld_pmaif_mask_tx_pll      [11]          ),
  /*output wire [0:0]   */  .pldadapt_out_test_data_b10      ( pcie_ctrl_testbus_b10      [11]          ),
  /*output wire [0:0]   */  .hip_cal_done                    ( hip_cal_done               [11]          )

);

///////////////////////////////////////////////////////////////
// Transceiver Channel Instance 12
// Generating Slave Channel
///////////////////////////////////////////////////////////////
assign tx_coreclkin[12]    = tx_clkout[8];
assign rx_coreclkin[12]    = tx_clkout[8];
assign tx_x2_coreclkin[12] = tx_clkout2[8];
wire [61:0]    int_hip_pcs_data_out_12;
assign hip_pcs_data_out[12*62+:62] = int_hip_pcs_data_out_12;
qsys_top_avmm_bridge_512_0_altera_xcvr_pcie_hip_native_s10_altera_xcvr_native_s10_htile_191_hnyookq altera_xcvr_hip_channel_s10_ch12 (
  // Channel Signals
  /*input  wire [1:0]   */  .pipe_sw_done                    ( 2'b0                                    ),
  /*output wire [1:0]   */  .pipe_sw                         (                                         ),
  /*input  wire [79:0]  */  .tx_parallel_data                ( tx_parallel_data           [12*80+:80]   ),
  /*output wire [79:0]  */  .rx_parallel_data                ( rx_parallel_data           [12*80+:80]   ),
  /*input  wire [0:0]   */  .tx_analogreset                  ( tx_analogreset             [12]          ),
  /*input  wire [0:0]   */  .tx_digitalreset                 ( tx_digitalreset            [12]          ),
  /*input  wire [0:0]   */  .rx_analogreset                  ( rx_analogreset             [12]          ),
  /*input  wire [0:0]   */  .rx_digitalreset                 ( rx_digitalreset            [12]          ),
  /*input  wire [0:0]   */  .tx_aibreset                     ( tx_aibreset_out            [12]          ),
  /*input  wire [0:0]   */  .rx_aibreset                     ( rx_aibreset_out            [12]          ),
  /*output wire [0:0]   */  .tx_transfer_ready               ( tx_transfer_ready          [12]          ),
  /*output wire [0:0]   */  .rx_transfer_ready               ( rx_transfer_ready          [12]          ),
  /*output wire [0:0]   */  .tx_cal_busy                     ( tx_cal_busy                [12]          ),
  /*output wire [0:0]   */  .rx_cal_busy                     ( rx_cal_busy                [12]          ),
  /*input  wire         */  .rx_cdr_refclk0                  ( rx_cdr_refclk0                          ),
  /*output wire [0:0]   */  .tx_serial_data                  ( tx_serial_data             [12]          ),
  /*input  wire [0:0]   */  .rx_serial_data                  ( rx_serial_data             [12]          ),
  /*output wire [0:0]   */  .rx_is_lockedtoref               ( rx_is_lockedtoref          [12]          ),
  /*output wire [0:0]   */  .rx_is_lockedtodata              ( rx_is_lockedtodata         [12]          ),
  /*input  wire [0:0]   */  .tx_coreclkin                    ( tx_coreclkin               [12]          ),
  /*input  wire [0:0]   */  .rx_coreclkin                    ( rx_coreclkin               [12]          ),
  /*input  wire [0:0]   */  .tx_x2_coreclkin                 ( tx_x2_coreclkin            [12]          ),
  /*output wire [0:0]   */  .tx_clkout                       ( tx_clkout                  [12]          ),
  /*output wire [0:0]   */  .tx_clkout2                      ( tx_clkout2                 [12]          ),
  /*output wire [0:0]   */  .rx_clkout                       ( rx_clkout                  [12]          ),
  /*input  wire         */  .pipe_hclk_in                    ( pipe_hclk_in                            ),
  /*input  wire [5:0]   */  .tx_bonding_clocks               ( tx_bonding_clocks                         ),

  /*input  wire [2:0]   */  .pipe_rx_eidleinfersel           ( pipe_rx_eidleinfersel      [12*3+:3]     ),
  /*output wire [0:0]   */  .pipe_rx_elecidle                ( pipe_rx_elecidle           [12]          ),

  // Bonding PCS
  /*output wire [29:0]  */  .pcs_bonding_top_data_out        ( pcs_bonding_top_data_out   [(12+1)*30+:30]),
  /*input  wire [29:0]  */  .pcs_bonding_bot_data_in         ( pcs_bonding_top_data_out   [12*30+:30]    ), 
  /*output wire [29:0]  */  .pcs_bonding_bot_data_out        ( pcs_bonding_bot_data_out   [12*30+:30]    ), 
  /*input  wire [29:0]  */  .pcs_bonding_top_data_in         ( pcs_bonding_bot_data_out   [(12+1)*30+:30]),

  // Bonding AIB Core TX
  /*output wire [4:0]   */  .pld_aib_bond_tx_us_out          ( pld_aib_bond_tx_us_out     [(12+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_ds_in           ( pld_aib_bond_tx_us_out     [12*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_tx_ds_out          ( pld_aib_bond_tx_ds_out     [12*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_us_in           ( pld_aib_bond_tx_ds_out     [(12+1)*5+:5] ),

  // Bonding AIB Core Rx
  /*output wire [4:0]   */  .pld_aib_bond_rx_us_out          ( pld_aib_bond_rx_us_out     [(12+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_ds_in           ( pld_aib_bond_rx_us_out     [12*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_rx_ds_out          ( pld_aib_bond_rx_ds_out     [12*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_us_in           ( pld_aib_bond_rx_ds_out     [(12+1)*5+:5] ),

  // Bonding AIB HSSI TX
  /*output wire [6:0]   */  .hssi_aib_bond_tx_us_out         ( hssi_aib_bond_tx_us_out    [(12+1)*7+:7] ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_ds_in          ( hssi_aib_bond_tx_us_out    [12*7+:7]     ),
  /*output wire [6:0]   */  .hssi_aib_bond_tx_ds_out         ( hssi_aib_bond_tx_ds_out    [12*7+:7]     ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_us_in          ( hssi_aib_bond_tx_ds_out    [(12+1)*7+:7] ),

  // Bonding AIB HSSI RX
  /*output wire [7:0]   */  .hssi_aib_bond_rx_us_out         ( hssi_aib_bond_rx_us_out    [(12+1)*8+:8] ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_ds_in          ( hssi_aib_bond_rx_us_out    [12*8+:8]     ),
  /*output wire [7:0]   */  .hssi_aib_bond_rx_ds_out         ( hssi_aib_bond_rx_ds_out    [12*8+:8]     ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_us_in          ( hssi_aib_bond_rx_ds_out    [(12+1)*8+:8] ),

  // Reconfig Signals
                            .reconfig_clk                    ( split_avmm_clk             [12]          ),
                            .reconfig_reset                  ( split_avmm_reset           [12]          ),
                            .reconfig_read                   ( split_user_read            [12]          ),
                            .reconfig_write                  ( split_user_write           [12]          ),
                            .reconfig_address                ( split_user_address         [12*11+:11]   ),
                            .reconfig_readdata               ( split_user_readdata        [12*32+:32]   ),
                            .reconfig_writedata              ( split_user_writedata       [12*32+:32]   ),
                            .reconfig_waitrequest            ( split_user_waitrequest     [12]          ),

  // HIP Signals
  /*input  wire [100:0] */  .hip_aib_data_in                 ( hip_aib_data_in            [12*101+:101] ),
  /*output wire [131:0] */  .hip_aib_data_out                ( hip_aib_data_out           [12*132+:132] ),
  /*input  wire [91:0]  */  .hip_pcs_data_in                 ( hip_pcs_data_in            [12*92+:92]   ),
  /*output wire [61:0]  */  .hip_pcs_data_out                ( int_hip_pcs_data_out_12                  ),
  /*input  wire [3:0]   */  .hip_aib_fsr_in                  ( hip_aib_fsr_in             [12*4+:4]     ),
  /*input  wire [39:0]  */  .hip_aib_ssr_in                  ( hip_aib_ssr_in             [12*40+:40]   ),
  /*output wire [3:0]   */  .hip_aib_fsr_out                 ( hip_aib_fsr_out            [12*4+:4]     ),
  /*output wire [7:0]   */  .hip_aib_ssr_out                 ( hip_aib_ssr_out            [12*8+:8]     ),
  /*input  wire [1:0]   */  .hip_in_reserved_out             ( hip_in_reserved_out        [12*2+:2]     ),
  /*output wire [0:0]   */  .pld_pmaif_mask_tx_pll           ( pld_pmaif_mask_tx_pll      [12]          ),
  /*output wire [0:0]   */  .pldadapt_out_test_data_b10      ( pcie_ctrl_testbus_b10      [12]          ),
  /*output wire [0:0]   */  .hip_cal_done                    ( hip_cal_done               [12]          )

);

///////////////////////////////////////////////////////////////
// Transceiver Channel Instance 13
// Generating Slave Channel
///////////////////////////////////////////////////////////////
assign tx_coreclkin[13]    = tx_clkout[8];
assign rx_coreclkin[13]    = tx_clkout[8];
assign tx_x2_coreclkin[13] = tx_clkout2[8];
wire [61:0]    int_hip_pcs_data_out_13;
assign hip_pcs_data_out[13*62+:62] = int_hip_pcs_data_out_13;
qsys_top_avmm_bridge_512_0_altera_xcvr_pcie_hip_native_s10_altera_xcvr_native_s10_htile_191_3z3mhca altera_xcvr_hip_channel_s10_ch13 (
  // Channel Signals
  /*input  wire [1:0]   */  .pipe_sw_done                    ( 2'b0                                    ),
  /*output wire [1:0]   */  .pipe_sw                         (                                         ),
  /*input  wire [79:0]  */  .tx_parallel_data                ( tx_parallel_data           [13*80+:80]   ),
  /*output wire [79:0]  */  .rx_parallel_data                ( rx_parallel_data           [13*80+:80]   ),
  /*input  wire [0:0]   */  .tx_analogreset                  ( tx_analogreset             [13]          ),
  /*input  wire [0:0]   */  .tx_digitalreset                 ( tx_digitalreset            [13]          ),
  /*input  wire [0:0]   */  .rx_analogreset                  ( rx_analogreset             [13]          ),
  /*input  wire [0:0]   */  .rx_digitalreset                 ( rx_digitalreset            [13]          ),
  /*input  wire [0:0]   */  .tx_aibreset                     ( tx_aibreset_out            [13]          ),
  /*input  wire [0:0]   */  .rx_aibreset                     ( rx_aibreset_out            [13]          ),
  /*output wire [0:0]   */  .tx_transfer_ready               ( tx_transfer_ready          [13]          ),
  /*output wire [0:0]   */  .rx_transfer_ready               ( rx_transfer_ready          [13]          ),
  /*output wire [0:0]   */  .tx_cal_busy                     ( tx_cal_busy                [13]          ),
  /*output wire [0:0]   */  .rx_cal_busy                     ( rx_cal_busy                [13]          ),
  /*input  wire         */  .rx_cdr_refclk0                  ( rx_cdr_refclk0                          ),
  /*output wire [0:0]   */  .tx_serial_data                  ( tx_serial_data             [13]          ),
  /*input  wire [0:0]   */  .rx_serial_data                  ( rx_serial_data             [13]          ),
  /*output wire [0:0]   */  .rx_is_lockedtoref               ( rx_is_lockedtoref          [13]          ),
  /*output wire [0:0]   */  .rx_is_lockedtodata              ( rx_is_lockedtodata         [13]          ),
  /*input  wire [0:0]   */  .tx_coreclkin                    ( tx_coreclkin               [13]          ),
  /*input  wire [0:0]   */  .rx_coreclkin                    ( rx_coreclkin               [13]          ),
  /*input  wire [0:0]   */  .tx_x2_coreclkin                 ( tx_x2_coreclkin            [13]          ),
  /*output wire [0:0]   */  .tx_clkout                       ( tx_clkout                  [13]          ),
  /*output wire [0:0]   */  .tx_clkout2                      ( tx_clkout2                 [13]          ),
  /*output wire [0:0]   */  .rx_clkout                       ( rx_clkout                  [13]          ),
  /*input  wire         */  .pipe_hclk_in                    ( pipe_hclk_in                            ),
  /*input  wire [5:0]   */  .tx_bonding_clocks               ( tx_bonding_clocks                         ),

  /*input  wire [2:0]   */  .pipe_rx_eidleinfersel           ( pipe_rx_eidleinfersel      [13*3+:3]     ),
  /*output wire [0:0]   */  .pipe_rx_elecidle                ( pipe_rx_elecidle           [13]          ),

  // Bonding PCS
  /*output wire [29:0]  */  .pcs_bonding_top_data_out        ( pcs_bonding_top_data_out   [(13+1)*30+:30]),
  /*input  wire [29:0]  */  .pcs_bonding_bot_data_in         ( pcs_bonding_top_data_out   [13*30+:30]    ), 
  /*output wire [29:0]  */  .pcs_bonding_bot_data_out        ( pcs_bonding_bot_data_out   [13*30+:30]    ), 
  /*input  wire [29:0]  */  .pcs_bonding_top_data_in         ( pcs_bonding_bot_data_out   [(13+1)*30+:30]),

  // Bonding AIB Core TX
  /*output wire [4:0]   */  .pld_aib_bond_tx_us_out          ( pld_aib_bond_tx_us_out     [(13+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_ds_in           ( pld_aib_bond_tx_us_out     [13*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_tx_ds_out          ( pld_aib_bond_tx_ds_out     [13*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_us_in           ( pld_aib_bond_tx_ds_out     [(13+1)*5+:5] ),

  // Bonding AIB Core Rx
  /*output wire [4:0]   */  .pld_aib_bond_rx_us_out          ( pld_aib_bond_rx_us_out     [(13+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_ds_in           ( pld_aib_bond_rx_us_out     [13*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_rx_ds_out          ( pld_aib_bond_rx_ds_out     [13*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_us_in           ( pld_aib_bond_rx_ds_out     [(13+1)*5+:5] ),

  // Bonding AIB HSSI TX
  /*output wire [6:0]   */  .hssi_aib_bond_tx_us_out         ( hssi_aib_bond_tx_us_out    [(13+1)*7+:7] ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_ds_in          ( hssi_aib_bond_tx_us_out    [13*7+:7]     ),
  /*output wire [6:0]   */  .hssi_aib_bond_tx_ds_out         ( hssi_aib_bond_tx_ds_out    [13*7+:7]     ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_us_in          ( hssi_aib_bond_tx_ds_out    [(13+1)*7+:7] ),

  // Bonding AIB HSSI RX
  /*output wire [7:0]   */  .hssi_aib_bond_rx_us_out         ( hssi_aib_bond_rx_us_out    [(13+1)*8+:8] ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_ds_in          ( hssi_aib_bond_rx_us_out    [13*8+:8]     ),
  /*output wire [7:0]   */  .hssi_aib_bond_rx_ds_out         ( hssi_aib_bond_rx_ds_out    [13*8+:8]     ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_us_in          ( hssi_aib_bond_rx_ds_out    [(13+1)*8+:8] ),

  // Reconfig Signals
                            .reconfig_clk                    ( split_avmm_clk             [13]          ),
                            .reconfig_reset                  ( split_avmm_reset           [13]          ),
                            .reconfig_read                   ( split_user_read            [13]          ),
                            .reconfig_write                  ( split_user_write           [13]          ),
                            .reconfig_address                ( split_user_address         [13*11+:11]   ),
                            .reconfig_readdata               ( split_user_readdata        [13*32+:32]   ),
                            .reconfig_writedata              ( split_user_writedata       [13*32+:32]   ),
                            .reconfig_waitrequest            ( split_user_waitrequest     [13]          ),

  // HIP Signals
  /*input  wire [100:0] */  .hip_aib_data_in                 ( hip_aib_data_in            [13*101+:101] ),
  /*output wire [131:0] */  .hip_aib_data_out                ( hip_aib_data_out           [13*132+:132] ),
  /*input  wire [91:0]  */  .hip_pcs_data_in                 ( hip_pcs_data_in            [13*92+:92]   ),
  /*output wire [61:0]  */  .hip_pcs_data_out                ( int_hip_pcs_data_out_13                  ),
  /*input  wire [3:0]   */  .hip_aib_fsr_in                  ( hip_aib_fsr_in             [13*4+:4]     ),
  /*input  wire [39:0]  */  .hip_aib_ssr_in                  ( hip_aib_ssr_in             [13*40+:40]   ),
  /*output wire [3:0]   */  .hip_aib_fsr_out                 ( hip_aib_fsr_out            [13*4+:4]     ),
  /*output wire [7:0]   */  .hip_aib_ssr_out                 ( hip_aib_ssr_out            [13*8+:8]     ),
  /*input  wire [1:0]   */  .hip_in_reserved_out             ( hip_in_reserved_out        [13*2+:2]     ),
  /*output wire [0:0]   */  .pld_pmaif_mask_tx_pll           ( pld_pmaif_mask_tx_pll      [13]          ),
  /*output wire [0:0]   */  .pldadapt_out_test_data_b10      ( pcie_ctrl_testbus_b10      [13]          ),
  /*output wire [0:0]   */  .hip_cal_done                    ( hip_cal_done               [13]          )

);

///////////////////////////////////////////////////////////////
// Transceiver Channel Instance 14
// Generating Slave Channel
///////////////////////////////////////////////////////////////
assign tx_coreclkin[14]    = tx_clkout[8];
assign rx_coreclkin[14]    = tx_clkout[8];
assign tx_x2_coreclkin[14] = tx_clkout2[8];
wire [61:0]    int_hip_pcs_data_out_14;
assign hip_pcs_data_out[14*62+:62] = int_hip_pcs_data_out_14;
qsys_top_avmm_bridge_512_0_altera_xcvr_pcie_hip_native_s10_altera_xcvr_native_s10_htile_191_xo6r6xa altera_xcvr_hip_channel_s10_ch14 (
  // Channel Signals
  /*input  wire [1:0]   */  .pipe_sw_done                    ( 2'b0                                    ),
  /*output wire [1:0]   */  .pipe_sw                         (                                         ),
  /*input  wire [79:0]  */  .tx_parallel_data                ( tx_parallel_data           [14*80+:80]   ),
  /*output wire [79:0]  */  .rx_parallel_data                ( rx_parallel_data           [14*80+:80]   ),
  /*input  wire [0:0]   */  .tx_analogreset                  ( tx_analogreset             [14]          ),
  /*input  wire [0:0]   */  .tx_digitalreset                 ( tx_digitalreset            [14]          ),
  /*input  wire [0:0]   */  .rx_analogreset                  ( rx_analogreset             [14]          ),
  /*input  wire [0:0]   */  .rx_digitalreset                 ( rx_digitalreset            [14]          ),
  /*input  wire [0:0]   */  .tx_aibreset                     ( tx_aibreset_out            [14]          ),
  /*input  wire [0:0]   */  .rx_aibreset                     ( rx_aibreset_out            [14]          ),
  /*output wire [0:0]   */  .tx_transfer_ready               ( tx_transfer_ready          [14]          ),
  /*output wire [0:0]   */  .rx_transfer_ready               ( rx_transfer_ready          [14]          ),
  /*output wire [0:0]   */  .tx_cal_busy                     ( tx_cal_busy                [14]          ),
  /*output wire [0:0]   */  .rx_cal_busy                     ( rx_cal_busy                [14]          ),
  /*input  wire         */  .rx_cdr_refclk0                  ( rx_cdr_refclk0                          ),
  /*output wire [0:0]   */  .tx_serial_data                  ( tx_serial_data             [14]          ),
  /*input  wire [0:0]   */  .rx_serial_data                  ( rx_serial_data             [14]          ),
  /*output wire [0:0]   */  .rx_is_lockedtoref               ( rx_is_lockedtoref          [14]          ),
  /*output wire [0:0]   */  .rx_is_lockedtodata              ( rx_is_lockedtodata         [14]          ),
  /*input  wire [0:0]   */  .tx_coreclkin                    ( tx_coreclkin               [14]          ),
  /*input  wire [0:0]   */  .rx_coreclkin                    ( rx_coreclkin               [14]          ),
  /*input  wire [0:0]   */  .tx_x2_coreclkin                 ( tx_x2_coreclkin            [14]          ),
  /*output wire [0:0]   */  .tx_clkout                       ( tx_clkout                  [14]          ),
  /*output wire [0:0]   */  .tx_clkout2                      ( tx_clkout2                 [14]          ),
  /*output wire [0:0]   */  .rx_clkout                       ( rx_clkout                  [14]          ),
  /*input  wire         */  .pipe_hclk_in                    ( pipe_hclk_in                            ),
  /*input  wire [5:0]   */  .tx_bonding_clocks               ( tx_bonding_clocks                         ),

  /*input  wire [2:0]   */  .pipe_rx_eidleinfersel           ( pipe_rx_eidleinfersel      [14*3+:3]     ),
  /*output wire [0:0]   */  .pipe_rx_elecidle                ( pipe_rx_elecidle           [14]          ),

  // Bonding PCS
  /*output wire [29:0]  */  .pcs_bonding_top_data_out        ( pcs_bonding_top_data_out   [(14+1)*30+:30]),
  /*input  wire [29:0]  */  .pcs_bonding_bot_data_in         ( pcs_bonding_top_data_out   [14*30+:30]    ), 
  /*output wire [29:0]  */  .pcs_bonding_bot_data_out        ( pcs_bonding_bot_data_out   [14*30+:30]    ), 
  /*input  wire [29:0]  */  .pcs_bonding_top_data_in         ( pcs_bonding_bot_data_out   [(14+1)*30+:30]),

  // Bonding AIB Core TX
  /*output wire [4:0]   */  .pld_aib_bond_tx_us_out          ( pld_aib_bond_tx_us_out     [(14+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_ds_in           ( pld_aib_bond_tx_us_out     [14*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_tx_ds_out          ( pld_aib_bond_tx_ds_out     [14*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_us_in           ( pld_aib_bond_tx_ds_out     [(14+1)*5+:5] ),

  // Bonding AIB Core Rx
  /*output wire [4:0]   */  .pld_aib_bond_rx_us_out          ( pld_aib_bond_rx_us_out     [(14+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_ds_in           ( pld_aib_bond_rx_us_out     [14*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_rx_ds_out          ( pld_aib_bond_rx_ds_out     [14*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_us_in           ( pld_aib_bond_rx_ds_out     [(14+1)*5+:5] ),

  // Bonding AIB HSSI TX
  /*output wire [6:0]   */  .hssi_aib_bond_tx_us_out         ( hssi_aib_bond_tx_us_out    [(14+1)*7+:7] ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_ds_in          ( hssi_aib_bond_tx_us_out    [14*7+:7]     ),
  /*output wire [6:0]   */  .hssi_aib_bond_tx_ds_out         ( hssi_aib_bond_tx_ds_out    [14*7+:7]     ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_us_in          ( hssi_aib_bond_tx_ds_out    [(14+1)*7+:7] ),

  // Bonding AIB HSSI RX
  /*output wire [7:0]   */  .hssi_aib_bond_rx_us_out         ( hssi_aib_bond_rx_us_out    [(14+1)*8+:8] ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_ds_in          ( hssi_aib_bond_rx_us_out    [14*8+:8]     ),
  /*output wire [7:0]   */  .hssi_aib_bond_rx_ds_out         ( hssi_aib_bond_rx_ds_out    [14*8+:8]     ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_us_in          ( hssi_aib_bond_rx_ds_out    [(14+1)*8+:8] ),

  // Reconfig Signals
                            .reconfig_clk                    ( split_avmm_clk             [14]          ),
                            .reconfig_reset                  ( split_avmm_reset           [14]          ),
                            .reconfig_read                   ( split_user_read            [14]          ),
                            .reconfig_write                  ( split_user_write           [14]          ),
                            .reconfig_address                ( split_user_address         [14*11+:11]   ),
                            .reconfig_readdata               ( split_user_readdata        [14*32+:32]   ),
                            .reconfig_writedata              ( split_user_writedata       [14*32+:32]   ),
                            .reconfig_waitrequest            ( split_user_waitrequest     [14]          ),

  // HIP Signals
  /*input  wire [100:0] */  .hip_aib_data_in                 ( hip_aib_data_in            [14*101+:101] ),
  /*output wire [131:0] */  .hip_aib_data_out                ( hip_aib_data_out           [14*132+:132] ),
  /*input  wire [91:0]  */  .hip_pcs_data_in                 ( hip_pcs_data_in            [14*92+:92]   ),
  /*output wire [61:0]  */  .hip_pcs_data_out                ( int_hip_pcs_data_out_14                  ),
  /*input  wire [3:0]   */  .hip_aib_fsr_in                  ( hip_aib_fsr_in             [14*4+:4]     ),
  /*input  wire [39:0]  */  .hip_aib_ssr_in                  ( hip_aib_ssr_in             [14*40+:40]   ),
  /*output wire [3:0]   */  .hip_aib_fsr_out                 ( hip_aib_fsr_out            [14*4+:4]     ),
  /*output wire [7:0]   */  .hip_aib_ssr_out                 ( hip_aib_ssr_out            [14*8+:8]     ),
  /*input  wire [1:0]   */  .hip_in_reserved_out             ( hip_in_reserved_out        [14*2+:2]     ),
  /*output wire [0:0]   */  .pld_pmaif_mask_tx_pll           ( pld_pmaif_mask_tx_pll      [14]          ),
  /*output wire [0:0]   */  .pldadapt_out_test_data_b10      ( pcie_ctrl_testbus_b10      [14]          ),
  /*output wire [0:0]   */  .hip_cal_done                    ( hip_cal_done               [14]          )

);

///////////////////////////////////////////////////////////////
// Transceiver Channel Instance 15
// Generating Slave Channel
///////////////////////////////////////////////////////////////
assign tx_coreclkin[15]    = tx_clkout[8];
assign rx_coreclkin[15]    = tx_clkout[8];
assign tx_x2_coreclkin[15] = tx_clkout2[8];
wire [61:0]    int_hip_pcs_data_out_15;
assign hip_pcs_data_out[15*62+:62] = int_hip_pcs_data_out_15;
qsys_top_avmm_bridge_512_0_altera_xcvr_pcie_hip_native_s10_altera_xcvr_native_s10_htile_191_qal7puq altera_xcvr_hip_channel_s10_ch15 (
  // Channel Signals
  /*input  wire [1:0]   */  .pipe_sw_done                    ( 2'b0                                    ),
  /*output wire [1:0]   */  .pipe_sw                         (                                         ),
  /*input  wire [79:0]  */  .tx_parallel_data                ( tx_parallel_data           [15*80+:80]   ),
  /*output wire [79:0]  */  .rx_parallel_data                ( rx_parallel_data           [15*80+:80]   ),
  /*input  wire [0:0]   */  .tx_analogreset                  ( tx_analogreset             [15]          ),
  /*input  wire [0:0]   */  .tx_digitalreset                 ( tx_digitalreset            [15]          ),
  /*input  wire [0:0]   */  .rx_analogreset                  ( rx_analogreset             [15]          ),
  /*input  wire [0:0]   */  .rx_digitalreset                 ( rx_digitalreset            [15]          ),
  /*input  wire [0:0]   */  .tx_aibreset                     ( tx_aibreset_out            [15]          ),
  /*input  wire [0:0]   */  .rx_aibreset                     ( rx_aibreset_out            [15]          ),
  /*output wire [0:0]   */  .tx_transfer_ready               ( tx_transfer_ready          [15]          ),
  /*output wire [0:0]   */  .rx_transfer_ready               ( rx_transfer_ready          [15]          ),
  /*output wire [0:0]   */  .tx_cal_busy                     ( tx_cal_busy                [15]          ),
  /*output wire [0:0]   */  .rx_cal_busy                     ( rx_cal_busy                [15]          ),
  /*input  wire         */  .rx_cdr_refclk0                  ( rx_cdr_refclk0                          ),
  /*output wire [0:0]   */  .tx_serial_data                  ( tx_serial_data             [15]          ),
  /*input  wire [0:0]   */  .rx_serial_data                  ( rx_serial_data             [15]          ),
  /*output wire [0:0]   */  .rx_is_lockedtoref               ( rx_is_lockedtoref          [15]          ),
  /*output wire [0:0]   */  .rx_is_lockedtodata              ( rx_is_lockedtodata         [15]          ),
  /*input  wire [0:0]   */  .tx_coreclkin                    ( tx_coreclkin               [15]          ),
  /*input  wire [0:0]   */  .rx_coreclkin                    ( rx_coreclkin               [15]          ),
  /*input  wire [0:0]   */  .tx_x2_coreclkin                 ( tx_x2_coreclkin            [15]          ),
  /*output wire [0:0]   */  .tx_clkout                       ( tx_clkout                  [15]          ),
  /*output wire [0:0]   */  .tx_clkout2                      ( tx_clkout2                 [15]          ),
  /*output wire [0:0]   */  .rx_clkout                       ( rx_clkout                  [15]          ),
  /*input  wire         */  .pipe_hclk_in                    ( pipe_hclk_in                            ),
  /*input  wire [5:0]   */  .tx_bonding_clocks               ( tx_bonding_clocks                         ),

  /*input  wire [2:0]   */  .pipe_rx_eidleinfersel           ( pipe_rx_eidleinfersel      [15*3+:3]     ),
  /*output wire [0:0]   */  .pipe_rx_elecidle                ( pipe_rx_elecidle           [15]          ),

  // Bonding PCS
  /*output wire [29:0]  */  .pcs_bonding_top_data_out        ( pcs_bonding_top_data_out   [(15+1)*30+:30]),
  /*input  wire [29:0]  */  .pcs_bonding_bot_data_in         ( pcs_bonding_top_data_out   [15*30+:30]    ), 
  /*output wire [29:0]  */  .pcs_bonding_bot_data_out        ( pcs_bonding_bot_data_out   [15*30+:30]    ), 
  /*input  wire [29:0]  */  .pcs_bonding_top_data_in         ( pcs_bonding_bot_data_out   [(15+1)*30+:30]),

  // Bonding AIB Core TX
  /*output wire [4:0]   */  .pld_aib_bond_tx_us_out          ( pld_aib_bond_tx_us_out     [(15+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_ds_in           ( pld_aib_bond_tx_us_out     [15*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_tx_ds_out          ( pld_aib_bond_tx_ds_out     [15*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_tx_us_in           ( pld_aib_bond_tx_ds_out     [(15+1)*5+:5] ),

  // Bonding AIB Core Rx
  /*output wire [4:0]   */  .pld_aib_bond_rx_us_out          ( pld_aib_bond_rx_us_out     [(15+1)*5+:5] ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_ds_in           ( pld_aib_bond_rx_us_out     [15*5+:5]     ),
  /*output wire [4:0]   */  .pld_aib_bond_rx_ds_out          ( pld_aib_bond_rx_ds_out     [15*5+:5]     ),
  /*input  wire [4:0]   */  .pld_aib_bond_rx_us_in           ( pld_aib_bond_rx_ds_out     [(15+1)*5+:5] ),

  // Bonding AIB HSSI TX
  /*output wire [6:0]   */  .hssi_aib_bond_tx_us_out         ( hssi_aib_bond_tx_us_out    [(15+1)*7+:7] ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_ds_in          ( hssi_aib_bond_tx_us_out    [15*7+:7]     ),
  /*output wire [6:0]   */  .hssi_aib_bond_tx_ds_out         ( hssi_aib_bond_tx_ds_out    [15*7+:7]     ),
  /*input  wire [6:0]   */  .hssi_aib_bond_tx_us_in          ( hssi_aib_bond_tx_ds_out    [(15+1)*7+:7] ),

  // Bonding AIB HSSI RX
  /*output wire [7:0]   */  .hssi_aib_bond_rx_us_out         ( hssi_aib_bond_rx_us_out    [(15+1)*8+:8] ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_ds_in          ( hssi_aib_bond_rx_us_out    [15*8+:8]     ),
  /*output wire [7:0]   */  .hssi_aib_bond_rx_ds_out         ( hssi_aib_bond_rx_ds_out    [15*8+:8]     ),
  /*input  wire [7:0]   */  .hssi_aib_bond_rx_us_in          ( hssi_aib_bond_rx_ds_out    [(15+1)*8+:8] ),

  // Reconfig Signals
                            .reconfig_clk                    ( split_avmm_clk             [15]          ),
                            .reconfig_reset                  ( split_avmm_reset           [15]          ),
                            .reconfig_read                   ( split_user_read            [15]          ),
                            .reconfig_write                  ( split_user_write           [15]          ),
                            .reconfig_address                ( split_user_address         [15*11+:11]   ),
                            .reconfig_readdata               ( split_user_readdata        [15*32+:32]   ),
                            .reconfig_writedata              ( split_user_writedata       [15*32+:32]   ),
                            .reconfig_waitrequest            ( split_user_waitrequest     [15]          ),

  // HIP Signals
  /*input  wire [100:0] */  .hip_aib_data_in                 ( hip_aib_data_in            [15*101+:101] ),
  /*output wire [131:0] */  .hip_aib_data_out                ( hip_aib_data_out           [15*132+:132] ),
  /*input  wire [91:0]  */  .hip_pcs_data_in                 ( hip_pcs_data_in            [15*92+:92]   ),
  /*output wire [61:0]  */  .hip_pcs_data_out                ( int_hip_pcs_data_out_15                  ),
  /*input  wire [3:0]   */  .hip_aib_fsr_in                  ( hip_aib_fsr_in             [15*4+:4]     ),
  /*input  wire [39:0]  */  .hip_aib_ssr_in                  ( hip_aib_ssr_in             [15*40+:40]   ),
  /*output wire [3:0]   */  .hip_aib_fsr_out                 ( hip_aib_fsr_out            [15*4+:4]     ),
  /*output wire [7:0]   */  .hip_aib_ssr_out                 ( hip_aib_ssr_out            [15*8+:8]     ),
  /*input  wire [1:0]   */  .hip_in_reserved_out             ( hip_in_reserved_out        [15*2+:2]     ),
  /*output wire [0:0]   */  .pld_pmaif_mask_tx_pll           ( pld_pmaif_mask_tx_pll      [15]          ),
  /*output wire [0:0]   */  .pldadapt_out_test_data_b10      ( pcie_ctrl_testbus_b10      [15]          ),
  /*output wire [0:0]   */  .hip_cal_done                    ( hip_cal_done               [15]          )

);


endmodule

