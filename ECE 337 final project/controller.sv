// $Id: $
// File name:   controller.sv
// Created:     11/30/2016
// Author:      Jiacheng Yuan
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: controller

module controller
(
	input clk, n_reset, 
	input reg Start, Wrong_start, End, Tree_done, Trans_done, Output_done, OC_r, OC_done, //OC_w,
	input reg [7:0] data_out_ahb, //data_out,
	//input reg [9:0] addr_in,
	output reg Cnt_start, tree_start, code_start, mem_clear, receive_wrong, Start_again,
	output reg [7:0] data_in, OC_data_in
	//output reg [9:0] addr_out
	//output reg [4:0] select
);

typedef enum bit [3:0] {INITI, IDLE, RECEIVE_START, CHECK_START, RECEIVING, RECEIVE_WRONG, EIDLE, STORE, CHECK_END, BUILD_TREE, CODE_TRANSFORM, OUTCODE, CODING, OUTPUT} state_type;
state_type current_state;
state_type next_state;

always_ff @ (posedge clk, negedge n_reset) begin
	if(n_reset == 0) begin
		current_state <= INITI;
	end 
	else begin
		current_state <= next_state;
	end
end

always_comb
begin
	//r_ena = 0;
	//w_ena = 0;
	Cnt_start = 0;
	tree_start = 0;
	code_start = 0;
	mem_clear = 0;
	receive_wrong = 0;
	Start_again = 0;
	
	next_state = current_state;
	case(current_state)
	INITI: begin
		mem_clear = 1;
		next_state = IDLE;	
	end
	IDLE : begin
		if (Start== 1) begin
			Start_again = 1;
			next_state = RECEIVE_START;
		end
		else
			next_state = IDLE;
	end
	RECEIVE_START : begin
		Cnt_start = 1;
		next_state = RECEIVING;
	end
	RECEIVING : begin
		data_in = data_out_ahb;
		next_state = CHECK_START;
	end
	CHECK_START : begin
		if (Wrong_start == 0)
			next_state = STORE;
		else
			next_state = RECEIVE_WRONG;
	end
	RECEIVE_WRONG : begin
		receive_wrong = 1;
		next_state = EIDLE;
	end
	EIDLE : begin
		if (Start == 1) begin
			Start_again = 1;
			receive_wrong = 0;
			next_state = RECEIVE_START;  // instead of RECEIVE_START, we refuse to receive the file and restart the process
		end
		else
			next_state = EIDLE;
	end

	STORE : begin
		next_state = CHECK_END;
	end
	CHECK_END : begin
		if (End == 0)
			next_state = RECEIVING;
		else
			next_state = BUILD_TREE;
	end
	BUILD_TREE : begin
		tree_start = 1;
		if (Tree_done == 1)
			next_state = CODE_TRANSFORM;
		else
			next_state = BUILD_TREE;
	end
	CODE_TRANSFORM : begin
		code_start = 1;
		if (Trans_done == 1)
			next_state = OUTCODE;
		else
			next_state = CODE_TRANSFORM;
	end
	OUTCODE : begin
		Start_again = 1;
		next_state = CODING;
	end
	CODING : begin
		if (OC_r) begin
			OC_data_in = data_out_ahb; //pass data
		end
		if (OC_done) 
			next_state = OUTPUT;
		else
			next_state = CODING;
	end
	OUTPUT : begin

		if (Output_done)
			next_state = IDLE;
		else
			next_state = OUTPUT;
	end
	endcase

end
endmodule
