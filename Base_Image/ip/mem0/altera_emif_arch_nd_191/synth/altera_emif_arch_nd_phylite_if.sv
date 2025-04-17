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
// This module is responsible for exposing the data interfaces through which
// soft logic interacts with the Avalon MM port of the HMC
// 
///////////////////////////////////////////////////////////////////////////////

`define _get_pin_count(_loc) ( _loc[ 9 : 0 ] )
`define _get_pin_index(_loc, _port_i) ( _loc[ (_port_i + 1) * 10 +: 10 ] )

`define _get_tile(_loc, _port_i) (  `_get_pin_index(_loc, _port_i) / (PINS_PER_LANE * LANES_PER_TILE) )
`define _get_lane(_loc, _port_i) ( (`_get_pin_index(_loc, _port_i) / PINS_PER_LANE) % LANES_PER_TILE ) 
`define _get_pin(_loc, _port_i)  (  `_get_pin_index(_loc, _port_i) % PINS_PER_LANE )

`define _core2l_data(_port_i, _phase_i) core2l_data\
   [`_get_tile(WD_PINLOC, _port_i)]\
   [`_get_lane(WD_PINLOC, _port_i)]\
   [(`_get_pin(WD_PINLOC, _port_i) * 8) + _phase_i]

`define _data_oe(_port_i, _phase_i) core2l_oe\
   [`_get_tile(WD_PINLOC, _port_i)]\
   [`_get_lane(WD_PINLOC, _port_i)]\
   [(`_get_pin(WD_PINLOC, _port_i) * 4) + _phase_i]

`define _strobe2l_data(_port_i, _phase_i) core2l_data\
   [`_get_tile(PORT_MEM_DQS_PINLOC, _port_i)]\
   [`_get_lane(PORT_MEM_DQS_PINLOC, _port_i)]\
   [(`_get_pin(PORT_MEM_DQS_PINLOC, _port_i) * 8) + _phase_i]

`define _stroben2l_data(_port_i, _phase_i) core2l_data\
   [`_get_tile(PORT_MEM_DQS_N_PINLOC, _port_i)]\
   [`_get_lane(PORT_MEM_DQS_N_PINLOC, _port_i)]\
   [(`_get_pin(PORT_MEM_DQS_N_PINLOC, _port_i) * 8) + _phase_i]

`define _strobe_oe(_port_i, _phase_i) core2l_oe\
   [`_get_tile(PORT_MEM_DQS_PINLOC, _port_i)]\
   [`_get_lane(PORT_MEM_DQS_PINLOC, _port_i)]\
   [(`_get_pin(PORT_MEM_DQS_PINLOC, _port_i) * 4) + _phase_i]

`define _strobe_n_oe(_port_i, _phase_i) core2l_oe\
   [`_get_tile(PORT_MEM_DQS_N_PINLOC, _port_i)]\
   [`_get_lane(PORT_MEM_DQS_N_PINLOC, _port_i)]\
   [(`_get_pin(PORT_MEM_DQS_N_PINLOC, _port_i) * 4) + _phase_i]

`define _datamask_oe(_port_i, _phase_i) core2l_oe\
   [`_get_tile(WM_PINLOC, _port_i)]\
   [`_get_lane(WM_PINLOC, _port_i)]\
   [(`_get_pin(WM_PINLOC, _port_i) * 4) + _phase_i]

`define _core2l_datamask(_port_i, _phase_i) core2l_data\
   [`_get_tile(WM_PINLOC, _port_i)]\
   [`_get_lane(WM_PINLOC, _port_i)]\
   [(`_get_pin(WM_PINLOC, _port_i) * 8) + _phase_i]
      
`define _l2core_data(_port_i, _phase_i) l2core_data\
   [`_get_tile(RD_PINLOC, _port_i)]\
   [`_get_lane(RD_PINLOC, _port_i)]\
   [(`_get_pin(RD_PINLOC, _port_i) * 8) + _phase_i]
   
