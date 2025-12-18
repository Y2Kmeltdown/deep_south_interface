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




module  altera_pcie_s10_gen3x16_rx_st_if
 #(
    parameter DEVICE_FAMILY 	= "Stratix 10",
    parameter pld_rx_parity_ena = "enable",
    parameter enable_sriov_hwtcl = 0
  )(
    input logic              clk500,
    input logic              rst,

    input logic              clk250,
    input logic              rst_clk250,
    input logic              usr_rst_clk250,

    //avst rx interface
    input logic              rx_st_ready_i,
    input logic              rx_st_sop_i,
    input logic              rx_st_eop_i,
    input logic [255:0]      rx_st_data_i,
    input logic [ 31:0]      rx_st_parity_i,
    input logic              rx_st_valid_i,
    input logic [ 2:0]       rx_st_bar_range_i,
    input logic [ 2:0]       rx_st_empty_i,
    input logic              rx_st_vf_active_i,
    input logic [1:0]        rx_st_func_num_i,
    input logic [10:0]       rx_st_vf_num_i,



    output logic [1:0]       rx_st_valid_o,
    output logic             rx_st_ready_o,
    output logic [1:0]       rx_st_sop_o,
    output logic [1:0]       rx_st_eop_o,
    output logic [256*2-1:0] rx_st_data_o,
    output logic [32*2-1:0]  rx_st_parity_o,
    output logic [3*2-1:0]   rx_st_bar_range_o,
    output logic [3*2-1:0]   rx_st_empty_o,
    output logic [1:0]       rx_st_vf_active_o,
    output logic [3:0]       rx_st_func_num_o,
    output logic [21:0]      rx_st_vf_num_o
    );
        
  localparam logic include_sriov  = enable_sriov_hwtcl            ? 1'b1 : 1'b0;
  localparam logic include_parity = pld_rx_parity_ena == "enable" ? 1'b1 : 1'b0;
  
  typedef struct packed {
    logic         sop;
    logic         eop;
    logic [255:0] data;
    logic [31:0]  parity;
    logic         valid;
    logic [2:0]   bar_range;
    logic [2:0]   empty;
    logic         vf_active;
    logic [1:0]   func_num;
    logic [10:0]  vf_num;
  } rx_data_t;
  
  rx_data_t   hip_data;  
  rx_data_t   high_data;
  rx_data_t   low_data;
  
  rx_data_t   fifo_wr_high_data;    
  rx_data_t   fifo_wr_low_data;

  rx_data_t   fifo_rd_high_data;    
  rx_data_t   fifo_rd_low_data;  

  logic       rx_fifo_wrreq;
  logic       rx_fifo_rdreq;
  logic       rx_fifo_empty;
  logic       rx_fifo_empty2;
  logic       rx_fifo_full;
  logic [3:0] rx_fifo_rusedw;
  logic       rx_fifo_rdreq_q;

  logic       rx_st_ready;
  
  // Async FIFO write interface  
  always_ff @ (posedge clk500) begin
    
    hip_data.sop       <= rx_st_sop_i;
    hip_data.eop       <= rx_st_eop_i;    
    hip_data.data      <= rx_st_data_i;
    hip_data.parity    <= rx_st_parity_i;    
    hip_data.valid     <= rx_st_valid_i;
    hip_data.bar_range <= rx_st_bar_range_i;    
    hip_data.empty     <= rx_st_empty_i;
    hip_data.vf_active <= rx_st_vf_active_i;
    hip_data.func_num  <= rx_st_func_num_i;
    hip_data.vf_num    <= rx_st_vf_num_i;    
    
    high_data <= hip_data;

    rx_fifo_wrreq <= 1'b0;
    
    if (! low_data.valid) begin
      low_data <= high_data;
    end

    if (low_data.valid && (low_data.eop || high_data.valid)) begin
      // Only send data to the application layer when:
      // - We have something in low part
      // AND
      // - Low part is EOP or we have data in high part
      fifo_wr_high_data <= high_data;
      fifo_wr_low_data  <= low_data;
      rx_fifo_wrreq     <= 1'b1;
      low_data.valid    <= 1'b0;
    end

    // Syncronize ready @ 250 MHz to 500 MHz
    rx_st_ready   <= rx_st_ready_i;
    rx_st_ready_o <= rx_st_ready;    
    
    if (rst) begin
      rx_fifo_wrreq           <= 1'b0;
      hip_data.valid          <= 1'b0;
      low_data.valid          <= 1'b0;
      high_data.valid         <= 1'b0;
      fifo_wr_low_data.valid  <= 1'b0;
      fifo_wr_high_data.valid <= 1'b0;

      rx_st_ready   <= 1'b0;
      rx_st_ready_o <= 1'b0;
    end
  end

  altera_pcie_s10_gen3x16_dcfifo
    #(
	  .DEVICE_FAMILY								(DEVICE_FAMILY	),
      .FIFO_WIDTH ($bits(fifo_wr_high_data) + $bits(fifo_wr_low_data)),
      .ADDR_WIDTH (4),
      .SIM_EMULATE(0)
      ) rx_fifo
     (
      .din_clk           (clk500),
      .din_sclr          (rst),
      .din_wreq          (rx_fifo_wrreq),
      .din               ({fifo_wr_high_data, fifo_wr_low_data}),
      .din_wusedw        (),
      .dout_clk          (clk250),
      .dout_sclr         (rst_clk250),
      .dout_rreq         (rx_fifo_rdreq),
      .dout              ({fifo_rd_high_data, fifo_rd_low_data}),
      .dout_rusedw       (rx_fifo_rusedw),
      .fifo_empty        (rx_fifo_empty),
      .fifo_empty2       (rx_fifo_empty2),
      .fifo_almost_empty (),
      .fifo_almost_full  ()
      );

  // Async FIFO read interface
  always_ff @ (posedge clk250) begin

    rx_st_data_o      <= '0;
    rx_st_valid_o     <= '0;
    rx_st_sop_o       <= '0;
    rx_st_eop_o       <= '0;   
    rx_st_empty_o     <= '0;
    rx_st_bar_range_o <= '0;
    rx_st_vf_active_o <= '0;
    rx_st_func_num_o  <= '0;
    rx_st_vf_num_o    <= '0;  
    rx_st_parity_o    <= '0;
    
    if (rx_fifo_rdreq_q) begin
      rx_st_data_o      <= {fifo_rd_high_data.data,      fifo_rd_low_data.data};
      rx_st_valid_o     <= {fifo_rd_high_data.valid,     fifo_rd_low_data.valid};
      rx_st_sop_o       <= {fifo_rd_high_data.sop,       fifo_rd_low_data.sop};
      rx_st_eop_o       <= {fifo_rd_high_data.eop,       fifo_rd_low_data.eop};
      rx_st_empty_o     <= {fifo_rd_high_data.empty,     fifo_rd_low_data.empty};
      rx_st_bar_range_o <= {fifo_rd_high_data.bar_range, fifo_rd_low_data.bar_range};
      rx_st_func_num_o  <= {fifo_rd_high_data.func_num,  fifo_rd_low_data.func_num};

      if (include_sriov) begin
        // Drive SR-IOV signals only if SR-IOV is included. Otherwise keep the '0' and let Quartus
        // optimze RAM cells away
        rx_st_vf_active_o <= {fifo_rd_high_data.vf_active, fifo_rd_low_data.vf_active};
        rx_st_vf_num_o    <= {fifo_rd_high_data.vf_num,    fifo_rd_low_data.vf_num};
      end  
      if (include_parity) begin
        // Drive parity signals only if parity is included. Otherwise keep the '0' and let Quartus
        // optimze RAM cells away        
        rx_st_parity_o    <= {fifo_rd_high_data.parity,    fifo_rd_low_data.parity};
      end
    end

    // Read from FIFO
    rx_fifo_rdreq   <= ~(rx_fifo_empty | rx_fifo_empty2) & ~(rx_fifo_rdreq & rx_fifo_rusedw <= 2);
    rx_fifo_rdreq_q <= rx_fifo_rdreq;
    
    if (usr_rst_clk250) begin
      rx_st_valid_o   <= '0;
      rx_fifo_rdreq   <= 1'b0;  
      rx_fifo_rdreq_q <= 1'b0;   
    end

  end

endmodule 
