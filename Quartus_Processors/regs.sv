//-----------------------------------------------------
// File Name : regs.sv
// Function : picoMIPS 32 x n registers, %0 == 0
// Version 1 :
// Author: tjk
// Last rev. 27 Oct 2012
//-----------------------------------------------------
module regs #(parameter n = 8) // n - data bus width
(input logic clk, w, // clk and write control
 input logic [n-1:0] Wdata,
 input logic [4:0] Raddr1, Raddr2, Raddr3,//%s,%d
 input logic [9:0] SW,
 output logic signed[n-1:0] Rdata1, Rdata2);

 	// Declare 32 n-bit registers 
	logic [n-1:0] gpr [31:0];

	
	// write process, dest reg is Raddr2
	always_ff @ (posedge clk)
	begin
		if(w)
            gpr[Raddr2] <= Wdata;
		if(SW[8])
		 gpr[Raddr3] <= SW[7:0];
		
	end

	// read process, output 0 if %0 is selected
	always_comb
	begin
	   if (Raddr1==5'd0)  //%s
	         Rdata1 =  {n{1'b0}};
        else  Rdata1 = gpr[Raddr1];
	 
        if (Raddr2==5'd0)    //%d
	        Rdata2 =  {n{1'b0}};
	  else  Rdata2 = gpr[Raddr2];
	end	
	
endmodule // module regs