	component xcvr_phy_prod is
		port (
			tx_analogreset          : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- tx_analogreset
			rx_analogreset          : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- rx_analogreset
			tx_digitalreset         : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- tx_digitalreset
			rx_digitalreset         : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- rx_digitalreset
			tx_analogreset_stat     : out std_logic_vector(3 downto 0);                      -- tx_analogreset_stat
			rx_analogreset_stat     : out std_logic_vector(3 downto 0);                      -- rx_analogreset_stat
			tx_digitalreset_stat    : out std_logic_vector(3 downto 0);                      -- tx_digitalreset_stat
			rx_digitalreset_stat    : out std_logic_vector(3 downto 0);                      -- rx_digitalreset_stat
			tx_cal_busy             : out std_logic_vector(3 downto 0);                      -- tx_cal_busy
			rx_cal_busy             : out std_logic_vector(3 downto 0);                      -- rx_cal_busy
			tx_serial_clk0          : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- clk
			rx_cdr_refclk0          : in  std_logic                      := 'X';             -- clk
			tx_serial_data          : out std_logic_vector(3 downto 0);                      -- tx_serial_data
			rx_serial_data          : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- rx_serial_data
			rx_is_lockedtoref       : out std_logic_vector(3 downto 0);                      -- rx_is_lockedtoref
			rx_is_lockedtodata      : out std_logic_vector(3 downto 0);                      -- rx_is_lockedtodata
			tx_coreclkin            : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- clk
			rx_coreclkin            : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- clk
			tx_clkout               : out std_logic_vector(3 downto 0);                      -- clk
			rx_clkout               : out std_logic_vector(3 downto 0);                      -- clk
			rx_clkout2              : out std_logic_vector(3 downto 0);                      -- clk
			tx_parallel_data        : in  std_logic_vector(255 downto 0) := (others => 'X'); -- tx_parallel_data
			tx_control              : in  std_logic_vector(7 downto 0)   := (others => 'X'); -- tx_control
			tx_enh_data_valid       : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- tx_enh_data_valid
			unused_tx_parallel_data : in  std_logic_vector(51 downto 0)  := (others => 'X'); -- unused_tx_parallel_data
			rx_parallel_data        : out std_logic_vector(255 downto 0);                    -- rx_parallel_data
			rx_control              : out std_logic_vector(7 downto 0);                      -- rx_control
			rx_enh_data_valid       : out std_logic_vector(3 downto 0);                      -- rx_enh_data_valid
			unused_rx_parallel_data : out std_logic_vector(51 downto 0);                     -- unused_rx_parallel_data
			tx_fifo_full            : out std_logic_vector(3 downto 0);                      -- tx_fifo_full
			tx_fifo_empty           : out std_logic_vector(3 downto 0);                      -- tx_fifo_empty
			rx_fifo_full            : out std_logic_vector(3 downto 0);                      -- rx_fifo_full
			rx_fifo_empty           : out std_logic_vector(3 downto 0);                      -- rx_fifo_empty
			rx_fifo_rd_en           : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- rx_fifo_rd_en
			rx_enh_blk_lock         : out std_logic_vector(3 downto 0);                      -- rx_enh_blk_lock
			reconfig_clk            : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- clk
			reconfig_reset          : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- reset
			reconfig_write          : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- write
			reconfig_read           : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- read
			reconfig_address        : in  std_logic_vector(12 downto 0)  := (others => 'X'); -- address
			reconfig_writedata      : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- writedata
			reconfig_readdata       : out std_logic_vector(31 downto 0);                     -- readdata
			reconfig_waitrequest    : out std_logic_vector(0 downto 0)                       -- waitrequest
		);
	end component xcvr_phy_prod;

	u0 : component xcvr_phy_prod
		port map (
			tx_analogreset          => CONNECTED_TO_tx_analogreset,          --          tx_analogreset.tx_analogreset
			rx_analogreset          => CONNECTED_TO_rx_analogreset,          --          rx_analogreset.rx_analogreset
			tx_digitalreset         => CONNECTED_TO_tx_digitalreset,         --         tx_digitalreset.tx_digitalreset
			rx_digitalreset         => CONNECTED_TO_rx_digitalreset,         --         rx_digitalreset.rx_digitalreset
			tx_analogreset_stat     => CONNECTED_TO_tx_analogreset_stat,     --     tx_analogreset_stat.tx_analogreset_stat
			rx_analogreset_stat     => CONNECTED_TO_rx_analogreset_stat,     --     rx_analogreset_stat.rx_analogreset_stat
			tx_digitalreset_stat    => CONNECTED_TO_tx_digitalreset_stat,    --    tx_digitalreset_stat.tx_digitalreset_stat
			rx_digitalreset_stat    => CONNECTED_TO_rx_digitalreset_stat,    --    rx_digitalreset_stat.rx_digitalreset_stat
			tx_cal_busy             => CONNECTED_TO_tx_cal_busy,             --             tx_cal_busy.tx_cal_busy
			rx_cal_busy             => CONNECTED_TO_rx_cal_busy,             --             rx_cal_busy.rx_cal_busy
			tx_serial_clk0          => CONNECTED_TO_tx_serial_clk0,          --          tx_serial_clk0.clk
			rx_cdr_refclk0          => CONNECTED_TO_rx_cdr_refclk0,          --          rx_cdr_refclk0.clk
			tx_serial_data          => CONNECTED_TO_tx_serial_data,          --          tx_serial_data.tx_serial_data
			rx_serial_data          => CONNECTED_TO_rx_serial_data,          --          rx_serial_data.rx_serial_data
			rx_is_lockedtoref       => CONNECTED_TO_rx_is_lockedtoref,       --       rx_is_lockedtoref.rx_is_lockedtoref
			rx_is_lockedtodata      => CONNECTED_TO_rx_is_lockedtodata,      --      rx_is_lockedtodata.rx_is_lockedtodata
			tx_coreclkin            => CONNECTED_TO_tx_coreclkin,            --            tx_coreclkin.clk
			rx_coreclkin            => CONNECTED_TO_rx_coreclkin,            --            rx_coreclkin.clk
			tx_clkout               => CONNECTED_TO_tx_clkout,               --               tx_clkout.clk
			rx_clkout               => CONNECTED_TO_rx_clkout,               --               rx_clkout.clk
			rx_clkout2              => CONNECTED_TO_rx_clkout2,              --              rx_clkout2.clk
			tx_parallel_data        => CONNECTED_TO_tx_parallel_data,        --        tx_parallel_data.tx_parallel_data
			tx_control              => CONNECTED_TO_tx_control,              --              tx_control.tx_control
			tx_enh_data_valid       => CONNECTED_TO_tx_enh_data_valid,       --       tx_enh_data_valid.tx_enh_data_valid
			unused_tx_parallel_data => CONNECTED_TO_unused_tx_parallel_data, -- unused_tx_parallel_data.unused_tx_parallel_data
			rx_parallel_data        => CONNECTED_TO_rx_parallel_data,        --        rx_parallel_data.rx_parallel_data
			rx_control              => CONNECTED_TO_rx_control,              --              rx_control.rx_control
			rx_enh_data_valid       => CONNECTED_TO_rx_enh_data_valid,       --       rx_enh_data_valid.rx_enh_data_valid
			unused_rx_parallel_data => CONNECTED_TO_unused_rx_parallel_data, -- unused_rx_parallel_data.unused_rx_parallel_data
			tx_fifo_full            => CONNECTED_TO_tx_fifo_full,            --            tx_fifo_full.tx_fifo_full
			tx_fifo_empty           => CONNECTED_TO_tx_fifo_empty,           --           tx_fifo_empty.tx_fifo_empty
			rx_fifo_full            => CONNECTED_TO_rx_fifo_full,            --            rx_fifo_full.rx_fifo_full
			rx_fifo_empty           => CONNECTED_TO_rx_fifo_empty,           --           rx_fifo_empty.rx_fifo_empty
			rx_fifo_rd_en           => CONNECTED_TO_rx_fifo_rd_en,           --           rx_fifo_rd_en.rx_fifo_rd_en
			rx_enh_blk_lock         => CONNECTED_TO_rx_enh_blk_lock,         --         rx_enh_blk_lock.rx_enh_blk_lock
			reconfig_clk            => CONNECTED_TO_reconfig_clk,            --            reconfig_clk.clk
			reconfig_reset          => CONNECTED_TO_reconfig_reset,          --          reconfig_reset.reset
			reconfig_write          => CONNECTED_TO_reconfig_write,          --           reconfig_avmm.write
			reconfig_read           => CONNECTED_TO_reconfig_read,           --                        .read
			reconfig_address        => CONNECTED_TO_reconfig_address,        --                        .address
			reconfig_writedata      => CONNECTED_TO_reconfig_writedata,      --                        .writedata
			reconfig_readdata       => CONNECTED_TO_reconfig_readdata,       --                        .readdata
			reconfig_waitrequest    => CONNECTED_TO_reconfig_waitrequest     --                        .waitrequest
		);

