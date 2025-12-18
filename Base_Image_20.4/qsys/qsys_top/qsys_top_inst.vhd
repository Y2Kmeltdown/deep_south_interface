	component qsys_top is
		port (
			pcie_irq_irq                                        : out   std_logic;                                        -- irq
			bmc_irq_irq                                         : out   std_logic;                                        -- irq
			esram_0_iopll_lock_iopll_lock                       : out   std_logic;                                        -- iopll_lock
			esram_0_refclk_clk                                  : in    std_logic                     := 'X';             -- clk
			pcie_user_clk_clk                                   : out   std_logic;                                        -- clk
			config_clk_clk                                      : in    std_logic                     := 'X';             -- clk
			config_rstn_reset_n                                 : in    std_logic                     := 'X';             -- reset_n
			avmm_master_waitrequest                             : in    std_logic                     := 'X';             -- waitrequest
			avmm_master_readdata                                : in    std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			avmm_master_readdatavalid                           : in    std_logic                     := 'X';             -- readdatavalid
			avmm_master_burstcount                              : out   std_logic_vector(0 downto 0);                     -- burstcount
			avmm_master_writedata                               : out   std_logic_vector(31 downto 0);                    -- writedata
			avmm_master_address                                 : out   std_logic_vector(11 downto 0);                    -- address
			avmm_master_write                                   : out   std_logic;                                        -- write
			avmm_master_read                                    : out   std_logic;                                        -- read
			avmm_master_byteenable                              : out   std_logic_vector(3 downto 0);                     -- byteenable
			avmm_master_debugaccess                             : out   std_logic;                                        -- debugaccess
			pcie_refclk_clk                                     : in    std_logic                     := 'X';             -- clk
			pcie_npor_npor                                      : in    std_logic                     := 'X';             -- npor
			pcie_npor_pin_perst                                 : in    std_logic                     := 'X';             -- pin_perst
			pcie_hip_ctrl_simu_mode_pipe                        : in    std_logic                     := 'X';             -- simu_mode_pipe
			pcie_hip_ctrl_test_in                               : in    std_logic_vector(66 downto 0) := (others => 'X'); -- test_in
			pcie_serial_rx_in0                                  : in    std_logic                     := 'X';             -- rx_in0
			pcie_serial_rx_in1                                  : in    std_logic                     := 'X';             -- rx_in1
			pcie_serial_rx_in2                                  : in    std_logic                     := 'X';             -- rx_in2
			pcie_serial_rx_in3                                  : in    std_logic                     := 'X';             -- rx_in3
			pcie_serial_rx_in4                                  : in    std_logic                     := 'X';             -- rx_in4
			pcie_serial_rx_in5                                  : in    std_logic                     := 'X';             -- rx_in5
			pcie_serial_rx_in6                                  : in    std_logic                     := 'X';             -- rx_in6
			pcie_serial_rx_in7                                  : in    std_logic                     := 'X';             -- rx_in7
			pcie_serial_rx_in8                                  : in    std_logic                     := 'X';             -- rx_in8
			pcie_serial_rx_in9                                  : in    std_logic                     := 'X';             -- rx_in9
			pcie_serial_rx_in10                                 : in    std_logic                     := 'X';             -- rx_in10
			pcie_serial_rx_in11                                 : in    std_logic                     := 'X';             -- rx_in11
			pcie_serial_rx_in12                                 : in    std_logic                     := 'X';             -- rx_in12
			pcie_serial_rx_in13                                 : in    std_logic                     := 'X';             -- rx_in13
			pcie_serial_rx_in14                                 : in    std_logic                     := 'X';             -- rx_in14
			pcie_serial_rx_in15                                 : in    std_logic                     := 'X';             -- rx_in15
			pcie_serial_tx_out0                                 : out   std_logic;                                        -- tx_out0
			pcie_serial_tx_out1                                 : out   std_logic;                                        -- tx_out1
			pcie_serial_tx_out2                                 : out   std_logic;                                        -- tx_out2
			pcie_serial_tx_out3                                 : out   std_logic;                                        -- tx_out3
			pcie_serial_tx_out4                                 : out   std_logic;                                        -- tx_out4
			pcie_serial_tx_out5                                 : out   std_logic;                                        -- tx_out5
			pcie_serial_tx_out6                                 : out   std_logic;                                        -- tx_out6
			pcie_serial_tx_out7                                 : out   std_logic;                                        -- tx_out7
			pcie_serial_tx_out8                                 : out   std_logic;                                        -- tx_out8
			pcie_serial_tx_out9                                 : out   std_logic;                                        -- tx_out9
			pcie_serial_tx_out10                                : out   std_logic;                                        -- tx_out10
			pcie_serial_tx_out11                                : out   std_logic;                                        -- tx_out11
			pcie_serial_tx_out12                                : out   std_logic;                                        -- tx_out12
			pcie_serial_tx_out13                                : out   std_logic;                                        -- tx_out13
			pcie_serial_tx_out14                                : out   std_logic;                                        -- tx_out14
			pcie_serial_tx_out15                                : out   std_logic;                                        -- tx_out15
			spi_mosi_to_the_spislave_inst_for_spichain          : in    std_logic                     := 'X';             -- mosi_to_the_spislave_inst_for_spichain
			spi_nss_to_the_spislave_inst_for_spichain           : in    std_logic                     := 'X';             -- nss_to_the_spislave_inst_for_spichain
			spi_sclk_to_the_spislave_inst_for_spichain          : in    std_logic                     := 'X';             -- sclk_to_the_spislave_inst_for_spichain
			spi_miso_to_and_from_the_spislave_inst_for_spichain : inout std_logic                     := 'X';             -- miso_to_and_from_the_spislave_inst_for_spichain
			pcie_user_rst_reset                                 : out   std_logic;                                        -- reset
			conf_d_conf_d                                       : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- conf_d
			soft_recfg_req_n_soft_reconfigure_req_n             : out   std_logic;                                        -- soft_reconfigure_req_n
			conf_c_out_conf_c_out                               : out   std_logic_vector(3 downto 0);                     -- conf_c_out
			conf_c_in_conf_c_in                                 : in    std_logic_vector(3 downto 0)  := (others => 'X')  -- conf_c_in
		);
	end component qsys_top;

	u0 : component qsys_top
		port map (
			pcie_irq_irq                                        => CONNECTED_TO_pcie_irq_irq,                                        --           pcie_irq.irq
			bmc_irq_irq                                         => CONNECTED_TO_bmc_irq_irq,                                         --            bmc_irq.irq
			esram_0_iopll_lock_iopll_lock                       => CONNECTED_TO_esram_0_iopll_lock_iopll_lock,                       -- esram_0_iopll_lock.iopll_lock
			esram_0_refclk_clk                                  => CONNECTED_TO_esram_0_refclk_clk,                                  --     esram_0_refclk.clk
			pcie_user_clk_clk                                   => CONNECTED_TO_pcie_user_clk_clk,                                   --      pcie_user_clk.clk
			config_clk_clk                                      => CONNECTED_TO_config_clk_clk,                                      --         config_clk.clk
			config_rstn_reset_n                                 => CONNECTED_TO_config_rstn_reset_n,                                 --        config_rstn.reset_n
			avmm_master_waitrequest                             => CONNECTED_TO_avmm_master_waitrequest,                             --        avmm_master.waitrequest
			avmm_master_readdata                                => CONNECTED_TO_avmm_master_readdata,                                --                   .readdata
			avmm_master_readdatavalid                           => CONNECTED_TO_avmm_master_readdatavalid,                           --                   .readdatavalid
			avmm_master_burstcount                              => CONNECTED_TO_avmm_master_burstcount,                              --                   .burstcount
			avmm_master_writedata                               => CONNECTED_TO_avmm_master_writedata,                               --                   .writedata
			avmm_master_address                                 => CONNECTED_TO_avmm_master_address,                                 --                   .address
			avmm_master_write                                   => CONNECTED_TO_avmm_master_write,                                   --                   .write
			avmm_master_read                                    => CONNECTED_TO_avmm_master_read,                                    --                   .read
			avmm_master_byteenable                              => CONNECTED_TO_avmm_master_byteenable,                              --                   .byteenable
			avmm_master_debugaccess                             => CONNECTED_TO_avmm_master_debugaccess,                             --                   .debugaccess
			pcie_refclk_clk                                     => CONNECTED_TO_pcie_refclk_clk,                                     --        pcie_refclk.clk
			pcie_npor_npor                                      => CONNECTED_TO_pcie_npor_npor,                                      --          pcie_npor.npor
			pcie_npor_pin_perst                                 => CONNECTED_TO_pcie_npor_pin_perst,                                 --                   .pin_perst
			pcie_hip_ctrl_simu_mode_pipe                        => CONNECTED_TO_pcie_hip_ctrl_simu_mode_pipe,                        --      pcie_hip_ctrl.simu_mode_pipe
			pcie_hip_ctrl_test_in                               => CONNECTED_TO_pcie_hip_ctrl_test_in,                               --                   .test_in
			pcie_serial_rx_in0                                  => CONNECTED_TO_pcie_serial_rx_in0,                                  --        pcie_serial.rx_in0
			pcie_serial_rx_in1                                  => CONNECTED_TO_pcie_serial_rx_in1,                                  --                   .rx_in1
			pcie_serial_rx_in2                                  => CONNECTED_TO_pcie_serial_rx_in2,                                  --                   .rx_in2
			pcie_serial_rx_in3                                  => CONNECTED_TO_pcie_serial_rx_in3,                                  --                   .rx_in3
			pcie_serial_rx_in4                                  => CONNECTED_TO_pcie_serial_rx_in4,                                  --                   .rx_in4
			pcie_serial_rx_in5                                  => CONNECTED_TO_pcie_serial_rx_in5,                                  --                   .rx_in5
			pcie_serial_rx_in6                                  => CONNECTED_TO_pcie_serial_rx_in6,                                  --                   .rx_in6
			pcie_serial_rx_in7                                  => CONNECTED_TO_pcie_serial_rx_in7,                                  --                   .rx_in7
			pcie_serial_rx_in8                                  => CONNECTED_TO_pcie_serial_rx_in8,                                  --                   .rx_in8
			pcie_serial_rx_in9                                  => CONNECTED_TO_pcie_serial_rx_in9,                                  --                   .rx_in9
			pcie_serial_rx_in10                                 => CONNECTED_TO_pcie_serial_rx_in10,                                 --                   .rx_in10
			pcie_serial_rx_in11                                 => CONNECTED_TO_pcie_serial_rx_in11,                                 --                   .rx_in11
			pcie_serial_rx_in12                                 => CONNECTED_TO_pcie_serial_rx_in12,                                 --                   .rx_in12
			pcie_serial_rx_in13                                 => CONNECTED_TO_pcie_serial_rx_in13,                                 --                   .rx_in13
			pcie_serial_rx_in14                                 => CONNECTED_TO_pcie_serial_rx_in14,                                 --                   .rx_in14
			pcie_serial_rx_in15                                 => CONNECTED_TO_pcie_serial_rx_in15,                                 --                   .rx_in15
			pcie_serial_tx_out0                                 => CONNECTED_TO_pcie_serial_tx_out0,                                 --                   .tx_out0
			pcie_serial_tx_out1                                 => CONNECTED_TO_pcie_serial_tx_out1,                                 --                   .tx_out1
			pcie_serial_tx_out2                                 => CONNECTED_TO_pcie_serial_tx_out2,                                 --                   .tx_out2
			pcie_serial_tx_out3                                 => CONNECTED_TO_pcie_serial_tx_out3,                                 --                   .tx_out3
			pcie_serial_tx_out4                                 => CONNECTED_TO_pcie_serial_tx_out4,                                 --                   .tx_out4
			pcie_serial_tx_out5                                 => CONNECTED_TO_pcie_serial_tx_out5,                                 --                   .tx_out5
			pcie_serial_tx_out6                                 => CONNECTED_TO_pcie_serial_tx_out6,                                 --                   .tx_out6
			pcie_serial_tx_out7                                 => CONNECTED_TO_pcie_serial_tx_out7,                                 --                   .tx_out7
			pcie_serial_tx_out8                                 => CONNECTED_TO_pcie_serial_tx_out8,                                 --                   .tx_out8
			pcie_serial_tx_out9                                 => CONNECTED_TO_pcie_serial_tx_out9,                                 --                   .tx_out9
			pcie_serial_tx_out10                                => CONNECTED_TO_pcie_serial_tx_out10,                                --                   .tx_out10
			pcie_serial_tx_out11                                => CONNECTED_TO_pcie_serial_tx_out11,                                --                   .tx_out11
			pcie_serial_tx_out12                                => CONNECTED_TO_pcie_serial_tx_out12,                                --                   .tx_out12
			pcie_serial_tx_out13                                => CONNECTED_TO_pcie_serial_tx_out13,                                --                   .tx_out13
			pcie_serial_tx_out14                                => CONNECTED_TO_pcie_serial_tx_out14,                                --                   .tx_out14
			pcie_serial_tx_out15                                => CONNECTED_TO_pcie_serial_tx_out15,                                --                   .tx_out15
			spi_mosi_to_the_spislave_inst_for_spichain          => CONNECTED_TO_spi_mosi_to_the_spislave_inst_for_spichain,          --                spi.mosi_to_the_spislave_inst_for_spichain
			spi_nss_to_the_spislave_inst_for_spichain           => CONNECTED_TO_spi_nss_to_the_spislave_inst_for_spichain,           --                   .nss_to_the_spislave_inst_for_spichain
			spi_sclk_to_the_spislave_inst_for_spichain          => CONNECTED_TO_spi_sclk_to_the_spislave_inst_for_spichain,          --                   .sclk_to_the_spislave_inst_for_spichain
			spi_miso_to_and_from_the_spislave_inst_for_spichain => CONNECTED_TO_spi_miso_to_and_from_the_spislave_inst_for_spichain, --                   .miso_to_and_from_the_spislave_inst_for_spichain
			pcie_user_rst_reset                                 => CONNECTED_TO_pcie_user_rst_reset,                                 --      pcie_user_rst.reset
			conf_d_conf_d                                       => CONNECTED_TO_conf_d_conf_d,                                       --             conf_d.conf_d
			soft_recfg_req_n_soft_reconfigure_req_n             => CONNECTED_TO_soft_recfg_req_n_soft_reconfigure_req_n,             --   soft_recfg_req_n.soft_reconfigure_req_n
			conf_c_out_conf_c_out                               => CONNECTED_TO_conf_c_out_conf_c_out,                               --         conf_c_out.conf_c_out
			conf_c_in_conf_c_in                                 => CONNECTED_TO_conf_c_in_conf_c_in                                  --          conf_c_in.conf_c_in
		);

