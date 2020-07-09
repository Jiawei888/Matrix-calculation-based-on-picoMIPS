//-----------------------------------------------------
// File Name   : alu.sv
// Function    : ALU module for picoMIPS
// Version: 1,  only 8 funcs
// Author:  tjk
// Last rev. 23 Oct 12
//-----------------------------------------------------

`include "alucodes.sv"  
module alu #(parameter n =8) (
   input logic signed[n-1:0] a, b, // ALU operands
   input logic [2:0] func, // ALU function code
   output logic [3:0] flags, // ALU flags V,N,Z,C
   output logic [n-1:0] result // ALU result
);       
//------------- code starts here ---------

// create an n-bit adder 
// and then build the ALU around the adder
logic signed [n-1:0] ar,b1; // temp signals
logic signed [15:0]r;
always_comb
begin
   if(func==`RSUB)
      b1 = ~b + 1'b1; // 2's complement subtrahend
   else b1 = b;

   ar = a+b1; // n-bit adder
end // always_comb
   
// create the ALU, use signal ar in arithmetic operations
always_comb
begin
  //default output values; prevent latches 
  flags = '0;
  r='0;
  result = a; // default
  case(func)
     `RADD  : begin
	     result = ar; // arithmetic addition
		  // V
        flags[3] = a[7] & b[7] & ~result[7] |  ~a[7] & ~b[7] 
                   &  result[7];
        // C
        flags[0] = a[7] & b[7]  |  a[7] & ~result[7] | b[7] 
                   & ~result[7];
		end
    `RSUB  : begin
	     result = ar; // arithmetic subtraction
		  // V
        flags[3] = ~a[7] & b[7] & ~result[7] |  a[7] & ~b[7] 
                  & result[7];
        // C - note: picoMIPS inverts carry when subtracting
        flags[0] = a[7] & ~b[7] |  a[7] & result[7] | ~b[7] 
                  & result[7];
		end   
    `MUL   : begin r = a * b; result = r[14:7]; //$display("result=%b,r=%b a=%b,b=%b", result,r,a,b); 
		end  

   endcase
	 
 
    // calculate flags Z and N
  flags[1] = result == {n{1'b0}}; // Z
  flags[2] = result[n-1]; // N
 
 end //always_comb

endmodule //end of module ALU


