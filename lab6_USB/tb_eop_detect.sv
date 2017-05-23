// $Id: $
// File name:   tb_eop_detect.sv
// Created:     10/4/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
`timescale 1ns / 100 ps

module tb_eop_detect();

   reg tb_d_plus;
   reg tb_d_minus;
   reg tb_eop;

   eop_detect DUT (.d_minus(tb_d_minus), .d_plus(tb_d_plus), .eop(tb_eop));

   initial
     begin
	tb_d_plus = 0;
	tb_d_minus = 0;
	#9;
	if(1 == tb_eop)
	  $info("Correct! p=0 m=0 passed");
	else
	  $error("Error!! p=0 m=0 failed");

	tb_d_plus = 0;
	tb_d_minus = 1;
	#9;
	if(0 == tb_eop)
	  $info("Correct! p=0 m=1 passed");
	else
	  $error("Error!! p=0 m=1 failed");	

	tb_d_plus = 1;
	tb_d_minus = 0;
	#9;
	if(0 == tb_eop)
	  $info("Correct! p=1 m=0 passed");
	else
	  $error("Error!! p=1 m=0 failed");

	tb_d_plus = 1;
	tb_d_minus = 1;
	#9;
	if(0 == tb_eop)
	  $info("Correct! p=1 m=1 passed");
	else
	  $error("Error!! p=1 m=1 failed");

	tb_d_plus = 0;
	tb_d_minus = 0;
	#9;
	if(1 == tb_eop)
	  $info("Correct! p=0 m=0 passed");
	else
	  $error("Error!! p=0 m=0 failed");

	tb_d_plus = 0;
	tb_d_minus = 1;
	#9;
	if(0 == tb_eop)
	  $info("Correct! p=0 m=1 passed");
	else
	  $error("Error!! p=0 m=1 failed");
     end // initial begin
endmodule // tb_eop_detect
