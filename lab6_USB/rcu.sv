// $Id: $
// File name:   rcu.sv
// Created:     10/12/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
module rcu
(
 input clk,
 input n_rst,
 input d_edge,
 input eop,
 input shift_enable,
 input [7:0] rcv_data,
 input byte_received,
 output reg rcving,
 output reg w_enable,
 output reg r_error
 );

   typedef enum bit [3:0] {idle,eidle,receive_sync,checksync,receiving,receive_wrong,receive_wrong_waitedge,store,eopcheck,eop_waitedge} stateType;

   stateType state;
   stateType next_state;

   always_ff @(posedge clk, negedge n_rst)
     begin
	if (n_rst == 0)
	  begin
	     state <= idle;
	  end
	else
	  begin
	     state <= next_state;
	  end // else: !if(n_rst == 0)
     end // always_ff @

   always_comb
     begin
	next_state = state;
	rcving = 1;
	w_enable = 0;
	r_error = 0;

	case(state)
	  idle:
	    begin
	       rcving = 0;
	       if (1 == d_edge)
		 begin
		    next_state = receive_sync;
		 end
	       else
		 begin
		    next_state = idle;
		 end
	    end // case: idle
	  receive_sync:
	    begin
	       if (1 == byte_received)
		 begin
		    next_state = checksync;
		 end
	       else
		 begin
		    next_state = receive_sync;
		 end
	    end // case: receive_sync
	  checksync:
	    begin
	       if (8'b10000000 == rcv_data)
		 begin
		    next_state = receiving;
		 end
	       else
		 begin
		    next_state = receive_wrong;
		 end
	    end // case: checksync
	  receiving:
	    begin
	       if (1 == eop & 1 == shift_enable)
		 begin
		    next_state = receive_wrong_waitedge;
		 end
	       else if (1 == byte_received)
		 begin
		    next_state = store;
		 end
	       else
		 begin
		    next_state = receiving;
		 end
	    end // case: receiving
	  store:
	    begin
	       w_enable = 1;
	       next_state = eopcheck;
	    end // case: store
	  eopcheck:
	    begin
	       if (0 == shift_enable)
		 begin
		    next_state = eopcheck;
		 end
	       else if (1 == eop)
		 begin
		    next_state = eop_waitedge;
		 end
	       else
		 begin
		    next_state = receiving;
		 end
	    end // case: eop
	  eop_waitedge:
	    begin
	       if (1 == d_edge)
		 begin
		    next_state = idle;
		 end
	       else
		 begin
		    next_state = eop_waitedge;
		 end
	    end // case: eop_waitedge
	  receive_wrong:
	    begin
	       r_error = 1;
	       if (0 == shift_enable)
		 begin
		    next_state = receive_wrong;
		 end
	       else if (1 == eop)
		 begin
		    next_state = receive_wrong_waitedge;
		 end
	       else
		 begin
		    next_state = receive_wrong;
		 end
	    end // case: receive_wrong
	  receive_wrong_waitedge:
	    begin
	       r_error = 1;
	       if (1 == d_edge)
		 begin
		    next_state = eidle;
		 end
	       else
		 begin
		    next_state = receive_wrong_waitedge;
		 end
	    end // case: receive_wrong_waitedge
	  eidle:
	    begin
	       rcving = 0;
	       r_error = 1;
	       if (1 == d_edge)
		 begin
		    next_state = receive_sync;
		 end
	       else
		 begin
		    next_state = eidle;
		 end
	    end // case: eidle
	endcase
     end // always_comb
   
endmodule
		   
	    
