	component tg_top0_1 is
		port (
			wmc_clk_in          : in  std_logic                      := 'X';             -- clk
			wmcrst_n_in         : in  std_logic                      := 'X';             -- reset_n
			ninit_done          : in  std_logic                      := 'X';             -- ninit_done
			awid                : out std_logic_vector(8 downto 0);                      -- awid
			awaddr              : out std_logic_vector(28 downto 0);                     -- awaddr
			awlen               : out std_logic_vector(7 downto 0);                      -- awlen
			awsize              : out std_logic_vector(2 downto 0);                      -- awsize
			awburst             : out std_logic_vector(1 downto 0);                      -- awburst
			awprot              : out std_logic_vector(2 downto 0);                      -- awprot
			awqos               : out std_logic_vector(3 downto 0);                      -- awqos
			awuser_ap           : out std_logic_vector(0 downto 0);                      -- awuser
			awvalid             : out std_logic;                                         -- awvalid
			awready             : in  std_logic                      := 'X';             -- awready
			wdata               : out std_logic_vector(255 downto 0);                    -- wdata
			wstrb               : out std_logic_vector(31 downto 0);                     -- wstrb
			wlast               : out std_logic;                                         -- wlast
			wvalid              : out std_logic;                                         -- wvalid
			wready              : in  std_logic                      := 'X';             -- wready
			bid                 : in  std_logic_vector(8 downto 0)   := (others => 'X'); -- bid
			bresp               : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- bresp
			bvalid              : in  std_logic                      := 'X';             -- bvalid
			bready              : out std_logic;                                         -- bready
			arid                : out std_logic_vector(8 downto 0);                      -- arid
			araddr              : out std_logic_vector(28 downto 0);                     -- araddr
			arlen               : out std_logic_vector(7 downto 0);                      -- arlen
			arsize              : out std_logic_vector(2 downto 0);                      -- arsize
			arburst             : out std_logic_vector(1 downto 0);                      -- arburst
			arprot              : out std_logic_vector(2 downto 0);                      -- arprot
			arqos               : out std_logic_vector(3 downto 0);                      -- arqos
			aruser_ap           : out std_logic_vector(0 downto 0);                      -- aruser
			arvalid             : out std_logic;                                         -- arvalid
			arready             : in  std_logic                      := 'X';             -- arready
			rid                 : in  std_logic_vector(8 downto 0)   := (others => 'X'); -- rid
			rdata               : in  std_logic_vector(255 downto 0) := (others => 'X'); -- rdata
			rresp               : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rresp
			rlast               : in  std_logic                      := 'X';             -- rlast
			rvalid              : in  std_logic                      := 'X';             -- rvalid
			rready              : out std_logic;                                         -- rready
			ruser_err_dbe       : in  std_logic                      := 'X';             -- ruser_err_dbe
			ruser_data          : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- ruser_data
			wuser_data          : out std_logic_vector(31 downto 0);                     -- wuser_data
			wuser_strb          : out std_logic_vector(3 downto 0);                      -- wuser_strb
			traffic_gen_pass    : out std_logic;                                         -- traffic_gen_pass
			traffic_gen_fail    : out std_logic;                                         -- traffic_gen_fail
			traffic_gen_timeout : out std_logic                                          -- traffic_gen_timeout
		);
	end component tg_top0_1;

	u0 : component tg_top0_1
		port map (
			wmc_clk_in          => CONNECTED_TO_wmc_clk_in,          --  wmc_clk_in.clk
			wmcrst_n_in         => CONNECTED_TO_wmcrst_n_in,         -- wmcrst_n_in.reset_n
			ninit_done          => CONNECTED_TO_ninit_done,          --  ninit_done.ninit_done
			awid                => CONNECTED_TO_awid,                --         axi.awid
			awaddr              => CONNECTED_TO_awaddr,              --            .awaddr
			awlen               => CONNECTED_TO_awlen,               --            .awlen
			awsize              => CONNECTED_TO_awsize,              --            .awsize
			awburst             => CONNECTED_TO_awburst,             --            .awburst
			awprot              => CONNECTED_TO_awprot,              --            .awprot
			awqos               => CONNECTED_TO_awqos,               --            .awqos
			awuser_ap           => CONNECTED_TO_awuser_ap,           --            .awuser
			awvalid             => CONNECTED_TO_awvalid,             --            .awvalid
			awready             => CONNECTED_TO_awready,             --            .awready
			wdata               => CONNECTED_TO_wdata,               --            .wdata
			wstrb               => CONNECTED_TO_wstrb,               --            .wstrb
			wlast               => CONNECTED_TO_wlast,               --            .wlast
			wvalid              => CONNECTED_TO_wvalid,              --            .wvalid
			wready              => CONNECTED_TO_wready,              --            .wready
			bid                 => CONNECTED_TO_bid,                 --            .bid
			bresp               => CONNECTED_TO_bresp,               --            .bresp
			bvalid              => CONNECTED_TO_bvalid,              --            .bvalid
			bready              => CONNECTED_TO_bready,              --            .bready
			arid                => CONNECTED_TO_arid,                --            .arid
			araddr              => CONNECTED_TO_araddr,              --            .araddr
			arlen               => CONNECTED_TO_arlen,               --            .arlen
			arsize              => CONNECTED_TO_arsize,              --            .arsize
			arburst             => CONNECTED_TO_arburst,             --            .arburst
			arprot              => CONNECTED_TO_arprot,              --            .arprot
			arqos               => CONNECTED_TO_arqos,               --            .arqos
			aruser_ap           => CONNECTED_TO_aruser_ap,           --            .aruser
			arvalid             => CONNECTED_TO_arvalid,             --            .arvalid
			arready             => CONNECTED_TO_arready,             --            .arready
			rid                 => CONNECTED_TO_rid,                 --            .rid
			rdata               => CONNECTED_TO_rdata,               --            .rdata
			rresp               => CONNECTED_TO_rresp,               --            .rresp
			rlast               => CONNECTED_TO_rlast,               --            .rlast
			rvalid              => CONNECTED_TO_rvalid,              --            .rvalid
			rready              => CONNECTED_TO_rready,              --            .rready
			ruser_err_dbe       => CONNECTED_TO_ruser_err_dbe,       --   axi_extra.ruser_err_dbe
			ruser_data          => CONNECTED_TO_ruser_data,          --            .ruser_data
			wuser_data          => CONNECTED_TO_wuser_data,          --            .wuser_data
			wuser_strb          => CONNECTED_TO_wuser_strb,          --            .wuser_strb
			traffic_gen_pass    => CONNECTED_TO_traffic_gen_pass,    --   tg_status.traffic_gen_pass
			traffic_gen_fail    => CONNECTED_TO_traffic_gen_fail,    --            .traffic_gen_fail
			traffic_gen_timeout => CONNECTED_TO_traffic_gen_timeout  --            .traffic_gen_timeout
		);

