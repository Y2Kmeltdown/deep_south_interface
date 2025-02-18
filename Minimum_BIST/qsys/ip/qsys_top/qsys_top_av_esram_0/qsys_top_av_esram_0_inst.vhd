	component qsys_top_av_esram_0 is
		port (
			refclk         : in  std_logic                     := 'X';             -- clk
			esram_clk      : out std_logic;                                        -- clk
			esram_rst      : out std_logic;                                        -- reset
			iopll_lock     : out std_logic;                                        -- iopll_lock
			av_address     : in  std_logic_vector(10 downto 0) := (others => 'X'); -- address
			av_read        : in  std_logic                     := 'X';             -- read
			av_waitrequest : out std_logic;                                        -- waitrequest
			av_write       : in  std_logic                     := 'X';             -- write
			av_readdata    : out std_logic_vector(31 downto 0);                    -- readdata
			av_writedata   : in  std_logic_vector(31 downto 0) := (others => 'X')  -- writedata
		);
	end component qsys_top_av_esram_0;

	u0 : component qsys_top_av_esram_0
		port map (
			refclk         => CONNECTED_TO_refclk,         --     refclk.clk
			esram_clk      => CONNECTED_TO_esram_clk,      --  esram_clk.clk
			esram_rst      => CONNECTED_TO_esram_rst,      --  esram_rst.reset
			iopll_lock     => CONNECTED_TO_iopll_lock,     -- iopll_lock.iopll_lock
			av_address     => CONNECTED_TO_av_address,     --     reg_if.address
			av_read        => CONNECTED_TO_av_read,        --           .read
			av_waitrequest => CONNECTED_TO_av_waitrequest, --           .waitrequest
			av_write       => CONNECTED_TO_av_write,       --           .write
			av_readdata    => CONNECTED_TO_av_readdata,    --           .readdata
			av_writedata   => CONNECTED_TO_av_writedata    --           .writedata
		);

