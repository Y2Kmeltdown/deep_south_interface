	component dr_interface is
		port (
			config_clk_clk           : in  std_logic                     := 'X';             -- clk
			config_rstn_reset_n      : in  std_logic                     := 'X';             -- reset_n
			pcie_user_clk_clk        : in  std_logic                     := 'X';             -- clk
			pcie_user_rstn_reset_n   : in  std_logic                     := 'X';             -- reset_n
			avmm_phy_0_waitrequest   : in  std_logic                     := 'X';             -- waitrequest
			avmm_phy_0_readdata      : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			avmm_phy_0_readdatavalid : in  std_logic                     := 'X';             -- readdatavalid
			avmm_phy_0_burstcount    : out std_logic_vector(0 downto 0);                     -- burstcount
			avmm_phy_0_writedata     : out std_logic_vector(31 downto 0);                    -- writedata
			avmm_phy_0_address       : out std_logic_vector(12 downto 0);                    -- address
			avmm_phy_0_write         : out std_logic;                                        -- write
			avmm_phy_0_read          : out std_logic;                                        -- read
			avmm_phy_0_byteenable    : out std_logic_vector(3 downto 0);                     -- byteenable
			avmm_phy_0_debugaccess   : out std_logic;                                        -- debugaccess
			avmm_phy_1_waitrequest   : in  std_logic                     := 'X';             -- waitrequest
			avmm_phy_1_readdata      : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			avmm_phy_1_readdatavalid : in  std_logic                     := 'X';             -- readdatavalid
			avmm_phy_1_burstcount    : out std_logic_vector(0 downto 0);                     -- burstcount
			avmm_phy_1_writedata     : out std_logic_vector(31 downto 0);                    -- writedata
			avmm_phy_1_address       : out std_logic_vector(12 downto 0);                    -- address
			avmm_phy_1_write         : out std_logic;                                        -- write
			avmm_phy_1_read          : out std_logic;                                        -- read
			avmm_phy_1_byteenable    : out std_logic_vector(3 downto 0);                     -- byteenable
			avmm_phy_1_debugaccess   : out std_logic;                                        -- debugaccess
			avmm_phy_2_waitrequest   : in  std_logic                     := 'X';             -- waitrequest
			avmm_phy_2_readdata      : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			avmm_phy_2_readdatavalid : in  std_logic                     := 'X';             -- readdatavalid
			avmm_phy_2_burstcount    : out std_logic_vector(0 downto 0);                     -- burstcount
			avmm_phy_2_writedata     : out std_logic_vector(31 downto 0);                    -- writedata
			avmm_phy_2_address       : out std_logic_vector(12 downto 0);                    -- address
			avmm_phy_2_write         : out std_logic;                                        -- write
			avmm_phy_2_read          : out std_logic;                                        -- read
			avmm_phy_2_byteenable    : out std_logic_vector(3 downto 0);                     -- byteenable
			avmm_phy_2_debugaccess   : out std_logic;                                        -- debugaccess
			avmm_phy_3_waitrequest   : in  std_logic                     := 'X';             -- waitrequest
			avmm_phy_3_readdata      : in  std_logic_vector(31 downto 0) := (others => 'X'); -- readdata
			avmm_phy_3_readdatavalid : in  std_logic                     := 'X';             -- readdatavalid
			avmm_phy_3_burstcount    : out std_logic_vector(0 downto 0);                     -- burstcount
			avmm_phy_3_writedata     : out std_logic_vector(31 downto 0);                    -- writedata
			avmm_phy_3_address       : out std_logic_vector(12 downto 0);                    -- address
			avmm_phy_3_write         : out std_logic;                                        -- write
			avmm_phy_3_read          : out std_logic;                                        -- read
			avmm_phy_3_byteenable    : out std_logic_vector(3 downto 0);                     -- byteenable
			avmm_phy_3_debugaccess   : out std_logic;                                        -- debugaccess
			avmm_slave_waitrequest   : out std_logic;                                        -- waitrequest
			avmm_slave_readdata      : out std_logic_vector(31 downto 0);                    -- readdata
			avmm_slave_readdatavalid : out std_logic;                                        -- readdatavalid
			avmm_slave_burstcount    : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- burstcount
			avmm_slave_writedata     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			avmm_slave_address       : in  std_logic_vector(17 downto 0) := (others => 'X'); -- address
			avmm_slave_write         : in  std_logic                     := 'X';             -- write
			avmm_slave_read          : in  std_logic                     := 'X';             -- read
			avmm_slave_byteenable    : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			avmm_slave_debugaccess   : in  std_logic                     := 'X'              -- debugaccess
		);
	end component dr_interface;

	u0 : component dr_interface
		port map (
			config_clk_clk           => CONNECTED_TO_config_clk_clk,           --     config_clk.clk
			config_rstn_reset_n      => CONNECTED_TO_config_rstn_reset_n,      --    config_rstn.reset_n
			pcie_user_clk_clk        => CONNECTED_TO_pcie_user_clk_clk,        --  pcie_user_clk.clk
			pcie_user_rstn_reset_n   => CONNECTED_TO_pcie_user_rstn_reset_n,   -- pcie_user_rstn.reset_n
			avmm_phy_0_waitrequest   => CONNECTED_TO_avmm_phy_0_waitrequest,   --     avmm_phy_0.waitrequest
			avmm_phy_0_readdata      => CONNECTED_TO_avmm_phy_0_readdata,      --               .readdata
			avmm_phy_0_readdatavalid => CONNECTED_TO_avmm_phy_0_readdatavalid, --               .readdatavalid
			avmm_phy_0_burstcount    => CONNECTED_TO_avmm_phy_0_burstcount,    --               .burstcount
			avmm_phy_0_writedata     => CONNECTED_TO_avmm_phy_0_writedata,     --               .writedata
			avmm_phy_0_address       => CONNECTED_TO_avmm_phy_0_address,       --               .address
			avmm_phy_0_write         => CONNECTED_TO_avmm_phy_0_write,         --               .write
			avmm_phy_0_read          => CONNECTED_TO_avmm_phy_0_read,          --               .read
			avmm_phy_0_byteenable    => CONNECTED_TO_avmm_phy_0_byteenable,    --               .byteenable
			avmm_phy_0_debugaccess   => CONNECTED_TO_avmm_phy_0_debugaccess,   --               .debugaccess
			avmm_phy_1_waitrequest   => CONNECTED_TO_avmm_phy_1_waitrequest,   --     avmm_phy_1.waitrequest
			avmm_phy_1_readdata      => CONNECTED_TO_avmm_phy_1_readdata,      --               .readdata
			avmm_phy_1_readdatavalid => CONNECTED_TO_avmm_phy_1_readdatavalid, --               .readdatavalid
			avmm_phy_1_burstcount    => CONNECTED_TO_avmm_phy_1_burstcount,    --               .burstcount
			avmm_phy_1_writedata     => CONNECTED_TO_avmm_phy_1_writedata,     --               .writedata
			avmm_phy_1_address       => CONNECTED_TO_avmm_phy_1_address,       --               .address
			avmm_phy_1_write         => CONNECTED_TO_avmm_phy_1_write,         --               .write
			avmm_phy_1_read          => CONNECTED_TO_avmm_phy_1_read,          --               .read
			avmm_phy_1_byteenable    => CONNECTED_TO_avmm_phy_1_byteenable,    --               .byteenable
			avmm_phy_1_debugaccess   => CONNECTED_TO_avmm_phy_1_debugaccess,   --               .debugaccess
			avmm_phy_2_waitrequest   => CONNECTED_TO_avmm_phy_2_waitrequest,   --     avmm_phy_2.waitrequest
			avmm_phy_2_readdata      => CONNECTED_TO_avmm_phy_2_readdata,      --               .readdata
			avmm_phy_2_readdatavalid => CONNECTED_TO_avmm_phy_2_readdatavalid, --               .readdatavalid
			avmm_phy_2_burstcount    => CONNECTED_TO_avmm_phy_2_burstcount,    --               .burstcount
			avmm_phy_2_writedata     => CONNECTED_TO_avmm_phy_2_writedata,     --               .writedata
			avmm_phy_2_address       => CONNECTED_TO_avmm_phy_2_address,       --               .address
			avmm_phy_2_write         => CONNECTED_TO_avmm_phy_2_write,         --               .write
			avmm_phy_2_read          => CONNECTED_TO_avmm_phy_2_read,          --               .read
			avmm_phy_2_byteenable    => CONNECTED_TO_avmm_phy_2_byteenable,    --               .byteenable
			avmm_phy_2_debugaccess   => CONNECTED_TO_avmm_phy_2_debugaccess,   --               .debugaccess
			avmm_phy_3_waitrequest   => CONNECTED_TO_avmm_phy_3_waitrequest,   --     avmm_phy_3.waitrequest
			avmm_phy_3_readdata      => CONNECTED_TO_avmm_phy_3_readdata,      --               .readdata
			avmm_phy_3_readdatavalid => CONNECTED_TO_avmm_phy_3_readdatavalid, --               .readdatavalid
			avmm_phy_3_burstcount    => CONNECTED_TO_avmm_phy_3_burstcount,    --               .burstcount
			avmm_phy_3_writedata     => CONNECTED_TO_avmm_phy_3_writedata,     --               .writedata
			avmm_phy_3_address       => CONNECTED_TO_avmm_phy_3_address,       --               .address
			avmm_phy_3_write         => CONNECTED_TO_avmm_phy_3_write,         --               .write
			avmm_phy_3_read          => CONNECTED_TO_avmm_phy_3_read,          --               .read
			avmm_phy_3_byteenable    => CONNECTED_TO_avmm_phy_3_byteenable,    --               .byteenable
			avmm_phy_3_debugaccess   => CONNECTED_TO_avmm_phy_3_debugaccess,   --               .debugaccess
			avmm_slave_waitrequest   => CONNECTED_TO_avmm_slave_waitrequest,   --     avmm_slave.waitrequest
			avmm_slave_readdata      => CONNECTED_TO_avmm_slave_readdata,      --               .readdata
			avmm_slave_readdatavalid => CONNECTED_TO_avmm_slave_readdatavalid, --               .readdatavalid
			avmm_slave_burstcount    => CONNECTED_TO_avmm_slave_burstcount,    --               .burstcount
			avmm_slave_writedata     => CONNECTED_TO_avmm_slave_writedata,     --               .writedata
			avmm_slave_address       => CONNECTED_TO_avmm_slave_address,       --               .address
			avmm_slave_write         => CONNECTED_TO_avmm_slave_write,         --               .write
			avmm_slave_read          => CONNECTED_TO_avmm_slave_read,          --               .read
			avmm_slave_byteenable    => CONNECTED_TO_avmm_slave_byteenable,    --               .byteenable
			avmm_slave_debugaccess   => CONNECTED_TO_avmm_slave_debugaccess    --               .debugaccess
		);

