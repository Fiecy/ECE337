// $Id: $
// File name:   ramcontroller.sv
// Created:     11/30/2016
// Author:      Jiacheng Yuan
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: ram controller

module sram_controller(
  input wire clk,
  input wire n_rst,
  input wire rw_trigger,
  input wire mem_clr,
  input wire mem_init,
  input wire mem_dump,
  input wire address,
  input wire r_en, w_en,
  input wire [7:0] write_data,
  output wire [7:0] sram_data
);
  localparam START_ADDR = 16'b0;
  localparam LAST_ADDR = 16'h1111; // number of cycles for 5 ms

  //reg r_en;
  //reg w_en;

  //reg [9:0] address;
  //reg [9:0] next_address;
 // reg [15:0] addr;
/*  reg [9:0] next_r_addr;
  reg [9:0] next_w_addr;
  reg [7:0] write_data_half;
  reg [7:0] read_data_half;
  reg [7:0] read_data;
  reg [7:0] next_read_data;
*/
  on_chip_sram_wrapper SRAM(
    .init_file_number(0),
    .dump_file_number(0),
    .mem_clr(mem_clr),
    .mem_init(mem_init),
    .mem_dump(0),
    .verbose(1'b0),
    .start_address(0),//START_ADDR
    .last_address(0), //LAST_ADDR
    .read_enable(r_en),
    .write_enable(w_en),
    .address(address),
    .read_data(sram_data),
    .write_data(write_data)
  );


assign address = {6'b0, address};

endmodule
