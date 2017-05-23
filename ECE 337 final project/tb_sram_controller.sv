// $Id: $
// File name:   tb_sram_controller.sv
// Created:     12/5/2016
// Author:      Jiacheng Yuan
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: test bench ram controller

`timescale 1ns / 100ps

module tb_sram_controller ();
	// SRAM configuation parameters (based on values set in wrapper file)
	localparam TB_CLK_PERIOD			= 6.0;	// Read/Write delays are 5ns and need ~1 ns for wire propagation
	
	// Test bench variables
	
	reg tb_clk;
	reg tb_n_rst;
	reg tb_mem_clr;		// Active high strobe for at least 1 simulation timestep to zero memory contents
	//reg tb_mem_init;	// Active high strobe for at least 1 simulation timestep to set the values for address in
										// currently selected init file to their corresonding values prescribed in the file
	//reg tb_mem_dump;	// Active high strobe for at least 1 simulation timestep to dump all values modified since most recent mem_clr activation to
										// the currently chosen dump file. 
										// Only the locations between the "tb_start_address" and "tb_last_address" (inclusive) will be dumped
	//reg tb_verbose;		// Active high enable for more verbose debuging information
	
	reg tb_read_enable;		// Active high read enable for the SRAM
	reg tb_write_enable;	// Active high write enable for the SRAM
	
	reg [9:0]	tb_address; 		// The address of the first word in the access
	reg [7:0]	tb_read_data;		// The data read from the SRAM
	reg [7:0]	tb_write_data;	// The data to be written to the SRAM
	
	// Wrapper portmap
	sram_controller DUT
	(
		// Test bench control signals
		.clk(tb_clk),
		.n_rst(tb_n_rst),
		.mem_clr(tb_mem_clr),
		// Memory interface signals
		.r_en(tb_read_enable),
		.w_en(tb_write_enable),
		.address(tb_address),
		.read_data(tb_read_data),
		.write_data(tb_write_data)
	);
	
always	begin : CLK_GEN
		tb_clk = 1'b0;
		#(TB_CLK_PERIOD / 2.0);
		tb_clk = 1'b1;
		#(TB_CLK_PERIOD / 2.0);
	end

	initial
	begin : TEST_BENCH
		// Initialize all test bench control signals and DUT inputs
		tb_n_rst <= 1;
		tb_mem_clr		<= 0;
	
		// Initialization of memory's interface input signals
		tb_read_enable	<= 0;
		tb_write_enable	<= 0;
		tb_address	<= 0;
		tb_write_data	<= 0;
		
		#(TB_CLK_PERIOD * 10);
		
		// Test the write functionality
		
		tb_address			<= 0;
		tb_write_enable	<= 1;
		tb_write_data		<= 15;
		#TB_CLK_PERIOD;
		
		tb_address 			<= 8;
		#TB_CLK_PERIOD;
		tb_write_enable	<= 1;
		tb_write_data		<= 5;
		#TB_CLK_PERIOD;
		
		tb_write_enable	<= 0;
		
		// Test the read functionality
		tb_read_enable	<= 1;
		#TB_CLK_PERIOD;
		
		tb_address			<= 0;
		tb_read_enable	<= 1;
		#TB_CLK_PERIOD;
		tb_read_enable	<= 1;
		#TB_CLK_PERIOD;

		tb_read_enable <= 0;
		tb_address 			<= 640;
		#TB_CLK_PERIOD;
		tb_write_enable	<= 1;
		tb_write_data		<= 7;
		#TB_CLK_PERIOD;
		
		tb_write_enable	<= 0;

		tb_read_enable	<= 1;
		#TB_CLK_PERIOD;
	/*	
		// Test error detection
		tb_read_enable	<= 1;
		tb_write_enable	<= 1;
		tb_write_data	<= 8;
		tb_address	<= 16;
		#TB_CLK_PERIOD;

		// Test the read functionality
		tb_read_enable	<= 1;
		#TB_CLK_PERIOD;
		
		tb_address	<= 16;
		tb_read_enable	<= 1;
		#TB_CLK_PERIOD;
	*/
		// Test the data clr
		$info("Testing Data clear feature");
		tb_read_enable	<= 0;
		tb_write_enable	<= 0;
		tb_mem_clr			<= 1;
		#TB_CLK_PERIOD;
		
		tb_mem_clr	<= 0;
		#TB_CLK_PERIOD;
		
		tb_read_enable <= 1;
		#TB_CLK_PERIOD;
		
		tb_address 			<= 8;

/*		
		// Test Memory Initialization feature
		$info("Testing Memory Initialziation Feature");
		tb_mem_init					<= 1;
		tb_init_file_number	<= 0;
		#TB_CLK_PERIOD;
		
		tb_mem_init	<= 0;
		
		tb_read_enable	<= 1;
		tb_address			<= 0;
		#TB_CLK_PERIOD;
		
		tb_read_enable	<= 1;
		tb_address			<= 2;
		#TB_CLK_PERIOD;
		
		tb_read_enable	<= 1;
		tb_address			<= 4;
		#TB_CLK_PERIOD;
		
		tb_read_enable	<= 1;
		tb_address			<= 8;
		#TB_CLK_PERIOD;
		
		tb_read_enable	<= 1;
		tb_address			<= 16;
		#TB_CLK_PERIOD;
		
		tb_read_enable	<= 1;
		tb_address			<= 64;
		#TB_CLK_PERIOD;
		
		tb_read_enable	<= 1;
		tb_address			<= 1024;
		#TB_CLK_PERIOD;
	*/	
	end
// 0 - 650 addr
// save and delay
// read every data
// replace old value

endmodule