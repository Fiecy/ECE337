// $Id: $
// File name:   tb_moore.sv
// Created:     9/19/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: /
`timescale 1ns / 100ps

module tb_moore
 ();
   
   // Define parameters
   localparam   NUM_CNT_BITS = 4;
   localparam	CLK_TIME     = 2.5; // clock
   localparam	DELAY        = 1; // delay of the check
   
    reg tb_clk;
    reg tb_n_rst;
    reg tb_i;
    reg tb_o;
   

    moore DUT  (.clk( tb_clk ), .n_rst( tb_n_rst ), .i( tb_i ), .o( tb_o ));


    // Clock generation block
	always
	begin
		tb_clk = 1'b0;
		#(CLK_TIME/2.0);
		tb_clk = 1'b1;
		#(CLK_TIME/2.0);
	end

    initial
    begin


        //case 1 @ normal check 1101

        tb_n_rst = 0;
        #3;
        tb_n_rst = 1;
        #3;
		
        tb_i = 1;
        @(posedge tb_clk);
        tb_i = 1;
        @(posedge tb_clk);
        tb_i = 0;
        @(posedge tb_clk);
        tb_i = 1;
        @(posedge tb_clk);

        #(DELAY);
        if( 1 == tb_o )
            $info("CORRECT: case 1 passed! ");
        else 
            $error("INCORRECT: case 1 failed!!");


        
        //case 2 @ 11101101
       
	tb_n_rst = 0;
        #3;
        tb_n_rst = 1;
        #3;
       
        tb_i = 1;
        @(posedge tb_clk);
        tb_i = 1;
        @(posedge tb_clk);
        tb_i = 1;
        @(posedge tb_clk);
        tb_i = 0;
        @(posedge tb_clk);
        tb_i = 1;	
        @(posedge tb_clk);	
        tb_i = 1;
        @(posedge tb_clk);
        tb_i = 0;
        @(posedge tb_clk);
        tb_i = 1;
        @(posedge tb_clk);       
        
        #(DELAY);
        if( 1 == tb_o )
            $info("CORRECT: case 2 passed! ");
        else 
            $error("INCORRECT: case 2 failed!!");

        // case 3 test n_rst
      
        tb_n_rst = 0;
        #3;
        tb_n_rst = 1;
        #3;
		
        tb_i = 1;
        @(posedge tb_clk);
        tb_i = 1;
        @(posedge tb_clk);
        tb_i = 0;
        @(posedge tb_clk);
        tb_i = 1;
        @(posedge tb_clk);
        tb_n_rst = 1;
       	tb_n_rst = 0;
       
        #(DELAY);
        if( 0 == tb_o )
            $info("CORRECT: case 3 passed! ");
        else 
            $error("INCORRECT: case 3 failed!!");

        // case 4 @ 110 output 0
        tb_n_rst = 0;
        #3;
        tb_n_rst = 1;
        #3;
		
        tb_i = 1;
        @(posedge tb_clk);
        tb_i = 1;
        @(posedge tb_clk);
        tb_i = 0;
        @(posedge tb_clk);


        #(DELAY);
        if( 0 == tb_o )
            $info("CORRECT: case 4 passed! ");
        else 
            $error("INCORRECT: case 4 failed!!");
    end
endmodule
