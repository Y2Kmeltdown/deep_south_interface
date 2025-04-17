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


module altera_emif_arch_nd_buf_bdir_df #(
   parameter OCT_CONTROL_WIDTH = 1,
   parameter CALIBRATED_OCT = 1
) (
   inout  tri   io,
   inout  tri   iobar,
   output logic ibuf_o,
   input  logic obuf_i,
   input  logic obuf_ibar,
   input  logic obuf_oe,
   input  logic obuf_oebar,
   input  logic obuf_dtc,
   input  logic obuf_dtcbar,
   input  logic [1:0] emif_phy_in_a,
   input  logic [1:0] emif_phy_in_b,
   input  logic [OCT_CONTROL_WIDTH-1:0] oct_stc,
   input  logic [OCT_CONTROL_WIDTH-1:0] oct_ptc
);
   timeunit 1ns;
   timeprecision 1ps;

   localparam DCCEN = "true";

   logic pdiff_out_o;
   logic pdiff_out_obar;
   logic pdiff_out_oe;
   logic pdiff_out_oebar;
   logic[1:0] emif_phy_a;
   logic[1:0] emif_phy_b;

   generate
      if (CALIBRATED_OCT)
      begin : cal_oct
         logic pdiff_out_dtc;
         logic pdiff_out_dtcbar;

         fourteennm_io_ibuf # (
            .differential_mode ("true")
         ) ibuf (
            .i(io),
            .ibar(iobar),
            .o(ibuf_o),
            .seriesterminationcontrol(oct_stc),
            .parallelterminationcontrol(oct_ptc),
            .dynamicterminationcontrol()
         );

         fourteennm_pseudo_diff_out # (
            .feedthrough ("true")
         ) pdiff_out (
            .i(obuf_i),
            .ibar(obuf_ibar),
            .oein(obuf_oe),
            .oebin(obuf_oebar),
            .dtcin(obuf_dtc),
            .dtcbarin(obuf_dtcbar),
            .o(pdiff_out_o),
            .obar(pdiff_out_obar),
            .oeout(pdiff_out_oe),
            .oebout(pdiff_out_oebar),
            .emif_phy_out(emif_phy_a),
            .emif_phy_outb(emif_phy_b),
            .emif_phy_in (emif_phy_in_a),
            .emif_phy_inb(emif_phy_in_b),
            .dtc(pdiff_out_dtc),
            .dtcbar(pdiff_out_dtcbar)
         );

         fourteennm_io_obuf # (
            .dccen(DCCEN)
         ) obuf (
            .i(pdiff_out_o),
            .o(io),
            .oe(pdiff_out_oe),
            .dynamicterminationcontrol(pdiff_out_dtc),
            .seriesterminationcontrol(oct_stc),
            .parallelterminationcontrol(oct_ptc),
            .emif_phy_in(emif_phy_a),
            .obar(),
            .devoe()
         );

         fourteennm_io_obuf # (
            .dccen(DCCEN)
         ) obuf_bar (
            .i(pdiff_out_obar),
            .o(iobar),
            .oe(pdiff_out_oebar),
            .dynamicterminationcontrol(pdiff_out_dtcbar),
            .seriesterminationcontrol(oct_stc),
            .parallelterminationcontrol(oct_ptc),
            .emif_phy_in(emif_phy_b),
            .obar(),
            .devoe()
         );
      end else
      begin : no_oct
         fourteennm_io_ibuf  # (
            .differential_mode ("true")
         ) ibuf (
            .i(io),
            .ibar(iobar),
            .o(ibuf_o),
            .seriesterminationcontrol(),
            .parallelterminationcontrol(),
            .dynamicterminationcontrol()
         );

         fourteennm_pseudo_diff_out # (
            .feedthrough ("true")
         ) pdiff_out (
            .i(obuf_i),
            .ibar(obuf_ibar),
            .oein(obuf_oe),
            .oebin(obuf_oebar),
            .dtcin(),
            .dtcbarin(),
            .o(pdiff_out_o),
            .obar(pdiff_out_obar),
            .oeout(pdiff_out_oe),
            .oebout(pdiff_out_oebar),
            .emif_phy_out(emif_phy_a),
            .emif_phy_outb(emif_phy_b),
            .emif_phy_in (emif_phy_in_a),
            .emif_phy_inb(emif_phy_in_b),
            .dtc(),
            .dtcbar()
         );

         fourteennm_io_obuf # (
            .dccen(DCCEN)
         ) obuf (
            .i(pdiff_out_o),
            .o(io),
            .oe(pdiff_out_oe),
            .dynamicterminationcontrol(),
            .seriesterminationcontrol(),
            .parallelterminationcontrol(),
            .emif_phy_in(emif_phy_a),
            .obar(),
            .devoe()
         );

         fourteennm_io_obuf # (
            .dccen(DCCEN)
         ) obuf_bar (
            .i(pdiff_out_obar),
            .o(iobar),
            .oe(pdiff_out_oebar),
            .dynamicterminationcontrol(),
            .seriesterminationcontrol(),
            .parallelterminationcontrol(),
            .emif_phy_in(emif_phy_b),
            .obar(),
            .devoe()
         );
      end
   endgenerate
endmodule