`define _unused_core2l_data(_pin_i) core2l_data\
   [_pin_i / (PINS_PER_LANE * LANES_PER_TILE)]\
   [(_pin_i / PINS_PER_LANE) % LANES_PER_TILE]\
   [((_pin_i % PINS_PER_LANE) * 8) +: 8]

`define _unused_oe(_pin_i) core2l_oe\
   [_pin_i / (PINS_PER_LANE * LANES_PER_TILE)]\
   [(_pin_i / PINS_PER_LANE) % LANES_PER_TILE]\
   [((_pin_i % PINS_PER_LANE) * 4) +: 4]    

module altera_emif_arch_nd_phylite_if #(
   parameter PINS_PER_LANE                  = 1,
   parameter LANES_PER_TILE                 = 1,
   parameter NUM_OF_RTL_TILES               = 1,
  
   // Pin indexes of data signals
   parameter PORT_MEM_D_PINLOC              = 10'b0000000000,
   parameter PORT_MEM_DQ_PINLOC             = 10'b0000000000,
   parameter PORT_MEM_Q_PINLOC              = 10'b0000000000,
   parameter PORT_MEM_DQS_PINLOC            = 10'b0000000000,
   parameter PORT_MEM_DQS_N_PINLOC          = 10'b0000000000,
 
   // Pin indexes of write data mask signals
   parameter PORT_MEM_DM_PINLOC             = 10'b0000000000,
   parameter PORT_MEM_DBI_N_PINLOC          = 10'b0000000000,
   parameter PORT_MEM_BWS_N_PINLOC          = 10'b0000000000,
   
   // Parameter indicating the core-2-lane connection of a pin is actually driven
   parameter PINS_C2L_DRIVEN                = 1'b0,
   parameter GENERATE_PHYLITE               = 1,

   // Definition of port widths for "phylite" interface (auto-generated)
   parameter PORT_CTRL_DATA_OUT_WIDTH       = 1,
   parameter PORT_CTRL_DATA_IN_WIDTH        = 1,
   parameter PORT_CTRL_DATA_OE_WIDTH        = 1,
   parameter PORT_CTRL_STROBE_OE_WIDTH      = 1,
   parameter PORT_CTRL_STROBE_WIDTH         = 1,
   parameter PORT_CTRL_RDATA_VALID_WIDTH    = 1,
   parameter PORT_CTRL_RDATA_ENABLE_WIDTH   = 1
) (
   input                                                                             pll_locked,
   input                                                                             emif_usr_clk,
   input                                                                             emif_usr_clk_sec,

   // Signals between core and data lanes
   output logic [NUM_OF_RTL_TILES-1:0][LANES_PER_TILE-1:0][PINS_PER_LANE * 8 - 1:0]  core2l_data,
   input  logic [NUM_OF_RTL_TILES-1:0][LANES_PER_TILE-1:0][PINS_PER_LANE * 8 - 1:0]  l2core_data,
   input  logic [NUM_OF_RTL_TILES-1:0][LANES_PER_TILE-1:0][3:0]                      l2core_rdata_valid,
   output logic [NUM_OF_RTL_TILES-1:0][LANES_PER_TILE-1:0][3:0]                      core2l_rdata_en_full,
   input  logic [NUM_OF_RTL_TILES-1:0][LANES_PER_TILE-1:0][5:0]                      l2core_ioereg_locked,
   input  logic [1:0]                                                                core_clks_locked_cpa_pri,
   output logic [NUM_OF_RTL_TILES-1:0][LANES_PER_TILE-1:0][PINS_PER_LANE * 4 - 1:0]  core2l_oe,

   // PHYLite interface
   input  logic [PORT_CTRL_STROBE_WIDTH-1:0]					     phylite_strobe,  
   input  logic [PORT_CTRL_DATA_OE_WIDTH-1:0]					     phylite_data_oe,
   input  logic [PORT_CTRL_STROBE_OE_WIDTH-1:0]					     phylite_strobe_oe,   
   input  logic [PORT_CTRL_DATA_OUT_WIDTH-1:0]					     phylite_data_from_core,  
   output logic [PORT_CTRL_DATA_IN_WIDTH-1:0]					     phylite_data_to_core,  
   output logic [PORT_CTRL_RDATA_VALID_WIDTH-1:0]				     phylite_rdata_valid,
   input  logic [PORT_CTRL_RDATA_ENABLE_WIDTH-1:0]				     phylite_rdata_en,
   output logic 								     phylite_interface_locked
);
   timeunit 1ns;
   timeprecision 1ps;

   localparam RD_PINLOC = (`_get_pin_count(PORT_MEM_DQ_PINLOC) != 0 ? PORT_MEM_DQ_PINLOC : PORT_MEM_Q_PINLOC);
   localparam WD_PINLOC = (`_get_pin_count(PORT_MEM_DQ_PINLOC) != 0 ? PORT_MEM_DQ_PINLOC : PORT_MEM_D_PINLOC);
   localparam WM_PINLOC = (`_get_pin_count(PORT_MEM_DM_PINLOC) != 0 ? PORT_MEM_DM_PINLOC : (`_get_pin_count(PORT_MEM_DBI_N_PINLOC) != 0 ? PORT_MEM_DBI_N_PINLOC : PORT_MEM_BWS_N_PINLOC));
      
   localparam NUM_RD_PINS    = `_get_pin_count(RD_PINLOC);
   localparam NUM_WD_PINS    = `_get_pin_count(WD_PINLOC);
   localparam NUM_WM_PINS    = `_get_pin_count(WM_PINLOC);
   localparam NUM_DQS_PINS   = `_get_pin_count(PORT_MEM_DQS_PINLOC);
   localparam NUM_DQS_N_PINS = `_get_pin_count(PORT_MEM_DQS_N_PINLOC);


   localparam NUM_OF_RD_PHASES = PORT_CTRL_DATA_OUT_WIDTH / NUM_RD_PINS;
   localparam NUM_OF_WD_PHASES = PORT_CTRL_DATA_IN_WIDTH / NUM_WD_PINS;
   localparam NUM_OF_OE_PHASES = NUM_OF_WD_PHASES / 2;
  
   generate
      genvar port_i;
      genvar phase_i;
      genvar pin_i;
      genvar lane_i;
      genvar tile_i;
     
      // phylite_interface locked signal 
      assign phylite_interface_locked= |l2core_ioereg_locked[`_get_tile(WD_PINLOC,0)][`_get_lane(WD_PINLOC,0)] && pll_locked ;
   
      // phylite_data_from_core  to lanes' write data bus
      for (port_i = 0; port_i < NUM_WD_PINS; ++port_i)
      begin : wd_port
         for (phase_i = 0; phase_i < NUM_OF_WD_PHASES; ++phase_i)
         begin : phase
               assign `_core2l_data(port_i, phase_i) = phylite_data_from_core[phase_i * NUM_WD_PINS + port_i];
         end
      end

      // Tie off unused phases for core2l_data for the write data pins
      for (port_i = 0; port_i < NUM_WD_PINS; ++port_i)
      begin : wd_port_unused
         for (phase_i = NUM_OF_WD_PHASES; phase_i < 8; ++phase_i)
         begin : unused_phase
            assign `_core2l_data(port_i, phase_i) = '0;
         end
      end

      // phylite_data_oe from core to lanes' write data bus 
      for (port_i = 0; port_i < NUM_WD_PINS; ++port_i)
      begin : data_oe 
         for (phase_i = 0; phase_i < NUM_OF_OE_PHASES; ++phase_i)
         begin : phase
               assign `_data_oe(port_i, phase_i) =~phylite_data_oe[port_i * NUM_OF_OE_PHASES +phase_i];
         end
      end

      // Tie off unused oe for core2l_data for the write data pins
      for (port_i = 0; port_i < NUM_WD_PINS; ++port_i)
      begin : data_oe_unused 
         for (phase_i = NUM_OF_OE_PHASES; phase_i < 4; ++phase_i)
         begin : phase
               assign `_data_oe(port_i, phase_i) = '1;
         end
      end

      // phylite_strobe from core to lanes' write data bus 
      for (port_i = 0; port_i < NUM_DQS_PINS; ++port_i)
      begin : strobe 
         for (phase_i = 0; phase_i < NUM_OF_WD_PHASES; ++phase_i)
         begin : phase
               assign `_strobe2l_data(port_i, phase_i) = phylite_strobe[phase_i];
               assign `_stroben2l_data(port_i, phase_i) = ~phylite_strobe[phase_i];
         end
      end

      // Tie off unused phases for strobe2l_data for the write data pins
      for (port_i = 0; port_i < NUM_DQS_PINS; ++port_i)
      begin : strobe_unused 
         for (phase_i = NUM_OF_WD_PHASES; phase_i < 8; ++phase_i)
         begin : phase
               assign `_strobe2l_data(port_i, phase_i) = '0;
               assign `_stroben2l_data(port_i, phase_i) = '0;
         end
      end

      // phylite_strobe_oe from core to lanes' data oe 
      for (port_i = 0; port_i < NUM_DQS_PINS; ++port_i)
      begin : strobe_oe
         for (phase_i = 0; phase_i < NUM_OF_OE_PHASES; ++phase_i)
         begin : phase
               assign `_strobe_oe(port_i, phase_i) =~phylite_strobe_oe[phase_i];
               assign `_strobe_n_oe(port_i, phase_i) =~phylite_strobe_oe[phase_i];
         end
      end

      // Tie off unused phases for phylite_strobe_oe for core to lanes' strobe oe 
      for (port_i = 0; port_i < NUM_DQS_PINS; ++port_i)
      begin : strobe_oe_unused
         for (phase_i = NUM_OF_OE_PHASES; phase_i < 4; ++phase_i)
         begin : phase
               assign `_strobe_oe(port_i, phase_i) ='1;
               assign `_strobe_n_oe(port_i, phase_i) ='1;
         end
      end
  
      // Map lanes' read data bus to phylite_data_to_core  
      for (port_i = 0; port_i < NUM_RD_PINS; ++port_i)
      begin : rd_port
         for (phase_i = 0; phase_i < NUM_OF_RD_PHASES; ++phase_i)
         begin : phase
               assign phylite_data_to_core[phase_i * NUM_RD_PINS + port_i] = `_l2core_data(port_i, phase_i);
         end
      end

      // Map lanes' read_valid to phylite_rdata_valid 
      assign phylite_rdata_valid = l2core_rdata_valid[`_get_tile(WD_PINLOC,0)][`_get_lane(WD_PINLOC,0)][PORT_CTRL_RDATA_VALID_WIDTH-1:0];

      // Map lanes' rdata_en
      for (tile_i = 0; tile_i < NUM_OF_RTL_TILES; ++tile_i)
      begin : rd_en
         for (lane_i = 0; lane_i < LANES_PER_TILE; ++lane_i)
         begin : phase
      	 	if ( tile_i == `_get_tile(WD_PINLOC,0))begin
      	 	        assign core2l_rdata_en_full[tile_i][lane_i] = {{(4 - PORT_CTRL_RDATA_ENABLE_WIDTH){1'b0}}, phylite_rdata_en[PORT_CTRL_RDATA_ENABLE_WIDTH - 1 : 0]};
      	 	end else begin
      	 	        assign core2l_rdata_en_full[tile_i][lane_i] = '0;
      	 	end
         end
      end

      // Tie off core2l_data for unused connections
      for (pin_i = 0; pin_i < (NUM_OF_RTL_TILES * LANES_PER_TILE * PINS_PER_LANE); ++pin_i)
      begin : non_c2l_pin
         if (PINS_C2L_DRIVEN[pin_i] == 1'b0 ) begin
            assign `_unused_core2l_data(pin_i) = '0;
	    assign `_unused_oe(pin_i) = '1;
	end 
      end
      
   endgenerate
endmodule

