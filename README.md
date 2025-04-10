## Dependencies

nalla520nmxlib

## Flashing an FPGA

1. Compile FPGA design
    * Use [Intel® Quartus® Prime Pro Edition Design Software Version 20.3 for Linux](https://www.intel.com/content/www/us/en/software-kit/660532/intel-quartus-prime-pro-edition-design-software-version-20-3-for-linux.html) or [Intel® Quartus® Prime Pro Edition Design Software Version 20.3 for Windows](https://www.intel.com/content/www/us/en/software-kit/660536/intel-quartus-prime-pro-edition-design-software-version-20-3-for-windows.html) and make sure to include stratix 10 support when installing. This will allow you to make a compatible design with the Bittware 520n-mx cards which are being used in Deepsouth.
    * Use the `minimal_bist.qpf` quartus project file provided by ICNS to develop your design for deepsouth. This ensures that the hardware on the FPGA is effectively utilised and easy to connect to your design.
    * Ensure nothing in the `qsys_top.qsys` was modified before compiling as it contains important components to enable PCIe, BMC and config manager communication which enable reprogamming of the FPGA and transmission of data between the server and the FPGA.
    *. Ensure the design meets timing constraints before moving to the next step
2. Generate programming file
    * generation steps
    * For more information please look at the hardware reference manual for the bittware 520n-mx card as it details the exact process of reconfiguring the qspi flash
3. Transfer program file to deepsouth
    * transfer script
4. Program a single FPGA to validate the design
    * qspiflashprog tool
5. Program the deepsouth cluster
    * pdsh

## Recovering from a failed flash

1. Verify qspiflashprog connection
2. Use standard bist design sof file
3. Program via jtag failing card
4. reboot node(Don't power cycle)
5. check qspiflashprog connection
6. use qspiflashprog to flash standard bist pof file

## Sending network data to an FPGA


## Reading Data from an FPGA