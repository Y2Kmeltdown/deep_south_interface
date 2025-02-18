module bittware_520nmx #(
	parameter NUM_RSTS = 18
)(
	output  		[1:0]		led_user_red,
	output		[1:0]		led_user_grn,
	output		[3:0]		led_qsfp,
	input						u1pps,
	input						config_clk,
	input						usr_refclk0,
	input						usr_refclk1,
//	-----------------------------------------------------------------------------
//	-- Clock test outputs
//	-----------------------------------------------------------------------------
	output		[1:0]		test,
//	-----------------------------------------------------------------------------
//	-- DDR4 SDRAM Bank 0
//	-----------------------------------------------------------------------------
	output					mem0_ck_n,
	output					mem0_ck,
	output		[16:0]	mem0_a,
	output					mem0_act_n,
	output		[1:0]		mem0_ba,
	output		[1:0]		mem0_bg,
	output					mem0_cke,
	output					mem0_cs_n,
	output					mem0_odt,
	output					mem0_reset_n,
	output					mem0_par,
	input						mem0_alert_n,
	inout			[17:0]	mem0_dqs,
	inout			[17:0]	mem0_dqs_n,
	inout			[71:0]	mem0_dq,
	input						mem0_oct_rzqin,
	input						mem0_refclk,
//	-----------------------------------------------------------------------------
//	-- DDR4 SDRAM Bank 1
//	-----------------------------------------------------------------------------
	output					mem1_ck_n,
	output					mem1_ck,
	output		[16:0]	mem1_a,
	output					mem1_act_n,
	output		[1:0]		mem1_ba,
	output		[1:0]		mem1_bg,
	output					mem1_cke,
	output					mem1_cs_n,
	output					mem1_odt,
	output					mem1_reset_n,
	output					mem1_par,
	input						mem1_alert_n,
	inout			[17:0]	mem1_dqs,
	inout			[17:0]	mem1_dqs_n,
	inout			[71:0]	mem1_dq,
	input						mem1_oct_rzqin,
	input						mem1_refclk,
//	-----------------------------------------------------------------------------
//	-- PCIe Gen3 x16
//	-----------------------------------------------------------------------------
	input						pcie_perstn,
	input						pcie_refclk,
	input			[15:0]	pcie_rx,
	output		[15:0]	pcie_tx,
//	-----------------------------------------------------------------------------
//	-- System Manager Interface
//	-----------------------------------------------------------------------------
	input			[3:0]		conf_c_in,
	output		[3:0]		conf_c_out,
	inout			[7:0]		conf_d,
	output					soft_recfg_req_n,
//	-----------------------------------------------------------------------------
//	-- BMC SPI Interface
//	-----------------------------------------------------------------------------
	input						spi_mosi,
	input						spi_nss,
	input						spi_sclk,
	inout						spi_miso,
	output					bmc_irq,
	input						fpga_gpio_1,
	input						fpga_rst_n,
//	-----------------------------------------------------------------------------
//	-- HBM2 catastrophic trip
//	-----------------------------------------------------------------------------
	output		[1:0]		uib_cattrip,
//	-----------------------------------------------------------------------------
//	-- QSFP I2C - inc arbitration
//	-- --------------------------------------------------------------------------
	inout			[3:0]		qsfp_i2c,
	input			[3:0]		qsfp_irq_n,
//	-----------------------------------------------------------------------------
//	-- ESRAM ref
//	-----------------------------------------------------------------------------
	input 					esram_0_refclk,
	input 					esram_1_refclk,
//	-----------------------------------------------------------------------------
//	-- HBM UIB reference clocks
//	-----------------------------------------------------------------------------
	input						hbm_bottom_ref_clks_pll_ref_clk,
	input						hbm_top_ref_clks_pll_ref_clk,   
//	--------------------------------------------------------
//	-- HBM boundary scan pins - (no explicit pin assignments)
//	--------------------------------------------------------
	input						hbm_bottom_m2u_cattrip,
	input			[2:0]		hbm_bottom_m2u_temp,
	input			[7:0]		hbm_bottom_m2u_wso,
	output					hbm_bottom_m2u_reset,
	output					hbm_bottom_m2u_wrst,
	output					hbm_bottom_m2u_wrck,
	output					hbm_bottom_m2u_shiftwr,
	output					hbm_bottom_m2u_capturewr,
	output					hbm_bottom_m2u_updatewr,
	output					hbm_bottom_m2u_selectwir,
	output					hbm_bottom_m2u_wsi,
	input						hbm_top_m2u_cattrip,
	input			[2:0]		hbm_top_m2u_temp,
	input			[7:0]		hbm_top_m2u_wso,
	output					hbm_top_m2u_reset,
	output					hbm_top_m2u_wrst,
	output					hbm_top_m2u_wrck,
	output					hbm_top_m2u_shiftwr,
	output					hbm_top_m2u_capturewr,
	output					hbm_top_m2u_updatewr,
	output					hbm_top_m2u_selectwir,
	output					hbm_top_m2u_wsi,
//	-----------------------------------------------------------------------------
//	-- 100G Serial Links
//	-----------------------------------------------------------------------------
	input						xcvr_refclk_0,
	input						rcvrd_refclk_0,
	output		[3:0]		tx_serial_data_0,
	input			[3:0]		rx_serial_data_0,
	input						xcvr_refclk_1,
	input						rcvrd_refclk_1,
	output		[3:0]		tx_serial_data_1,
	input			[3:0]		rx_serial_data_1,
	input						xcvr_refclk_2,
	input						rcvrd_refclk_2,
	output		[3:0]		tx_serial_data_2,
	input			[3:0]		rx_serial_data_2,
	input						xcvr_refclk_3,
	input						rcvrd_refclk_3,
	output		[3:0]		tx_serial_data_3,
	input			[3:0]		rx_serial_data_3,
//	-----------------------------------------------------------------------------
//	-- XCVR Recovered clock outputs
//	-----------------------------------------------------------------------------
	output					rx_clkout_0,
	output					rx_clkout_1,
//	-----------------------------------------------------------------------------
//	-- PCIe OCuLink GPIO
//	-----------------------------------------------------------------------------
	inout			[15:0]		oc0_gpio,
	inout			[15:0]		oc1_gpio,
	output		[15:0]		oc0_gpio_dir,
	output		[15:0]		oc1_gpio_dir,
	output		[7:2]			oc_buff_en_n,
	output		[3:2]			opci_buff_in_sel,
	input			[3:2]			oc_perst_n,
//	-----------------------------------------------------------------------------
//	-- UART
//	------------------------------------------------------------------------------
	input						uart_tx,
	output					uart_rx,
//	-----------------------------------------------------------------------------
//	-- OcuLink Serial (RHS PCIe HIP capable, limited to 12.5G)
//	-----------------------------------------------------------------------------
	input						xcvr_refclk_4,
	output		[3:0]		tx_serial_data_4,
	input			[3:0]		rx_serial_data_4,
//	-- xcvr_refclk_5,
	output		[3:0]		tx_serial_data_5,
	input			[3:0]		rx_serial_data_5,
	input					xcvr_refclk_6,
	output		[3:0]		tx_serial_data_6,
	input			[3:0]		rx_serial_data_6,
//	-- xcvr_refclk_7,
	output		[3:0]		tx_serial_data_7,
	input			[3:0]		rx_serial_data_7,
//	-----------------------------------------------------------------------------
//	-- OcuLink Serial (RHS non PCIe HIP, 100G)
//	-----------------------------------------------------------------------------
	input						xcvr_refclk_8,
	input						xcvr_refclk_9,
	input						xcvr_refclk_10,
	input						xcvr_refclk_11
);


    qsys_top u0 (
        .pcie_irq_irq_in                                                       (),                                                          //  output,   width = 1,                                      pcie_irq.irq
        .bmc_irq_irq_in                                                        (bmc_irq),                                                           //  output,   width = 1,                                       bmc_irq.irq

		  //PCIE avalon master interface 19bit address USE THIS AS THE INTERFACE FOR COMMUNICATION VIA PCIE
		  .pcie_to_avmm_clk_clk                                                  (),                                                  //   input,    width = 1,                              pcie_to_avmm_clk.clk
        .pcie_to_avmm_rst_reset                                                (),                                                //   input,    width = 1,                              pcie_to_avmm_rst.reset
        .pcie_to_avmm_bus_waitrequest                                          (),                                          //   input,    width = 1,                              pcie_to_avmm_bus.waitrequest
        .pcie_to_avmm_bus_readdata                                             (),                                             //   input,  width = 32,                                              .readdata
        .pcie_to_avmm_bus_readdatavalid                                        (),                                        //   input,    width = 1,                                              .readdatavalid
        .pcie_to_avmm_bus_burstcount                                           (),                                           //  output,    width = 1,                                              .burstcount
        .pcie_to_avmm_bus_writedata                                            (),                                            //  output,  width = 32,                                              .writedata
        .pcie_to_avmm_bus_address                                              (),                                              //  output,   width = 19,                                              .address
        .pcie_to_avmm_bus_write                                                (),                                                //  output,    width = 1,                                              .write
        .pcie_to_avmm_bus_read                                                 (),                                                 //  output,    width = 1,                                              .read
        .pcie_to_avmm_bus_byteenable                                           (),                                           //  output,   width = 64,                                              .byteenable
        .pcie_to_avmm_bus_debugaccess														 (),

        .pcie_user_clk_clk                                                     (pcie_user_clk),                                                     //  output,   width = 1,                                 pcie_user_clk.clk

        .config_clk_clk                                                        (config_clk),                                                        //   input,   width = 1,                                    config_clk.clk
        .config_rstn_reset_n                                                   (config_rstn[1]),                                                   //   input,   width = 1,                                   config_rstn.reset_n

		  // SPI/JTAG/PCIE accessible master interface
        .avmm_master_waitrequest                                               (),                                               //   input,   width = 1,                                   avmm_master.waitrequest
        .avmm_master_readdata                                                  (),                                                  //   input,  width = 32,                                              .readdata
        .avmm_master_readdatavalid                                             (),                                             //   input,   width = 1,                                              .readdatavalid
        .avmm_master_burstcount                                                (),                                                //  output,   width = 1,                                              .burstcount
        .avmm_master_writedata                                                 (),                                                 //  output,  width = 32,                                              .writedata
        .avmm_master_address                                                   (),                                                   //  output,  width = 12,                                              .address
        .avmm_master_write                                                     (),                                                     //  output,   width = 1,                                              .write
        .avmm_master_read                                                      (),                                                      //  output,   width = 1,                                              .read
        .avmm_master_byteenable                                                (),                                                //  output,   width = 4,                                              .byteenable
        .avmm_master_debugaccess                                               (),                                               //  output,   width = 1,                                              .debugaccess

        .pcie_refclk_clk                                                       (pcie_refclk),                                                       //   input,   width = 1,                                   pcie_refclk.clk
        .pcie_npor_npor                                                        (pcie_perstn),                                                        //   input,   width = 1,                                     pcie_npor.npor
        .pcie_npor_pin_perst                                                   (pcie_perstn),                                                   //   input,   width = 1,                                              .pin_perst
        .pcie_hip_ctrl_simu_mode_pipe                                          (1'b0),                                          //   input,   width = 1,                                 pcie_hip_ctrl.simu_mode_pipe
        .pcie_hip_ctrl_test_in                                                 (pcie_test_in),                                                 //   input,  width = 67,                                              .test_in
        .pcie_serial_rx_in0                                                    (pcie_rx[0]),                                                    //   input,   width = 1,                                   pcie_serial.rx_in0
        .pcie_serial_rx_in1                                                    (pcie_rx[1]),                                                    //   input,   width = 1,                                              .rx_in1
        .pcie_serial_rx_in2                                                    (pcie_rx[2]),                                                    //   input,   width = 1,                                              .rx_in2
        .pcie_serial_rx_in3                                                    (pcie_rx[3]),                                                    //   input,   width = 1,                                              .rx_in3
        .pcie_serial_rx_in4                                                    (pcie_rx[4]),                                                    //   input,   width = 1,                                              .rx_in4
        .pcie_serial_rx_in5                                                    (pcie_rx[5]),                                                    //   input,   width = 1,                                              .rx_in5
        .pcie_serial_rx_in6                                                    (pcie_rx[6]),                                                    //   input,   width = 1,                                              .rx_in6
        .pcie_serial_rx_in7                                                    (pcie_rx[7]),                                                    //   input,   width = 1,                                              .rx_in7
        .pcie_serial_rx_in8                                                    (pcie_rx[8]),                                                    //   input,   width = 1,                                              .rx_in8
        .pcie_serial_rx_in9                                                    (pcie_rx[9]),                                                    //   input,   width = 1,                                              .rx_in9
        .pcie_serial_rx_in10                                                   (pcie_rx[10]),                                                   //   input,   width = 1,                                              .rx_in10
        .pcie_serial_rx_in11                                                   (pcie_rx[11]),                                                   //   input,   width = 1,                                              .rx_in11
        .pcie_serial_rx_in12                                                   (pcie_rx[12]),                                                   //   input,   width = 1,                                              .rx_in12
        .pcie_serial_rx_in13                                                   (pcie_rx[13]),                                                   //   input,   width = 1,                                              .rx_in13
        .pcie_serial_rx_in14                                                   (pcie_rx[14]),                                                   //   input,   width = 1,                                              .rx_in14
        .pcie_serial_rx_in15                                                   (pcie_rx[15]),                                                   //   input,   width = 1,                                              .rx_in15
        .pcie_serial_tx_out0                                                   (pcie_tx[0]),                                                   //  output,   width = 1,                                              .tx_out0
        .pcie_serial_tx_out1                                                   (pcie_tx[1]),                                                   //  output,   width = 1,                                              .tx_out1
        .pcie_serial_tx_out2                                                   (pcie_tx[2]),                                                   //  output,   width = 1,                                              .tx_out2
        .pcie_serial_tx_out3                                                   (pcie_tx[3]),                                                   //  output,   width = 1,                                              .tx_out3
        .pcie_serial_tx_out4                                                   (pcie_tx[4]),                                                   //  output,   width = 1,                                              .tx_out4
        .pcie_serial_tx_out5                                                   (pcie_tx[5]),                                                   //  output,   width = 1,                                              .tx_out5
        .pcie_serial_tx_out6                                                   (pcie_tx[6]),                                                   //  output,   width = 1,                                              .tx_out6
        .pcie_serial_tx_out7                                                   (pcie_tx[7]),                                                   //  output,   width = 1,                                              .tx_out7
        .pcie_serial_tx_out8                                                   (pcie_tx[8]),                                                   //  output,   width = 1,                                              .tx_out8
        .pcie_serial_tx_out9                                                   (pcie_tx[9]),                                                   //  output,   width = 1,                                              .tx_out9
        .pcie_serial_tx_out10                                                  (pcie_tx[10]),                                                  //  output,   width = 1,                                              .tx_out10
        .pcie_serial_tx_out11                                                  (pcie_tx[11]),                                                  //  output,   width = 1,                                              .tx_out11
        .pcie_serial_tx_out12                                                  (pcie_tx[12]),                                                  //  output,   width = 1,                                              .tx_out12
        .pcie_serial_tx_out13                                                  (pcie_tx[13]),                                                  //  output,   width = 1,                                              .tx_out13
        .pcie_serial_tx_out14                                                  (pcie_tx[14]),                                                  //  output,   width = 1,                                              .tx_out14
        .pcie_serial_tx_out15                                                  (pcie_tx[15]),                                                  //  output,   width = 1,                                              .tx_out15
        .pcie_user_rst_reset                                                   (pcie_user_rst),                                                   //  output,   width = 1,                                 pcie_user_rst.reset
		  
        .spi_mosi_to_the_spislave_inst_for_spichain                            (spi_mosi),                            //   input,   width = 1,                                           spi.mosi_to_the_spislave_inst_for_spichain
        .spi_nss_to_the_spislave_inst_for_spichain                             (spi_nss),                             //   input,   width = 1,                                              .nss_to_the_spislave_inst_for_spichain
        .spi_sclk_to_the_spislave_inst_for_spichain                            (spi_sclk),                            //   input,   width = 1,                                              .sclk_to_the_spislave_inst_for_spichain
        .spi_miso_to_and_from_the_spislave_inst_for_spichain                   (spi_miso),                   //   inout,   width = 1,                                              .miso_to_and_from_the_spislave_inst_for_spichain

        .conf_d_conf_d                                                         (conf_d),                                                         //   inout,   width = 8,                                        conf_d.conf_d
        .soft_recfg_req_n_soft_reconfigure_req_n                               (soft_recfg_req_n),                               //  output,   width = 1,                              soft_recfg_req_n.soft_reconfigure_req_n
        .conf_c_out_conf_c_out                                                 (conf_c_out),                                                 //  output,   width = 4,                                    conf_c_out.conf_c_out
        .conf_c_in_conf_c_in                                                   (conf_c_in)                                                    //   input,   width = 4,                                     conf_c_in.conf_c_in
    );

//	------------------
//	-- Heartbeat
//	------------------

wire [4:0]	hrt_beat;

heartbeat_50m u1 (
	.clk(config_clk),
	.hrt_beat(hrt_beat)
);

  // User LEDs
	assign led_user_red[0] = hrt_beat[1];
	assign led_user_grn[0] = hrt_beat[1];
	assign led_user_red[1] = hrt_beat[2];
	assign led_user_grn[1] = hrt_beat[2];

	
//	------------------
//	-- Power On Reset
//	------------------
	 
reg 	[NUM_RSTS-1:0] config_rstn;
wire	[NUM_RSTS-1:0]	config_rstn_init;

pwr_on_rst_init_dist #(
	.NUMBER_OF_CYCLES(32'h0007A120),
	.FAN_OUT(NUM_RSTS)
) u2 (
	.clk(config_clk),
	.init_done_n(config_rstn_i),
	.por_n(config_rstn_init)
);

reset_release u3 (
	.ninit_done(init_done_n)
);

reset_filter u4 (
	.enable(1'b1),
	.rstn_raw(init_done_n),
	.clk(config_clk),
	.rstn_filtered(config_rstn_i)
);

bretime_async_rst #(
	.DEPTH(3)
) u5 (
	.clock(config_clk),
	.d(fpga_rst_n),
	.q(fpga_rst_n_sync)
);

bretime_async_rst #(
	.DEPTH(3)
) u6 (
	.clock(config_clk),
	.d(pcie_user_rst),
	.q(pcie_user_rst_sync)
);

