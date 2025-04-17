	component l_tile_xcvr_rst_tx is
		port (
			clock                : in  std_logic                    := 'X';             -- clk
			reset                : in  std_logic                    := 'X';             -- reset
			tx_analogreset       : out std_logic_vector(3 downto 0);                    -- tx_analogreset
			tx_digitalreset      : out std_logic_vector(3 downto 0);                    -- tx_digitalreset
			tx_ready             : out std_logic_vector(3 downto 0);                    -- tx_ready
			pll_locked           : in  std_logic_vector(0 downto 0) := (others => 'X'); -- pll_locked
			pll_select           : in  std_logic_vector(0 downto 0) := (others => 'X'); -- pll_select
			tx_cal_busy          : in  std_logic_vector(3 downto 0) := (others => 'X'); -- tx_cal_busy
			tx_analogreset_stat  : in  std_logic_vector(3 downto 0) := (others => 'X'); -- tx_analogreset_stat
			tx_digitalreset_stat : in  std_logic_vector(3 downto 0) := (others => 'X')  -- tx_digitalreset_stat
		);
	end component l_tile_xcvr_rst_tx;

	u0 : component l_tile_xcvr_rst_tx
		port map (
			clock                => CONNECTED_TO_clock,                --                clock.clk
			reset                => CONNECTED_TO_reset,                --                reset.reset
			tx_analogreset       => CONNECTED_TO_tx_analogreset,       --       tx_analogreset.tx_analogreset
			tx_digitalreset      => CONNECTED_TO_tx_digitalreset,      --      tx_digitalreset.tx_digitalreset
			tx_ready             => CONNECTED_TO_tx_ready,             --             tx_ready.tx_ready
			pll_locked           => CONNECTED_TO_pll_locked,           --           pll_locked.pll_locked
			pll_select           => CONNECTED_TO_pll_select,           --           pll_select.pll_select
			tx_cal_busy          => CONNECTED_TO_tx_cal_busy,          --          tx_cal_busy.tx_cal_busy
			tx_analogreset_stat  => CONNECTED_TO_tx_analogreset_stat,  --  tx_analogreset_stat.tx_analogreset_stat
			tx_digitalreset_stat => CONNECTED_TO_tx_digitalreset_stat  -- tx_digitalreset_stat.tx_digitalreset_stat
		);

