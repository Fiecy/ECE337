// $Id: $
// File name:   tb_build_tree.sv
// Created:     12/10/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: tb for build_tree -- Yi Li
`timescale 1ns / 100ps

module tb_BTCT();

   localparam CLK_TIME = 6;
   localparam DELAY    = 1;
   localparam RAM_DELAY = 5;
   localparam MEMORY_SIZE = 553+1;
   localparam MEMORY_MAX_BIT = MEMORY_SIZE - 1;


	reg       tb_clk;
	reg 	     tb_n_rst;
	reg 	     tb_ALL_start;
	reg	     tb_ALL_finish;
	reg [7:0] tb_ini_data_R;
	reg [7:0] tb_ini_data_W;
	reg [9:0] tb_ini_addr;
	reg 	     tb_ini_R;
	reg 	     tb_ini_W;
	reg [7:0] data[MEMORY_MAX_BIT:0];
	reg [1:0] cnt_case;
	reg [15:0] tb_mem_addr;
	reg [7:0] tb_mem_data_R;
	reg [7:0] tb_mem_data_W;
	reg tb_mem_R;
	reg tb_mem_W;
	reg tb_BT_start;
	reg tb_CT_start;
	reg [9:0] count;
	reg [9:0] count_w;
	reg [9:0] node_cnt;


// DUT portmap
    BTCT DUT (.clk(tb_clk), .n_rst(tb_n_rst), .ALL_start(tb_ALL_start), .ini_data_W(tb_ini_data_W), .ini_addr(tb_ini_addr), .ini_data_R(tb_ini_data_R), .ini_R(tb_ini_R), .ini_W(tb_ini_W), .ALL_finish(tb_ALL_finish),
		.mem_addr(tb_mem_addr), .mem_data_R(tb_mem_data_R), .mem_data_W(tb_mem_data_W), .mem_R(tb_mem_R), .mem_W(tb_mem_W), .BT_start(tb_BT_start), .CT_start(tb_CT_start));

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
	for (i = 0; i < MEMORY_SIZE; i++)
	begin
		data[i] = 0;
	end
   end
   endtask

// setup number
   task setup;
	integer i;
   begin
	data[0+128] = 5;
	data[1+128] = 2;
	data[2+128] = 1;
	data[3+128] = 4;
	data[4+128] = 3;
	data[5+128] = 8;
	data[256] = 'hff;

	@(negedge tb_clk);
	tb_ini_addr = 0;
	tb_ini_data_W = data[0];
	tb_ini_R = 0;
	tb_ini_W = 1;
	for (i = 0; i < MEMORY_SIZE; i++)
	begin
		@(negedge tb_clk);
		tb_ini_addr = i;
		tb_ini_data_W = data[i];
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
		@(negedge tb_clk);  // wait
		if (count <= 128)
		begin
			check_result(tb_mem_addr, tb_mem_data_R, count+128, data[count+128], count);  // check read
		end
		else
		begin
			check_result(tb_mem_addr, tb_mem_data_R, (256+((count-128)*3)), data[(256+((count-128)*3))], count);  // check read
		end
		count++;
		@(negedge tb_clk);  // compare
			if (0 != tb_mem_data_R)
			begin
				@(negedge tb_clk);  // check_end
				$info("data_R = %d\n", tb_mem_data_R);
				if ('hFF == tb_mem_data_R)
				begin
					i = 999;
					$info("reach the end of memory\n");
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
	@(negedge tb_clk);  // store_sum
   	check_result(tb_mem_addr, tb_mem_data_W, 256+count_w, sum, count_w);  // sum = 2 + 1 = 3
	count_w++;
	@(negedge tb_clk);  // wait2
	@(negedge tb_clk);  // store_min1
   	check_result(tb_mem_addr, tb_mem_data_W, 256+count_w, min1, count_w);  // 2 means addr of min1 = 128 + 2
	count_w++;
	@(negedge tb_clk);  // wait3
	@(negedge tb_clk);  // store_min2
   	check_result(tb_mem_addr, tb_mem_data_W, 256+count_w, min2, count_w);  // 1 means addr of min2 = 128 + 1
	count_w++;
	@(negedge tb_clk);  // wait4
	@(negedge tb_clk);  // clear_min1
   	check_result(tb_mem_addr, tb_mem_data_W, min1_addr, 0, count_w);  // set min1 = 00
	@(negedge tb_clk);  // wait5
	@(negedge tb_clk);  // clear_min2
   	check_result(tb_mem_addr, tb_mem_data_W, min2_addr, 0, count_w);  // set min2 = 00
	@(negedge tb_clk);  // wait6
	@(negedge tb_clk);  // ending
   	check_result(tb_mem_addr, tb_mem_data_W, 256+count_w, 'hFF, count_w);  // add ending, set 259 = 0xFF
	@(negedge tb_clk);  // wait7
	@(negedge tb_clk);  // reset
   end
   endtask

// check find_end
   task find_end;
	input [9:0] count;
	integer i;
   begin
	for (i = 0; i < MEMORY_SIZE; i++)
	begin
		@(negedge tb_clk);  // find_end 
		@(negedge tb_clk);  // wait
		if (count <= 128)
		begin
			check_result(tb_mem_addr, tb_mem_data_R, count+128, data[count+128], count);  // check read
		end
		else
		begin
			check_result(tb_mem_addr, tb_mem_data_R, (256+(count-128)*3), data[(256+(count-128)*3)], count);  // check read
		end
		count++;
		@(negedge tb_clk);  // check_end
		if ('hFF == tb_mem_data_R)
		begin
			i = 999;
		end
	end
   end
   endtask

// check write
   task check_write_CT;
	input [7:0] result;
	input [7:0] digit;
	input [9:0] result_addr;
	input [9:0] digit_addr;
   begin
	@(negedge tb_clk);  // store_code
	@(negedge tb_clk);  // swait
	check_result(tb_mem_addr, tb_mem_data_W, result_addr, result, 100);  // check read
	@(negedge tb_clk);  // store_cnt
	@(negedge tb_clk);  // cwait
	check_result(tb_mem_addr, tb_mem_data_W, digit_addr, digit, 101);  // check read
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
	   $error("case %d: build %d node failed!!! \ncheck:    %d, %d\nexpected: %d, %d\n", cnt_case, cnt, check_addr, check_data, expected_addr, expected_data);
	end
      end
   endtask

// print memory
   task print_memory;
	integer i;

     begin
	@(negedge tb_clk);
	tb_ini_addr = 0;
	//tb_ini_data_W = data[0];
	tb_ini_R = 1;
	tb_ini_W = 0;
	@(negedge tb_clk);
	for (i = 0; i < MEMORY_SIZE; i++)
	begin
		tb_ini_addr = i;
		@(negedge tb_clk);
		@(negedge tb_clk);
		#DELAY;
		$info("MEMORY[%d] = %d\n", i, tb_mem_data_R);
	end
     end
   endtask

// start of tb
   initial
     begin
	tb_n_rst = 0;
	tb_ALL_start = 0;
	tb_ini_R = 0;
	tb_ini_W = 0;
	clear;
	setup;
	count_w = 0;
	cnt_case = 1;
	@(negedge tb_clk);
	tb_ini_R = 0;
	tb_ini_W = 0;
	tb_n_rst = 1;
	$info("case 1: small data, normal test\n");
	@(negedge tb_clk);
	tb_ini_addr = 1;
	tb_ini_data_W = data[1];
	tb_ini_W = 0;
	tb_ini_R = 1;
	@(negedge tb_clk);
	tb_ini_addr = 256;
	@(negedge tb_clk);
	$info("1   ini_data_R = %d,  addr = %d\n", tb_ini_data_R, tb_ini_addr); //  check initializaion
	tb_ini_addr = 257;
	@(negedge tb_clk);
	$info("1   ini_data_R = %d,  addr = %d\n", tb_ini_data_R, tb_ini_addr); //  check initializaion
	tb_ALL_start = 1;
	tb_ini_R = 0;
	tb_ini_W = 0;
	@(negedge tb_clk);
	#DELAY;
	$info("BT_start = %d\n", tb_BT_start);
	@(negedge tb_clk);
	#DELAY;
	tb_ALL_start = 0;
	$info("BT_start = %d\n", tb_BT_start);
	@(negedge tb_clk);
	count = 0;
	check_read(count);  // 1st round check read

	check_write(3, 2, 1, 128+2, 128+1);  // sum = 3, (addr)min1 = 2, (addr)min2 = 1, (clear)min1_addr = 128+2, (clear)min2_addr = 128+1
	data[129] = 0;
	data[130] = 0;
	data[256] = 3;
	data[257] = 2;
	data[258] = 1;
	data[259] = 8'hFF;

	count = 0;
	check_read(count);  // 2nd round check read

	check_write(6, 4, 128, 128+4, (256+(128-128)*3));  // sum = 6, min1 = 4, min2 = 128, min1_addr = 128+4, min2_addr = (256+(128-128)*3))
	data[132] = 0;
	data[256] = 0;
	data[259] = 6;
	data[260] = 4;
	data[261] = 128;
	data[262] = 8'hFF;

	count = 0;
	check_read(count);  // 3rd round check read

	check_write(9, 3, 0, 128+3, 128+0);  // sum = 9, min1 = 3, min2 = 0, min1_addr = 128+3, min2_addr = 128+0
	data[131] = 0;
	data[128] = 0;
	data[262] = 9;
	data[263] = 3;
	data[264] = 0;
	data[265] = 8'hFF;

	count = 0;
	check_read(count);  // 4th round check read

	check_write(14, 129, 5, (256+(129-128)*3), 128+5);  // sum = 14, min1 = 129, min2 = 5, min1_addr = (256+(129-128)*3), min2_addr = 128+5
	data[259] = 0;
	data[133] = 0;
	data[265] = 14;
	data[266] = 129;
	data[267] = 5;
	data[268] = 8'hFF;

	count = 0;
	check_read(count);  // 5th round check read

	check_write(23, 130, 131, (256+(130-128)*3), (256+(131-128)*3));  // sum = 23, min1 = 130, min2 = 131, min1_addr = (256+(130-128)*3), min2_addr = (256+(131-128)*3)
	data[262] = 0;
	data[265] = 0;
	data[268] = 23;
	data[269] = 130;
	data[270] = 131;
	data[271] = 8'hFF;

	count = 0;
	check_read(count);  // 6th round check read [last round]

	@(negedge tb_clk);  // calc_sum
	@(negedge tb_clk);  // finish
	$info("CT_start = %d\n", tb_CT_start);
	count = 128;
	count_w = 0;



	@(negedge tb_clk); // delay 1 clk for state transition
	find_end(count); // find the end of memory

	@(negedge tb_clk);  // zero_dig
	@(negedge tb_clk);  // wait
	node_cnt = 132;
	check_result(tb_mem_addr, tb_mem_data_R, (256+(node_cnt-128)*3)+2, data[(256+(node_cnt-128)*3)+2], 1);  // check read
	@(negedge tb_clk);  // check0
	@(negedge tb_clk);  // fst_dig
	@(negedge tb_clk);  // wait
	node_cnt = 131;
	check_result(tb_mem_addr, tb_mem_data_R, (256+(node_cnt-128)*3)+2, data[(256+(node_cnt-128)*3)+2], 2);  // check read
	@(negedge tb_clk);  // check1

	check_write_CT(8'b11000000, 2, 5+128, 5); // F
	data[5+128] = 8'b11000000;
	data[5] = 2;

	@(negedge tb_clk);  // fst_dig
	@(negedge tb_clk);  // wait
	node_cnt = 131;
	check_result(tb_mem_addr, tb_mem_data_R, (256+(node_cnt-128)*3)+1, data[(256+(node_cnt-128)*3)+1], 10);  // check read
	@(negedge tb_clk);  // check1	
	@(negedge tb_clk);  // sec_dig
	@(negedge tb_clk);  // wait
	node_cnt = 129;
	check_result(tb_mem_addr, tb_mem_data_R, (256+(node_cnt-128)*3)+2, data[(256+(node_cnt-128)*3)+2], 11);  // check read
	@(negedge tb_clk);  // check2
	@(negedge tb_clk);  // trd_dig
	@(negedge tb_clk);  // wait
	node_cnt = 128;
	check_result(tb_mem_addr, tb_mem_data_R, (256+(node_cnt-128)*3)+2, data[(256+(node_cnt-128)*3)+2], 12);  // check read
	@(negedge tb_clk);  // check3

	check_write_CT(8'b10110000, 4, 1+128, 1); // B
	data[1+128] = 8'b10110000;
	data[1] = 4;

	@(negedge tb_clk);  // trd_dig
	@(negedge tb_clk);  // wait
	node_cnt = 128;
	check_result(tb_mem_addr, tb_mem_data_R, (256+(node_cnt-128)*3)+1, data[(256+(node_cnt-128)*3)+1], 20);  // check read
	@(negedge tb_clk);  // check3

	check_write_CT(8'b10100000, 4, 2+128, 2); // C
	data[2+128] = 8'b10100000;
	data[2] = 4;

	@(negedge tb_clk);  // trd_dig
	@(negedge tb_clk);  // wait
	node_cnt = 128;
	check_result(tb_mem_addr, tb_mem_data_R, (256+(node_cnt-128)*3), data[(256+(node_cnt-128)*3)], 30);  // check read    return to sec_dig
	@(negedge tb_clk);  // check3
	@(negedge tb_clk);  // sec_dig
	@(negedge tb_clk);  // wait
	node_cnt = 129;
	check_result(tb_mem_addr, tb_mem_data_R, (256+(node_cnt-128)*3)+1, data[(256+(node_cnt-128)*3)+1], 31);  // check read
	@(negedge tb_clk);  // check2

	check_write_CT(8'b10000000, 3, 4+128, 4); // E
	data[4+128] = 8'b10000000;
	data[4] = 3;

	@(negedge tb_clk);  // sec_dig
	@(negedge tb_clk);  // wait
	node_cnt = 129;
	check_result(tb_mem_addr, tb_mem_data_R, (256+(node_cnt-128)*3), data[(256+(node_cnt-128)*3)], 40);  // check read  return to fst_dig
	@(negedge tb_clk);  // check2
	@(negedge tb_clk);  // fst_dig
	@(negedge tb_clk);  // wait
	node_cnt = 131;
	check_result(tb_mem_addr, tb_mem_data_R, (256+(node_cnt-128)*3), data[(256+(node_cnt-128)*3)], 10);  // check read  return to zero_dig
	@(negedge tb_clk);  // check1
	@(negedge tb_clk);  // zero_dig
	@(negedge tb_clk);  // wait
	node_cnt = 132;
	check_result(tb_mem_addr, tb_mem_data_R, (256+(node_cnt-128)*3)+1, data[(256+(node_cnt-128)*3)+1], 1);  // check read
	@(negedge tb_clk);  // check0
	@(negedge tb_clk);  // fst_dig
	@(negedge tb_clk);  // wait
	node_cnt = 130;
	check_result(tb_mem_addr, tb_mem_data_R, (256+(node_cnt-128)*3)+2, data[(256+(node_cnt-128)*3)+2], 2);  // check read
	@(negedge tb_clk);  // check1

	check_write_CT(8'b01000000, 2, 0+128, 0); // A
	data[128] = 8'b01000000;
	data[0] = 2;

	@(negedge tb_clk);  // fst_dig
	@(negedge tb_clk);  // wait
	node_cnt = 130;
	check_result(tb_mem_addr, tb_mem_data_R, (256+(node_cnt-128)*3)+1, data[(256+(node_cnt-128)*3)+1], 2);  // check read
	@(negedge tb_clk);  // check1

	check_write_CT(8'b00000000, 2, 3+128, 3); // D
	data[3+128] = 8'b00000000;
	data[3] = 2;


	@(negedge tb_clk);  // fst_dig
	@(negedge tb_clk);  // wait
	node_cnt = 130;
	check_result(tb_mem_addr, tb_mem_data_R, (256+(node_cnt-128)*3), data[(256+(node_cnt-128)*3)], 2);  // check read  return to zero_dig
	@(negedge tb_clk);  // check1
	@(negedge tb_clk);  // zero_dig
	@(negedge tb_clk);  // wait
	node_cnt = 132;
	check_result(tb_mem_addr, tb_mem_data_R, (256+(node_cnt-128)*3), data[(256+(node_cnt-128)*3)], 1);  // check read  go to finish state
	@(negedge tb_clk);  // check0

	@(negedge tb_clk);  // finish
	@(negedge tb_clk);  // delay 1 clk for state transition
	$info("ALL_finish = %d\n", tb_ALL_finish);

/*
	tb_ini_W = 0;
	tb_ini_R = 1;
	@(negedge tb_clk);
	tb_ini_addr = 257;
	@(negedge tb_clk);
	$info("1   ini_data_R = %d,  addr = %d\n", tb_ini_data_R, tb_ini_addr); //  check initializaion
*/
	print_memory;



	

     end


endmodule


