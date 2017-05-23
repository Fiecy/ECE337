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

  input wire mem_clr,
  //input wire mem_init,
  //input wire mem_dump,
  input wire [9:0] address,
  input wire r_en, w_en,
  input wire [7:0] write_data,
  output wire [7:0] read_data
);
  localparam START_ADDR = 16'b0;
  localparam LAST_ADDR = 16'h1111; // number of cycles for 5 ms

  reg [15:0] input_addr;
  //reg [7:0]  read_data_next;

  on_chip_sram_wrapper SRAM(
    .init_file_number(1'b0),
    .dump_file_number(1'b0),
    .mem_clr(mem_clr),
    .mem_init(1'b0),
    .mem_dump(1'b0),
    .verbose(1'b0),
    .start_address(1'b0),//START_ADDR
    .last_address(1'b0), //LAST_ADDR
    .read_enable(r_en),
    .write_enable(w_en),
    .address(input_addr),
    .read_data(read_data),
    .write_data(write_data)
  );

always_ff @ (posedge clk, negedge n_rst) begin
	if(n_rst == 0) begin
		input_addr <= 0;
	end 
	else begin
		input_addr <= {6'b0, address};
	end
end

endmodule
