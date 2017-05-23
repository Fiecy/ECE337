// $Id: $
// File name:   tb_counter.sv
// Created:     12/5/2016
// Author:      Zhichao Wang
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
`timescale 1ns / 100ps

module tb_counter();

reg clk;
reg n_rst;
reg cnt_start;
reg [7:0] data_c;
reg [9:0] cnt_addr;
reg [7:0] num_r;
reg cnt_w;
reg cnt_r;
reg [7:0] new_w;
reg err;

counter COUNTER(.clk(clk),.n_rst(n_rst),.cnt_start(cnt_start),.data_c(data_c),.cnt_addr(cnt_addr),.num_r(num_r),.cnt_w(cnt_w),.cnt_r(cnt_r),.new_w(new_w),.err(err));

always begin
	clk = 1'b0;
	#(6/2.0);
	clk = 1'b1;
	#(6/2.0);
end

initial 
begin
	//n_rst = 1;
	//data_c = 1'b00000000;
        //cnt_w = 0;
        //cnt_r = 0;
        //new_w = 1'b00000000;
        

	@(posedge clk);
	n_rst = 0;
	@(posedge clk);
	n_rst = 1;
        @(posedge clk);
	@(posedge clk);
	@(posedge clk);
        cnt_start = 1;
        @(posedge clk);
	data_c = 1'b00000000;
        @(posedge clk);
 	@(posedge clk)
        num_r = 0; 
	@(posedge clk);
	
         
		

	@(posedge clk);
	@(posedge clk);
	data_c = 1'b00000000;
        @(posedge clk);
 	@(posedge clk);
	num_r = 1'b00000001;
	@(posedge clk);
////////////////////////////		
	
	@(posedge clk);
	@(posedge clk);
	data_c = 1'b00000001;
        @(posedge clk);
 	@(posedge clk);
	num_r = 1'b00000000;
	@(posedge clk);
        
        
	
	@(posedge clk);
	@(posedge clk);
	data_c = 1'b00000001;
        @(posedge clk);
 	@(posedge clk);
	num_r = 1'b00000001;
	@(posedge clk);
/////////////////////////////
	

	
	
	
        
        
     

end

endmodule
