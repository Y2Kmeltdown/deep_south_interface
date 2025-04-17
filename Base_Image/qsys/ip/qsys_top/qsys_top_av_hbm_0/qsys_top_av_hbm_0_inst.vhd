	component qsys_top_av_hbm_0 is
		port (
			clk                              : in  std_logic                     := 'X';             -- clk
			rst                              : in  std_logic                     := 'X';             -- reset
			av_address                       : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- address
			av_read                          : in  std_logic                     := 'X';             -- read
			av_waitrequest                   : out std_logic;                                        -- waitrequest
			av_write                         : in  std_logic                     := 'X';             -- write
			av_readdata                      : out std_logic_vector(31 downto 0);                    -- readdata
			av_writedata                     : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			bottom_core_clk_iopll_refclk_clk : in  std_logic                     := 'X';             -- iopll_ref_clk
			bottom_pll_ref_clk_clk           : in  std_logic                     := 'X';             -- pll_ref_clk
			top_core_clk_iopll_ref_clk_clk   : in  std_logic                     := 'X';             -- iopll_ref_clk
			top_pll_ref_clk_clk              : in  std_logic                     := 'X';             -- pll_ref_clk
			bottom_m2u_bridge_cattrip        : in  std_logic                     := 'X';             -- cattrip
			bottom_m2u_bridge_temp           : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- temp
			bottom_m2u_bridge_wso            : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- wso
			bottom_m2u_bridge_reset_n        : out std_logic;                                        -- reset
			bottom_m2u_bridge_wrst_n         : out std_logic;                                        -- wrst
			bottom_m2u_bridge_wrck           : out std_logic;                                        -- wrck
			bottom_m2u_bridge_shiftwr        : out std_logic;                                        -- shiftwr
			bottom_m2u_bridge_capturewr      : out std_logic;                                        -- capturewr
			bottom_m2u_bridge_updatewr       : out std_logic;                                        -- updatewr
			bottom_m2u_bridge_selectwir      : out std_logic;                                        -- selectwir
			bottom_m2u_bridge_wsi            : out std_logic;                                        -- wsi
			top_m2u_bridge_cattrip           : in  std_logic                     := 'X';             -- cattrip
			top_m2u_bridge_temp              : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- temp
			top_m2u_bridge_wso               : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- wso
			top_m2u_bridge_reset_n           : out std_logic;                                        -- reset
			top_m2u_bridge_wrst_n            : out std_logic;                                        -- wrst
			top_m2u_bridge_wrck              : out std_logic;                                        -- wrck
			top_m2u_bridge_shiftwr           : out std_logic;                                        -- shiftwr
			top_m2u_bridge_capturewr         : out std_logic;                                        -- capturewr
			top_m2u_bridge_updatewr          : out std_logic;                                        -- updatewr
			top_m2u_bridge_selectwir         : out std_logic;                                        -- selectwir
			top_m2u_bridge_wsi               : out std_logic                                         -- wsi
		);
	end component qsys_top_av_hbm_0;

	u0 : component qsys_top_av_hbm_0
		port map (
			clk                              => CONNECTED_TO_clk,                              --                 clk.clk
			rst                              => CONNECTED_TO_rst,                              --                 rst.reset
			av_address                       => CONNECTED_TO_av_address,                       --              reg_if.address
			av_read                          => CONNECTED_TO_av_read,                          --                    .read
			av_waitrequest                   => CONNECTED_TO_av_waitrequest,                   --                    .waitrequest
			av_write                         => CONNECTED_TO_av_write,                         --                    .write
			av_readdata                      => CONNECTED_TO_av_readdata,                      --                    .readdata
			av_writedata                     => CONNECTED_TO_av_writedata,                     --                    .writedata
			bottom_core_clk_iopll_refclk_clk => CONNECTED_TO_bottom_core_clk_iopll_refclk_clk, -- hbm_bottom_ref_clks.iopll_ref_clk
			bottom_pll_ref_clk_clk           => CONNECTED_TO_bottom_pll_ref_clk_clk,           --                    .pll_ref_clk
			top_core_clk_iopll_ref_clk_clk   => CONNECTED_TO_top_core_clk_iopll_ref_clk_clk,   --    hbm_top_ref_clks.iopll_ref_clk
			top_pll_ref_clk_clk              => CONNECTED_TO_top_pll_ref_clk_clk,              --                    .pll_ref_clk
			bottom_m2u_bridge_cattrip        => CONNECTED_TO_bottom_m2u_bridge_cattrip,        --          bottom_m2u.cattrip
			bottom_m2u_bridge_temp           => CONNECTED_TO_bottom_m2u_bridge_temp,           --                    .temp
			bottom_m2u_bridge_wso            => CONNECTED_TO_bottom_m2u_bridge_wso,            --                    .wso
			bottom_m2u_bridge_reset_n        => CONNECTED_TO_bottom_m2u_bridge_reset_n,        --                    .reset
			bottom_m2u_bridge_wrst_n         => CONNECTED_TO_bottom_m2u_bridge_wrst_n,         --                    .wrst
			bottom_m2u_bridge_wrck           => CONNECTED_TO_bottom_m2u_bridge_wrck,           --                    .wrck
			bottom_m2u_bridge_shiftwr        => CONNECTED_TO_bottom_m2u_bridge_shiftwr,        --                    .shiftwr
			bottom_m2u_bridge_capturewr      => CONNECTED_TO_bottom_m2u_bridge_capturewr,      --                    .capturewr
			bottom_m2u_bridge_updatewr       => CONNECTED_TO_bottom_m2u_bridge_updatewr,       --                    .updatewr
			bottom_m2u_bridge_selectwir      => CONNECTED_TO_bottom_m2u_bridge_selectwir,      --                    .selectwir
			bottom_m2u_bridge_wsi            => CONNECTED_TO_bottom_m2u_bridge_wsi,            --                    .wsi
			top_m2u_bridge_cattrip           => CONNECTED_TO_top_m2u_bridge_cattrip,           --             top_m2u.cattrip
			top_m2u_bridge_temp              => CONNECTED_TO_top_m2u_bridge_temp,              --                    .temp
			top_m2u_bridge_wso               => CONNECTED_TO_top_m2u_bridge_wso,               --                    .wso
			top_m2u_bridge_reset_n           => CONNECTED_TO_top_m2u_bridge_reset_n,           --                    .reset
			top_m2u_bridge_wrst_n            => CONNECTED_TO_top_m2u_bridge_wrst_n,            --                    .wrst
			top_m2u_bridge_wrck              => CONNECTED_TO_top_m2u_bridge_wrck,              --                    .wrck
			top_m2u_bridge_shiftwr           => CONNECTED_TO_top_m2u_bridge_shiftwr,           --                    .shiftwr
			top_m2u_bridge_capturewr         => CONNECTED_TO_top_m2u_bridge_capturewr,         --                    .capturewr
			top_m2u_bridge_updatewr          => CONNECTED_TO_top_m2u_bridge_updatewr,          --                    .updatewr
			top_m2u_bridge_selectwir         => CONNECTED_TO_top_m2u_bridge_selectwir,         --                    .selectwir
			top_m2u_bridge_wsi               => CONNECTED_TO_top_m2u_bridge_wsi                --                    .wsi
		);

