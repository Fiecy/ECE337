// $Id: $
// File name:   build_tree.sv
// Created:     11/25/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: build huffman tree -- Yi Li
module build_tree
(
	input clk,
	input n_rst,
	input BT_start,
	input [7:0] FM_data,
	output reg BT_finish,
	output reg [9:0] BT_addr,
	output reg tree_R,
	output reg tree_W,
	output reg [7:0] BN_data
);
	reg [7:0] min1;
	reg [7:0] min2;
	reg [7:0] next_min1;
	reg [7:0] next_min2;
	reg [7:0] min1_addr;
	reg [7:0] min2_addr;
	reg [7:0] next_min1_addr;
	reg [7:0] next_min2_addr;
	reg [7:0] sum;
	reg [7:0] next_sum;
	reg [7:0] FM_addr;
	reg [7:0] next_FM_addr;  // [7:0]
	reg [8:0] BN_addr;                    ////[9:0]
	reg [8:0] next_BN_addr;                    ////
	reg [9:0] next_BT_addr;
	reg [7:0] next_BN_data;
	reg next_tree_W;
	reg next_tree_R;
	reg next_BT_finish;

   	typedef enum bit [4:0] {idle, get_data, wait1, compare, check_end, calc_sum, store_sum, wait2, store_min1, wait3, store_min2, wait4, clear_min1, wait5, clear_min2, wait6, ending, wait7, reset, finish} stateType;
   	stateType state;
  	stateType next_state;

 	always_ff @(posedge clk, negedge n_rst)
     	begin
		if (n_rst == 0)
	  	begin
	     		state <= idle;
			BN_addr <= '0;
			FM_addr <= '0;
			BT_addr <= '0;
			min1 <= 8'b11111111;
			min2 <= 8'b11111111;
			min1_addr <= 0;
			min2_addr <= 0;
			sum <= 0;
			BN_data <= 0;
			tree_R <= 0;
			tree_W <= 0;
			BT_finish <= 0;
	  	end
		else
	  	begin
	     		state <= next_state;
			FM_addr <= next_FM_addr;
			BN_addr <= next_BN_addr;
			BT_addr <= next_BT_addr;
			min1 <= next_min1;
			min2 <= next_min2;
			min1_addr <= next_min1_addr;
			min2_addr <= next_min2_addr;
			sum <= next_sum;
			BN_data <= next_BN_data;
			tree_R <= next_tree_R;
			tree_W <= next_tree_W;
			BT_finish <= next_BT_finish;
	  	end // else: !if(n_rst == 0)
     	end // always_ff @

   	always_comb
     	begin
		next_state = state;
		//BT_finish = 0;
		next_tree_R = tree_R;
		next_tree_W = tree_W;
		next_BN_addr = BN_addr;
		next_FM_addr = FM_addr;
		next_BT_addr = BT_addr;
		next_min1 = min1;
		next_min2 = min2;
		next_min1_addr = min1_addr;
		next_min2_addr = min2_addr;
		next_sum = sum;
		next_BN_data = BN_data;
		next_BT_finish = BT_finish;

		case(state)
	  	idle:
	    	begin
			next_tree_R = 0;
			next_tree_W = 0;
			next_BT_finish = 0;
			if (1 == BT_start) 
			begin
				next_state = get_data;
			end
			else 
			begin
				next_state = idle;
			end
		end
		get_data:
		begin
			next_tree_W = 0;
			next_tree_R = 1;
			if (128 >= FM_addr) 
			begin
				next_BT_addr = FM_addr + 128;
			end
			else
			begin
				next_BT_addr = 256 + (FM_addr - 128) * 3;
				next_BN_data = FM_addr;
			end
			next_state = wait1;
		end
		wait1:
		begin
			next_tree_W = 0;
			next_tree_R = 1;
			next_state = compare;
		end
		compare:
		begin
			next_tree_R = 0;
			next_tree_W = 0;
			if (0 == FM_data)
			begin
				next_FM_addr = FM_addr + 1'b1;
				next_state = get_data;
			end
			else
			begin
				if (min1 > FM_data)
				begin
					next_min1 = FM_data;
					next_min1_addr = FM_addr;
					next_min2 = min1;
					next_min2_addr = min1_addr;
				end
				else if (min2 > FM_data)
				begin
					next_min2 = FM_data;
					next_min2_addr = FM_addr;
				end
				next_state = check_end;
			end
		end
		check_end:
		begin
			next_tree_R = 0;
			next_tree_W = 0;
			if (8'hFF == FM_data)
			begin
				next_state = calc_sum;
			end
			else
			begin
				next_FM_addr = FM_addr + 1'b1;
				next_state = get_data;
			end
		end
		calc_sum:
		begin
			next_tree_R = 0;
			next_tree_W = 0;
			if (8'hFF == min2)
			begin
				next_state = finish;
			end
			else
			begin
				next_sum = min1 + min2;
				next_state = store_sum;
			end
		end
		store_sum:
		begin
			next_tree_R = 0;
			next_tree_W = 1;
			next_BT_addr = 256 + BN_addr;
			next_BN_addr = BN_addr + 1;
			next_BN_data = sum;
			next_state = wait2;
		end
		wait2:
		begin
			next_tree_R = 0;
			next_tree_W = 1;
			next_state = store_min1;
		end
		store_min1:
		begin
			next_tree_R = 0;
			next_tree_W = 1;
			next_BT_addr = 256 + BN_addr;
			next_BN_addr = BN_addr + 1;
			next_BN_data = min1_addr;
			next_state = wait3;
		end
		wait3:
		begin
			next_tree_R = 0;
			next_tree_W = 1;
			next_state = store_min2;
		end
		store_min2:
		begin
			next_tree_R = 0;
			next_tree_W = 1;
			next_BT_addr = 256 + BN_addr;
			next_BN_addr = BN_addr + 1;
			next_BN_data = min2_addr;
			next_state = wait4;
		end
		wait4:
		begin
			next_tree_R = 0;
			next_tree_W = 1;
			next_state = clear_min1;
		end
		clear_min1:
		begin
			next_tree_R = 0;
			next_tree_W = 1;
			if (128 >= min1_addr) 
			begin
				next_BT_addr = min1_addr + 128;
			end
			else
			begin
				next_BT_addr = 256 + (min1_addr - 128) * 3;
			end
			next_BN_data = 0;
			next_state = wait5;
		end
		wait5:
		begin
			next_tree_R = 0;
			next_tree_W = 1;
			next_state = clear_min2;
		end
		clear_min2:
		begin
			next_tree_R = 0;
			next_tree_W = 1;
			if (128 >= min2_addr) 
			begin
				next_BT_addr = min2_addr + 128;
			end
			else
			begin
				next_BT_addr = 256 + (min2_addr - 128) * 3;
			end
			next_BN_data = 0;
			next_state = wait6;
		end
		wait6:
		begin
			next_tree_R = 0;
			next_tree_W = 1;
			next_state = ending;
		end
		ending:
		begin
			next_tree_R = 0;
			next_tree_W = 1;
			next_BT_addr = 256 + BN_addr;
			next_BN_data = 8'hFF;
			next_state = wait7;
		end
		wait7:
		begin
			next_tree_R = 0;
			next_tree_W = 1;
			next_state = reset;
		end
		reset:
		begin
			next_tree_R = 0;
			next_tree_W = 0;
			next_min1 = 8'hFF;
			next_min2 = 8'hFF;
			next_sum = '0;
			next_FM_addr = '0;
			next_BT_addr = '0;
			next_state = get_data;
		end
		finish:
		begin
			next_tree_R = 0;
			next_tree_W = 0;
			//BT_finish = 1;
			next_BT_finish = 1;
			next_min1 = 8'hFF;
			next_min2 = 8'hFF;
			next_FM_addr = '0;
			next_BN_addr = '0;
			next_state = idle;
		end
		endcase
	end
endmodule
