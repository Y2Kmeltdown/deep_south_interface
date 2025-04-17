	component l_tile_xcvr_fpll_prod is
		port (
			pll_refclk0     : in  std_logic := 'X'; -- clk
			tx_serial_clk   : out std_logic;        -- clk
			pll_locked      : out std_logic;        -- pll_locked
			pll_cal_busy    : out std_logic;        -- pll_cal_busy
			mcgb_serial_clk : out std_logic         -- clk
		);
	end component l_tile_xcvr_fpll_prod;

	u0 : component l_tile_xcvr_fpll_prod
		port map (
			pll_refclk0     => CONNECTED_TO_pll_refclk0,     --     pll_refclk0.clk
			tx_serial_clk   => CONNECTED_TO_tx_serial_clk,   --   tx_serial_clk.clk
			pll_locked      => CONNECTED_TO_pll_locked,      --      pll_locked.pll_locked
			pll_cal_busy    => CONNECTED_TO_pll_cal_busy,    --    pll_cal_busy.pll_cal_busy
			mcgb_serial_clk => CONNECTED_TO_mcgb_serial_clk  -- mcgb_serial_clk.clk
		);

