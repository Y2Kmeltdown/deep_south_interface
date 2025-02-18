	component IP_Tests_esRAM_AVMM_0 is
		port (
			av_address       : in  std_logic_vector(19 downto 0) := (others => 'X'); -- address
			av_write         : in  std_logic                     := 'X';             -- write
			av_writedata     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			av_read          : in  std_logic                     := 'X';             -- read
			av_readdata      : out std_logic_vector(31 downto 0);                    -- readdata
			av_waitrequest   : out std_logic;                                        -- waitrequest
			reset_n          : out std_logic;                                        -- reset_n
			esram_clk_locked : out std_logic;                                        -- esram_clk_locked
			esram_clk        : out std_logic;                                        -- clk
			refclk           : in  std_logic                     := 'X'              -- clk
		);
	end component IP_Tests_esRAM_AVMM_0;

	u0 : component IP_Tests_esRAM_AVMM_0
		port map (
			av_address       => CONNECTED_TO_av_address,       --             av.address
			av_write         => CONNECTED_TO_av_write,         --               .write
			av_writedata     => CONNECTED_TO_av_writedata,     --               .writedata
			av_read          => CONNECTED_TO_av_read,          --               .read
			av_readdata      => CONNECTED_TO_av_readdata,      --               .readdata
			av_waitrequest   => CONNECTED_TO_av_waitrequest,   --               .waitrequest
			reset_n          => CONNECTED_TO_reset_n,          --          reset.reset_n
			esram_clk_locked => CONNECTED_TO_esram_clk_locked, -- esram_locked_1.esram_clk_locked
			esram_clk        => CONNECTED_TO_esram_clk,        --      esram_clk.clk
			refclk           => CONNECTED_TO_refclk            --        ref_clk.clk
		);

