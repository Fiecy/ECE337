// $Id: $
// File name:   counter.sv
// Created:     11/25/2016
// Author:      Zhichao Wang
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: Count the frequency of each character
module counter(
input reg clk,
input reg n_rst,
input reg cnt_start,
input reg [7:0] data_c,
output reg [9:0] cnt_addr,
input reg [7:0] num_r,
output reg cnt_w,
output reg cnt_r,
output reg [7:0] new_w,
output reg err
);


reg [7:0] Next_addr_gen;
reg [7:0] addr_gen;
reg [7:0] Next_new_num;
reg [7:0] new_num;
reg [7:0] cnt_addr_r;
reg [7:0] cnt_addr_w;


typedef enum bit[2:0]{idle, get_data,read_num,increase,write_num}stateType;
stateType state;
stateType next_state;

always_ff@(posedge clk, negedge n_rst)
begin
    if(n_rst == 0)
   begin
     state <= idle;
     addr_gen <= 0;
     new_num <=0;
     cnt_addr_w <= 0;
     
   end else begin
     state <= next_state;
     new_num <= Next_new_num;
     addr_gen <= Next_addr_gen;
     cnt_addr_w <= cnt_addr_r;
     end    
end


always_comb
   begin
   next_state = state;
   cnt_r = 0;
   cnt_w = 0;
   new_w = 0;
   err = 0;
   Next_new_num = new_num;
   Next_addr_gen = addr_gen;
   cnt_addr_r = cnt_addr_w; 
   


case(state)
idle:
begin
    if(cnt_start == 1)
    begin 
    next_state = get_data;
    end else begin
    next_state = idle;
    end
end

get_data:
    begin 
    if(data_c > 8'b1111111)
    begin 
    err = 1;
    next_state = idle;
    end else begin
    Next_addr_gen = data_c + 128;
    next_state = read_num;
    end
    end
  
read_num:
   begin
   cnt_r =1;
   cnt_addr = addr_gen;
   next_state = increase;
   end

increase:
   begin
   Next_new_num = num_r + 1;
   cnt_addr_r = cnt_addr; 
   next_state = write_num;
   end

write_num:
   begin
   cnt_w = 1;
   cnt_addr = cnt_addr_w;
   new_w = new_num;
   next_state = idle;
   end
   endcase
end    



endmodule






