// $Id: $
// File name:   tb_rcu.sv
// Created:     12/7/2016
// Author:      Shenwei Wang
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
`timescale 1ns / 100ps
module tb_ahb_lite();
   
   localparam CLK_PERIOD = 6;
   localparam CHECK_DELAY= 1;
   localparam MEMORY_SIZE = 553;
   localparam MEMORY_MAX_BIT = MEMORY_SIZE -1;
 
   //input
   reg tb_hclk, tb_hresetn;
   reg [31:0] tb_haddr;
   reg [31:0] tb_hwdata;
   reg 	      tb_hwrite;
   reg [31:0] tb_data_in;
   
   //output
   reg [31:0] tb_hrdata;
   reg tb_hreadyout;
   reg [31:0] tb_data_out;
   

   ahb_lite DUT(
		      //input call
		      .HCLK(tb_hclk),
		      .HRESETn(tb_hresetn),
		      .HADDR(tb_haddr),
		      .HWDATA(tb_hwdata),
		      .HWRITE(tb_hwrite),
		      .data_in(tb_data_in),
		      //output call
		      .HRDATA(tb_hrdata),
      		      .HREADYOUT(tb_hreadyout),
		      .data_out(tb_data_out)
		      );
   
   always
     begin
	tb_hclk = 1'b0;
	#(CLK_PERIOD/2);
	tb_hclk = 1'b1;
	#(CLK_PERIOD/2);
     end

   initial
     begin
	
	//Case1 test of reset
	tb_hresetn = 1'b0;
	tb_haddr = 32'hffffffff;
	tb_hwdata = 32'hffffffff;
	tb_hwrite = 1'b1;
	tb_data_in = 32'hffffffff;
	
	#(CHECK_DELAY);
	@(posedge tb_hclk);
	@(posedge tb_hclk);
	#(CHECK_DELAY);	
	//assert hready out
	assert(tb_hreadyout == 1'b1)
	  $info("Case 1 hreadyout passed");
	else
	  $error("case 1 hreadyout failed");
	//assert ins_data
	assert(tb_hrdata == '0)
	  $info("Case 1 hrdata passed");
	else
	  $error("case 1 hrdata failed");
	
	assert(tb_data_out == '0)
	  $info("Case 1 data_out passed");
	else
	  $error("case 1 data_out failed");
//////////////////////////////////////////////////////////
	
	//Case2 test invalid address
	tb_hresetn = 1'b1;
	tb_haddr = 32'h00000000;
	tb_hwdata = 32'hffffffff;
	tb_hwrite = 1'b1;
	tb_data_in = 32'hffffffff;
	
	#(CHECK_DELAY);
	@(posedge tb_hclk);
	tb_hresetn = 1;
	@(posedge tb_hclk);
	#(CHECK_DELAY);	
	//assert hready out
	assert(tb_hreadyout == 1'b1)
	  $info("Case 2 hreadyout passed");
	else
	  $error("case 2 hreadyout failed");
	//assert ins_data
	assert(tb_hrdata == '0)
	  $info("Case 2 hrdata passed");
	else
	  $error("case 2 hrdata failed");
	
	assert(tb_data_out == '0)
	  $info("Case 2 data_out passed");
	else
	  $error("case 2 data_out failed");

	//////////////////////////////////////////////////////////
	
	//Case3 test valid address with read process
	tb_hresetn = 1'b1;
	tb_haddr = 32'hffff0002;
	tb_hwdata = 32'hffffffff;
	tb_hwrite = 1'b0;
	tb_data_in = 32'h12345678;
	
	#(CHECK_DELAY);
	@(posedge tb_hclk);
	tb_hresetn = 1;
	@(posedge tb_hclk);
	#(CHECK_DELAY);
	@(posedge tb_hclk);
	
	//assert hready out
	assert(tb_hreadyout == 1'b1)
	  $info("Case 3 hreadyout passed");
	else
	  $error("case 3 hreadyout failed");
	//assert ins_data
	assert(tb_hrdata == 32'h12345678)
	  $info("Case 3 hrdata passed");
	else
	  $error("case 3 hrdata failed");
	
	assert(tb_data_out == '0)
	  $info("Case 3 data_out passed");
	else
	  $error("case 3 data_out failed");	

	/////////////////////////////////////////////////////////////////////

	//Case4 test valid addr with write process
	tb_hresetn = 1'b1;
	tb_haddr = 32'hffff0001;
	tb_hwdata = 32'hffff0002;
	tb_hwrite = 1'b1;
	tb_data_in = 32'hffff0003;
	
	#(CHECK_DELAY);
	@(posedge tb_hclk);
	tb_hresetn = 1;
	@(posedge tb_hclk);
	#(CHECK_DELAY);
	@(posedge tb_hclk);
	
	//assert hready out
	assert(tb_hreadyout == 1'b1)
	  $info("Case 4 hreadyout passed");
	else
	  $error("case 4 hreadyout failed");
	//assert ins_data
	assert(tb_hrdata == '0)
	  $info("Case 4 hrdata passed");
	else
	  $error("case 4 hrdata failed");
	
	assert(tb_data_out == 32'hffff0002)
	  $info("Case 4 data_out passed");
	else
	  $error("case 4 data_out failed");
   
     end // initial begin
   
endmodule

