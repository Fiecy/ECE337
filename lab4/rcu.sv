// $Id: $
// File name:   rcu.sv
// Created:     9/19/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
module rcu
  (
   input  clk,
   input  n_rst,
   input  start_bit_detected,
   input  packet_done,
   input  framing_error,
   output reg sbc_clear,
   output reg sbc_enable,
   output reg load_buffer,
   output reg enable_timer
   );

   typedef enum bit [3:0] {idle, start, packet, stop, check_frame, store} stateType;
   
   stateType 	  state;
   stateType      next_state;
   

   always_ff @ (posedge clk, negedge n_rst)
     begin
	if (n_rst == 0)
	  state <= idle;
	else
	  state <= next_state;
     end
   
   always_comb
     begin : NXT_LOGIC
	// Set the default value(s)
	next_state = state;
	// Initialize the flags
	sbc_clear = 0;
	sbc_enable = 0;
	load_buffer = 0;
	enable_timer = 0;
	
	case(state)
	  idle:
	    begin
	       if (1 == start_bit_detected)
		 next_state = start;
	    end
	  start:
	    begin
	       sbc_clear = 1;
	       next_state = packet;
	    end
	  packet:
	    begin
	       enable_timer = 1;
	       if (1 == packet_done)
		 next_state = stop;
	    end
	  stop:
	    begin
	       sbc_enable = 1;
	       next_state = check_frame;
	    end
	  check_frame:
	    begin
	       if (1 == framing_error)
		 next_state = idle;
	       else
		 next_state = store;
	    end
	  store:
	    begin
	       load_buffer = 1;
	       next_state = idle;
	    end
	endcase // case (state)
     end // block: NXT_LOGIC
endmodule // rcu

	  
	
	
	  
