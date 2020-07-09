//------------------------------------
// File Name   : cpu.sv
// Function    : picoMIPS CPU top level encapsulating module, version 2
// Author      : tjk
// Ver 2 :  PC , prog memory, regs, ALU and decoder, no RAM
// Last revised: 27 Oct 2012
//------------------------------------

`include "alucodes.sv"
module cpu #( parameter n = 8) // data bus width
(input logic fastclk,  
  input logic [9:0] SW,// master reset
  output logic[n-1:0] LED // need an output port, tentatively this will be the ALU output
);       

// declarations of local signals that connect CPU modules
// ALU
logic [2:0] ALUfunc; // ALU function
logic [3:0] flags; // ALU flags, routed to decoder
logic imm; // immediate operand signal
logic [n-1:0] Alub; // output from imm MUX
//
// registers
logic signed [n-1:0] Rdata1, Rdata2, Wdata; // Register data
logic w; // register write control
//
// Program Counter 
parameter Psize = 6; // up to 64 instructions
logic PCincr,PCabsbranch,PCrelbranch; // program counter control
logic [Psize-1 : 0]ProgAddress;
// Program Memory
parameter Isize = n+16; // Isize - instruction width
logic [Isize:0] I; // I - instruction code
logic [4:0] writein;
logic [5:0] PCout_out[4:0];
logic clk;
//------------- code starts here ---------
// module instantiations

counter c (.fastclk(fastclk),.SW(SW),.clk(clk));

pc  #(.Psize(Psize)) progCounter (.clk(clk),.reset(SW[9]),
        .PCincr(PCincr), .PCout_out(PCout_out),
        .PCabsbranch(PCabsbranch),
        .PCrelbranch(PCrelbranch),
        .Branchaddr(I[Psize-1:0]), 
        .PCout(ProgAddress) );

prog #(.Psize(Psize),.Isize(Isize)) 
      progMemory (.address(ProgAddress),.I(I));

decoder  D (.opcode(I[Isize-1:Isize-6]),
            .PCincr(PCincr),
            .PCabsbranch(PCabsbranch), 
            .PCrelbranch(PCrelbranch),
            .flags(flags), // ALU flags
		  .ALUfunc(ALUfunc),.imm(imm),.w(w));

regs   #(.n(n))  gpr(.clk(clk),.w(w),
        .Wdata(Wdata),
		.Raddr2(I[Isize-7:Isize-11]),  // reg %d number I[17:13]
		.Raddr1(I[Isize-12:Isize-16]), // reg %s number I[12:8]
		.Raddr3(writein),
        .SW(SW),.Rdata1(Rdata1),.Rdata2(Rdata2));

sequencer  #(.n(n)) abc(.clk(clk), .SW(SW), .writein(writein), .PCout_out(PCout_out));

alu    #(.n(n))  iu(.a(Rdata1),.b(Alub),
       .func(ALUfunc),.flags(flags),
       .result(Wdata)); // ALU result -> destination reg



// create MUX for immediate operand
assign Alub = (imm ? I[n-1:0] : Rdata2);
//assign Wdata = (SW[8] ? SW[7:0] : );

// connect ALU result to outport
assign LED = Wdata;

endmodule