integer i;
always @(posedge config_clk) begin
	for (i = 0; i <= NUM_RSTS-1; i = i + 1) begin
        config_rstn[i] <= config_rstn_init[i] && fpga_rst_n_sync && !pcie_user_rst_sync;
	end
end
/*
	------------------
	-- Power On Reset
	------------------
  u12 : entity work.pwr_on_rst_init_dist
    generic map (
      NUMBER_OF_CYCLES => x"0007A120",  -- 10ms
      FAN_OUT          => NUM_RSTS
      )
    port map (
      clk              => config_clk,   -- in  std_logic
      init_done_n      => config_rstn_i,  -- in  std_logic
      por_n            => config_rstn_init   -- out std_logic_vector(NUM_RSTS-1 downto 0)
      );

  u14 : s10_reset_release
    port map (
      ninit_done       => init_done_n   -- out std_logic
      );

  u15 : entity work.reset_filter
  port map (
    enable                      => '1',
    rstn_raw                    => init_done_n,
    clk                         => config_clk,
    rstn_filtered               => config_rstn_i
  );
  
  u16 : entity work.bretime_async_rst
    generic map (
      DEPTH     => 3
      )
    port map (
      clock     => config_clk,
      d         => fpga_rst_n,
      q         => fpga_rst_n_sync
    );

  u17 : entity work.bretime_async_rst
    generic map (
      DEPTH     => 3
      )
    port map (
      clock     => config_clk,
      d         => pcie_user_rst,
      q         => pcie_user_rst_sync
    );
  
  process (config_clk)
  begin
    if rising_edge(config_clk) then
      for i in 0 to NUM_RSTS-1 loop
        config_rstn(i) <= config_rstn_init(i) and fpga_rst_n_sync and (not (pcie_user_rst_sync));
      end loop;
    end if;
  end process;
*/



