// $Id: $
// File name:   tb_controller.sv
// Created:     12/5/2016
// Author:      Jiacheng Yuan
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: controller test bench
`timescale 1ns / 100ps

module tb_controller ();

reg tb_clk;
reg tb_n_reset;
reg tb_Start, tb_End, tb_Wrong_start, tb_Tree_done, tb_Trans_done, tb_Output_done, tb_OC_r, tb_OC_done; //OC_w,
reg [7:0] tb_data_out_ahb; //tb_data_out;
reg tb_Cnt_start, tb_tree_start, tb_code_start, tb_mem_clear, tb_receive_wrong, tb_Start_again; //tb_r_ena, tb_w_ena, 
reg [7:0] tb_data_in, tb_OC_data_in;


	localparam CLK_PERIOD = 6ns;

	
	// Clock gen block
	always
	begin : CLK_GEN
		tb_clk = 1'b0;
		#(CLK_PERIOD / 2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD / 2.0);
	end
	
	// DUT portmap
	controller DUT(
		.clk(tb_clk),
		.n_reset(tb_n_reset),
		.Start(tb_Start),
		.Wrong_start(tb_Wrong_start),
		.End(tb_End),
		.Tree_done(tb_Tree_done),
		.Trans_done(tb_Trans_done),
		.Output_done(tb_Output_done),
		.OC_done(tb_OC_done),
		.data_out_ahb(tb_data_out_ahb), 
		.data_in(tb_data_in),
		.OC_data_in(tb_OC_data_in),
		.Cnt_start(tb_Cnt_start), 
		.tree_start(tb_tree_start), 
		.code_start(tb_code_start), 
		.mem_clear(tb_mem_clear), 
		.receive_wrong(tb_receive_wrong), 
		.Start_again(tb_Start_again),
		.OC_r(tb_OC_r)
 );

	initial
	begin : TEST_BENCH
		tb_Start = 0;
		tb_End = 0; 
		tb_Wrong_start = 0;
		tb_Tree_done = 0;
		tb_Trans_done = 0;
		tb_Output_done = 0;
		tb_OC_r = 0;
		tb_OC_done = 0;
		
		@(negedge tb_clk);
		tb_n_reset = 0;
		@(negedge tb_clk);
		tb_n_reset = 1;
		@(negedge tb_clk);	//receiving
		tb_Start = 1;
		//@(negedge tb_clk);
		//tb_Start = 0;
		@(negedge tb_clk);
		tb_data_out_ahb = 8'b11001000;
		#(CLK_PERIOD*10);
		@(negedge tb_clk);
		tb_data_out_ahb = 8'b10100100;
		#(CLK_PERIOD*10);
		@(negedge tb_clk);
		tb_End = 1;		//receiving end
		//@(negedge tb_clk);
		//tb_End = 0;
		#(CLK_PERIOD*10);
		@(negedge tb_clk);
		tb_Tree_done = 1;	//build tree end
		//@(negedge tb_clk);
		//tb_Tree_done = 0;
		#(CLK_PERIOD*10);
		@(negedge tb_clk);
		tb_Trans_done = 1;	//trans code end
		//@(negedge tb_clk);
		//tb_Trans_done = 0;
		#(CLK_PERIOD*10);
		@(negedge tb_clk);
		tb_OC_r = 1;
		@(negedge tb_clk);
		tb_data_out_ahb = 8'b11001000;
		#(CLK_PERIOD*10);
		@(negedge tb_clk);
		tb_data_out_ahb = 8'b10100100;
		#(CLK_PERIOD*10);
		@(negedge tb_clk);
		//tb_OC_r = 0;
		tb_OC_done = 1;		//out code end
		@(negedge tb_clk);
		//tb_OC_done = 0;
		#(CLK_PERIOD*10);
		@(negedge tb_clk);
		tb_Output_done = 1;
		@(negedge tb_clk);
		//tb_Output_done = 0;
		@(negedge tb_clk);

		tb_Start = 0;
		tb_End = 0; 
		tb_Wrong_start = 0;
		tb_Tree_done = 0;
		tb_Trans_done = 0;
		tb_Output_done = 0;
		tb_OC_r = 0;
		tb_OC_done = 0;

		@(negedge tb_clk);
		tb_n_reset = 0;
		@(negedge tb_clk);
		tb_n_reset = 1;
		@(negedge tb_clk);	//receiving
		tb_Start = 1;
		//@(negedge tb_clk);
		//tb_Start = 0;
		@(negedge tb_clk);
		tb_data_out_ahb = 8'b11111111;
		#(CLK_PERIOD*10);
		@(negedge tb_clk);
		tb_data_out_ahb = 8'b00000000;
		#(CLK_PERIOD*10);
		@(negedge tb_clk);
		tb_Wrong_start = 1;	//receive wrong
		@(negedge tb_clk);
		tb_Start = 0;
		@(negedge tb_clk);
	
end
endmodule