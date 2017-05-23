// $Id: $
// File name:   tb_build_tree.sv
// Created:     11/13/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: tb for build_tree -- Yi Li
`timescale 1ns / 100ps

module tb_build_tree();

   localparam CLK_TIME = 6;
   localparam DELAY    = 1;
   localparam RAM_DELAY = 5;
   localparam MEMORY_SIZE = 553+1;
   localparam MEMORY_MAX_BIT = MEMORY_SIZE - 1;

    
   reg       tb_clk;
   reg 	     tb_n_rst;
   reg 	     tb_BT_start;
   reg [7:0] tb_FM_data;
   reg [7:0] tb_BN_data;
   reg [9:0] tb_BT_addr;
   reg 	     tb_tree_R;
   reg 	     tb_tree_W;
   reg	     tb_BT_finish;
   reg [7:0] data[MEMORY_MAX_BIT:0];
   reg [9:0] count;
   reg [9:0] count_w;
   reg [9:0] big_cnt;
   reg [4:0] cnt_case;

// DUT portmap
    build_tree DUT (.clk(tb_clk), .n_rst(tb_n_rst), .BT_start(tb_BT_start), .FM_data(tb_FM_data), .BT_addr(tb_BT_addr), .tree_R(tb_tree_R), .tree_W(tb_tree_W), .BN_data(tb_BN_data), .BT_finish(tb_BT_finish));

// Generate clock
   always
     begin
	tb_clk = 1'b0;
	#(CLK_TIME/2);
	tb_clk = 1'b1;
	#(CLK_TIME/2);
     end

// clear all blocks
   task clear;
	integer i;
   begin
	@(negedge tb_clk);
	for (i = 0; i < MEMORY_SIZE; i++)
	begin
		data[i] = 0;
	end
   end
   endtask

// setup number
   task setup;
   begin
	data[0+128] = 5;
	data[1+128] = 2;
	data[2+128] = 1;
	data[3+128] = 4;
	data[4+128] = 3;
	data[5+128] = 8;
	data[256] = 'hff;
   end
   endtask

   task setup2;
	integer i;
   begin
	for (i = 128; i < 128+100; i++)
	begin
		data[i] = 1;
	end
	data[256] = 'hff;
   end
   endtask

// simulation of memory
   task memory;
   begin
	//@RAM_DELAY;
	if (1 == tb_tree_R)
	begin
		tb_FM_data = data[tb_BT_addr];
	end
	if (1 == tb_tree_W)
	begin
		data[tb_BT_addr] = tb_BN_data;
	end
   end
   endtask

// check result
   task check_result;
	input [9:0] check_addr;
	input [7:0] check_data;
	input [9:0] expected_addr;
	input [7:0] expected_data;
	input [9:0] cnt;

      begin
	#DELAY;
	if ((check_addr == expected_addr) && (check_data == expected_data)) begin
	   //$info("case %d: build %d node correct!!\n",  cnt_case, cnt);
		if ('hFF == check_data)
		begin
			$info("reach the end of memory\n");
		end
	end
	else begin
	   $error("case %d: build %d node failed!!! \ncheck:    %d, %d\nexpected: %d, %d, FM_addr = %d\n", cnt_case, cnt, check_addr, check_data, expected_addr, expected_data, tb_BN_data);
	end
      end
   endtask

// check data and addr of read cycles
   task check_read;
	input [9:0] count;
	integer i;


   begin
	for (i = 0; i < MEMORY_SIZE; i++)
	begin
	
		@(negedge tb_clk);  // get_data 
		memory;
		@(negedge tb_clk);  // wait
		memory;
		if (count <= 128)
		begin
			check_result(tb_BT_addr, tb_FM_data, count+128, data[count+128], count);  // check read
		end
		else
		begin
			check_result(tb_BT_addr, tb_FM_data, (256+(count-128)*3), data[(256+(count-128)*3)], count);  // check read
		end
		count++;

		@(negedge tb_clk);  // compare
		memory;
			if (0 != tb_FM_data)
			begin
				@(negedge tb_clk);  // check_end
				memory;
				if ('hFF == tb_FM_data)
				begin
					i = 999;
				end
			end
	end
   end
   endtask

// check data and addr of write cycles
   task check_write;
	input [7:0] sum;
	input [7:0] min1;
	input [7:0] min2;
	input [9:0] min1_addr;
	input [9:0] min2_addr;
   begin
	@(negedge tb_clk);  // calc_sum
	memory;
	@(negedge tb_clk);  // store_sum
	memory;
	@(negedge tb_clk);  // wait2
	memory;
   	check_result(tb_BT_addr, tb_BN_data, 256+count_w, sum, count_w);  // sum = 2 + 1 = 3
	count_w++;
	@(negedge tb_clk);  // store_min1
	memory;
	@(negedge tb_clk);  // wait3
	memory;
   	check_result(tb_BT_addr, tb_BN_data, 256+count_w, min1, count_w);  // 2 means addr of min1 = 128 + 2
	count_w++;
	@(negedge tb_clk);  // store_min2
	memory;
	@(negedge tb_clk);  // wait4
	memory;
   	check_result(tb_BT_addr, tb_BN_data, 256+count_w, min2, count_w);  // 1 means addr of min2 = 128 + 1
	count_w++;
	@(negedge tb_clk);  // clear_min1
	memory;
	@(negedge tb_clk);  // wait5
	memory;
   	check_result(tb_BT_addr, tb_BN_data, min1_addr, 0, count_w);  // set min1 = 00
	@(negedge tb_clk);  // clear_min2
	memory;
	@(negedge tb_clk);  // wait6
	memory;
   	check_result(tb_BT_addr, tb_BN_data, min2_addr, 0, count_w);  // set min2 = 00
	@(negedge tb_clk);  // ending
	memory;
	@(negedge tb_clk);  // wait7
	memory;
   	check_result(tb_BT_addr, tb_BN_data, 256+count_w, 'hFF, count_w);  // add ending, set 259 = 0xFF

	@(negedge tb_clk);  // reset
	memory;
   end
   endtask

// big check
   task big_check_50;
	integer i;
   begin
	for (i = 0; i < 50; i++)
	begin
	count = 0;
	check_read(count);  // check read

	check_write(2, big_cnt, big_cnt+1, 128+big_cnt, 128+1+big_cnt);  // sum, (addr)min1, (addr)min2, (clear)min1_addr, (clear)min2_addr
	big_cnt = big_cnt+2;
	end
   end
   endtask

   task big_check_25;
	integer i;
   begin
	big_cnt = 0;
	for (i = 0; i < 25; i++)
	begin
	count = 0;
	check_read(count);  // check read

	check_write(4, 128+big_cnt, 128+big_cnt+1, 256+(big_cnt)*3, 256+(big_cnt+1)*3);  // sum, (addr)min1, (addr)min2, (clear)min1_addr, (clear)min2_addr
	big_cnt = big_cnt+2;
	end
   end
   endtask

   task big_check_12;
	integer i;
   begin
	for (i = 0; i < 12; i++)
	begin
	count = 0;
	check_read(count);  // check read

	check_write(8, 128+big_cnt, 128+big_cnt+1, 256+(big_cnt)*3, 256+(big_cnt+1)*3);  // sum, (addr)min1, (addr)min2, (clear)min1_addr, (clear)min2_addr
	big_cnt = big_cnt+2;
	end
   end
   endtask

   task big_check_6;
	integer i;
   begin
	count = 0;
	check_read(count);  // check read

	check_write(12, 128+big_cnt, 128+big_cnt+1, 256+(big_cnt)*3, 256+(big_cnt+1)*3);  // sum, (addr)min1, (addr)min2, (clear)min1_addr, (clear)min2_addr
	big_cnt = big_cnt+2;
	for (i = 0; i < 5; i++)
	begin
	count = 0;
	check_read(count);  // check read

	check_write(16, 128+big_cnt, 128+big_cnt+1, 256+(big_cnt)*3, 256+(big_cnt+1)*3);  // sum, (addr)min1, (addr)min2, (clear)min1_addr, (clear)min2_addr
	big_cnt = big_cnt+2;
	end
   end
   endtask

   task big_check_3;
	integer i;
   begin
	count = 0;
	check_read(count);  // check read

	check_write(20, 128+big_cnt, 128+big_cnt+1, 256+(big_cnt)*3, 256+(big_cnt+1)*3);  // sum, (addr)min1, (addr)min2, (clear)min1_addr, (clear)min2_addr
	big_cnt = big_cnt+2;
	for (i = 0; i < 2; i++)
	begin
	count = 0;
	check_read(count);  // check read

	check_write(32, 128+big_cnt, 128+big_cnt+1, 256+(big_cnt)*3, 256+(big_cnt+1)*3);  // sum, (addr)min1, (addr)min2, (clear)min1_addr, (clear)min2_addr
	big_cnt = big_cnt+2;
	end
   end
   endtask

   task big_check_2;
	integer i;
   begin
	count = 0;
	check_read(count);  // check read

	check_write(36, 128+big_cnt, 128+big_cnt+1, 256+(big_cnt)*3, 256+(big_cnt+1)*3);  // sum, (addr)min1, (addr)min2, (clear)min1_addr, (clear)min2_addr
	big_cnt = big_cnt+2;
	for (i = 0; i < 1; i++)
	begin
	count = 0;
	check_read(count);  // check read

	check_write(64, 128+big_cnt, 128+big_cnt+1, 256+(big_cnt)*3, 256+(big_cnt+1)*3);  // sum, (addr)min1, (addr)min2, (clear)min1_addr, (clear)min2_addr
	big_cnt = big_cnt+2;
	end
   end
   endtask

   task big_check_1;
	integer i;
   begin
	for (i = 0; i < 1; i++)
	begin
	count = 0;
	check_read(count);  // check read

	check_write(100, 128+big_cnt, 128+big_cnt+1, 256+(big_cnt)*3, 256+(big_cnt+1)*3);  // sum, (addr)min1, (addr)min2, (clear)min1_addr, (clear)min2_addr
	big_cnt = big_cnt+2;
	end
   end
   endtask

// check finish
   task check_finish;
   begin

	@(negedge tb_clk);  // calc_sum
	memory;
	@(negedge tb_clk);  // finish
	@(negedge tb_clk);  // delay 1 clk
	if (1 == tb_BT_finish)
	begin
		print_all;
	end
	else
	begin
		$error("BT_finish != 1, BT_finish = %d\n", tb_BT_finish);
	end

   end
   endtask

// print all data in memory
   task print_all;
	integer i;
   begin
	$info("start to print all data in memory!\n");
	for (i = 0; i < MEMORY_SIZE; i++)
	begin
		$info("data[%d] = %d\n", i, data[i]);
	end
   end
   endtask
// start of tb
   initial
     begin
	//  case 1: FIRST NODE
	cnt_case = 10;
	count = 0;
	count_w = 0;
	tb_n_rst = 0;
	tb_BT_start = 0;
	tb_FM_data = 0;
	@(negedge tb_clk);
	$info("case 1: small data, normal test\n");
	@(negedge tb_clk);
	tb_n_rst = 1;
	@(negedge tb_clk);
	clear;
	@(negedge tb_clk);
	setup;
	@(negedge tb_clk);  // idle
	tb_BT_start = 1;
	memory;

	check_read(count);  // 1st round check read

	tb_BT_start = 0;

	check_write(3, 2, 1, 128+2, 128+1);  // sum = 3, (addr)min1 = 2, (addr)min2 = 1, (clear)min1_addr = 128+2, (clear)min2_addr = 128+1

	count = 0;
	check_read(count);  // 2nd round check read

	check_write(6, 4, 128, 128+4, (256+(128-128)*3));  // sum = 6, min1 = 4, min2 = 128, min1_addr = 128+4, min2_addr = (256+(128-128)*3))

	count = 0;
	check_read(count);  // 3rd round check read

	check_write(9, 3, 0, 128+3, 128+0);  // sum = 9, min1 = 3, min2 = 0, min1_addr = 128+3, min2_addr = 128+0

	count = 0;
	check_read(count);  // 4th round check read

	check_write(14, 129, 5, (256+(129-128)*3), 128+5);  // sum = 14, min1 = 129, min2 = 5, min1_addr = (256+(129-128)*3), min2_addr = 128+5

	count = 0;
	check_read(count);  // 5th round check read

	check_write(23, 130, 131, (256+(130-128)*3), (256+(131-128)*3));  // sum = 23, min1 = 130, min2 = 131, min1_addr = (256+(130-128)*3), min2_addr = (256+(131-128)*3)

	count = 0;
	check_read(count);  // 6th round check read [last round]

	check_finish;


	//  case 2: 100 data of freq = 1
	cnt_case = 20;
	count = 0;
	count_w = 0;
	tb_n_rst = 0;
	tb_BT_start = 0;
	tb_FM_data = 0;
	@(negedge tb_clk);
	$info("case 2: 100 data of freq = 1\n");
	@(negedge tb_clk);
	tb_n_rst = 1;
	@(negedge tb_clk);
	clear;
	@(negedge tb_clk);
	setup2;
	@(negedge tb_clk);  // idle
	tb_BT_start = 1;
	memory;

	count = 0;
	big_cnt = 0;
	// build the first 50 node of 1 + 1 = 2
	cnt_case = 20;
	big_check_50;

	tb_BT_start = 0;

	// build 25 node of 2 + 2 = 4
	cnt_case = 21;
	big_check_25;

	// build 12 node of 4 + 4 = 8 and left 1 node of 4
	cnt_case = 22;
	big_check_12;

	// build 1 node of 4 + 8 = 12 and 5 node of 8 + 8 = 16 and left 1 node of 8
	cnt_case = 22;
	big_check_6;

	// build 1 node of 8 + 12 = 20 and 2 node of 16 + 16 = 32 and left 1 node of 16
	cnt_case = 22;
	big_check_3;

	// build 1 node of 16 + 20 = 36 and 1 node of 32 + 32 = 64
	cnt_case = 22;
	big_check_2;

	// build 1 node of 36 + 64 = 100
	cnt_case = 22;
	big_check_1;

	count = 0;
	check_read(count);  // 6th round check read [last round]

	check_finish;

	
     end
endmodule
