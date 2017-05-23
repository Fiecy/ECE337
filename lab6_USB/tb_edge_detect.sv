// $Id: $
// File name:   tb_edge_detect.sv
// Created:     10/4/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
`timescale 1ns / 100 ps

module tb_edge_detect();

   localparam CLK_TIME = 2.5;
   localparam DELAY    = 1;
   
   reg tb_clk;
   reg tb_n_rst;
   reg tb_d_plus;
   reg tb_d_edge;

   edge_detect DUT (.clk(tb_clk), .n_rst(tb_n_rst), .d_plus(tb_d_plus), .d_edge(tb_d_edge));

   always
     begin
	tb_clk = 1'b0;
	#(CLK_TIME/2.0);
	tb_clk = 1'b1;
	#(CLK_TIME/2.0);
     end
   
   initial
     begin
	//case 1 normal 1 test
	tb_n_rst = 0;
	tb_d_plus = 0;
	@(posedge tb_clk);
	tb_n_rst = 1;

	tb_d_plus = 1;
	@(negedge tb_clk);
	@(posedge tb_clk);
	#DELAY;
	if (0 == tb_d_edge)
	  $info("Correct: case 1 passed!");
	else
	  $error("Error: case 1 failed!!");

	//case 2 normal 0 test
	tb_n_rst = 0;
	tb_d_plus = 1;
	@(posedge tb_clk);
	tb_n_rst = 1;

	tb_d_plus = 0;
	@(negedge tb_clk);
	@(posedge tb_clk);
	#DELAY;
	if (0 == tb_d_edge)
	  $info("Correct: case 2 passed!");
	else
	  $error("Error: case 2 failed!!");

	//case 3 normal 01 test
	tb_n_rst = 0;
	tb_d_plus = 0;
	tb_n_rst = 1;
	#5
	@(negedge tb_clk);
 	@(negedge tb_clk);
	@(negedge tb_clk);
	tb_d_plus = 1;
	@(posedge tb_clk);
	#DELAY;
	if (1 == tb_d_edge)
	  $info("Correct: case 3 passed!");
	else
	  $error("Error: case 3 failed!!");

	//case 4 normal 10 test
	tb_n_rst = 0;
	tb_d_plus = 0;
	@(posedge tb_clk);
	tb_n_rst = 1;

	tb_d_plus = 1;
	@(negedge tb_clk);
	@(negedge tb_clk);
	tb_d_plus = 0;
	@(posedge tb_clk);
	#DELAY;
	if (1 == tb_d_edge)
	  $info("Correct: case 4 passed!");
	else
	  $error("Error: case 4 failed!!");

	//case 5 n_rst test
	tb_n_rst = 0;
	tb_d_plus = 0;
	@(posedge tb_clk);
	tb_n_rst = 1;

	tb_d_plus = 1;
	@(negedge tb_clk);
	tb_d_plus = 0;
	@(posedge tb_clk);
	
	tb_n_rst = 0;
	
	#DELAY;
	if (0 == tb_d_edge)
	  $info("Correct: case 5 passed!");
	else
	  $error("Error: case 5 failed!!");	

	//case 6  10 after long 1 test
	tb_n_rst = 0;
	tb_d_plus = 0;
	@(posedge tb_clk);
	tb_n_rst = 1;

	tb_d_plus = 1;
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	tb_d_plus = 0;
	@(posedge tb_clk);
	
	
	#DELAY;
	if (1 == tb_d_edge)
	  $info("Correct: case 6 passed!");
	else
	  $error("Error: case 6 failed!!");
 
     end // initial begin
endmodule // tb_eop_detect
