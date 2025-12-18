// Converted from VHDL to Verilog
// Includes merged components from pkg_user_registers.vhd

module bist_top_me1 (
  input  wire        config_clk,
  input  wire        usr_refclk0,
  input  wire        usr_refclk1,
  // PCIe Gen3 x16
  input  wire        pcie_perstn,
  input  wire        pcie_refclk,
  input  wire [15:0] pcie_rx,
  output wire [15:0] pcie_tx,
  // System Manager Interface
  input  wire [3:0]  conf_c_in,
  output wire [3:0]  conf_c_out,
  inout  wire [7:0]  conf_d,
  output wire        soft_recfg_req_n,
  // BMC SPI Interface
  input  wire        spi_mosi,
  input  wire        spi_nss,
  input  wire        spi_sclk,
  inout  wire        spi_miso,
  output wire        bmc_irq,
  input  wire        fpga_gpio_1,
  input  wire        fpga_rst_n,
  // HBM2 catastrophic trip
  output wire [1:0]  uib_cattrip,
  // ESRAM ref
  input  wire        esram_0_refclk,
  input  wire        esram_1_refclk,
  // HBM UIB reference clocks
  input  wire        hbm_bottom_ref_clks_pll_ref_clk,
  input  wire        hbm_top_ref_clks_pll_ref_clk,
  // HBM boundary scan pins - (no explicit pin assignments)
  input  wire        hbm_bottom_m2u_cattrip,
  input  wire [2:0]  hbm_bottom_m2u_temp,
  input  wire [7:0]  hbm_bottom_m2u_wso,
  output wire        hbm_bottom_m2u_reset,
  output wire        hbm_bottom_m2u_wrst,
  output wire        hbm_bottom_m2u_wrck,
  output wire        hbm_bottom_m2u_shiftwr,
  output wire        hbm_bottom_m2u_capturewr,
  output wire        hbm_bottom_m2u_updatewr,
  output wire        hbm_bottom_m2u_selectwir,
  output wire        hbm_bottom_m2u_wsi,
  input  wire        hbm_top_m2u_cattrip,
  input  wire [2:0]  hbm_top_m2u_temp,
  input  wire [7:0]  hbm_top_m2u_wso,
  output wire        hbm_top_m2u_reset,
  output wire        hbm_top_m2u_wrst,
  output wire        hbm_top_m2u_wrck,
  output wire        hbm_top_m2u_shiftwr,
  output wire        hbm_top_m2u_capturewr,
  output wire        hbm_top_m2u_updatewr,
  output wire        hbm_top_m2u_selectwir,
  output wire        hbm_top_m2u_wsi
);

// Constants
localparam NUM_RSTS = 22;

// User registers
wire [31:0] reg_chip_id_l;
wire [31:0] reg_chip_id_h;
wire [31:0] reg_temp_stcl;
wire [31:0] reg_temp_chan_0, reg_temp_chan_1, reg_temp_chan_2, reg_temp_chan_3;
wire [31:0] reg_temp_chan_4, reg_temp_chan_5, reg_temp_chan_6, reg_temp_chan_7;
wire [31:0] reg_temp_chan_8;
wire [31:0] reg_volt_stcl;
wire [31:0] reg_volt_chan_2, reg_volt_chan_3, reg_volt_chan_4;
wire [31:0] reg_volt_chan_6, reg_volt_chan_9;

// Internal signals
reg  [NUM_RSTS-1:0] config_rstn;
wire [NUM_RSTS-1:0] config_rstn_init;
wire config_rstn_i;
wire init_done_n;
wire fpga_rst_n_sync;
wire pcie_user_rst_sync;
wire [66:0] pcie_test_in;
wire pcie_user_clk;
wire pcie_user_rst;
wire avmm_waitrequest;
wire [31:0] avmm_readdata;
wire avmm_readdatavalid;
wire [0:0] avmm_burstcount;
wire [31:0] avmm_writedata;
wire [11:0] avmm_address;
wire avmm_write;
wire avmm_read;
wire [3:0] avmm_byteenable;
wire avmm_debugaccess;
wire slave_wait;
wire esram_0_iopll_lock;

// Power On Reset
pwr_on_rst_init_dist #(
  .NUMBER_OF_CYCLES(32'h0007A120),  // 10ms
  .FAN_OUT(NUM_RSTS)
) u12 (
  .clk(config_clk),
  .init_done_n(config_rstn_i),
  .por_n(config_rstn_init)
);

s10_reset_release u14 (
  .ninit_done(init_done_n)
);

reset_filter u15 (
  .enable(1'b1),
  .rstn_raw(init_done_n),
  .clk(config_clk),
  .rstn_filtered(config_rstn_i)
);

bretime_async_rst #(.DEPTH(3)) u16 (
  .clock(config_clk),
  .d(fpga_rst_n),
  .q(fpga_rst_n_sync)
);

