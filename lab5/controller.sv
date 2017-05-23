// $Id: $
// File name:   controller.sv
// Created:     9/27/2016
// Author:      Yi Li
// Lab Section: 337-03
// Version:     1.0  Initial Design Entry
// Description: .
module controller
  (
   input wire 	    clk,
   input wire 	    n_reset,
   input wire 	    dr,
   input wire 	    lc,
   input wire 	    overflow,
   output reg 	    cnt_up,
   output reg 	    clear,
   output wire 	    modwait,
   output reg [2:0] op,
   output reg [3:0] src1,
   output reg [3:0] src2,
   output reg [3:0] dest,
   output reg 	    err
);

   typedef enum bit [4:0] {idle, eidle, load1, load2, load3, load4, pause1, pause2, pause3, pause4, store, zero, sort1, sort2, sort3, sort4, mul1, mul2, mul3, mul4, add1, add2, sub1, sub2} stateType;
   
   stateType 	  state;
   stateType      next_state;
   reg 		mw;
   reg 		next_mw;
   
   always_ff @ (posedge clk, negedge n_reset)
     begin
	if (n_reset == 0)
	  begin
	     state <= idle;
	     mw <= 0;
	  end
	else
	  begin
	     state <= next_state;
	     mw <= next_mw;
	  end
     end

   always_comb
     begin
	next_state = state;
	cnt_up = 0;
	clear = 0;
	op = 0;
	src1 = 0;
	src2 = 0;
	dest = 0;
	err = 0;
	next_mw = 0;
	
	case(state)
	  idle:
	    begin
	       clear = 1;
	       if(1 == lc)
		 begin
		    next_state = load1;
		    next_mw = 1;
		 end
	       else if (1 == dr)
		 begin
		    next_state = store;
		    next_mw = 1;
		 end
	       else
		 next_state = idle;
	    end // case: idle
	  
	  load1:
	    begin
	       next_state = pause1;
	       next_mw = 0;
	       op = 3'b011;
	       clear = 1;
	       dest = 6;
	    end
	  pause1:
	    begin
	       if (1 == lc)
		 begin
		    next_state = load2;
		    next_mw = 1;
		 end
	       else
		 begin
		    next_state = pause1;
		 end
	    end
	  load2:
	    begin
	       next_state = pause2;
	       next_mw = 0;
	       op = 3'b011;
//	       clear = 1;
	       dest = 7;
	    end
	  pause2:
	    begin
	       if (1 == lc)
		 begin
		    next_state = load3;
		    next_mw = 1;
		 end
	       else
		 begin
		    next_state = pause2;
		 end
	    end
	  load3:
	    begin
	       next_state = pause3;
	       next_mw = 0;
	       op = 3'b011;
//	       clear = 1;
	       dest = 8;
	    end
	  pause3:
	    begin
	       if (1 == lc)
		 begin
		    next_state = load4;
		    next_mw = 1;
		 end
	       else
		 begin
		    next_state = pause3;
		 end
	    end
 	  load4:
	    begin
	       next_state = idle;
	       op = 3'b011;
//	       clear = 1;
	       dest = 9;
	    end // end load
	  
	  store:
	    begin
	       if (0 == dr)
		 begin
		    next_state = eidle;
		    next_mw = 1;
		 end
	       else
		 begin
		    next_state = zero;
		    next_mw = 0;
		 end
	       op = 3'b010;
	       dest = 5;
	    end	  
	  zero:
	    begin
	       next_state = sort1;
	       next_mw = 1;
	       op = 3'b101;
	    end
	  sort1:
	    begin
	       next_state = sort2;
	       next_mw = 1;
	       op = 3'b001;
	       src1 = 2;
	       dest = 1;
	    end
	  sort2:
	    begin
	       next_state = sort3;
	       next_mw = 1;
	       op = 3'b001;
	       src1 = 3;
	       dest = 2;
	    end	 
	  sort3:
	    begin
	       next_state = sort4;
	       next_mw = 1;
	       op = 3'b001;
	       src1 = 4;
	       dest = 3;
	    end	 
	  sort4:
	    begin
	       next_state = mul1;
	       next_mw = 1;
	       op = 3'b001;
	       src1 = 5;
	       dest = 4;
	    end // end sort	
	  mul1:
	    begin
	       next_state = sub1;
	       next_mw = 1;
	       op = 3'b110;
	       src1 = 1;
	       src2 = 6;
	       dest = 10;
	    end
	  sub1:
	    begin
	       if (1 == overflow)
		 begin
		    next_state = eidle;
		    next_mw = 0;
		 end
	       else
		 begin
		    next_state = mul2;
		    next_mw = 1;
		 end
	       op = 3'b101;
	       src2 = 10;
	       dest = 0;
	    end // case: sub1
	  mul2:
	    begin
	       next_state = add1;
	       next_mw = 1;
	       op = 3'b110;
	       src1 = 2;
	       src2 = 7;
	       dest = 10;
	    end
	  add1:
	    begin
	       if (1 == overflow)
		 begin
		    next_state = eidle;
		    next_mw = 0;
		 end
	       else
		 begin
		    next_state = mul3;
		    next_mw = 1;
		 end
	       op = 3'b100;
	       src2 = 10;
	       dest = 0;
	    end
	  mul3:
	    begin
	       next_state = sub2;
	       next_mw = 1;
	       op = 3'b110;
	       src1 = 3;
	       src2 = 8;
	       dest = 10;
	    end	  
	  sub2:
	    begin
	       if (1 == overflow)
		 begin
		    next_state = eidle;
		    next_mw = 0;
		 end
	       else
		 begin
		    next_state = mul4;
		    next_mw = 1;
		 end
	       op = 3'b101;
	       src2 = 10;
	       dest = 0; 
	    end  
	  mul4:
	    begin
	       next_state = add2;
	       next_mw = 1;
	       op = 3'b110;
	       src1 = 4;
	       src2 = 9;
	       dest = 10;
	    end	
	  add2:
	    begin
	       if (1 == overflow)
		 begin
		    next_state = eidle;
		    next_mw = 0;
		 end
	       else
		 begin
		    next_state = idle;
		    next_mw = 1;
		    cnt_up = 1;
		 end
	       op = 3'b100;
	       src2 = 10;
	       dest = 0;
	    end
	  
	  eidle:
	    begin
	       err = 1;
	       if(1 == dr)
		 next_state = store;
	       else
		 next_state = eidle;
	    end
	endcase	
   end
   assign modwait = mw; 
endmodule // controller


