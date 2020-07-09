//-----------------------------------------------------
// File Name : pc.sv
// Function : picoMIPS Program Counter
// functions: increment, absolute and relative branches
// Author: tjk
// Last rev. 24 Oct 2012
//-----------------------------------------------------
module pc #(parameter Psize = 4) // up to 64 instructions
(input logic clk, reset, PCincr,PCabsbranch,PCrelbranch,
 input logic [Psize-1:0] PCout_out[4:0],
 input logic [Psize-1:0] Branchaddr,
 output logic [Psize-1 : 0]PCout
);

//------------- code starts here---------
logic[Psize-1:0] Rbranch; // temp variable for addition operand
always_comb
  if (PCincr)
       Rbranch = { {(Psize-1){1'b0}}, 1'b1};
  else Rbranch =  Branchaddr;


always_ff @ ( posedge clk or negedge reset) // async reset

  if (~reset) // sync reset
     begin PCout <= {Psize{1'b0}}; 
	   end
  else if(PCout==6)
        begin PCout<=PCout_out[0];//$display("NOP_6");
	end
  else if(PCout==8)
	begin PCout<=PCout_out[1];//$display("NOP_8");
	end
  else if(PCout==22)
	begin PCout<=PCout_out[2];//$display("NOP_20"); 
	end
  else if(PCout==23)
	begin PCout<=PCout_out[3];//$display("NOP_22");
	end
  else if(PCout==24)
	begin PCout<=PCout_out[4];//$display("NOP_22");
	end
  else if(PCout==63)
	PCout<=63;
  else if (PCincr | PCrelbranch) // increment or relative branch
     PCout <= PCout + Rbranch; // 1 adder does both
  else if (PCabsbranch) // absolute branch
     PCout <= Branchaddr;
	
	
	 
endmodule // module pc