// $Id: $
// File name:   build_tree.sv
// Created:     12/10/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: controller for Build Tree and Code Transform block -- Yi Li
module controller_BTCT
(
	input clk,//12
	input n_rst,//12
	input BT_finish,//12
	input CT_finish,//12
	input ALL_start,//12
	input BT_R,//12
	input BT_W,//12
	input CT_R,//12
	input CT_W,//12
	input ini_W,//12
	input ini_R,//12
	input [7:0] ini_data_W,//12
	input [9:0] ini_addr,//12
	input [7:0] mem_data_R,//12
	input [7:0] BN_data,//12
	input [7:0] RC_data,//12
	input [9:0] BT_addr,//12
	input [9:0] CT_addr,//12
	output reg [7:0] ini_data_R,//12
	output reg BT_start,//12
	output reg CT_start,//12
	output reg ALL_finish,//12
	output [7:0] FM_data,//12
	output [7:0] SN_data,//12
	output reg [7:0] mem_data_W,//12
	output reg [15:0] mem_addr,//12
	output mem_R,//12
	output mem_W//12
);

	reg next_BT_start;
	reg next_CT_start;
	reg next_ALL_finish;

   	typedef enum bit [2:0] {idle, BT_wait, CT_wait, finish} stateType;
   	stateType state;
  	stateType next_state;

 	always_ff @(posedge clk, negedge n_rst)
     	begin
		if (n_rst == 0)
	  	begin
	     		state <= idle;
			BT_start <= 0;
			CT_start <= 0;
			ALL_finish <= 0;
	  	end
		else
	  	begin
	     		state <= next_state;
			BT_start <= next_BT_start;
			CT_start <= next_CT_start;
			ALL_finish <= next_ALL_finish;
	  	end // else: !if(n_rst == 0)
     	end // always_ff @

always_comb
     	begin
		next_state = state;
		next_BT_start = 0;
		next_CT_start = 0;	
		next_ALL_finish = 0;	

		case(state)
	  	idle:
	    	begin
			if (1 == ALL_start) 
			begin
				next_state = BT_wait;
				next_BT_start = 1;
			end
			else 
			begin
				mem_data_W = ini_data_W;
				mem_addr = {1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,ini_addr[9:0]};
				ini_data_R = mem_data_R;
				next_state = idle;
			end
		end


		BT_wait:
		begin
			if (1 == BT_finish)
			begin
				next_state = CT_wait;
				next_CT_start = 1;
			end
			else
			begin
				mem_data_W = BN_data;
				mem_addr = {1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,BT_addr[9:0]};
				ini_data_R = mem_data_R;
				next_state = BT_wait;
				next_BT_start = 1;
			end
		end

		CT_wait:
		begin
			if (1 == CT_finish)
			begin
				next_state = finish;
			end
			else
			begin
				mem_data_W = RC_data;
				mem_addr = {1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,CT_addr[9:0]};
				ini_data_R = mem_data_R;
				next_state = CT_wait;
				next_CT_start = 1;
			end
		end

		finish:
		begin
			next_ALL_finish = 1;
			next_state = idle;
		end

		endcase
	end

	assign FM_data = mem_data_R;
	assign SN_data = mem_data_R;
	//assign ini_data_R = mem_data_R;
	assign mem_R = BT_R | CT_R | ini_R;
	assign mem_W = BT_W | CT_W | ini_W;
	
endmodule
