	component qsys_top_esram_0 is
		port (
			c0_q_0          : out std_logic_vector(31 downto 0);                    -- s2c0_qb_0
			esram2f_clk     : out std_logic;                                        -- esram2f_clk
			iopll_lock2core : out std_logic;                                        -- iopll_lock2core
			c0_data_0       : in  std_logic_vector(31 downto 0) := (others => 'X'); -- s2c0_da_0
			c0_rdaddress_0  : in  std_logic_vector(15 downto 0) := (others => 'X'); -- s2c0_adrb_0
			c0_rden_n_0     : in  std_logic                     := 'X';             -- s2c0_meb_n_0
			c0_sd_n_0       : in  std_logic                     := 'X';             -- s2c0_sd_n_0
			c0_wraddress_0  : in  std_logic_vector(15 downto 0) := (others => 'X'); -- s2c0_adra_0
			c0_wren_n_0     : in  std_logic                     := 'X';             -- s2c0_mea_n_0
			refclk          : in  std_logic                     := 'X'              -- clock
		);
	end component qsys_top_esram_0;

	u0 : component qsys_top_esram_0
		port map (
			c0_q_0          => CONNECTED_TO_c0_q_0,          -- ram_output.s2c0_qb_0
			esram2f_clk     => CONNECTED_TO_esram2f_clk,     --           .esram2f_clk
			iopll_lock2core => CONNECTED_TO_iopll_lock2core, --           .iopll_lock2core
			c0_data_0       => CONNECTED_TO_c0_data_0,       --  ram_input.s2c0_da_0
			c0_rdaddress_0  => CONNECTED_TO_c0_rdaddress_0,  --           .s2c0_adrb_0
			c0_rden_n_0     => CONNECTED_TO_c0_rden_n_0,     --           .s2c0_meb_n_0
			c0_sd_n_0       => CONNECTED_TO_c0_sd_n_0,       --           .s2c0_sd_n_0
			c0_wraddress_0  => CONNECTED_TO_c0_wraddress_0,  --           .s2c0_adra_0
			c0_wren_n_0     => CONNECTED_TO_c0_wren_n_0,     --           .s2c0_mea_n_0
			refclk          => CONNECTED_TO_refclk           --           .clock
		);

