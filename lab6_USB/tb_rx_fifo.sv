// $Id: $
// File name:   tb_rx_fifo.sv
// Created:     10/4/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
`timescale 1ns / 100ps

module tb_rx_fifo();

   localparam CLK_TIME = 2.5;
   localparam DELAY    = 1;
    
   reg       tb_clk;
   reg 	     tb_n_rst;
   reg 	     tb_r_enable;
   reg 	     tb_w_enable;
   reg [7:0] tb_w_data;
   reg [7:0] tb_r_data;
   reg 	     tb_empty;
   reg 	     tb_full;

   rx_fifo DUT (.clk(tb_clk), .n_rst(tb_n_rst), .r_enable(tb_r_enable), .w_enable(tb_w_enable), .w_data(tb_w_data), .r_data(tb_r_data), .empty(tb_empty), .full(tb_full));

   always
     begin
	tb_clk = 1'b0;
	#(CLK_TIME/2.0);
	tb_clk = 1'b1;
	#(CLK_TIME/2.0);
     end
   
   initial
     begin
	//  case 1: n_rst
	tb_n_rst = 0;
	tb_r_enable = 0;
	tb_w_enable = 0;
	tb_w_data = 0;
	tb_n_rst = 1;

	#10
	  if(1 == tb_empty && 0 == tb_full)
	    $info("Correct: case 1 passed!");
	  else
	    $error("Error: case 1 failed!!");

	//  case 2: write and read
	tb_n_rst = 0;
	tb_r_enable = 0;
	tb_w_enable = 0;
	tb_w_data = 0;
	tb_n_rst = 1;

	tb_w_data = 8'b10010110;
	tb_w_enable = 1;
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	@(negedge tb_clk);
	tb_w_enable = 0;
 	@(negedge tb_clk);
 	@(negedge tb_clk);
	tb_r_enable = 1;
	@(negedge tb_clk);

	if (tb_r_data == tb_w_data)
	  $info("Correct: case 2 passed!");
	else
	  $error("Error: case 2 failed!!");
     end // initial begin
   
endmodule // tb_rx_fifo

	
	
	