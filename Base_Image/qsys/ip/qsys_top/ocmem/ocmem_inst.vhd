	component ocmem is
		port (
			clk        : in  std_logic                     := 'X';             -- clk
			address    : in  std_logic_vector(9 downto 0)  := (others => 'X'); -- address
			clken      : in  std_logic                     := 'X';             -- clken
			chipselect : in  std_logic                     := 'X';             -- chipselect
			write      : in  std_logic                     := 'X';             -- write
			readdata   : out std_logic_vector(31 downto 0);                    -- readdata
			writedata  : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			byteenable : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			reset      : in  std_logic                     := 'X';             -- reset
			reset_req  : in  std_logic                     := 'X'              -- reset_req
		);
	end component ocmem;

	u0 : component ocmem
		port map (
			clk        => CONNECTED_TO_clk,        --   clk1.clk
			address    => CONNECTED_TO_address,    --     s1.address
			clken      => CONNECTED_TO_clken,      --       .clken
			chipselect => CONNECTED_TO_chipselect, --       .chipselect
			write      => CONNECTED_TO_write,      --       .write
			readdata   => CONNECTED_TO_readdata,   --       .readdata
			writedata  => CONNECTED_TO_writedata,  --       .writedata
			byteenable => CONNECTED_TO_byteenable, --       .byteenable
			reset      => CONNECTED_TO_reset,      -- reset1.reset
			reset_req  => CONNECTED_TO_reset_req   --       .reset_req
		);

