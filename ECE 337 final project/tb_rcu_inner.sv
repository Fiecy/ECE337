// $Id: $
// File name:   tb_rcu_inner.sv
// Created:     12/7/2016
// Author:      Shenwei Wang
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
`timescale 1ns / 100ps
module tb_rcu_inner();
   
   localparam CLK_PERIOD = 6;
   localparam CHECK_DELAY= 1;
   localparam MEMORY_SIZE = 553;
   localparam MEMORY_MAX_BIT = MEMORY_SIZE -1;
 
   //input
   reg tb_clk, tb_n_rst;
   reg [31:0] tb_data_out;
   reg [7:0] tb_data_in;
   reg 	     tb_hwrite;
   
   //output
   reg [31:0] tb_data_into_rcu;
   reg [7:0] tb_data_outto_c;
   reg 	     tb_eot;
   

   rcu_inner DUT(
		 .clk(tb_clk),
		 .n_rst(tb_n_rst),
		 .data_out(tb_data_out),
		 .data_in(tb_data_in),
		 .HWRITE(tb_hwrite),
		 //output call
		 .data_into_rcu(tb_data_into_rcu),
		 .data_outto_c(tb_data_outto_c),
		 .eot(tb_eot)
		 );
   
   always
     begin
	tb_clk = 1'b0;
	#(CLK_PERIOD/2);
	tb_clk = 1'b1;
	#(CLK_PERIOD/2);
     end

   initial
     begin
	//Case1 test reset
	tb_n_rst = 1'b0;
	tb_data_out = 32'hffffffff;
	tb_data_in = 8'hff;
	tb_hwrite=1;
	#(CHECK_DELAY);
	@(posedge tb_clk);
	tb_n_rst = 0;
	@(posedge tb_clk);
	#(CHECK_DELAY);	
	//assert hready out
	assert(tb_eot == 1'b0)
	  $info("Case 1 eot passed");
	else
	  $error("case 1 eot failed");
	//assert ins_data
	assert(tb_data_into_rcu == '0)
	  $info("Case 1 data_into_rcu passed");
	else
	  $error("case 1 data_into_rcu failed");
	assert(tb_data_outto_c == '0)
	  $info("Case 1 data_outto_c passed");
	else
	  $error("case 1 data_outto_c failed");
	
	////////////////////////////////////////////
	
	//Case2 write with not end
	tb_n_rst = 1'b0;
	tb_data_out = 32'hffffff33;
	tb_data_in = 8'h11;
	tb_hwrite=1'b1;
	#(CHECK_DELAY);
	@(posedge tb_clk);
	tb_n_rst = 1;
	@(posedge tb_clk);
	#(CHECK_DELAY);	
	//assert hready out
	assert(tb_eot == 1'b0)
	  $info("Case 2 eot passed");
	else
	  $error("case 2 eot failed");
	//assert ins_data
	assert(tb_data_into_rcu == '0)
	  $info("Case 2 data_into_rcu passed");
	else
	  $error("case 1 data_into_rcu failed");
	assert(tb_data_outto_c == 8'h33)
	  $info("Case 3 data_outto_c passed");
	else
	  $error("case 3 data_outto_c failed");

	//////////////////////////////////////////////////////
	
	//Case3 test data_in with 32 bit output
	tb_data_out = 32'hffffff21;
	tb_data_in = 8'h12;
	tb_hwrite=1'b0;
	#(CHECK_DELAY);
	@(posedge tb_clk);
	tb_n_rst = 1;
	@(posedge tb_clk);
	#(CHECK_DELAY);	
	//assert hready out
	assert(tb_eot == 1'b0)
	  $info("Case 3 eot passed");
	else
	  $error("case 3 eot failed");
	//assert ins_data
	assert(tb_data_into_rcu == {24'h000000,tb_data_in})
	  $info("Case 3 data_into_rcu passed");
	else
	  $error("case 3 data_into_rcu failed");
	assert(tb_data_outto_c == '0)
	  $info("Case 3 data_outto_c passed");
	else
	  $error("case 3 data_outto_c failed");

	///////////////////////////////////////////////////

	//Case4 test data_out with 8 bit input as end of transfer ff
	tb_data_out = 32'hffffffff;
	tb_data_in = 8'hff;
	tb_hwrite=1'b1;
	#(CHECK_DELAY);
	@(posedge tb_clk);
	tb_n_rst = 1;
	@(posedge tb_clk);
	#(CHECK_DELAY);	
	//assert hready out
	assert(tb_eot == 1'b1)
	  $info("Case 4 eot passed");
	else
	  $error("case 4 eot failed");
	//assert ins_data
	assert(tb_data_into_rcu == '0)
	  $info("Case 4 data_into_rcu passed");
	else
	  $error("case 4 data_into_rcu failed");
	assert(tb_data_outto_c == 8'hff)
	  $info("Case 4 data_outto_c passed");
	else
	  $error("case 4 data_outto_c failed");

	///////////////////////////////////////////////////////
	
	//Case5 test after eot, the output will always show 8'hff no matter what's the input
	tb_data_out = 32'hffffff12;
	tb_data_in = 8'h34;
	tb_hwrite=1'b1;
	#(CHECK_DELAY);
	@(posedge tb_clk);
	tb_n_rst = 1;
	@(posedge tb_clk);
	#(CHECK_DELAY);	
	//assert hready out
	assert(tb_eot == 1'b1)
	  $info("Case 5 eot passed");
	else
	  $error("case 5 eot failed");
	//assert ins_data
	assert(tb_data_into_rcu == '0)
	  $info("Case 5 data_into_rcu passed");
	else
	  $error("case 5 data_into_rcu failed");
	assert(tb_data_outto_c == 8'hff)
	  $info("Case 5 data_outto_c passed");
	else
	  $error("case 5 data_outto_c failed");
	
     end
endmodule