/*
  ------------------------
  -- DDR4 SDRAM Interface
  ------------------------
  u50 : entity work.ddr4_sdram_if
    port map (
      -- Clocks & Reset
      config_clk      => config_clk,    -- in    std_logic
      config_rstn     => config_rstn(7 downto 6),  -- in    std_logic_vector(3 downto 0)
      mem_usrclk      => mem_usrclk,    -- out   std_logic_vector(3 downto 0)
      mem_usr_stat    => mem_usr_stat,  -- out   std_logic_vector(3 downto 0)
      -- DDR4 SDRAM Bank 0
      mem0_ck         => mem0_ck,       -- out   std_logic
      mem0_ck_n       => mem0_ck_n,     -- out   std_logic
      mem0_a          => mem0_a,        -- out   std_logic_vector(16 downto 0)
      mem0_act_n      => mem0_act_n,    -- out   std_logic
      mem0_ba         => mem0_ba,       -- out   std_logic_vector(1 downto 0)
      mem0_bg         => mem0_bg,       -- out   std_logic_vector(1 downto 0)
      mem0_cke        => mem0_cke,      -- out   std_logic_vector(0 downto 0)
      mem0_cs_n       => mem0_cs_n,     -- out   std_logic_vector(0 downto 0)
      mem0_odt        => mem0_odt,      -- out   std_logic_vector(0 downto 0)
      mem0_reset_n    => mem0_reset_n,  -- out   std_logic
      mem0_par        => mem0_par,      -- out   std_logic
      mem0_alert_n    => mem0_alert_n,  -- in    std_logic
      mem0_dqs        => mem0_dqs,      -- inout std_logic_vector(17 downto 0)
      mem0_dqs_n      => mem0_dqs_n,    -- inout std_logic_vector(17 downto 0)
      mem0_dq         => mem0_dq,       -- inout std_logic_vector(71 downto 0)
      mem0_oct_rzqin  => mem0_oct_rzqin,-- in    std_logic
      mem0_refclk     => mem0_refclk,   -- in    std_logic
      -- DDR4 SDRAM Bank 1
      mem1_ck         => mem1_ck,       -- out   std_logic
      mem1_ck_n       => mem1_ck_n,     -- out   std_logic
      mem1_a          => mem1_a,        -- out   std_logic_vector(16 downto 0)
      mem1_act_n      => mem1_act_n,    -- out   std_logic
      mem1_ba         => mem1_ba,       -- out   std_logic_vector(1 downto 0)
      mem1_bg         => mem1_bg,       -- out   std_logic_vector(1 downto 0)
      mem1_cke        => mem1_cke,      -- out   std_logic_vector(0 downto 0)
      mem1_cs_n       => mem1_cs_n,     -- out   std_logic_vector(0 downto 0)
      mem1_odt        => mem1_odt,      -- out   std_logic_vector(0 downto 0)
      mem1_reset_n    => mem1_reset_n,  -- out   std_logic
      mem1_par        => mem1_par,      -- out   std_logic
      mem1_alert_n    => mem1_alert_n,  -- in    std_logic
      mem1_dqs        => mem1_dqs,      -- inout std_logic_vector(17 downto 0)
      mem1_dqs_n      => mem1_dqs_n,    -- inout std_logic_vector(17 downto 0)
      mem1_dq         => mem1_dq,       -- inout std_logic_vector(71 downto 0)
      mem1_oct_rzqin  => mem1_oct_rzqin,-- in    std_logic
      mem1_refclk     => mem1_refclk,   -- in    std_logic
      -- Host Interface
      avmm_writedata  => avmm_writedata,  -- in    std_logic_vector(31 downto 0)
      avmm_address    => avmm_address,  -- in    std_logic_vector(11 downto 0)
      avmm_write      => avmm_write,    -- in    std_logic
      avmm_read       => avmm_read,     -- in    std_logic
      avmm_byteenable => avmm_byteenable,  -- in    std_logic_vector(3 downto 0)
      dout_mem0       => dout_mem0,     -- out   T_mem_status
      dout_mem1       => dout_mem1,     -- out   T_mem_status
      dout_mem_stat0  => user_regs.reg_mem0_pp_stat,  -- out   std_logic_vector(31 downto 0)
      dout_mem_ctrl0  => user_regs.reg_mem0_pp_ctrl,  -- out   std_logic_vector(31 downto 0)
      dout_depth0     => user_regs.reg_mem0_pp_depth,  -- out   std_logic_vector(31 downto 0)
      dout_send_buf0  => user_regs.reg_mem0_pp_send_buf,  -- out   std_logic_vector(31 downto 0)
      dout_read_buf0  => user_regs.reg_mem0_pp_read_buf,  -- out   std_logic_vector(31 downto 0)
      dout_mem_stat1  => user_regs.reg_mem1_pp_stat,  -- out   std_logic_vector(31 downto 0)
      dout_mem_ctrl1  => user_regs.reg_mem1_pp_ctrl,  -- out   std_logic_vector(31 downto 0)
      dout_depth1     => user_regs.reg_mem1_pp_depth,  -- out   std_logic_vector(31 downto 0)
      dout_send_buf1  => user_regs.reg_mem1_pp_send_buf,  -- out   std_logic_vector(31 downto 0)
      dout_read_buf1  => user_regs.reg_mem1_pp_read_buf  -- out   std_logic_vector(31 downto 0)
      );
*/



