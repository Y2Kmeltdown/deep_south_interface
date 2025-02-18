	component system_manager_if is
		port (
			clk                    : in    std_logic                     := 'X';             -- clk
			rst                    : in    std_logic                     := 'X';             -- reset
			pll_clk                : in    std_logic                     := 'X';             -- clk
			conf_d                 : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- conf_d
			soft_reconfigure_req_n : out   std_logic;                                        -- soft_reconfigure_req_n
			d_address              : out   std_logic_vector(8 downto 0);                     -- address
			d_read                 : out   std_logic;                                        -- read
			d_write                : out   std_logic;                                        -- write
			d_readdata             : in    std_logic_vector(15 downto 0) := (others => 'X'); -- readdata
			d_writedata            : out   std_logic_vector(15 downto 0);                    -- writedata
			d_waitrequest          : in    std_logic                     := 'X';             -- waitrequest
			c_address              : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- address
			c_read                 : in    std_logic                     := 'X';             -- read
			c_write                : in    std_logic                     := 'X';             -- write
			c_readdata             : out   std_logic_vector(31 downto 0);                    -- readdata
			c_writedata            : in    std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			conf_c_out             : out   std_logic_vector(3 downto 0);                     -- conf_c_out
			conf_c_in              : in    std_logic_vector(3 downto 0)  := (others => 'X')  -- conf_c_in
		);
	end component system_manager_if;

	u0 : component system_manager_if
		port map (
			clk                    => CONNECTED_TO_clk,                    --                    clk.clk
			rst                    => CONNECTED_TO_rst,                    --                    rst.reset
			pll_clk                => CONNECTED_TO_pll_clk,                --                pll_clk.clk
			conf_d                 => CONNECTED_TO_conf_d,                 --                 conf_d.conf_d
			soft_reconfigure_req_n => CONNECTED_TO_soft_reconfigure_req_n, -- soft_reconfigure_req_n.soft_reconfigure_req_n
			d_address              => CONNECTED_TO_d_address,              --                 mem_if.address
			d_read                 => CONNECTED_TO_d_read,                 --                       .read
			d_write                => CONNECTED_TO_d_write,                --                       .write
			d_readdata             => CONNECTED_TO_d_readdata,             --                       .readdata
			d_writedata            => CONNECTED_TO_d_writedata,            --                       .writedata
			d_waitrequest          => CONNECTED_TO_d_waitrequest,          --                       .waitrequest
			c_address              => CONNECTED_TO_c_address,              --                 reg_if.address
			c_read                 => CONNECTED_TO_c_read,                 --                       .read
			c_write                => CONNECTED_TO_c_write,                --                       .write
			c_readdata             => CONNECTED_TO_c_readdata,             --                       .readdata
			c_writedata            => CONNECTED_TO_c_writedata,            --                       .writedata
			conf_c_out             => CONNECTED_TO_conf_c_out,             --             conf_c_out.conf_c_out
			conf_c_in              => CONNECTED_TO_conf_c_in               --              conf_c_in.conf_c_in
		);

