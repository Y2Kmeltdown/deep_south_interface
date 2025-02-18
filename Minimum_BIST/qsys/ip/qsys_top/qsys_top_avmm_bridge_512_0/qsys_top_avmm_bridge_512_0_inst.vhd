	component qsys_top_avmm_bridge_512_0 is
		port (
			refclk                    : in  std_logic                      := 'X';             -- clk
			coreclkout_hip            : out std_logic;                                         -- clk
			npor                      : in  std_logic                      := 'X';             -- npor
			pin_perst                 : in  std_logic                      := 'X';             -- pin_perst
			app_nreset_status         : out std_logic;                                         -- reset_n
			ninit_done                : in  std_logic                      := 'X';             -- ninit_done
			bam_pfnum_o               : out std_logic_vector(1 downto 0);                      -- pfnum
			bam_bar_o                 : out std_logic_vector(2 downto 0);                      -- barnum
			bam_waitrequest_i         : in  std_logic                      := 'X';             -- waitrequest
			bam_address_o             : out std_logic_vector(19 downto 0);                     -- address
			bam_byteenable_o          : out std_logic_vector(63 downto 0);                     -- byteenable
			bam_read_o                : out std_logic;                                         -- read
			bam_readdata_i            : in  std_logic_vector(511 downto 0) := (others => 'X'); -- readdata
			bam_readdatavalid_i       : in  std_logic                      := 'X';             -- readdatavalid
			bam_write_o               : out std_logic;                                         -- write
			bam_writedata_o           : out std_logic_vector(511 downto 0);                    -- writedata
			bam_burstcount_o          : out std_logic_vector(3 downto 0);                      -- burstcount
			bam_response_i            : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- response
			bam_writeresponsevalid_i  : in  std_logic                      := 'X';             -- writeresponsevalid
			flr_pf_done_i             : in  std_logic                      := 'X';             -- flr_pf_done
			flr_pf_active_o           : out std_logic;                                         -- flr_pf_active
			bus_master_enable_o       : out std_logic_vector(3 downto 0);                      -- bus_master_enable
			simu_mode_pipe            : in  std_logic                      := 'X';             -- simu_mode_pipe
			test_in                   : in  std_logic_vector(66 downto 0)  := (others => 'X'); -- test_in
			sim_pipe_pclk_in          : in  std_logic                      := 'X';             -- sim_pipe_pclk_in
			sim_pipe_rate             : out std_logic_vector(1 downto 0);                      -- sim_pipe_rate
			sim_ltssmstate            : out std_logic_vector(5 downto 0);                      -- sim_ltssmstate
			txdata0                   : out std_logic_vector(31 downto 0);                     -- txdata0
			txdata1                   : out std_logic_vector(31 downto 0);                     -- txdata1
			txdata2                   : out std_logic_vector(31 downto 0);                     -- txdata2
			txdata3                   : out std_logic_vector(31 downto 0);                     -- txdata3
			txdata4                   : out std_logic_vector(31 downto 0);                     -- txdata4
			txdata5                   : out std_logic_vector(31 downto 0);                     -- txdata5
			txdata6                   : out std_logic_vector(31 downto 0);                     -- txdata6
			txdata7                   : out std_logic_vector(31 downto 0);                     -- txdata7
			txdata8                   : out std_logic_vector(31 downto 0);                     -- txdata8
			txdata9                   : out std_logic_vector(31 downto 0);                     -- txdata9
			txdata10                  : out std_logic_vector(31 downto 0);                     -- txdata10
			txdata11                  : out std_logic_vector(31 downto 0);                     -- txdata11
			txdata12                  : out std_logic_vector(31 downto 0);                     -- txdata12
			txdata13                  : out std_logic_vector(31 downto 0);                     -- txdata13
			txdata14                  : out std_logic_vector(31 downto 0);                     -- txdata14
			txdata15                  : out std_logic_vector(31 downto 0);                     -- txdata15
			txdatak0                  : out std_logic_vector(3 downto 0);                      -- txdatak0
			txdatak1                  : out std_logic_vector(3 downto 0);                      -- txdatak1
			txdatak2                  : out std_logic_vector(3 downto 0);                      -- txdatak2
			txdatak3                  : out std_logic_vector(3 downto 0);                      -- txdatak3
			txdatak4                  : out std_logic_vector(3 downto 0);                      -- txdatak4
			txdatak5                  : out std_logic_vector(3 downto 0);                      -- txdatak5
			txdatak6                  : out std_logic_vector(3 downto 0);                      -- txdatak6
			txdatak7                  : out std_logic_vector(3 downto 0);                      -- txdatak7
			txdatak8                  : out std_logic_vector(3 downto 0);                      -- txdatak8
			txdatak9                  : out std_logic_vector(3 downto 0);                      -- txdatak9
			txdatak10                 : out std_logic_vector(3 downto 0);                      -- txdatak10
			txdatak11                 : out std_logic_vector(3 downto 0);                      -- txdatak11
			txdatak12                 : out std_logic_vector(3 downto 0);                      -- txdatak12
			txdatak13                 : out std_logic_vector(3 downto 0);                      -- txdatak13
			txdatak14                 : out std_logic_vector(3 downto 0);                      -- txdatak14
			txdatak15                 : out std_logic_vector(3 downto 0);                      -- txdatak15
			txcompl0                  : out std_logic;                                         -- txcompl0
			txcompl1                  : out std_logic;                                         -- txcompl1
			txcompl2                  : out std_logic;                                         -- txcompl2
			txcompl3                  : out std_logic;                                         -- txcompl3
			txcompl4                  : out std_logic;                                         -- txcompl4
			txcompl5                  : out std_logic;                                         -- txcompl5
			txcompl6                  : out std_logic;                                         -- txcompl6
			txcompl7                  : out std_logic;                                         -- txcompl7
			txcompl8                  : out std_logic;                                         -- txcompl8
			txcompl9                  : out std_logic;                                         -- txcompl9
			txcompl10                 : out std_logic;                                         -- txcompl10
			txcompl11                 : out std_logic;                                         -- txcompl11
			txcompl12                 : out std_logic;                                         -- txcompl12
			txcompl13                 : out std_logic;                                         -- txcompl13
			txcompl14                 : out std_logic;                                         -- txcompl14
			txcompl15                 : out std_logic;                                         -- txcompl15
			txelecidle0               : out std_logic;                                         -- txelecidle0
			txelecidle1               : out std_logic;                                         -- txelecidle1
			txelecidle2               : out std_logic;                                         -- txelecidle2
			txelecidle3               : out std_logic;                                         -- txelecidle3
			txelecidle4               : out std_logic;                                         -- txelecidle4
			txelecidle5               : out std_logic;                                         -- txelecidle5
			txelecidle6               : out std_logic;                                         -- txelecidle6
			txelecidle7               : out std_logic;                                         -- txelecidle7
			txelecidle8               : out std_logic;                                         -- txelecidle8
			txelecidle9               : out std_logic;                                         -- txelecidle9
			txelecidle10              : out std_logic;                                         -- txelecidle10
			txelecidle11              : out std_logic;                                         -- txelecidle11
			txelecidle12              : out std_logic;                                         -- txelecidle12
			txelecidle13              : out std_logic;                                         -- txelecidle13
			txelecidle14              : out std_logic;                                         -- txelecidle14
			txelecidle15              : out std_logic;                                         -- txelecidle15
			txdetectrx0               : out std_logic;                                         -- txdetectrx0
			txdetectrx1               : out std_logic;                                         -- txdetectrx1
			txdetectrx2               : out std_logic;                                         -- txdetectrx2
			txdetectrx3               : out std_logic;                                         -- txdetectrx3
			txdetectrx4               : out std_logic;                                         -- txdetectrx4
			txdetectrx5               : out std_logic;                                         -- txdetectrx5
			txdetectrx6               : out std_logic;                                         -- txdetectrx6
			txdetectrx7               : out std_logic;                                         -- txdetectrx7
			txdetectrx8               : out std_logic;                                         -- txdetectrx8
			txdetectrx9               : out std_logic;                                         -- txdetectrx9
			txdetectrx10              : out std_logic;                                         -- txdetectrx10
			txdetectrx11              : out std_logic;                                         -- txdetectrx11
			txdetectrx12              : out std_logic;                                         -- txdetectrx12
			txdetectrx13              : out std_logic;                                         -- txdetectrx13
			txdetectrx14              : out std_logic;                                         -- txdetectrx14
			txdetectrx15              : out std_logic;                                         -- txdetectrx15
			powerdown0                : out std_logic_vector(1 downto 0);                      -- powerdown0
			powerdown1                : out std_logic_vector(1 downto 0);                      -- powerdown1
			powerdown2                : out std_logic_vector(1 downto 0);                      -- powerdown2
			powerdown3                : out std_logic_vector(1 downto 0);                      -- powerdown3
			powerdown4                : out std_logic_vector(1 downto 0);                      -- powerdown4
			powerdown5                : out std_logic_vector(1 downto 0);                      -- powerdown5
			powerdown6                : out std_logic_vector(1 downto 0);                      -- powerdown6
			powerdown7                : out std_logic_vector(1 downto 0);                      -- powerdown7
			powerdown8                : out std_logic_vector(1 downto 0);                      -- powerdown8
			powerdown9                : out std_logic_vector(1 downto 0);                      -- powerdown9
			powerdown10               : out std_logic_vector(1 downto 0);                      -- powerdown10
			powerdown11               : out std_logic_vector(1 downto 0);                      -- powerdown11
			powerdown12               : out std_logic_vector(1 downto 0);                      -- powerdown12
			powerdown13               : out std_logic_vector(1 downto 0);                      -- powerdown13
			powerdown14               : out std_logic_vector(1 downto 0);                      -- powerdown14
			powerdown15               : out std_logic_vector(1 downto 0);                      -- powerdown15
			txmargin0                 : out std_logic_vector(2 downto 0);                      -- txmargin0
			txmargin1                 : out std_logic_vector(2 downto 0);                      -- txmargin1
			txmargin2                 : out std_logic_vector(2 downto 0);                      -- txmargin2
			txmargin3                 : out std_logic_vector(2 downto 0);                      -- txmargin3
			txmargin4                 : out std_logic_vector(2 downto 0);                      -- txmargin4
			txmargin5                 : out std_logic_vector(2 downto 0);                      -- txmargin5
			txmargin6                 : out std_logic_vector(2 downto 0);                      -- txmargin6
			txmargin7                 : out std_logic_vector(2 downto 0);                      -- txmargin7
			txmargin8                 : out std_logic_vector(2 downto 0);                      -- txmargin8
			txmargin9                 : out std_logic_vector(2 downto 0);                      -- txmargin9
			txmargin10                : out std_logic_vector(2 downto 0);                      -- txmargin10
			txmargin11                : out std_logic_vector(2 downto 0);                      -- txmargin11
			txmargin12                : out std_logic_vector(2 downto 0);                      -- txmargin12
			txmargin13                : out std_logic_vector(2 downto 0);                      -- txmargin13
			txmargin14                : out std_logic_vector(2 downto 0);                      -- txmargin14
			txmargin15                : out std_logic_vector(2 downto 0);                      -- txmargin15
			txdeemph0                 : out std_logic;                                         -- txdeemph0
			txdeemph1                 : out std_logic;                                         -- txdeemph1
			txdeemph2                 : out std_logic;                                         -- txdeemph2
			txdeemph3                 : out std_logic;                                         -- txdeemph3
			txdeemph4                 : out std_logic;                                         -- txdeemph4
			txdeemph5                 : out std_logic;                                         -- txdeemph5
			txdeemph6                 : out std_logic;                                         -- txdeemph6
			txdeemph7                 : out std_logic;                                         -- txdeemph7
			txdeemph8                 : out std_logic;                                         -- txdeemph8
			txdeemph9                 : out std_logic;                                         -- txdeemph9
			txdeemph10                : out std_logic;                                         -- txdeemph10
			txdeemph11                : out std_logic;                                         -- txdeemph11
			txdeemph12                : out std_logic;                                         -- txdeemph12
			txdeemph13                : out std_logic;                                         -- txdeemph13
			txdeemph14                : out std_logic;                                         -- txdeemph14
			txdeemph15                : out std_logic;                                         -- txdeemph15
			txswing0                  : out std_logic;                                         -- txswing0
			txswing1                  : out std_logic;                                         -- txswing1
			txswing2                  : out std_logic;                                         -- txswing2
			txswing3                  : out std_logic;                                         -- txswing3
			txswing4                  : out std_logic;                                         -- txswing4
			txswing5                  : out std_logic;                                         -- txswing5
			txswing6                  : out std_logic;                                         -- txswing6
			txswing7                  : out std_logic;                                         -- txswing7
			txswing8                  : out std_logic;                                         -- txswing8
			txswing9                  : out std_logic;                                         -- txswing9
			txswing10                 : out std_logic;                                         -- txswing10
			txswing11                 : out std_logic;                                         -- txswing11
			txswing12                 : out std_logic;                                         -- txswing12
			txswing13                 : out std_logic;                                         -- txswing13
			txswing14                 : out std_logic;                                         -- txswing14
			txswing15                 : out std_logic;                                         -- txswing15
			txsynchd0                 : out std_logic_vector(1 downto 0);                      -- txsynchd0
			txsynchd1                 : out std_logic_vector(1 downto 0);                      -- txsynchd1
			txsynchd2                 : out std_logic_vector(1 downto 0);                      -- txsynchd2
			txsynchd3                 : out std_logic_vector(1 downto 0);                      -- txsynchd3
			txsynchd4                 : out std_logic_vector(1 downto 0);                      -- txsynchd4
			txsynchd5                 : out std_logic_vector(1 downto 0);                      -- txsynchd5
			txsynchd6                 : out std_logic_vector(1 downto 0);                      -- txsynchd6
			txsynchd7                 : out std_logic_vector(1 downto 0);                      -- txsynchd7
			txsynchd8                 : out std_logic_vector(1 downto 0);                      -- txsynchd8
			txsynchd9                 : out std_logic_vector(1 downto 0);                      -- txsynchd9
			txsynchd10                : out std_logic_vector(1 downto 0);                      -- txsynchd10
			txsynchd11                : out std_logic_vector(1 downto 0);                      -- txsynchd11
			txsynchd12                : out std_logic_vector(1 downto 0);                      -- txsynchd12
			txsynchd13                : out std_logic_vector(1 downto 0);                      -- txsynchd13
			txsynchd14                : out std_logic_vector(1 downto 0);                      -- txsynchd14
			txsynchd15                : out std_logic_vector(1 downto 0);                      -- txsynchd15
			txblkst0                  : out std_logic;                                         -- txblkst0
			txblkst1                  : out std_logic;                                         -- txblkst1
			txblkst2                  : out std_logic;                                         -- txblkst2
			txblkst3                  : out std_logic;                                         -- txblkst3
			txblkst4                  : out std_logic;                                         -- txblkst4
			txblkst5                  : out std_logic;                                         -- txblkst5
			txblkst6                  : out std_logic;                                         -- txblkst6
			txblkst7                  : out std_logic;                                         -- txblkst7
			txblkst8                  : out std_logic;                                         -- txblkst8
			txblkst9                  : out std_logic;                                         -- txblkst9
			txblkst10                 : out std_logic;                                         -- txblkst10
			txblkst11                 : out std_logic;                                         -- txblkst11
			txblkst12                 : out std_logic;                                         -- txblkst12
			txblkst13                 : out std_logic;                                         -- txblkst13
			txblkst14                 : out std_logic;                                         -- txblkst14
			txblkst15                 : out std_logic;                                         -- txblkst15
			txdataskip0               : out std_logic;                                         -- txdataskip0
			txdataskip1               : out std_logic;                                         -- txdataskip1
			txdataskip2               : out std_logic;                                         -- txdataskip2
			txdataskip3               : out std_logic;                                         -- txdataskip3
			txdataskip4               : out std_logic;                                         -- txdataskip4
			txdataskip5               : out std_logic;                                         -- txdataskip5
			txdataskip6               : out std_logic;                                         -- txdataskip6
			txdataskip7               : out std_logic;                                         -- txdataskip7
			txdataskip8               : out std_logic;                                         -- txdataskip8
			txdataskip9               : out std_logic;                                         -- txdataskip9
			txdataskip10              : out std_logic;                                         -- txdataskip10
			txdataskip11              : out std_logic;                                         -- txdataskip11
			txdataskip12              : out std_logic;                                         -- txdataskip12
			txdataskip13              : out std_logic;                                         -- txdataskip13
			txdataskip14              : out std_logic;                                         -- txdataskip14
			txdataskip15              : out std_logic;                                         -- txdataskip15
			rate0                     : out std_logic_vector(1 downto 0);                      -- rate0
			rate1                     : out std_logic_vector(1 downto 0);                      -- rate1
			rate2                     : out std_logic_vector(1 downto 0);                      -- rate2
			rate3                     : out std_logic_vector(1 downto 0);                      -- rate3
			rate4                     : out std_logic_vector(1 downto 0);                      -- rate4
			rate5                     : out std_logic_vector(1 downto 0);                      -- rate5
			rate6                     : out std_logic_vector(1 downto 0);                      -- rate6
			rate7                     : out std_logic_vector(1 downto 0);                      -- rate7
			rate8                     : out std_logic_vector(1 downto 0);                      -- rate8
			rate9                     : out std_logic_vector(1 downto 0);                      -- rate9
			rate10                    : out std_logic_vector(1 downto 0);                      -- rate10
			rate11                    : out std_logic_vector(1 downto 0);                      -- rate11
			rate12                    : out std_logic_vector(1 downto 0);                      -- rate12
			rate13                    : out std_logic_vector(1 downto 0);                      -- rate13
			rate14                    : out std_logic_vector(1 downto 0);                      -- rate14
			rate15                    : out std_logic_vector(1 downto 0);                      -- rate15
			rxpolarity0               : out std_logic;                                         -- rxpolarity0
			rxpolarity1               : out std_logic;                                         -- rxpolarity1
			rxpolarity2               : out std_logic;                                         -- rxpolarity2
			rxpolarity3               : out std_logic;                                         -- rxpolarity3
			rxpolarity4               : out std_logic;                                         -- rxpolarity4
			rxpolarity5               : out std_logic;                                         -- rxpolarity5
			rxpolarity6               : out std_logic;                                         -- rxpolarity6
			rxpolarity7               : out std_logic;                                         -- rxpolarity7
			rxpolarity8               : out std_logic;                                         -- rxpolarity8
			rxpolarity9               : out std_logic;                                         -- rxpolarity9
			rxpolarity10              : out std_logic;                                         -- rxpolarity10
			rxpolarity11              : out std_logic;                                         -- rxpolarity11
			rxpolarity12              : out std_logic;                                         -- rxpolarity12
			rxpolarity13              : out std_logic;                                         -- rxpolarity13
			rxpolarity14              : out std_logic;                                         -- rxpolarity14
			rxpolarity15              : out std_logic;                                         -- rxpolarity15
			currentrxpreset0          : out std_logic_vector(2 downto 0);                      -- currentrxpreset0
			currentrxpreset1          : out std_logic_vector(2 downto 0);                      -- currentrxpreset1
			currentrxpreset2          : out std_logic_vector(2 downto 0);                      -- currentrxpreset2
			currentrxpreset3          : out std_logic_vector(2 downto 0);                      -- currentrxpreset3
			currentrxpreset4          : out std_logic_vector(2 downto 0);                      -- currentrxpreset4
			currentrxpreset5          : out std_logic_vector(2 downto 0);                      -- currentrxpreset5
			currentrxpreset6          : out std_logic_vector(2 downto 0);                      -- currentrxpreset6
			currentrxpreset7          : out std_logic_vector(2 downto 0);                      -- currentrxpreset7
			currentrxpreset8          : out std_logic_vector(2 downto 0);                      -- currentrxpreset8
			currentrxpreset9          : out std_logic_vector(2 downto 0);                      -- currentrxpreset9
			currentrxpreset10         : out std_logic_vector(2 downto 0);                      -- currentrxpreset10
			currentrxpreset11         : out std_logic_vector(2 downto 0);                      -- currentrxpreset11
			currentrxpreset12         : out std_logic_vector(2 downto 0);                      -- currentrxpreset12
			currentrxpreset13         : out std_logic_vector(2 downto 0);                      -- currentrxpreset13
			currentrxpreset14         : out std_logic_vector(2 downto 0);                      -- currentrxpreset14
			currentrxpreset15         : out std_logic_vector(2 downto 0);                      -- currentrxpreset15
			currentcoeff0             : out std_logic_vector(17 downto 0);                     -- currentcoeff0
			currentcoeff1             : out std_logic_vector(17 downto 0);                     -- currentcoeff1
			currentcoeff2             : out std_logic_vector(17 downto 0);                     -- currentcoeff2
			currentcoeff3             : out std_logic_vector(17 downto 0);                     -- currentcoeff3
			currentcoeff4             : out std_logic_vector(17 downto 0);                     -- currentcoeff4
			currentcoeff5             : out std_logic_vector(17 downto 0);                     -- currentcoeff5
			currentcoeff6             : out std_logic_vector(17 downto 0);                     -- currentcoeff6
			currentcoeff7             : out std_logic_vector(17 downto 0);                     -- currentcoeff7
			currentcoeff8             : out std_logic_vector(17 downto 0);                     -- currentcoeff8
			currentcoeff9             : out std_logic_vector(17 downto 0);                     -- currentcoeff9
			currentcoeff10            : out std_logic_vector(17 downto 0);                     -- currentcoeff10
			currentcoeff11            : out std_logic_vector(17 downto 0);                     -- currentcoeff11
			currentcoeff12            : out std_logic_vector(17 downto 0);                     -- currentcoeff12
			currentcoeff13            : out std_logic_vector(17 downto 0);                     -- currentcoeff13
			currentcoeff14            : out std_logic_vector(17 downto 0);                     -- currentcoeff14
			currentcoeff15            : out std_logic_vector(17 downto 0);                     -- currentcoeff15
			rxeqeval0                 : out std_logic;                                         -- rxeqeval0
			rxeqeval1                 : out std_logic;                                         -- rxeqeval1
			rxeqeval2                 : out std_logic;                                         -- rxeqeval2
			rxeqeval3                 : out std_logic;                                         -- rxeqeval3
			rxeqeval4                 : out std_logic;                                         -- rxeqeval4
			rxeqeval5                 : out std_logic;                                         -- rxeqeval5
			rxeqeval6                 : out std_logic;                                         -- rxeqeval6
			rxeqeval7                 : out std_logic;                                         -- rxeqeval7
			rxeqeval8                 : out std_logic;                                         -- rxeqeval8
			rxeqeval9                 : out std_logic;                                         -- rxeqeval9
			rxeqeval10                : out std_logic;                                         -- rxeqeval10
			rxeqeval11                : out std_logic;                                         -- rxeqeval11
			rxeqeval12                : out std_logic;                                         -- rxeqeval12
			rxeqeval13                : out std_logic;                                         -- rxeqeval13
			rxeqeval14                : out std_logic;                                         -- rxeqeval14
			rxeqeval15                : out std_logic;                                         -- rxeqeval15
			rxeqinprogress0           : out std_logic;                                         -- rxeqinprogress0
			rxeqinprogress1           : out std_logic;                                         -- rxeqinprogress1
			rxeqinprogress2           : out std_logic;                                         -- rxeqinprogress2
			rxeqinprogress3           : out std_logic;                                         -- rxeqinprogress3
			rxeqinprogress4           : out std_logic;                                         -- rxeqinprogress4
			rxeqinprogress5           : out std_logic;                                         -- rxeqinprogress5
			rxeqinprogress6           : out std_logic;                                         -- rxeqinprogress6
			rxeqinprogress7           : out std_logic;                                         -- rxeqinprogress7
			rxeqinprogress8           : out std_logic;                                         -- rxeqinprogress8
			rxeqinprogress9           : out std_logic;                                         -- rxeqinprogress9
			rxeqinprogress10          : out std_logic;                                         -- rxeqinprogress10
			rxeqinprogress11          : out std_logic;                                         -- rxeqinprogress11
			rxeqinprogress12          : out std_logic;                                         -- rxeqinprogress12
			rxeqinprogress13          : out std_logic;                                         -- rxeqinprogress13
			rxeqinprogress14          : out std_logic;                                         -- rxeqinprogress14
			rxeqinprogress15          : out std_logic;                                         -- rxeqinprogress15
			invalidreq0               : out std_logic;                                         -- invalidreq0
			invalidreq1               : out std_logic;                                         -- invalidreq1
			invalidreq2               : out std_logic;                                         -- invalidreq2
			invalidreq3               : out std_logic;                                         -- invalidreq3
			invalidreq4               : out std_logic;                                         -- invalidreq4
			invalidreq5               : out std_logic;                                         -- invalidreq5
			invalidreq6               : out std_logic;                                         -- invalidreq6
			invalidreq7               : out std_logic;                                         -- invalidreq7
			invalidreq8               : out std_logic;                                         -- invalidreq8
			invalidreq9               : out std_logic;                                         -- invalidreq9
			invalidreq10              : out std_logic;                                         -- invalidreq10
			invalidreq11              : out std_logic;                                         -- invalidreq11
			invalidreq12              : out std_logic;                                         -- invalidreq12
			invalidreq13              : out std_logic;                                         -- invalidreq13
			invalidreq14              : out std_logic;                                         -- invalidreq14
			invalidreq15              : out std_logic;                                         -- invalidreq15
			rxdata0                   : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- rxdata0
			rxdata1                   : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- rxdata1
			rxdata2                   : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- rxdata2
			rxdata3                   : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- rxdata3
			rxdata4                   : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- rxdata4
			rxdata5                   : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- rxdata5
			rxdata6                   : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- rxdata6
			rxdata7                   : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- rxdata7
			rxdata8                   : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- rxdata8
			rxdata9                   : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- rxdata9
			rxdata10                  : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- rxdata10
			rxdata11                  : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- rxdata11
			rxdata12                  : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- rxdata12
			rxdata13                  : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- rxdata13
			rxdata14                  : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- rxdata14
			rxdata15                  : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- rxdata15
			rxdatak0                  : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- rxdatak0
			rxdatak1                  : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- rxdatak1
			rxdatak2                  : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- rxdatak2
			rxdatak3                  : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- rxdatak3
			rxdatak4                  : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- rxdatak4
			rxdatak5                  : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- rxdatak5
			rxdatak6                  : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- rxdatak6
			rxdatak7                  : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- rxdatak7
			rxdatak8                  : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- rxdatak8
			rxdatak9                  : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- rxdatak9
			rxdatak10                 : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- rxdatak10
			rxdatak11                 : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- rxdatak11
			rxdatak12                 : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- rxdatak12
			rxdatak13                 : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- rxdatak13
			rxdatak14                 : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- rxdatak14
			rxdatak15                 : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- rxdatak15
			phystatus0                : in  std_logic                      := 'X';             -- phystatus0
			phystatus1                : in  std_logic                      := 'X';             -- phystatus1
			phystatus2                : in  std_logic                      := 'X';             -- phystatus2
			phystatus3                : in  std_logic                      := 'X';             -- phystatus3
			phystatus4                : in  std_logic                      := 'X';             -- phystatus4
			phystatus5                : in  std_logic                      := 'X';             -- phystatus5
			phystatus6                : in  std_logic                      := 'X';             -- phystatus6
			phystatus7                : in  std_logic                      := 'X';             -- phystatus7
			phystatus8                : in  std_logic                      := 'X';             -- phystatus8
			phystatus9                : in  std_logic                      := 'X';             -- phystatus9
			phystatus10               : in  std_logic                      := 'X';             -- phystatus10
			phystatus11               : in  std_logic                      := 'X';             -- phystatus11
			phystatus12               : in  std_logic                      := 'X';             -- phystatus12
			phystatus13               : in  std_logic                      := 'X';             -- phystatus13
			phystatus14               : in  std_logic                      := 'X';             -- phystatus14
			phystatus15               : in  std_logic                      := 'X';             -- phystatus15
			rxvalid0                  : in  std_logic                      := 'X';             -- rxvalid0
			rxvalid1                  : in  std_logic                      := 'X';             -- rxvalid1
			rxvalid2                  : in  std_logic                      := 'X';             -- rxvalid2
			rxvalid3                  : in  std_logic                      := 'X';             -- rxvalid3
			rxvalid4                  : in  std_logic                      := 'X';             -- rxvalid4
			rxvalid5                  : in  std_logic                      := 'X';             -- rxvalid5
			rxvalid6                  : in  std_logic                      := 'X';             -- rxvalid6
			rxvalid7                  : in  std_logic                      := 'X';             -- rxvalid7
			rxvalid8                  : in  std_logic                      := 'X';             -- rxvalid8
			rxvalid9                  : in  std_logic                      := 'X';             -- rxvalid9
			rxvalid10                 : in  std_logic                      := 'X';             -- rxvalid10
			rxvalid11                 : in  std_logic                      := 'X';             -- rxvalid11
			rxvalid12                 : in  std_logic                      := 'X';             -- rxvalid12
			rxvalid13                 : in  std_logic                      := 'X';             -- rxvalid13
			rxvalid14                 : in  std_logic                      := 'X';             -- rxvalid14
			rxvalid15                 : in  std_logic                      := 'X';             -- rxvalid15
			rxstatus0                 : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- rxstatus0
			rxstatus1                 : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- rxstatus1
			rxstatus2                 : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- rxstatus2
			rxstatus3                 : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- rxstatus3
			rxstatus4                 : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- rxstatus4
			rxstatus5                 : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- rxstatus5
			rxstatus6                 : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- rxstatus6
			rxstatus7                 : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- rxstatus7
			rxstatus8                 : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- rxstatus8
			rxstatus9                 : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- rxstatus9
			rxstatus10                : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- rxstatus10
			rxstatus11                : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- rxstatus11
			rxstatus12                : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- rxstatus12
			rxstatus13                : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- rxstatus13
			rxstatus14                : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- rxstatus14
			rxstatus15                : in  std_logic_vector(2 downto 0)   := (others => 'X'); -- rxstatus15
			rxelecidle0               : in  std_logic                      := 'X';             -- rxelecidle0
			rxelecidle1               : in  std_logic                      := 'X';             -- rxelecidle1
			rxelecidle2               : in  std_logic                      := 'X';             -- rxelecidle2
			rxelecidle3               : in  std_logic                      := 'X';             -- rxelecidle3
			rxelecidle4               : in  std_logic                      := 'X';             -- rxelecidle4
			rxelecidle5               : in  std_logic                      := 'X';             -- rxelecidle5
			rxelecidle6               : in  std_logic                      := 'X';             -- rxelecidle6
			rxelecidle7               : in  std_logic                      := 'X';             -- rxelecidle7
			rxelecidle8               : in  std_logic                      := 'X';             -- rxelecidle8
			rxelecidle9               : in  std_logic                      := 'X';             -- rxelecidle9
			rxelecidle10              : in  std_logic                      := 'X';             -- rxelecidle10
			rxelecidle11              : in  std_logic                      := 'X';             -- rxelecidle11
			rxelecidle12              : in  std_logic                      := 'X';             -- rxelecidle12
			rxelecidle13              : in  std_logic                      := 'X';             -- rxelecidle13
			rxelecidle14              : in  std_logic                      := 'X';             -- rxelecidle14
			rxelecidle15              : in  std_logic                      := 'X';             -- rxelecidle15
			rxsynchd0                 : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rxsynchd0
			rxsynchd1                 : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rxsynchd1
			rxsynchd2                 : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rxsynchd2
			rxsynchd3                 : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rxsynchd3
			rxsynchd4                 : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rxsynchd4
			rxsynchd5                 : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rxsynchd5
			rxsynchd6                 : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rxsynchd6
			rxsynchd7                 : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rxsynchd7
			rxsynchd8                 : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rxsynchd8
			rxsynchd9                 : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rxsynchd9
			rxsynchd10                : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rxsynchd10
			rxsynchd11                : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rxsynchd11
			rxsynchd12                : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rxsynchd12
			rxsynchd13                : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rxsynchd13
			rxsynchd14                : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rxsynchd14
			rxsynchd15                : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rxsynchd15
			rxblkst0                  : in  std_logic                      := 'X';             -- rxblkst0
			rxblkst1                  : in  std_logic                      := 'X';             -- rxblkst1
			rxblkst2                  : in  std_logic                      := 'X';             -- rxblkst2
			rxblkst3                  : in  std_logic                      := 'X';             -- rxblkst3
			rxblkst4                  : in  std_logic                      := 'X';             -- rxblkst4
			rxblkst5                  : in  std_logic                      := 'X';             -- rxblkst5
			rxblkst6                  : in  std_logic                      := 'X';             -- rxblkst6
			rxblkst7                  : in  std_logic                      := 'X';             -- rxblkst7
			rxblkst8                  : in  std_logic                      := 'X';             -- rxblkst8
			rxblkst9                  : in  std_logic                      := 'X';             -- rxblkst9
			rxblkst10                 : in  std_logic                      := 'X';             -- rxblkst10
			rxblkst11                 : in  std_logic                      := 'X';             -- rxblkst11
			rxblkst12                 : in  std_logic                      := 'X';             -- rxblkst12
			rxblkst13                 : in  std_logic                      := 'X';             -- rxblkst13
			rxblkst14                 : in  std_logic                      := 'X';             -- rxblkst14
			rxblkst15                 : in  std_logic                      := 'X';             -- rxblkst15
			rxdataskip0               : in  std_logic                      := 'X';             -- rxdataskip0
			rxdataskip1               : in  std_logic                      := 'X';             -- rxdataskip1
			rxdataskip2               : in  std_logic                      := 'X';             -- rxdataskip2
			rxdataskip3               : in  std_logic                      := 'X';             -- rxdataskip3
			rxdataskip4               : in  std_logic                      := 'X';             -- rxdataskip4
			rxdataskip5               : in  std_logic                      := 'X';             -- rxdataskip5
			rxdataskip6               : in  std_logic                      := 'X';             -- rxdataskip6
			rxdataskip7               : in  std_logic                      := 'X';             -- rxdataskip7
			rxdataskip8               : in  std_logic                      := 'X';             -- rxdataskip8
			rxdataskip9               : in  std_logic                      := 'X';             -- rxdataskip9
			rxdataskip10              : in  std_logic                      := 'X';             -- rxdataskip10
			rxdataskip11              : in  std_logic                      := 'X';             -- rxdataskip11
			rxdataskip12              : in  std_logic                      := 'X';             -- rxdataskip12
			rxdataskip13              : in  std_logic                      := 'X';             -- rxdataskip13
			rxdataskip14              : in  std_logic                      := 'X';             -- rxdataskip14
			rxdataskip15              : in  std_logic                      := 'X';             -- rxdataskip15
			dirfeedback0              : in  std_logic_vector(5 downto 0)   := (others => 'X'); -- dirfeedback0
			dirfeedback1              : in  std_logic_vector(5 downto 0)   := (others => 'X'); -- dirfeedback1
			dirfeedback2              : in  std_logic_vector(5 downto 0)   := (others => 'X'); -- dirfeedback2
			dirfeedback3              : in  std_logic_vector(5 downto 0)   := (others => 'X'); -- dirfeedback3
			dirfeedback4              : in  std_logic_vector(5 downto 0)   := (others => 'X'); -- dirfeedback4
			dirfeedback5              : in  std_logic_vector(5 downto 0)   := (others => 'X'); -- dirfeedback5
			dirfeedback6              : in  std_logic_vector(5 downto 0)   := (others => 'X'); -- dirfeedback6
			dirfeedback7              : in  std_logic_vector(5 downto 0)   := (others => 'X'); -- dirfeedback7
			dirfeedback8              : in  std_logic_vector(5 downto 0)   := (others => 'X'); -- dirfeedback8
			dirfeedback9              : in  std_logic_vector(5 downto 0)   := (others => 'X'); -- dirfeedback9
			dirfeedback10             : in  std_logic_vector(5 downto 0)   := (others => 'X'); -- dirfeedback10
			dirfeedback11             : in  std_logic_vector(5 downto 0)   := (others => 'X'); -- dirfeedback11
			dirfeedback12             : in  std_logic_vector(5 downto 0)   := (others => 'X'); -- dirfeedback12
			dirfeedback13             : in  std_logic_vector(5 downto 0)   := (others => 'X'); -- dirfeedback13
			dirfeedback14             : in  std_logic_vector(5 downto 0)   := (others => 'X'); -- dirfeedback14
			dirfeedback15             : in  std_logic_vector(5 downto 0)   := (others => 'X'); -- dirfeedback15
			sim_pipe_mask_tx_pll_lock : in  std_logic                      := 'X';             -- sim_pipe_mask_tx_pll_lock
			rx_in0                    : in  std_logic                      := 'X';             -- rx_in0
			rx_in1                    : in  std_logic                      := 'X';             -- rx_in1
			rx_in2                    : in  std_logic                      := 'X';             -- rx_in2
			rx_in3                    : in  std_logic                      := 'X';             -- rx_in3
			rx_in4                    : in  std_logic                      := 'X';             -- rx_in4
			rx_in5                    : in  std_logic                      := 'X';             -- rx_in5
			rx_in6                    : in  std_logic                      := 'X';             -- rx_in6
			rx_in7                    : in  std_logic                      := 'X';             -- rx_in7
			rx_in8                    : in  std_logic                      := 'X';             -- rx_in8
			rx_in9                    : in  std_logic                      := 'X';             -- rx_in9
			rx_in10                   : in  std_logic                      := 'X';             -- rx_in10
			rx_in11                   : in  std_logic                      := 'X';             -- rx_in11
			rx_in12                   : in  std_logic                      := 'X';             -- rx_in12
			rx_in13                   : in  std_logic                      := 'X';             -- rx_in13
			rx_in14                   : in  std_logic                      := 'X';             -- rx_in14
			rx_in15                   : in  std_logic                      := 'X';             -- rx_in15
			tx_out0                   : out std_logic;                                         -- tx_out0
			tx_out1                   : out std_logic;                                         -- tx_out1
			tx_out2                   : out std_logic;                                         -- tx_out2
			tx_out3                   : out std_logic;                                         -- tx_out3
			tx_out4                   : out std_logic;                                         -- tx_out4
			tx_out5                   : out std_logic;                                         -- tx_out5
			tx_out6                   : out std_logic;                                         -- tx_out6
			tx_out7                   : out std_logic;                                         -- tx_out7
			tx_out8                   : out std_logic;                                         -- tx_out8
			tx_out9                   : out std_logic;                                         -- tx_out9
			tx_out10                  : out std_logic;                                         -- tx_out10
			tx_out11                  : out std_logic;                                         -- tx_out11
			tx_out12                  : out std_logic;                                         -- tx_out12
			tx_out13                  : out std_logic;                                         -- tx_out13
			tx_out14                  : out std_logic;                                         -- tx_out14
			tx_out15                  : out std_logic;                                         -- tx_out15
			tl_cfg_func_o             : out std_logic_vector(1 downto 0);                      -- tl_cfg_func
			tl_cfg_add_o              : out std_logic_vector(3 downto 0);                      -- tl_cfg_add
			tl_cfg_ctl_o              : out std_logic_vector(31 downto 0)                      -- tl_cfg_ctl
		);
	end component qsys_top_avmm_bridge_512_0;

	u0 : component qsys_top_avmm_bridge_512_0
		port map (
			refclk                    => CONNECTED_TO_refclk,                    --            refclk.clk
			coreclkout_hip            => CONNECTED_TO_coreclkout_hip,            --    coreclkout_hip.clk
			npor                      => CONNECTED_TO_npor,                      --              npor.npor
			pin_perst                 => CONNECTED_TO_pin_perst,                 --                  .pin_perst
			app_nreset_status         => CONNECTED_TO_app_nreset_status,         -- app_nreset_status.reset_n
			ninit_done                => CONNECTED_TO_ninit_done,                --        ninit_done.ninit_done
			bam_pfnum_o               => CONNECTED_TO_bam_pfnum_o,               --       bam_conduit.pfnum
			bam_bar_o                 => CONNECTED_TO_bam_bar_o,                 --                  .barnum
			bam_waitrequest_i         => CONNECTED_TO_bam_waitrequest_i,         --        bam_master.waitrequest
			bam_address_o             => CONNECTED_TO_bam_address_o,             --                  .address
			bam_byteenable_o          => CONNECTED_TO_bam_byteenable_o,          --                  .byteenable
			bam_read_o                => CONNECTED_TO_bam_read_o,                --                  .read
			bam_readdata_i            => CONNECTED_TO_bam_readdata_i,            --                  .readdata
			bam_readdatavalid_i       => CONNECTED_TO_bam_readdatavalid_i,       --                  .readdatavalid
			bam_write_o               => CONNECTED_TO_bam_write_o,               --                  .write
			bam_writedata_o           => CONNECTED_TO_bam_writedata_o,           --                  .writedata
			bam_burstcount_o          => CONNECTED_TO_bam_burstcount_o,          --                  .burstcount
			bam_response_i            => CONNECTED_TO_bam_response_i,            --                  .response
			bam_writeresponsevalid_i  => CONNECTED_TO_bam_writeresponsevalid_i,  --                  .writeresponsevalid
			flr_pf_done_i             => CONNECTED_TO_flr_pf_done_i,             --          flr_ctrl.flr_pf_done
			flr_pf_active_o           => CONNECTED_TO_flr_pf_active_o,           --                  .flr_pf_active
			bus_master_enable_o       => CONNECTED_TO_bus_master_enable_o,       -- bus_master_enable.bus_master_enable
			simu_mode_pipe            => CONNECTED_TO_simu_mode_pipe,            --          hip_ctrl.simu_mode_pipe
			test_in                   => CONNECTED_TO_test_in,                   --                  .test_in
			sim_pipe_pclk_in          => CONNECTED_TO_sim_pipe_pclk_in,          --          hip_pipe.sim_pipe_pclk_in
			sim_pipe_rate             => CONNECTED_TO_sim_pipe_rate,             --                  .sim_pipe_rate
			sim_ltssmstate            => CONNECTED_TO_sim_ltssmstate,            --                  .sim_ltssmstate
			txdata0                   => CONNECTED_TO_txdata0,                   --                  .txdata0
			txdata1                   => CONNECTED_TO_txdata1,                   --                  .txdata1
			txdata2                   => CONNECTED_TO_txdata2,                   --                  .txdata2
			txdata3                   => CONNECTED_TO_txdata3,                   --                  .txdata3
			txdata4                   => CONNECTED_TO_txdata4,                   --                  .txdata4
			txdata5                   => CONNECTED_TO_txdata5,                   --                  .txdata5
			txdata6                   => CONNECTED_TO_txdata6,                   --                  .txdata6
			txdata7                   => CONNECTED_TO_txdata7,                   --                  .txdata7
			txdata8                   => CONNECTED_TO_txdata8,                   --                  .txdata8
			txdata9                   => CONNECTED_TO_txdata9,                   --                  .txdata9
			txdata10                  => CONNECTED_TO_txdata10,                  --                  .txdata10
			txdata11                  => CONNECTED_TO_txdata11,                  --                  .txdata11
			txdata12                  => CONNECTED_TO_txdata12,                  --                  .txdata12
			txdata13                  => CONNECTED_TO_txdata13,                  --                  .txdata13
			txdata14                  => CONNECTED_TO_txdata14,                  --                  .txdata14
			txdata15                  => CONNECTED_TO_txdata15,                  --                  .txdata15
			txdatak0                  => CONNECTED_TO_txdatak0,                  --                  .txdatak0
			txdatak1                  => CONNECTED_TO_txdatak1,                  --                  .txdatak1
			txdatak2                  => CONNECTED_TO_txdatak2,                  --                  .txdatak2
			txdatak3                  => CONNECTED_TO_txdatak3,                  --                  .txdatak3
			txdatak4                  => CONNECTED_TO_txdatak4,                  --                  .txdatak4
			txdatak5                  => CONNECTED_TO_txdatak5,                  --                  .txdatak5
			txdatak6                  => CONNECTED_TO_txdatak6,                  --                  .txdatak6
			txdatak7                  => CONNECTED_TO_txdatak7,                  --                  .txdatak7
			txdatak8                  => CONNECTED_TO_txdatak8,                  --                  .txdatak8
			txdatak9                  => CONNECTED_TO_txdatak9,                  --                  .txdatak9
			txdatak10                 => CONNECTED_TO_txdatak10,                 --                  .txdatak10
			txdatak11                 => CONNECTED_TO_txdatak11,                 --                  .txdatak11
			txdatak12                 => CONNECTED_TO_txdatak12,                 --                  .txdatak12
			txdatak13                 => CONNECTED_TO_txdatak13,                 --                  .txdatak13
			txdatak14                 => CONNECTED_TO_txdatak14,                 --                  .txdatak14
			txdatak15                 => CONNECTED_TO_txdatak15,                 --                  .txdatak15
			txcompl0                  => CONNECTED_TO_txcompl0,                  --                  .txcompl0
			txcompl1                  => CONNECTED_TO_txcompl1,                  --                  .txcompl1
			txcompl2                  => CONNECTED_TO_txcompl2,                  --                  .txcompl2
			txcompl3                  => CONNECTED_TO_txcompl3,                  --                  .txcompl3
			txcompl4                  => CONNECTED_TO_txcompl4,                  --                  .txcompl4
			txcompl5                  => CONNECTED_TO_txcompl5,                  --                  .txcompl5
			txcompl6                  => CONNECTED_TO_txcompl6,                  --                  .txcompl6
			txcompl7                  => CONNECTED_TO_txcompl7,                  --                  .txcompl7
			txcompl8                  => CONNECTED_TO_txcompl8,                  --                  .txcompl8
			txcompl9                  => CONNECTED_TO_txcompl9,                  --                  .txcompl9
			txcompl10                 => CONNECTED_TO_txcompl10,                 --                  .txcompl10
			txcompl11                 => CONNECTED_TO_txcompl11,                 --                  .txcompl11
			txcompl12                 => CONNECTED_TO_txcompl12,                 --                  .txcompl12
			txcompl13                 => CONNECTED_TO_txcompl13,                 --                  .txcompl13
			txcompl14                 => CONNECTED_TO_txcompl14,                 --                  .txcompl14
			txcompl15                 => CONNECTED_TO_txcompl15,                 --                  .txcompl15
			txelecidle0               => CONNECTED_TO_txelecidle0,               --                  .txelecidle0
			txelecidle1               => CONNECTED_TO_txelecidle1,               --                  .txelecidle1
			txelecidle2               => CONNECTED_TO_txelecidle2,               --                  .txelecidle2
			txelecidle3               => CONNECTED_TO_txelecidle3,               --                  .txelecidle3
			txelecidle4               => CONNECTED_TO_txelecidle4,               --                  .txelecidle4
			txelecidle5               => CONNECTED_TO_txelecidle5,               --                  .txelecidle5
			txelecidle6               => CONNECTED_TO_txelecidle6,               --                  .txelecidle6
			txelecidle7               => CONNECTED_TO_txelecidle7,               --                  .txelecidle7
			txelecidle8               => CONNECTED_TO_txelecidle8,               --                  .txelecidle8
			txelecidle9               => CONNECTED_TO_txelecidle9,               --                  .txelecidle9
			txelecidle10              => CONNECTED_TO_txelecidle10,              --                  .txelecidle10
			txelecidle11              => CONNECTED_TO_txelecidle11,              --                  .txelecidle11
			txelecidle12              => CONNECTED_TO_txelecidle12,              --                  .txelecidle12
			txelecidle13              => CONNECTED_TO_txelecidle13,              --                  .txelecidle13
			txelecidle14              => CONNECTED_TO_txelecidle14,              --                  .txelecidle14
			txelecidle15              => CONNECTED_TO_txelecidle15,              --                  .txelecidle15
			txdetectrx0               => CONNECTED_TO_txdetectrx0,               --                  .txdetectrx0
			txdetectrx1               => CONNECTED_TO_txdetectrx1,               --                  .txdetectrx1
			txdetectrx2               => CONNECTED_TO_txdetectrx2,               --                  .txdetectrx2
			txdetectrx3               => CONNECTED_TO_txdetectrx3,               --                  .txdetectrx3
			txdetectrx4               => CONNECTED_TO_txdetectrx4,               --                  .txdetectrx4
			txdetectrx5               => CONNECTED_TO_txdetectrx5,               --                  .txdetectrx5
			txdetectrx6               => CONNECTED_TO_txdetectrx6,               --                  .txdetectrx6
			txdetectrx7               => CONNECTED_TO_txdetectrx7,               --                  .txdetectrx7
			txdetectrx8               => CONNECTED_TO_txdetectrx8,               --                  .txdetectrx8
			txdetectrx9               => CONNECTED_TO_txdetectrx9,               --                  .txdetectrx9
			txdetectrx10              => CONNECTED_TO_txdetectrx10,              --                  .txdetectrx10
			txdetectrx11              => CONNECTED_TO_txdetectrx11,              --                  .txdetectrx11
			txdetectrx12              => CONNECTED_TO_txdetectrx12,              --                  .txdetectrx12
			txdetectrx13              => CONNECTED_TO_txdetectrx13,              --                  .txdetectrx13
			txdetectrx14              => CONNECTED_TO_txdetectrx14,              --                  .txdetectrx14
			txdetectrx15              => CONNECTED_TO_txdetectrx15,              --                  .txdetectrx15
			powerdown0                => CONNECTED_TO_powerdown0,                --                  .powerdown0
			powerdown1                => CONNECTED_TO_powerdown1,                --                  .powerdown1
			powerdown2                => CONNECTED_TO_powerdown2,                --                  .powerdown2
			powerdown3                => CONNECTED_TO_powerdown3,                --                  .powerdown3
			powerdown4                => CONNECTED_TO_powerdown4,                --                  .powerdown4
			powerdown5                => CONNECTED_TO_powerdown5,                --                  .powerdown5
			powerdown6                => CONNECTED_TO_powerdown6,                --                  .powerdown6
			powerdown7                => CONNECTED_TO_powerdown7,                --                  .powerdown7
			powerdown8                => CONNECTED_TO_powerdown8,                --                  .powerdown8
			powerdown9                => CONNECTED_TO_powerdown9,                --                  .powerdown9
			powerdown10               => CONNECTED_TO_powerdown10,               --                  .powerdown10
			powerdown11               => CONNECTED_TO_powerdown11,               --                  .powerdown11
			powerdown12               => CONNECTED_TO_powerdown12,               --                  .powerdown12
			powerdown13               => CONNECTED_TO_powerdown13,               --                  .powerdown13
			powerdown14               => CONNECTED_TO_powerdown14,               --                  .powerdown14
			powerdown15               => CONNECTED_TO_powerdown15,               --                  .powerdown15
			txmargin0                 => CONNECTED_TO_txmargin0,                 --                  .txmargin0
			txmargin1                 => CONNECTED_TO_txmargin1,                 --                  .txmargin1
			txmargin2                 => CONNECTED_TO_txmargin2,                 --                  .txmargin2
			txmargin3                 => CONNECTED_TO_txmargin3,                 --                  .txmargin3
			txmargin4                 => CONNECTED_TO_txmargin4,                 --                  .txmargin4
			txmargin5                 => CONNECTED_TO_txmargin5,                 --                  .txmargin5
			txmargin6                 => CONNECTED_TO_txmargin6,                 --                  .txmargin6
			txmargin7                 => CONNECTED_TO_txmargin7,                 --                  .txmargin7
			txmargin8                 => CONNECTED_TO_txmargin8,                 --                  .txmargin8
			txmargin9                 => CONNECTED_TO_txmargin9,                 --                  .txmargin9
			txmargin10                => CONNECTED_TO_txmargin10,                --                  .txmargin10
			txmargin11                => CONNECTED_TO_txmargin11,                --                  .txmargin11
			txmargin12                => CONNECTED_TO_txmargin12,                --                  .txmargin12
			txmargin13                => CONNECTED_TO_txmargin13,                --                  .txmargin13
			txmargin14                => CONNECTED_TO_txmargin14,                --                  .txmargin14
			txmargin15                => CONNECTED_TO_txmargin15,                --                  .txmargin15
			txdeemph0                 => CONNECTED_TO_txdeemph0,                 --                  .txdeemph0
			txdeemph1                 => CONNECTED_TO_txdeemph1,                 --                  .txdeemph1
			txdeemph2                 => CONNECTED_TO_txdeemph2,                 --                  .txdeemph2
			txdeemph3                 => CONNECTED_TO_txdeemph3,                 --                  .txdeemph3
			txdeemph4                 => CONNECTED_TO_txdeemph4,                 --                  .txdeemph4
			txdeemph5                 => CONNECTED_TO_txdeemph5,                 --                  .txdeemph5
			txdeemph6                 => CONNECTED_TO_txdeemph6,                 --                  .txdeemph6
			txdeemph7                 => CONNECTED_TO_txdeemph7,                 --                  .txdeemph7
			txdeemph8                 => CONNECTED_TO_txdeemph8,                 --                  .txdeemph8
			txdeemph9                 => CONNECTED_TO_txdeemph9,                 --                  .txdeemph9
			txdeemph10                => CONNECTED_TO_txdeemph10,                --                  .txdeemph10
			txdeemph11                => CONNECTED_TO_txdeemph11,                --                  .txdeemph11
			txdeemph12                => CONNECTED_TO_txdeemph12,                --                  .txdeemph12
			txdeemph13                => CONNECTED_TO_txdeemph13,                --                  .txdeemph13
			txdeemph14                => CONNECTED_TO_txdeemph14,                --                  .txdeemph14
			txdeemph15                => CONNECTED_TO_txdeemph15,                --                  .txdeemph15
			txswing0                  => CONNECTED_TO_txswing0,                  --                  .txswing0
			txswing1                  => CONNECTED_TO_txswing1,                  --                  .txswing1
			txswing2                  => CONNECTED_TO_txswing2,                  --                  .txswing2
			txswing3                  => CONNECTED_TO_txswing3,                  --                  .txswing3
			txswing4                  => CONNECTED_TO_txswing4,                  --                  .txswing4
			txswing5                  => CONNECTED_TO_txswing5,                  --                  .txswing5
			txswing6                  => CONNECTED_TO_txswing6,                  --                  .txswing6
			txswing7                  => CONNECTED_TO_txswing7,                  --                  .txswing7
			txswing8                  => CONNECTED_TO_txswing8,                  --                  .txswing8
			txswing9                  => CONNECTED_TO_txswing9,                  --                  .txswing9
			txswing10                 => CONNECTED_TO_txswing10,                 --                  .txswing10
			txswing11                 => CONNECTED_TO_txswing11,                 --                  .txswing11
			txswing12                 => CONNECTED_TO_txswing12,                 --                  .txswing12
			txswing13                 => CONNECTED_TO_txswing13,                 --                  .txswing13
			txswing14                 => CONNECTED_TO_txswing14,                 --                  .txswing14
			txswing15                 => CONNECTED_TO_txswing15,                 --                  .txswing15
			txsynchd0                 => CONNECTED_TO_txsynchd0,                 --                  .txsynchd0
			txsynchd1                 => CONNECTED_TO_txsynchd1,                 --                  .txsynchd1
			txsynchd2                 => CONNECTED_TO_txsynchd2,                 --                  .txsynchd2
			txsynchd3                 => CONNECTED_TO_txsynchd3,                 --                  .txsynchd3
			txsynchd4                 => CONNECTED_TO_txsynchd4,                 --                  .txsynchd4
			txsynchd5                 => CONNECTED_TO_txsynchd5,                 --                  .txsynchd5
			txsynchd6                 => CONNECTED_TO_txsynchd6,                 --                  .txsynchd6
			txsynchd7                 => CONNECTED_TO_txsynchd7,                 --                  .txsynchd7
			txsynchd8                 => CONNECTED_TO_txsynchd8,                 --                  .txsynchd8
			txsynchd9                 => CONNECTED_TO_txsynchd9,                 --                  .txsynchd9
			txsynchd10                => CONNECTED_TO_txsynchd10,                --                  .txsynchd10
			txsynchd11                => CONNECTED_TO_txsynchd11,                --                  .txsynchd11
			txsynchd12                => CONNECTED_TO_txsynchd12,                --                  .txsynchd12
			txsynchd13                => CONNECTED_TO_txsynchd13,                --                  .txsynchd13
			txsynchd14                => CONNECTED_TO_txsynchd14,                --                  .txsynchd14
			txsynchd15                => CONNECTED_TO_txsynchd15,                --                  .txsynchd15
			txblkst0                  => CONNECTED_TO_txblkst0,                  --                  .txblkst0
			txblkst1                  => CONNECTED_TO_txblkst1,                  --                  .txblkst1
			txblkst2                  => CONNECTED_TO_txblkst2,                  --                  .txblkst2
			txblkst3                  => CONNECTED_TO_txblkst3,                  --                  .txblkst3
			txblkst4                  => CONNECTED_TO_txblkst4,                  --                  .txblkst4
			txblkst5                  => CONNECTED_TO_txblkst5,                  --                  .txblkst5
			txblkst6                  => CONNECTED_TO_txblkst6,                  --                  .txblkst6
			txblkst7                  => CONNECTED_TO_txblkst7,                  --                  .txblkst7
			txblkst8                  => CONNECTED_TO_txblkst8,                  --                  .txblkst8
			txblkst9                  => CONNECTED_TO_txblkst9,                  --                  .txblkst9
			txblkst10                 => CONNECTED_TO_txblkst10,                 --                  .txblkst10
			txblkst11                 => CONNECTED_TO_txblkst11,                 --                  .txblkst11
			txblkst12                 => CONNECTED_TO_txblkst12,                 --                  .txblkst12
			txblkst13                 => CONNECTED_TO_txblkst13,                 --                  .txblkst13
			txblkst14                 => CONNECTED_TO_txblkst14,                 --                  .txblkst14
			txblkst15                 => CONNECTED_TO_txblkst15,                 --                  .txblkst15
			txdataskip0               => CONNECTED_TO_txdataskip0,               --                  .txdataskip0
			txdataskip1               => CONNECTED_TO_txdataskip1,               --                  .txdataskip1
			txdataskip2               => CONNECTED_TO_txdataskip2,               --                  .txdataskip2
			txdataskip3               => CONNECTED_TO_txdataskip3,               --                  .txdataskip3
			txdataskip4               => CONNECTED_TO_txdataskip4,               --                  .txdataskip4
			txdataskip5               => CONNECTED_TO_txdataskip5,               --                  .txdataskip5
			txdataskip6               => CONNECTED_TO_txdataskip6,               --                  .txdataskip6
			txdataskip7               => CONNECTED_TO_txdataskip7,               --                  .txdataskip7
			txdataskip8               => CONNECTED_TO_txdataskip8,               --                  .txdataskip8
			txdataskip9               => CONNECTED_TO_txdataskip9,               --                  .txdataskip9
			txdataskip10              => CONNECTED_TO_txdataskip10,              --                  .txdataskip10
			txdataskip11              => CONNECTED_TO_txdataskip11,              --                  .txdataskip11
			txdataskip12              => CONNECTED_TO_txdataskip12,              --                  .txdataskip12
			txdataskip13              => CONNECTED_TO_txdataskip13,              --                  .txdataskip13
			txdataskip14              => CONNECTED_TO_txdataskip14,              --                  .txdataskip14
			txdataskip15              => CONNECTED_TO_txdataskip15,              --                  .txdataskip15
			rate0                     => CONNECTED_TO_rate0,                     --                  .rate0
			rate1                     => CONNECTED_TO_rate1,                     --                  .rate1
			rate2                     => CONNECTED_TO_rate2,                     --                  .rate2
			rate3                     => CONNECTED_TO_rate3,                     --                  .rate3
			rate4                     => CONNECTED_TO_rate4,                     --                  .rate4
			rate5                     => CONNECTED_TO_rate5,                     --                  .rate5
			rate6                     => CONNECTED_TO_rate6,                     --                  .rate6
			rate7                     => CONNECTED_TO_rate7,                     --                  .rate7
			rate8                     => CONNECTED_TO_rate8,                     --                  .rate8
			rate9                     => CONNECTED_TO_rate9,                     --                  .rate9
			rate10                    => CONNECTED_TO_rate10,                    --                  .rate10
			rate11                    => CONNECTED_TO_rate11,                    --                  .rate11
			rate12                    => CONNECTED_TO_rate12,                    --                  .rate12
			rate13                    => CONNECTED_TO_rate13,                    --                  .rate13
			rate14                    => CONNECTED_TO_rate14,                    --                  .rate14
			rate15                    => CONNECTED_TO_rate15,                    --                  .rate15
			rxpolarity0               => CONNECTED_TO_rxpolarity0,               --                  .rxpolarity0
			rxpolarity1               => CONNECTED_TO_rxpolarity1,               --                  .rxpolarity1
			rxpolarity2               => CONNECTED_TO_rxpolarity2,               --                  .rxpolarity2
			rxpolarity3               => CONNECTED_TO_rxpolarity3,               --                  .rxpolarity3
			rxpolarity4               => CONNECTED_TO_rxpolarity4,               --                  .rxpolarity4
			rxpolarity5               => CONNECTED_TO_rxpolarity5,               --                  .rxpolarity5
			rxpolarity6               => CONNECTED_TO_rxpolarity6,               --                  .rxpolarity6
			rxpolarity7               => CONNECTED_TO_rxpolarity7,               --                  .rxpolarity7
			rxpolarity8               => CONNECTED_TO_rxpolarity8,               --                  .rxpolarity8
			rxpolarity9               => CONNECTED_TO_rxpolarity9,               --                  .rxpolarity9
			rxpolarity10              => CONNECTED_TO_rxpolarity10,              --                  .rxpolarity10
			rxpolarity11              => CONNECTED_TO_rxpolarity11,              --                  .rxpolarity11
			rxpolarity12              => CONNECTED_TO_rxpolarity12,              --                  .rxpolarity12
			rxpolarity13              => CONNECTED_TO_rxpolarity13,              --                  .rxpolarity13
			rxpolarity14              => CONNECTED_TO_rxpolarity14,              --                  .rxpolarity14
			rxpolarity15              => CONNECTED_TO_rxpolarity15,              --                  .rxpolarity15
			currentrxpreset0          => CONNECTED_TO_currentrxpreset0,          --                  .currentrxpreset0
			currentrxpreset1          => CONNECTED_TO_currentrxpreset1,          --                  .currentrxpreset1
			currentrxpreset2          => CONNECTED_TO_currentrxpreset2,          --                  .currentrxpreset2
			currentrxpreset3          => CONNECTED_TO_currentrxpreset3,          --                  .currentrxpreset3
			currentrxpreset4          => CONNECTED_TO_currentrxpreset4,          --                  .currentrxpreset4
			currentrxpreset5          => CONNECTED_TO_currentrxpreset5,          --                  .currentrxpreset5
			currentrxpreset6          => CONNECTED_TO_currentrxpreset6,          --                  .currentrxpreset6
			currentrxpreset7          => CONNECTED_TO_currentrxpreset7,          --                  .currentrxpreset7
			currentrxpreset8          => CONNECTED_TO_currentrxpreset8,          --                  .currentrxpreset8
			currentrxpreset9          => CONNECTED_TO_currentrxpreset9,          --                  .currentrxpreset9
			currentrxpreset10         => CONNECTED_TO_currentrxpreset10,         --                  .currentrxpreset10
			currentrxpreset11         => CONNECTED_TO_currentrxpreset11,         --                  .currentrxpreset11
			currentrxpreset12         => CONNECTED_TO_currentrxpreset12,         --                  .currentrxpreset12
			currentrxpreset13         => CONNECTED_TO_currentrxpreset13,         --                  .currentrxpreset13
			currentrxpreset14         => CONNECTED_TO_currentrxpreset14,         --                  .currentrxpreset14
			currentrxpreset15         => CONNECTED_TO_currentrxpreset15,         --                  .currentrxpreset15
			currentcoeff0             => CONNECTED_TO_currentcoeff0,             --                  .currentcoeff0
			currentcoeff1             => CONNECTED_TO_currentcoeff1,             --                  .currentcoeff1
			currentcoeff2             => CONNECTED_TO_currentcoeff2,             --                  .currentcoeff2
			currentcoeff3             => CONNECTED_TO_currentcoeff3,             --                  .currentcoeff3
			currentcoeff4             => CONNECTED_TO_currentcoeff4,             --                  .currentcoeff4
			currentcoeff5             => CONNECTED_TO_currentcoeff5,             --                  .currentcoeff5
			currentcoeff6             => CONNECTED_TO_currentcoeff6,             --                  .currentcoeff6
			currentcoeff7             => CONNECTED_TO_currentcoeff7,             --                  .currentcoeff7
			currentcoeff8             => CONNECTED_TO_currentcoeff8,             --                  .currentcoeff8
			currentcoeff9             => CONNECTED_TO_currentcoeff9,             --                  .currentcoeff9
			currentcoeff10            => CONNECTED_TO_currentcoeff10,            --                  .currentcoeff10
			currentcoeff11            => CONNECTED_TO_currentcoeff11,            --                  .currentcoeff11
			currentcoeff12            => CONNECTED_TO_currentcoeff12,            --                  .currentcoeff12
			currentcoeff13            => CONNECTED_TO_currentcoeff13,            --                  .currentcoeff13
			currentcoeff14            => CONNECTED_TO_currentcoeff14,            --                  .currentcoeff14
			currentcoeff15            => CONNECTED_TO_currentcoeff15,            --                  .currentcoeff15
			rxeqeval0                 => CONNECTED_TO_rxeqeval0,                 --                  .rxeqeval0
			rxeqeval1                 => CONNECTED_TO_rxeqeval1,                 --                  .rxeqeval1
			rxeqeval2                 => CONNECTED_TO_rxeqeval2,                 --                  .rxeqeval2
			rxeqeval3                 => CONNECTED_TO_rxeqeval3,                 --                  .rxeqeval3
			rxeqeval4                 => CONNECTED_TO_rxeqeval4,                 --                  .rxeqeval4
			rxeqeval5                 => CONNECTED_TO_rxeqeval5,                 --                  .rxeqeval5
			rxeqeval6                 => CONNECTED_TO_rxeqeval6,                 --                  .rxeqeval6
			rxeqeval7                 => CONNECTED_TO_rxeqeval7,                 --                  .rxeqeval7
			rxeqeval8                 => CONNECTED_TO_rxeqeval8,                 --                  .rxeqeval8
			rxeqeval9                 => CONNECTED_TO_rxeqeval9,                 --                  .rxeqeval9
			rxeqeval10                => CONNECTED_TO_rxeqeval10,                --                  .rxeqeval10
			rxeqeval11                => CONNECTED_TO_rxeqeval11,                --                  .rxeqeval11
			rxeqeval12                => CONNECTED_TO_rxeqeval12,                --                  .rxeqeval12
			rxeqeval13                => CONNECTED_TO_rxeqeval13,                --                  .rxeqeval13
			rxeqeval14                => CONNECTED_TO_rxeqeval14,                --                  .rxeqeval14
			rxeqeval15                => CONNECTED_TO_rxeqeval15,                --                  .rxeqeval15
			rxeqinprogress0           => CONNECTED_TO_rxeqinprogress0,           --                  .rxeqinprogress0
			rxeqinprogress1           => CONNECTED_TO_rxeqinprogress1,           --                  .rxeqinprogress1
			rxeqinprogress2           => CONNECTED_TO_rxeqinprogress2,           --                  .rxeqinprogress2
			rxeqinprogress3           => CONNECTED_TO_rxeqinprogress3,           --                  .rxeqinprogress3
			rxeqinprogress4           => CONNECTED_TO_rxeqinprogress4,           --                  .rxeqinprogress4
			rxeqinprogress5           => CONNECTED_TO_rxeqinprogress5,           --                  .rxeqinprogress5
			rxeqinprogress6           => CONNECTED_TO_rxeqinprogress6,           --                  .rxeqinprogress6
			rxeqinprogress7           => CONNECTED_TO_rxeqinprogress7,           --                  .rxeqinprogress7
			rxeqinprogress8           => CONNECTED_TO_rxeqinprogress8,           --                  .rxeqinprogress8
			rxeqinprogress9           => CONNECTED_TO_rxeqinprogress9,           --                  .rxeqinprogress9
			rxeqinprogress10          => CONNECTED_TO_rxeqinprogress10,          --                  .rxeqinprogress10
			rxeqinprogress11          => CONNECTED_TO_rxeqinprogress11,          --                  .rxeqinprogress11
			rxeqinprogress12          => CONNECTED_TO_rxeqinprogress12,          --                  .rxeqinprogress12
			rxeqinprogress13          => CONNECTED_TO_rxeqinprogress13,          --                  .rxeqinprogress13
			rxeqinprogress14          => CONNECTED_TO_rxeqinprogress14,          --                  .rxeqinprogress14
			rxeqinprogress15          => CONNECTED_TO_rxeqinprogress15,          --                  .rxeqinprogress15
			invalidreq0               => CONNECTED_TO_invalidreq0,               --                  .invalidreq0
			invalidreq1               => CONNECTED_TO_invalidreq1,               --                  .invalidreq1
			invalidreq2               => CONNECTED_TO_invalidreq2,               --                  .invalidreq2
			invalidreq3               => CONNECTED_TO_invalidreq3,               --                  .invalidreq3
			invalidreq4               => CONNECTED_TO_invalidreq4,               --                  .invalidreq4
			invalidreq5               => CONNECTED_TO_invalidreq5,               --                  .invalidreq5
			invalidreq6               => CONNECTED_TO_invalidreq6,               --                  .invalidreq6
			invalidreq7               => CONNECTED_TO_invalidreq7,               --                  .invalidreq7
			invalidreq8               => CONNECTED_TO_invalidreq8,               --                  .invalidreq8
			invalidreq9               => CONNECTED_TO_invalidreq9,               --                  .invalidreq9
			invalidreq10              => CONNECTED_TO_invalidreq10,              --                  .invalidreq10
			invalidreq11              => CONNECTED_TO_invalidreq11,              --                  .invalidreq11
			invalidreq12              => CONNECTED_TO_invalidreq12,              --                  .invalidreq12
			invalidreq13              => CONNECTED_TO_invalidreq13,              --                  .invalidreq13
			invalidreq14              => CONNECTED_TO_invalidreq14,              --                  .invalidreq14
			invalidreq15              => CONNECTED_TO_invalidreq15,              --                  .invalidreq15
			rxdata0                   => CONNECTED_TO_rxdata0,                   --                  .rxdata0
			rxdata1                   => CONNECTED_TO_rxdata1,                   --                  .rxdata1
			rxdata2                   => CONNECTED_TO_rxdata2,                   --                  .rxdata2
			rxdata3                   => CONNECTED_TO_rxdata3,                   --                  .rxdata3
			rxdata4                   => CONNECTED_TO_rxdata4,                   --                  .rxdata4
			rxdata5                   => CONNECTED_TO_rxdata5,                   --                  .rxdata5
			rxdata6                   => CONNECTED_TO_rxdata6,                   --                  .rxdata6
			rxdata7                   => CONNECTED_TO_rxdata7,                   --                  .rxdata7
			rxdata8                   => CONNECTED_TO_rxdata8,                   --                  .rxdata8
			rxdata9                   => CONNECTED_TO_rxdata9,                   --                  .rxdata9
			rxdata10                  => CONNECTED_TO_rxdata10,                  --                  .rxdata10
			rxdata11                  => CONNECTED_TO_rxdata11,                  --                  .rxdata11
			rxdata12                  => CONNECTED_TO_rxdata12,                  --                  .rxdata12
			rxdata13                  => CONNECTED_TO_rxdata13,                  --                  .rxdata13
			rxdata14                  => CONNECTED_TO_rxdata14,                  --                  .rxdata14
			rxdata15                  => CONNECTED_TO_rxdata15,                  --                  .rxdata15
			rxdatak0                  => CONNECTED_TO_rxdatak0,                  --                  .rxdatak0
			rxdatak1                  => CONNECTED_TO_rxdatak1,                  --                  .rxdatak1
			rxdatak2                  => CONNECTED_TO_rxdatak2,                  --                  .rxdatak2
			rxdatak3                  => CONNECTED_TO_rxdatak3,                  --                  .rxdatak3
			rxdatak4                  => CONNECTED_TO_rxdatak4,                  --                  .rxdatak4
			rxdatak5                  => CONNECTED_TO_rxdatak5,                  --                  .rxdatak5
			rxdatak6                  => CONNECTED_TO_rxdatak6,                  --                  .rxdatak6
			rxdatak7                  => CONNECTED_TO_rxdatak7,                  --                  .rxdatak7
			rxdatak8                  => CONNECTED_TO_rxdatak8,                  --                  .rxdatak8
			rxdatak9                  => CONNECTED_TO_rxdatak9,                  --                  .rxdatak9
			rxdatak10                 => CONNECTED_TO_rxdatak10,                 --                  .rxdatak10
			rxdatak11                 => CONNECTED_TO_rxdatak11,                 --                  .rxdatak11
			rxdatak12                 => CONNECTED_TO_rxdatak12,                 --                  .rxdatak12
			rxdatak13                 => CONNECTED_TO_rxdatak13,                 --                  .rxdatak13
			rxdatak14                 => CONNECTED_TO_rxdatak14,                 --                  .rxdatak14
			rxdatak15                 => CONNECTED_TO_rxdatak15,                 --                  .rxdatak15
			phystatus0                => CONNECTED_TO_phystatus0,                --                  .phystatus0
			phystatus1                => CONNECTED_TO_phystatus1,                --                  .phystatus1
			phystatus2                => CONNECTED_TO_phystatus2,                --                  .phystatus2
			phystatus3                => CONNECTED_TO_phystatus3,                --                  .phystatus3
			phystatus4                => CONNECTED_TO_phystatus4,                --                  .phystatus4
			phystatus5                => CONNECTED_TO_phystatus5,                --                  .phystatus5
			phystatus6                => CONNECTED_TO_phystatus6,                --                  .phystatus6
			phystatus7                => CONNECTED_TO_phystatus7,                --                  .phystatus7
			phystatus8                => CONNECTED_TO_phystatus8,                --                  .phystatus8
			phystatus9                => CONNECTED_TO_phystatus9,                --                  .phystatus9
			phystatus10               => CONNECTED_TO_phystatus10,               --                  .phystatus10
			phystatus11               => CONNECTED_TO_phystatus11,               --                  .phystatus11
			phystatus12               => CONNECTED_TO_phystatus12,               --                  .phystatus12
			phystatus13               => CONNECTED_TO_phystatus13,               --                  .phystatus13
			phystatus14               => CONNECTED_TO_phystatus14,               --                  .phystatus14
			phystatus15               => CONNECTED_TO_phystatus15,               --                  .phystatus15
			rxvalid0                  => CONNECTED_TO_rxvalid0,                  --                  .rxvalid0
			rxvalid1                  => CONNECTED_TO_rxvalid1,                  --                  .rxvalid1
			rxvalid2                  => CONNECTED_TO_rxvalid2,                  --                  .rxvalid2
			rxvalid3                  => CONNECTED_TO_rxvalid3,                  --                  .rxvalid3
			rxvalid4                  => CONNECTED_TO_rxvalid4,                  --                  .rxvalid4
			rxvalid5                  => CONNECTED_TO_rxvalid5,                  --                  .rxvalid5
			rxvalid6                  => CONNECTED_TO_rxvalid6,                  --                  .rxvalid6
			rxvalid7                  => CONNECTED_TO_rxvalid7,                  --                  .rxvalid7
			rxvalid8                  => CONNECTED_TO_rxvalid8,                  --                  .rxvalid8
			rxvalid9                  => CONNECTED_TO_rxvalid9,                  --                  .rxvalid9
			rxvalid10                 => CONNECTED_TO_rxvalid10,                 --                  .rxvalid10
			rxvalid11                 => CONNECTED_TO_rxvalid11,                 --                  .rxvalid11
			rxvalid12                 => CONNECTED_TO_rxvalid12,                 --                  .rxvalid12
			rxvalid13                 => CONNECTED_TO_rxvalid13,                 --                  .rxvalid13
			rxvalid14                 => CONNECTED_TO_rxvalid14,                 --                  .rxvalid14
			rxvalid15                 => CONNECTED_TO_rxvalid15,                 --                  .rxvalid15
			rxstatus0                 => CONNECTED_TO_rxstatus0,                 --                  .rxstatus0
			rxstatus1                 => CONNECTED_TO_rxstatus1,                 --                  .rxstatus1
			rxstatus2                 => CONNECTED_TO_rxstatus2,                 --                  .rxstatus2
			rxstatus3                 => CONNECTED_TO_rxstatus3,                 --                  .rxstatus3
			rxstatus4                 => CONNECTED_TO_rxstatus4,                 --                  .rxstatus4
			rxstatus5                 => CONNECTED_TO_rxstatus5,                 --                  .rxstatus5
			rxstatus6                 => CONNECTED_TO_rxstatus6,                 --                  .rxstatus6
			rxstatus7                 => CONNECTED_TO_rxstatus7,                 --                  .rxstatus7
			rxstatus8                 => CONNECTED_TO_rxstatus8,                 --                  .rxstatus8
			rxstatus9                 => CONNECTED_TO_rxstatus9,                 --                  .rxstatus9
			rxstatus10                => CONNECTED_TO_rxstatus10,                --                  .rxstatus10
			rxstatus11                => CONNECTED_TO_rxstatus11,                --                  .rxstatus11
			rxstatus12                => CONNECTED_TO_rxstatus12,                --                  .rxstatus12
			rxstatus13                => CONNECTED_TO_rxstatus13,                --                  .rxstatus13
			rxstatus14                => CONNECTED_TO_rxstatus14,                --                  .rxstatus14
			rxstatus15                => CONNECTED_TO_rxstatus15,                --                  .rxstatus15
			rxelecidle0               => CONNECTED_TO_rxelecidle0,               --                  .rxelecidle0
			rxelecidle1               => CONNECTED_TO_rxelecidle1,               --                  .rxelecidle1
			rxelecidle2               => CONNECTED_TO_rxelecidle2,               --                  .rxelecidle2
			rxelecidle3               => CONNECTED_TO_rxelecidle3,               --                  .rxelecidle3
			rxelecidle4               => CONNECTED_TO_rxelecidle4,               --                  .rxelecidle4
			rxelecidle5               => CONNECTED_TO_rxelecidle5,               --                  .rxelecidle5
			rxelecidle6               => CONNECTED_TO_rxelecidle6,               --                  .rxelecidle6
			rxelecidle7               => CONNECTED_TO_rxelecidle7,               --                  .rxelecidle7
			rxelecidle8               => CONNECTED_TO_rxelecidle8,               --                  .rxelecidle8
			rxelecidle9               => CONNECTED_TO_rxelecidle9,               --                  .rxelecidle9
			rxelecidle10              => CONNECTED_TO_rxelecidle10,              --                  .rxelecidle10
			rxelecidle11              => CONNECTED_TO_rxelecidle11,              --                  .rxelecidle11
			rxelecidle12              => CONNECTED_TO_rxelecidle12,              --                  .rxelecidle12
			rxelecidle13              => CONNECTED_TO_rxelecidle13,              --                  .rxelecidle13
			rxelecidle14              => CONNECTED_TO_rxelecidle14,              --                  .rxelecidle14
			rxelecidle15              => CONNECTED_TO_rxelecidle15,              --                  .rxelecidle15
			rxsynchd0                 => CONNECTED_TO_rxsynchd0,                 --                  .rxsynchd0
			rxsynchd1                 => CONNECTED_TO_rxsynchd1,                 --                  .rxsynchd1
			rxsynchd2                 => CONNECTED_TO_rxsynchd2,                 --                  .rxsynchd2
			rxsynchd3                 => CONNECTED_TO_rxsynchd3,                 --                  .rxsynchd3
			rxsynchd4                 => CONNECTED_TO_rxsynchd4,                 --                  .rxsynchd4
			rxsynchd5                 => CONNECTED_TO_rxsynchd5,                 --                  .rxsynchd5
			rxsynchd6                 => CONNECTED_TO_rxsynchd6,                 --                  .rxsynchd6
			rxsynchd7                 => CONNECTED_TO_rxsynchd7,                 --                  .rxsynchd7
			rxsynchd8                 => CONNECTED_TO_rxsynchd8,                 --                  .rxsynchd8
			rxsynchd9                 => CONNECTED_TO_rxsynchd9,                 --                  .rxsynchd9
			rxsynchd10                => CONNECTED_TO_rxsynchd10,                --                  .rxsynchd10
			rxsynchd11                => CONNECTED_TO_rxsynchd11,                --                  .rxsynchd11
			rxsynchd12                => CONNECTED_TO_rxsynchd12,                --                  .rxsynchd12
			rxsynchd13                => CONNECTED_TO_rxsynchd13,                --                  .rxsynchd13
			rxsynchd14                => CONNECTED_TO_rxsynchd14,                --                  .rxsynchd14
			rxsynchd15                => CONNECTED_TO_rxsynchd15,                --                  .rxsynchd15
			rxblkst0                  => CONNECTED_TO_rxblkst0,                  --                  .rxblkst0
			rxblkst1                  => CONNECTED_TO_rxblkst1,                  --                  .rxblkst1
			rxblkst2                  => CONNECTED_TO_rxblkst2,                  --                  .rxblkst2
			rxblkst3                  => CONNECTED_TO_rxblkst3,                  --                  .rxblkst3
			rxblkst4                  => CONNECTED_TO_rxblkst4,                  --                  .rxblkst4
			rxblkst5                  => CONNECTED_TO_rxblkst5,                  --                  .rxblkst5
			rxblkst6                  => CONNECTED_TO_rxblkst6,                  --                  .rxblkst6
			rxblkst7                  => CONNECTED_TO_rxblkst7,                  --                  .rxblkst7
			rxblkst8                  => CONNECTED_TO_rxblkst8,                  --                  .rxblkst8
			rxblkst9                  => CONNECTED_TO_rxblkst9,                  --                  .rxblkst9
			rxblkst10                 => CONNECTED_TO_rxblkst10,                 --                  .rxblkst10
			rxblkst11                 => CONNECTED_TO_rxblkst11,                 --                  .rxblkst11
			rxblkst12                 => CONNECTED_TO_rxblkst12,                 --                  .rxblkst12
			rxblkst13                 => CONNECTED_TO_rxblkst13,                 --                  .rxblkst13
			rxblkst14                 => CONNECTED_TO_rxblkst14,                 --                  .rxblkst14
			rxblkst15                 => CONNECTED_TO_rxblkst15,                 --                  .rxblkst15
			rxdataskip0               => CONNECTED_TO_rxdataskip0,               --                  .rxdataskip0
			rxdataskip1               => CONNECTED_TO_rxdataskip1,               --                  .rxdataskip1
			rxdataskip2               => CONNECTED_TO_rxdataskip2,               --                  .rxdataskip2
			rxdataskip3               => CONNECTED_TO_rxdataskip3,               --                  .rxdataskip3
			rxdataskip4               => CONNECTED_TO_rxdataskip4,               --                  .rxdataskip4
			rxdataskip5               => CONNECTED_TO_rxdataskip5,               --                  .rxdataskip5
			rxdataskip6               => CONNECTED_TO_rxdataskip6,               --                  .rxdataskip6
			rxdataskip7               => CONNECTED_TO_rxdataskip7,               --                  .rxdataskip7
			rxdataskip8               => CONNECTED_TO_rxdataskip8,               --                  .rxdataskip8
			rxdataskip9               => CONNECTED_TO_rxdataskip9,               --                  .rxdataskip9
			rxdataskip10              => CONNECTED_TO_rxdataskip10,              --                  .rxdataskip10
			rxdataskip11              => CONNECTED_TO_rxdataskip11,              --                  .rxdataskip11
			rxdataskip12              => CONNECTED_TO_rxdataskip12,              --                  .rxdataskip12
			rxdataskip13              => CONNECTED_TO_rxdataskip13,              --                  .rxdataskip13
			rxdataskip14              => CONNECTED_TO_rxdataskip14,              --                  .rxdataskip14
			rxdataskip15              => CONNECTED_TO_rxdataskip15,              --                  .rxdataskip15
			dirfeedback0              => CONNECTED_TO_dirfeedback0,              --                  .dirfeedback0
			dirfeedback1              => CONNECTED_TO_dirfeedback1,              --                  .dirfeedback1
			dirfeedback2              => CONNECTED_TO_dirfeedback2,              --                  .dirfeedback2
			dirfeedback3              => CONNECTED_TO_dirfeedback3,              --                  .dirfeedback3
			dirfeedback4              => CONNECTED_TO_dirfeedback4,              --                  .dirfeedback4
			dirfeedback5              => CONNECTED_TO_dirfeedback5,              --                  .dirfeedback5
			dirfeedback6              => CONNECTED_TO_dirfeedback6,              --                  .dirfeedback6
			dirfeedback7              => CONNECTED_TO_dirfeedback7,              --                  .dirfeedback7
			dirfeedback8              => CONNECTED_TO_dirfeedback8,              --                  .dirfeedback8
			dirfeedback9              => CONNECTED_TO_dirfeedback9,              --                  .dirfeedback9
			dirfeedback10             => CONNECTED_TO_dirfeedback10,             --                  .dirfeedback10
			dirfeedback11             => CONNECTED_TO_dirfeedback11,             --                  .dirfeedback11
			dirfeedback12             => CONNECTED_TO_dirfeedback12,             --                  .dirfeedback12
			dirfeedback13             => CONNECTED_TO_dirfeedback13,             --                  .dirfeedback13
			dirfeedback14             => CONNECTED_TO_dirfeedback14,             --                  .dirfeedback14
			dirfeedback15             => CONNECTED_TO_dirfeedback15,             --                  .dirfeedback15
			sim_pipe_mask_tx_pll_lock => CONNECTED_TO_sim_pipe_mask_tx_pll_lock, --                  .sim_pipe_mask_tx_pll_lock
			rx_in0                    => CONNECTED_TO_rx_in0,                    --        hip_serial.rx_in0
			rx_in1                    => CONNECTED_TO_rx_in1,                    --                  .rx_in1
			rx_in2                    => CONNECTED_TO_rx_in2,                    --                  .rx_in2
			rx_in3                    => CONNECTED_TO_rx_in3,                    --                  .rx_in3
			rx_in4                    => CONNECTED_TO_rx_in4,                    --                  .rx_in4
			rx_in5                    => CONNECTED_TO_rx_in5,                    --                  .rx_in5
			rx_in6                    => CONNECTED_TO_rx_in6,                    --                  .rx_in6
			rx_in7                    => CONNECTED_TO_rx_in7,                    --                  .rx_in7
			rx_in8                    => CONNECTED_TO_rx_in8,                    --                  .rx_in8
			rx_in9                    => CONNECTED_TO_rx_in9,                    --                  .rx_in9
			rx_in10                   => CONNECTED_TO_rx_in10,                   --                  .rx_in10
			rx_in11                   => CONNECTED_TO_rx_in11,                   --                  .rx_in11
			rx_in12                   => CONNECTED_TO_rx_in12,                   --                  .rx_in12
			rx_in13                   => CONNECTED_TO_rx_in13,                   --                  .rx_in13
			rx_in14                   => CONNECTED_TO_rx_in14,                   --                  .rx_in14
			rx_in15                   => CONNECTED_TO_rx_in15,                   --                  .rx_in15
			tx_out0                   => CONNECTED_TO_tx_out0,                   --                  .tx_out0
			tx_out1                   => CONNECTED_TO_tx_out1,                   --                  .tx_out1
			tx_out2                   => CONNECTED_TO_tx_out2,                   --                  .tx_out2
			tx_out3                   => CONNECTED_TO_tx_out3,                   --                  .tx_out3
			tx_out4                   => CONNECTED_TO_tx_out4,                   --                  .tx_out4
			tx_out5                   => CONNECTED_TO_tx_out5,                   --                  .tx_out5
			tx_out6                   => CONNECTED_TO_tx_out6,                   --                  .tx_out6
			tx_out7                   => CONNECTED_TO_tx_out7,                   --                  .tx_out7
			tx_out8                   => CONNECTED_TO_tx_out8,                   --                  .tx_out8
			tx_out9                   => CONNECTED_TO_tx_out9,                   --                  .tx_out9
			tx_out10                  => CONNECTED_TO_tx_out10,                  --                  .tx_out10
			tx_out11                  => CONNECTED_TO_tx_out11,                  --                  .tx_out11
			tx_out12                  => CONNECTED_TO_tx_out12,                  --                  .tx_out12
			tx_out13                  => CONNECTED_TO_tx_out13,                  --                  .tx_out13
			tx_out14                  => CONNECTED_TO_tx_out14,                  --                  .tx_out14
			tx_out15                  => CONNECTED_TO_tx_out15,                  --                  .tx_out15
			tl_cfg_func_o             => CONNECTED_TO_tl_cfg_func_o,             --         config_tl.tl_cfg_func
			tl_cfg_add_o              => CONNECTED_TO_tl_cfg_add_o,              --                  .tl_cfg_add
			tl_cfg_ctl_o              => CONNECTED_TO_tl_cfg_ctl_o               --                  .tl_cfg_ctl
		);