/*
  -------------------------
  -- Transceiver Interface
  -------------------------
  u60 : entity work.xcvr_bist_100g
    generic map (
      ADDRESS_OFFSET     => XCVR0_STAT
      )
    port map (
      tx_refclk          => xcvr_refclk_0,  -- in  std_logic
      rx_refclk          => xcvr_refclk_0,  -- in  std_logic
      tx_user_clk        => xcvr_user_clk(0),  -- out std_logic
      tx_user_clk_locked => xcvr_user_clk_lock(0),  -- out std_logic
      tx_serial_data     => tx_serial_data_0,  -- out std_logic_vector(3 downto 0)
      rx_serial_data     => rx_serial_data_0,  -- in  std_logic_vector(3 downto 0)
      -- Host Interface
      config_clk         => config_clk,  -- in  std_logic
      config_rstn        => config_rstn(10),  -- in  std_logic
      avmm_writedata     => avmm_writedata,  -- in  std_logic_vector(31 downto 0)
      avmm_address       => avmm_address,  -- in  std_logic_vector(11 downto 0)
      avmm_write         => avmm_write,  -- in  std_logic
      avmm_byteenable    => avmm_byteenable,  -- in  std_logic_vector(3 downto 0)
      dout_0             => user_regs.reg_xcvr0_stat,  -- out std_logic_vector(31 downto 0)
      dout_1             => user_regs.reg_xcvr0_ctrl,  -- out std_logic_vector(31 downto 0)
      dout_2             => user_regs.reg_xcvr0_phy0_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_3             => user_regs.reg_xcvr0_phy1_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_4             => user_regs.reg_xcvr0_phy2_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_5             => user_regs.reg_xcvr0_phy3_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_6             => user_regs.reg_xcvr0_statistics, -- out std_logic_vector(31 downto 0)
      -- PHY Dynamic Reconfig Port
      dr_phy_write            => dr_phy_0.write,            -- in  std_logic
      dr_phy_read             => dr_phy_0.read,             -- in  std_logic
      dr_phy_address          => dr_phy_0.address,          -- in  std_logic_vector(12 downto 0)
      dr_phy_writedata        => dr_phy_0.writedata,        -- in  std_logic_vector(31 downto 0)
      dr_phy_readdata         => dr_phy_0.readdata,         -- out std_logic_vector(31 downto 0)
      dr_phy_readdatavalid    => dr_phy_0.readdatavalid,    -- out std_logic
      dr_phy_waitrequest      => dr_phy_0.waitrequest       -- out std_logic
      );

  u61 : entity work.xcvr_bist_100g
    generic map (
      ADDRESS_OFFSET     => XCVR1_STAT
      )
    port map (
      tx_refclk          => xcvr_refclk_1,  -- in  std_logic
      rx_refclk          => xcvr_refclk_1,  -- in  std_logic
      tx_user_clk        => xcvr_user_clk(1),  -- out std_logic
      tx_user_clk_locked => xcvr_user_clk_lock(1),  -- out std_logic
      tx_serial_data     => tx_serial_data_1,  -- out std_logic_vector(3 downto 0)
      rx_serial_data     => rx_serial_data_1,  -- in  std_logic_vector(3 downto 0)
      -- Host Interface
      config_clk         => config_clk,  -- in  std_logic
      config_rstn        => config_rstn(11),  -- in  std_logic
      avmm_writedata     => avmm_writedata,  -- in  std_logic_vector(31 downto 0)
      avmm_address       => avmm_address,  -- in  std_logic_vector(11 downto 0)
      avmm_write         => avmm_write,  -- in  std_logic
      avmm_byteenable    => avmm_byteenable,  -- in  std_logic_vector(3 downto 0)
      dout_0             => user_regs.reg_xcvr1_stat,  -- out std_logic_vector(31 downto 0)
      dout_1             => user_regs.reg_xcvr1_ctrl,  -- out std_logic_vector(31 downto 0)
      dout_2             => user_regs.reg_xcvr1_phy0_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_3             => user_regs.reg_xcvr1_phy1_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_4             => user_regs.reg_xcvr1_phy2_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_5             => user_regs.reg_xcvr1_phy3_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_6             => user_regs.reg_xcvr1_statistics, -- out std_logic_vector(31 downto 0)
      -- PHY Dynamic Reconfig Port
      dr_phy_write            => dr_phy_1.write,            -- in  std_logic
      dr_phy_read             => dr_phy_1.read,             -- in  std_logic
      dr_phy_address          => dr_phy_1.address,          -- in  std_logic_vector(12 downto 0)
      dr_phy_writedata        => dr_phy_1.writedata,        -- in  std_logic_vector(31 downto 0)
      dr_phy_readdata         => dr_phy_1.readdata,         -- out std_logic_vector(31 downto 0)
      dr_phy_readdatavalid    => dr_phy_1.readdatavalid,    -- out std_logic
      dr_phy_waitrequest      => dr_phy_1.waitrequest       -- out std_logic
      );

  u62 : entity work.xcvr_bist_100g
    generic map (
      ADDRESS_OFFSET     => XCVR2_STAT
      )
    port map (
      tx_refclk          => xcvr_refclk_2,  -- in  std_logic
      rx_refclk          => xcvr_refclk_2,  -- in  std_logic
      tx_user_clk        => xcvr_user_clk(2),  -- out std_logic
      tx_user_clk_locked => xcvr_user_clk_lock(2),  -- out std_logic
      tx_serial_data     => tx_serial_data_2,  -- out std_logic_vector(3 downto 0)
      rx_serial_data     => rx_serial_data_2,  -- in  std_logic_vector(3 downto 0)
      -- Host Interface
      config_clk         => config_clk,  -- in  std_logic
      config_rstn        => config_rstn(12),  -- in  std_logic
      avmm_writedata     => avmm_writedata,  -- in  std_logic_vector(31 downto 0)
      avmm_address       => avmm_address,  -- in  std_logic_vector(11 downto 0)
      avmm_write         => avmm_write,  -- in  std_logic
      avmm_byteenable    => avmm_byteenable,  -- in  std_logic_vector(3 downto 0)
      dout_0             => user_regs.reg_xcvr2_stat,  -- out std_logic_vector(31 downto 0)
      dout_1             => user_regs.reg_xcvr2_ctrl,  -- out std_logic_vector(31 downto 0)
      dout_2             => user_regs.reg_xcvr2_phy0_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_3             => user_regs.reg_xcvr2_phy1_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_4             => user_regs.reg_xcvr2_phy2_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_5             => user_regs.reg_xcvr2_phy3_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_6             => user_regs.reg_xcvr2_statistics, -- out std_logic_vector(31 downto 0)
      -- PHY Dynamic Reconfig Port
      dr_phy_write            => dr_phy_2.write,            -- in  std_logic
      dr_phy_read             => dr_phy_2.read,             -- in  std_logic
      dr_phy_address          => dr_phy_2.address,          -- in  std_logic_vector(12 downto 0)
      dr_phy_writedata        => dr_phy_2.writedata,        -- in  std_logic_vector(31 downto 0)
      dr_phy_readdata         => dr_phy_2.readdata,         -- out std_logic_vector(31 downto 0)
      dr_phy_readdatavalid    => dr_phy_2.readdatavalid,    -- out std_logic
      dr_phy_waitrequest      => dr_phy_2.waitrequest       -- out std_logic
      );

  u63 : entity work.xcvr_bist_100g
    generic map (
      ADDRESS_OFFSET     => XCVR3_STAT
      )
    port map (
      tx_refclk          => xcvr_refclk_3,  -- in  std_logic
      rx_refclk          => xcvr_refclk_3,  -- in  std_logic
      tx_user_clk        => xcvr_user_clk(3),  -- out std_logic
      tx_user_clk_locked => xcvr_user_clk_lock(3),  -- out std_logic
      tx_serial_data     => tx_serial_data_3,  -- out std_logic_vector(3 downto 0)
      rx_serial_data     => rx_serial_data_3,  -- in  std_logic_vector(3 downto 0)
      -- Host Interface
      config_clk         => config_clk,  -- in  std_logic
      config_rstn        => config_rstn(13),  -- in  std_logic
      avmm_writedata     => avmm_writedata,  -- in  std_logic_vector(31 downto 0)
      avmm_address       => avmm_address,  -- in  std_logic_vector(11 downto 0)
      avmm_write         => avmm_write,  -- in  std_logic
      avmm_byteenable    => avmm_byteenable,  -- in  std_logic_vector(3 downto 0)
      dout_0             => user_regs.reg_xcvr3_stat,  -- out std_logic_vector(31 downto 0)
      dout_1             => user_regs.reg_xcvr3_ctrl,  -- out std_logic_vector(31 downto 0)
      dout_2             => user_regs.reg_xcvr3_phy0_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_3             => user_regs.reg_xcvr3_phy1_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_4             => user_regs.reg_xcvr3_phy2_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_5             => user_regs.reg_xcvr3_phy3_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_6             => user_regs.reg_xcvr3_statistics, -- out std_logic_vector(31 downto 0)
      -- PHY Dynamic Reconfig Port
      dr_phy_write            => dr_phy_3.write,            -- in  std_logic
      dr_phy_read             => dr_phy_3.read,             -- in  std_logic
      dr_phy_address          => dr_phy_3.address,          -- in  std_logic_vector(12 downto 0)
      dr_phy_writedata        => dr_phy_3.writedata,        -- in  std_logic_vector(31 downto 0)
      dr_phy_readdata         => dr_phy_3.readdata,         -- out std_logic_vector(31 downto 0)
      dr_phy_readdatavalid    => dr_phy_3.readdatavalid,    -- out std_logic
      dr_phy_waitrequest      => dr_phy_3.waitrequest       -- out std_logic
      );
*/



