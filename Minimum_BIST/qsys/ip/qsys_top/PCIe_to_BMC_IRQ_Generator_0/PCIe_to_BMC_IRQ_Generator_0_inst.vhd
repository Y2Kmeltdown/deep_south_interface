	component PCIe_to_BMC_IRQ_Generator_0 is
		port (
			address    : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- address
			chipselect : in  std_logic                     := 'X';             -- chipselect
			write_n    : in  std_logic                     := 'X';             -- write_n
			writedata  : in  std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			readdata   : out std_logic_vector(31 downto 0);                    -- readdata
			clk        : in  std_logic                     := 'X';             -- clk
			reset_n    : in  std_logic                     := 'X';             -- reset_n
			irq_in     : in  std_logic_vector(1 downto 0)  := (others => 'X'); -- irq_in
			irq        : out std_logic                                         -- irq
		);
	end component PCIe_to_BMC_IRQ_Generator_0;

	u0 : component PCIe_to_BMC_IRQ_Generator_0
		port map (
			address    => CONNECTED_TO_address,    --    avalon_slave_0.address
			chipselect => CONNECTED_TO_chipselect, --                  .chipselect
			write_n    => CONNECTED_TO_write_n,    --                  .write_n
			writedata  => CONNECTED_TO_writedata,  --                  .writedata
			readdata   => CONNECTED_TO_readdata,   --                  .readdata
			clk        => CONNECTED_TO_clk,        --             clock.clk
			reset_n    => CONNECTED_TO_reset_n,    --             reset.reset_n
			irq_in     => CONNECTED_TO_irq_in,     -- Ext_irq_interface.irq_in
			irq        => CONNECTED_TO_irq         --  interrupt_sender.irq
		);