bretime_async_rst #(.DEPTH(3)) u17 (
  .clock(config_clk),
  .d(pcie_user_rst),
  .q(pcie_user_rst_sync)
);

// Reset generation process
integer i;
always @(posedge config_clk) begin
  for (i = 0; i < NUM_RSTS; i = i + 1) begin
    config_rstn[i] <= config_rstn_init[i] & fpga_rst_n_sync & (~pcie_user_rst_sync);
  end
end

// PCIe & JTAG
qsys_top u30 (
  // BMC IRQ
  .bmc_irq_irq(bmc_irq),
  // PCIe irq
  .pcie_irq_irq(),  // open
  // Avalon MM Master
  .avmm_master_waitrequest(avmm_waitrequest),
  .avmm_master_readdata(avmm_readdata),
  .avmm_master_readdatavalid(avmm_readdatavalid),
  .avmm_master_burstcount(avmm_burstcount),
  .avmm_master_writedata(avmm_writedata),
  .avmm_master_address(avmm_address),
  .avmm_master_write(avmm_write),
  .avmm_master_read(avmm_read),
  .avmm_master_byteenable(avmm_byteenable),
  .avmm_master_debugaccess(avmm_debugaccess),
  // Clocks and Resets
  .config_clk_clk(config_clk),
  .config_rstn_reset_n(config_rstn[1]),
  // System Manager Interface
  .conf_c_in_conf_c_in(conf_c_in),
  .conf_c_out_conf_c_out(conf_c_out),
  .conf_d_conf_d(conf_d),
  .soft_recfg_req_n_soft_reconfigure_req_n(soft_recfg_req_n),
  // BMC SPI Slave
  .spi_mosi_to_the_spislave_inst_for_spichain(spi_mosi),
  .spi_nss_to_the_spislave_inst_for_spichain(spi_nss),
  .spi_sclk_to_the_spislave_inst_for_spichain(spi_sclk),
  .spi_miso_to_and_from_the_spislave_inst_for_spichain(spi_miso),
  // PCIe Gen3 x16
  .pcie_hip_ctrl_simu_mode_pipe(1'b0),
  .pcie_hip_ctrl_test_in(pcie_test_in),
  .pcie_npor_npor(pcie_perstn),
  .pcie_npor_pin_perst(pcie_perstn),
  .pcie_refclk_clk(pcie_refclk),
  .pcie_serial_rx_in0(pcie_rx[0]),
  .pcie_serial_rx_in1(pcie_rx[1]),
  .pcie_serial_rx_in2(pcie_rx[2]),
  .pcie_serial_rx_in3(pcie_rx[3]),
  .pcie_serial_rx_in4(pcie_rx[4]),
  .pcie_serial_rx_in5(pcie_rx[5]),
  .pcie_serial_rx_in6(pcie_rx[6]),
  .pcie_serial_rx_in7(pcie_rx[7]),
  .pcie_serial_rx_in8(pcie_rx[8]),
  .pcie_serial_rx_in9(pcie_rx[9]),
  .pcie_serial_rx_in10(pcie_rx[10]),
  .pcie_serial_rx_in11(pcie_rx[11]),
  .pcie_serial_rx_in12(pcie_rx[12]),
  .pcie_serial_rx_in13(pcie_rx[13]),
  .pcie_serial_rx_in14(pcie_rx[14]),
  .pcie_serial_rx_in15(pcie_rx[15]),
  .pcie_serial_tx_out0(pcie_tx[0]),
  .pcie_serial_tx_out1(pcie_tx[1]),
  .pcie_serial_tx_out2(pcie_tx[2]),
  .pcie_serial_tx_out3(pcie_tx[3]),
  .pcie_serial_tx_out4(pcie_tx[4]),
  .pcie_serial_tx_out5(pcie_tx[5]),
  .pcie_serial_tx_out6(pcie_tx[6]),
  .pcie_serial_tx_out7(pcie_tx[7]),
  .pcie_serial_tx_out8(pcie_tx[8]),
  .pcie_serial_tx_out9(pcie_tx[9]),
  .pcie_serial_tx_out10(pcie_tx[10]),
  .pcie_serial_tx_out11(pcie_tx[11]),
  .pcie_serial_tx_out12(pcie_tx[12]),
  .pcie_serial_tx_out13(pcie_tx[13]),
  .pcie_serial_tx_out14(pcie_tx[14]),
  .pcie_serial_tx_out15(pcie_tx[15]),
  .pcie_user_clk_clk(pcie_user_clk),
  .pcie_user_rst_reset(pcie_user_rst),
  // Processor to PCIE Bridge Via ESRAM
  .esram_0_refclk_clk(esram_0_refclk),
  .esram_0_iopll_lock_iopll_lock(esram_0_iopll_lock)
//  .proc_to_esram_bridge_clk_clk(),								 //   input,   width = 1,   proc_to_esram_bridge_clk.clk
//  .proc_to_esram_bridge_reset_reset(),							 //   input,   width = 1, proc_to_esram_bridge_reset.reset
//  .proc_to_esram_bridge_avmm_waitrequest(),               //  output,   width = 1,  proc_to_esram_bridge_avmm.waitrequest
//  .proc_to_esram_bridge_avmm_readdata(),                  //  output,  width = 32,                           .readdata
//  .proc_to_esram_bridge_avmm_readdatavalid(),             //  output,   width = 1,                           .readdatavalid
//  .proc_to_esram_bridge_avmm_burstcount(),                //   input,   width = 1,                           .burstcount
//  .proc_to_esram_bridge_avmm_writedata(),                 //   input,  width = 32,                           .writedata
//  .proc_to_esram_bridge_avmm_address(),                   //   input,  width = 16,                           .address
//  .proc_to_esram_bridge_avmm_write(),                     //   input,   width = 1,                           .write
//  .proc_to_esram_bridge_avmm_read(),                      //   input,   width = 1,                           .read
//  .proc_to_esram_bridge_avmm_byteenable(),					 //   input,   width = 4,                           .byteenable
//  .proc_to_esram_bridge_avmm_debugaccess()                //   input,   width = 1,                           .debugaccess
);

assign pcie_test_in = 67'h0;

// User Registers
user_registers_wrapper u31 (
  // Clocks & Reset
  .config_clk(config_clk),
  .config_rstn(config_rstn[2]),
  // Host Interface
  .avmm_waitrequest(avmm_waitrequest),
  .avmm_readdata(avmm_readdata),
  .avmm_readdatavalid(avmm_readdatavalid),
  .avmm_burstcount(avmm_burstcount),
  .avmm_writedata(avmm_writedata),
  .avmm_address(avmm_address),
  .avmm_write(avmm_write),
  .avmm_read(avmm_read),
  .avmm_byteenable(avmm_byteenable),
  // Registers
  .slave_wait(slave_wait),
  .fpga_gpio_1(fpga_gpio_1),
  .fpga_rst_n(fpga_rst_n),
  // User register outputs
  .reg_chip_id_l(reg_chip_id_l),
  .reg_chip_id_h(reg_chip_id_h),
  .reg_temp_stcl(reg_temp_stcl),
  .reg_temp_chan_0(reg_temp_chan_0),
  .reg_temp_chan_1(reg_temp_chan_1),
  .reg_temp_chan_2(reg_temp_chan_2),
  .reg_temp_chan_3(reg_temp_chan_3),
  .reg_temp_chan_4(reg_temp_chan_4),
  .reg_temp_chan_5(reg_temp_chan_5),
  .reg_temp_chan_6(reg_temp_chan_6),
  .reg_temp_chan_7(reg_temp_chan_7),
  .reg_temp_chan_8(reg_temp_chan_8),
  .reg_volt_stcl(reg_volt_stcl),
  .reg_volt_chan_2(reg_volt_chan_2),
  .reg_volt_chan_3(reg_volt_chan_3),
  .reg_volt_chan_4(reg_volt_chan_4),
  .reg_volt_chan_6(reg_volt_chan_6),
  .reg_volt_chan_9(reg_volt_chan_9)
);

assign slave_wait = 1'b0;

s10_chip_id_wrap u32 (
  .config_clk(config_clk),
  .config_rstn(config_rstn[3]),
  .chip_id_l(reg_chip_id_l),
  .chip_id_h(reg_chip_id_h)
);

// Temperature & Voltage
s10_auto_adc u41 (
  // Clocks & Reset
  .config_clk(config_clk),
  .config_rstn(config_rstn[5]),
  // Host Interface
  .avmm_writedata(avmm_writedata),
  .avmm_address(avmm_address),
  .avmm_write(avmm_write),
  .avmm_read(avmm_read),
  .avmm_byteenable(avmm_byteenable),
  .slave_wait(slave_wait),
  // Registers
  .temp_stcl(reg_temp_stcl),
  .temp_chan_0(reg_temp_chan_0),
  .temp_chan_1(reg_temp_chan_1),
  .temp_chan_2(reg_temp_chan_2),
  .temp_chan_3(reg_temp_chan_3),
  .temp_chan_4(reg_temp_chan_4),
  .temp_chan_5(reg_temp_chan_5),
  .temp_chan_6(reg_temp_chan_6),
  .temp_chan_7(reg_temp_chan_7),
  .temp_chan_8(reg_temp_chan_8),
  .volt_stcl(reg_volt_stcl),
  .volt_chan_2(reg_volt_chan_2),
  .volt_chan_3(reg_volt_chan_3),
  .volt_chan_4(reg_volt_chan_4),
  .volt_chan_6(reg_volt_chan_6),
  .volt_chan_9(reg_volt_chan_9)
);



endmodule