/*
  -------------------------------------------------------------------------------
  --  OcuLink Transceiver Interface (PCIe capable)
  -------------------------------------------------------------------------------

  -- Common clocking for next 8 PHYs
  -- Master Clock Generation Block is enabled and used on the FPLL so that
  -- clocking can span out of sixpack tile and up to 24 lanes.

  u800 : l_tile_xcvr_fpll_prod
    port map (
      mcgb_serial_clk => xcvr_tx_serial_clk(0),  -- out std_logic
      pll_cal_busy    => xcvr_pll_cal_busy(0),   -- out std_logic
      pll_locked      => xcvr_pll_locked(0),     -- out std_logic
      pll_refclk0     => xcvr_refclk_4,          -- in  std_logic
      tx_serial_clk   => open
      );
*/



/*
  -------------------------
  -- Transceiver Interface
  -------------------------
  u80 : entity work.xcvr_bist
    generic map (
      ADDRESS_OFFSET     => XCVR4_STAT
      )
    port map (
      pll_cal_busy       => xcvr_pll_cal_busy(0),  -- in 
      pll_locked         => xcvr_pll_locked(0),  -- in 
      tx_serial_clk      => xcvr_tx_serial_clk(0),  --- in 
      rx_refclk          => xcvr_refclk_4,  -- in  std_logic
      tx_user_clk        => xcvr_user_clk(4),  -- out std_logic
      tx_user_clk_locked => xcvr_user_clk_lock(4),  -- out std_logic
      tx_serial_data     => tx_serial_data_4,  -- out std_logic_vector(3 downto 0)
      rx_serial_data     => rx_serial_data_4,  -- in  std_logic_vector(3 downto 0)
      -- Host Interface
      config_clk         => config_clk,  -- in  std_logic
      config_rstn        => config_rstn(14),  -- in  std_logic
      avmm_writedata     => avmm_writedata,  -- in  std_logic_vector(31 downto 0)
      avmm_address       => avmm_address,  -- in  std_logic_vector(11 downto 0)
      avmm_write         => avmm_write,  -- in  std_logic
      avmm_byteenable    => avmm_byteenable,  -- in  std_logic_vector(3 downto 0)
      dout_0             => user_regs.reg_xcvr4_stat,  -- out std_logic_vector(31 downto 0)
      dout_1             => user_regs.reg_xcvr4_ctrl,  -- out std_logic_vector(31 downto 0)
      dout_2             => user_regs.reg_xcvr4_phy0_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_3             => user_regs.reg_xcvr4_phy1_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_4             => user_regs.reg_xcvr4_phy2_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_5             => user_regs.reg_xcvr4_phy3_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_6             => user_regs.reg_xcvr4_statistics  -- out std_logic_vector(31 downto 0)
      );

  u81 : entity work.xcvr_bist
    generic map (
      ADDRESS_OFFSET     => XCVR5_STAT
      )
    port map (
      pll_cal_busy       => xcvr_pll_cal_busy(0),  -- in 
      pll_locked         => xcvr_pll_locked(0),  -- in 
      tx_serial_clk      => xcvr_tx_serial_clk(0),  --- in 
      rx_refclk          => xcvr_refclk_4,  -- in  std_logic
      tx_user_clk        => xcvr_user_clk(5),  -- out std_logic
      tx_user_clk_locked => xcvr_user_clk_lock(5),  -- out std_logic
      tx_serial_data     => tx_serial_data_5,  -- out std_logic_vector(3 downto 0)
      rx_serial_data     => rx_serial_data_5,  -- in  std_logic_vector(3 downto 0)
      -- Host Interface
      config_clk         => config_clk,  -- in  std_logic
      config_rstn        => config_rstn(15),  -- in  std_logic
      avmm_writedata     => avmm_writedata,  -- in  std_logic_vector(31 downto 0)
      avmm_address       => avmm_address,  -- in  std_logic_vector(11 downto 0)
      avmm_write         => avmm_write,  -- in  std_logic
      avmm_byteenable    => avmm_byteenable,  -- in  std_logic_vector(3 downto 0)
      dout_0             => user_regs.reg_xcvr5_stat,  -- out std_logic_vector(31 downto 0)
      dout_1             => user_regs.reg_xcvr5_ctrl,  -- out std_logic_vector(31 downto 0)
      dout_2             => user_regs.reg_xcvr5_phy0_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_3             => user_regs.reg_xcvr5_phy1_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_4             => user_regs.reg_xcvr5_phy2_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_5             => user_regs.reg_xcvr5_phy3_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_6             => user_regs.reg_xcvr5_statistics  -- out std_logic_vector(31 downto 0)
      );

  -- Common clocking for next 8 PHYs
  -- Master Clock Generation Block is enabled and used on the FPLL so that
  -- clocking can span out of sixpack tile and up to 24 lanes.

  u820 : l_tile_xcvr_fpll_prod
    port map (
      mcgb_serial_clk => xcvr_tx_serial_clk(1),  -- out std_logic
      pll_cal_busy    => xcvr_pll_cal_busy(1),   -- out std_logic
      pll_locked      => xcvr_pll_locked(1),     -- out std_logic
      pll_refclk0     => xcvr_refclk_6,          -- in  std_logic
      tx_serial_clk   => open
      );



  u82 : entity work.xcvr_bist
    generic map (
      ADDRESS_OFFSET     => XCVR6_STAT
      )
    port map (
      pll_cal_busy       => xcvr_pll_cal_busy(1),  -- in 
      pll_locked         => xcvr_pll_locked(1),  -- in 
      tx_serial_clk      => xcvr_tx_serial_clk(1),  --- in 
      rx_refclk          => xcvr_refclk_6,  -- in  std_logic
      tx_user_clk        => xcvr_user_clk(6),  -- out std_logic
      tx_user_clk_locked => xcvr_user_clk_lock(6),  -- out std_logic
      tx_serial_data     => tx_serial_data_6,  -- out std_logic_vector(3 downto 0)
      rx_serial_data     => rx_serial_data_6,  -- in  std_logic_vector(3 downto 0)
      -- Host Interface
      config_clk         => config_clk,  -- in  std_logic
      config_rstn        => config_rstn(16),  -- in  std_logic
      avmm_writedata     => avmm_writedata,  -- in  std_logic_vector(31 downto 0)
      avmm_address       => avmm_address,  -- in  std_logic_vector(11 downto 0)
      avmm_write         => avmm_write,  -- in  std_logic
      avmm_byteenable    => avmm_byteenable,  -- in  std_logic_vector(3 downto 0)
      dout_0             => user_regs.reg_xcvr6_stat,  -- out std_logic_vector(31 downto 0)
      dout_1             => user_regs.reg_xcvr6_ctrl,  -- out std_logic_vector(31 downto 0)
      dout_2             => user_regs.reg_xcvr6_phy0_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_3             => user_regs.reg_xcvr6_phy1_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_4             => user_regs.reg_xcvr6_phy2_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_5             => user_regs.reg_xcvr6_phy3_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_6             => user_regs.reg_xcvr6_statistics  -- out std_logic_vector(31 downto 0)
      );


  u83 : entity work.xcvr_bist
    generic map (
      ADDRESS_OFFSET     => XCVR7_STAT
      )
    port map (
      pll_cal_busy       => xcvr_pll_cal_busy(1),  -- in 
      pll_locked         => xcvr_pll_locked(1),  -- in 
      tx_serial_clk      => xcvr_tx_serial_clk(1),  --- in 
      rx_refclk          => xcvr_refclk_6,  -- in  std_logic
      tx_user_clk        => xcvr_user_clk(7),  -- out std_logic
      tx_user_clk_locked => xcvr_user_clk_lock(7),  -- out std_logic
      tx_serial_data     => tx_serial_data_7,  -- out std_logic_vector(3 downto 0)
      rx_serial_data     => rx_serial_data_7,  -- in  std_logic_vector(3 downto 0)
      -- Host Interface
      config_clk         => config_clk,  -- in  std_logic
      config_rstn        => config_rstn(17),  -- in  std_logic
      avmm_writedata     => avmm_writedata,  -- in  std_logic_vector(31 downto 0)
      avmm_address       => avmm_address,  -- in  std_logic_vector(11 downto 0)
      avmm_write         => avmm_write,  -- in  std_logic
      avmm_byteenable    => avmm_byteenable,  -- in  std_logic_vector(3 downto 0)
      dout_0             => user_regs.reg_xcvr7_stat,  -- out std_logic_vector(31 downto 0)
      dout_1             => user_regs.reg_xcvr7_ctrl,  -- out std_logic_vector(31 downto 0)
      dout_2             => user_regs.reg_xcvr7_phy0_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_3             => user_regs.reg_xcvr7_phy1_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_4             => user_regs.reg_xcvr7_phy2_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_5             => user_regs.reg_xcvr7_phy3_err_counts,  -- out std_logic_vector(31 downto 0)
      dout_6             => user_regs.reg_xcvr7_statistics  -- out std_logic_vector(31 downto 0)
      );
*/
endmodule