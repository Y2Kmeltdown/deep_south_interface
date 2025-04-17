	component qsys_top_avmm_to_esram_0 is
		generic (
			c_ADDR_BITS : integer := 16;
			c_WORD_SIZE : integer := 32
		);
		port (
			av_address      : in  std_logic_vector((((c_ADDR_BITS-1)-0)+1)-1 downto 0) := (others => 'X'); -- address
			av_read         : in  std_logic                                            := 'X';             -- read
			av_waitrequest  : out std_logic;                                                               -- waitrequest
			av_write        : in  std_logic                                            := 'X';             -- write
			av_readdata     : out std_logic_vector((((c_WORD_SIZE-1)-0)+1)-1 downto 0);                    -- readdata
			av_writedata    : in  std_logic_vector((((c_WORD_SIZE-1)-0)+1)-1 downto 0) := (others => 'X'); -- writedata
			data            : out std_logic_vector((((c_WORD_SIZE-1)-0)+1)-1 downto 0);                    -- s2c0_da_0
			rdaddress       : out std_logic_vector((((c_ADDR_BITS-1)-0)+1)-1 downto 0);                    -- s2c0_adrb_0
			rden_n          : out std_logic;                                                               -- s2c0_meb_n_0
			sd_n            : out std_logic;                                                               -- s2c0_sd_n_0
			wraddress       : out std_logic_vector((((c_ADDR_BITS-1)-0)+1)-1 downto 0);                    -- s2c0_adra_0
			wren_n          : out std_logic;                                                               -- s2c0_mea_n_0
			refclk_out      : out std_logic;                                                               -- clock
			q               : in  std_logic_vector((((c_WORD_SIZE-1)-0)+1)-1 downto 0) := (others => 'X'); -- s2c0_qb_0
			esram_clk_i     : in  std_logic                                            := 'X';             -- esram2f_clk
			iopll_lock2core : in  std_logic                                            := 'X';             -- iopll_lock2core
			iopll_lock      : out std_logic;                                                               -- writeresponsevalid_n
			refclk          : in  std_logic                                            := 'X';             -- clk
			esram_clk       : out std_logic;                                                               -- clk
			esram_rst       : out std_logic                                                                -- reset
		);
	end component qsys_top_avmm_to_esram_0;

	u0 : component qsys_top_avmm_to_esram_0
		generic map (
			c_ADDR_BITS => INTEGER_VALUE_FOR_c_ADDR_BITS,
			c_WORD_SIZE => INTEGER_VALUE_FOR_c_WORD_SIZE
		)
		port map (
			av_address      => CONNECTED_TO_av_address,      --         av.address
			av_read         => CONNECTED_TO_av_read,         --           .read
			av_waitrequest  => CONNECTED_TO_av_waitrequest,  --           .waitrequest
			av_write        => CONNECTED_TO_av_write,        --           .write
			av_readdata     => CONNECTED_TO_av_readdata,     --           .readdata
			av_writedata    => CONNECTED_TO_av_writedata,    --           .writedata
			data            => CONNECTED_TO_data,            --  ram_input.s2c0_da_0
			rdaddress       => CONNECTED_TO_rdaddress,       --           .s2c0_adrb_0
			rden_n          => CONNECTED_TO_rden_n,          --           .s2c0_meb_n_0
			sd_n            => CONNECTED_TO_sd_n,            --           .s2c0_sd_n_0
			wraddress       => CONNECTED_TO_wraddress,       --           .s2c0_adra_0
			wren_n          => CONNECTED_TO_wren_n,          --           .s2c0_mea_n_0
			refclk_out      => CONNECTED_TO_refclk_out,      --           .clock
			q               => CONNECTED_TO_q,               -- ram_output.s2c0_qb_0
			esram_clk_i     => CONNECTED_TO_esram_clk_i,     --           .esram2f_clk
			iopll_lock2core => CONNECTED_TO_iopll_lock2core, --           .iopll_lock2core
			iopll_lock      => CONNECTED_TO_iopll_lock,      -- iopll_lock.writeresponsevalid_n
			refclk          => CONNECTED_TO_refclk,          --     refclk.clk
			esram_clk       => CONNECTED_TO_esram_clk,       --  esram_clk.clk
			esram_rst       => CONNECTED_TO_esram_rst        --  esram_rst.reset
		);

