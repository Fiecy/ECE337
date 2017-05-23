// $Id: $
// File name:   build_tree.sv
// Created:     12/10/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Top level block for Build Tree and Code Transform block -- Yi Li
module BTCT
(
	input clk,
	input n_rst,
	input ALL_start,
	input ini_W,
	input ini_R,
	input [7:0] ini_data_W,
	input [9:0] ini_addr,
	output reg [7:0] ini_data_R,
	output reg ALL_finish,
	output reg mem_R,
	output reg mem_W,
	output reg [7:0] mem_data_W,
	output reg [7:0] mem_data_R,
	output reg [15:0] mem_addr,
	output reg BT_start,
	output reg CT_start
);
/*
	reg [15:0] mem_addr;
	reg [7:0] mem_data_R;
	reg [7:0] mem_data_W;
	reg mem_R;
	reg mem_W;
*/
	reg BT_finish;
	reg CT_finish;
	reg BT_R;
	reg BT_W;
	reg CT_R;
	reg CT_W;
	reg [7:0] BN_data;
	reg [7:0] RC_data;
	reg [9:0] BT_addr;
	reg [9:0] CT_addr;
	//reg BT_start;
	//reg CT_start;
	reg [7:0] FM_data;
	reg [7:0] SN_data;
	
	

	on_chip_sram_wrapper DUT
	(
		// Memory interface signals
		.read_enable(mem_R),
		.write_enable(mem_W),
		.address(mem_addr),
		.read_data(mem_data_R),
		.write_data(mem_data_W)
	);
/*
	controller_BTCT ctrl1 (.clk(clk), .n_rst(n_rst), .ini_data_W(ini_data_W), .ini_addr(ini_addr), .ini_data_R(ini_data_R), .ini_R(ini_R), .ini_W(ini_W),
		.mem_R(mem_R), .mem_W(mem_W), .mem_addr(mem_addr), .mem_data_R(mem_data_R), .mem_data_W(mem_data_W),
		.ALL_start(ALL_start), .ALL_finish(ALL_finish), .BT_start(BT_start), .BT_finish(BT_finish), .CT_start(CT_start), .CT_finish(CT_finish));
*/
	controller_BTCT ctrl (.clk(clk), .n_rst(n_rst), .BT_finish(BT_finish), .CT_finish(CT_finish), .ALL_start(ALL_start), .ALL_finish(ALL_finish), .BT_R(BT_R), .BT_W(BT_W), .CT_R(CT_R), .CT_W(CT_W), 
		.ini_data_W(ini_data_W), .ini_addr(ini_addr), .ini_data_R(ini_data_R), .ini_R(ini_R), .ini_W(ini_W),
		.mem_R(mem_R), .mem_W(mem_W), .mem_addr(mem_addr), .mem_data_R(mem_data_R), .mem_data_W(mem_data_W),
		.BN_data(BN_data), .RC_data(RC_data), .BT_addr(BT_addr), .CT_addr(CT_addr), .BT_start(BT_start), .CT_start(CT_start), .FM_data(FM_data), .SN_data(SN_data));

	build_tree bt_block (.clk(clk), .n_rst(n_rst), .BT_start(BT_start), .FM_data(FM_data), .BT_finish(BT_finish), .BT_addr(BT_addr), .tree_R(BT_R), .tree_W(BT_W), .BN_data(BN_data));

	code_transform ct_block (.clk(clk), .n_rst(n_rst), .CT_start(CT_start), .SN_data(SN_data), .CT_finish(CT_finish), .CT_addr(CT_addr), .CT_R(CT_R), .CT_W(CT_W), .RC_data(RC_data));

endmodule
	







