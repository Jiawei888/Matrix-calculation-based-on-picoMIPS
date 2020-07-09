
`include "alucodes.sv"
`include "opcodes.sv"
//---------------------------------------------------------
module cputest;

parameter n = 8;

logic[9:0] SW; // master reset
logic[n-1:0] LED;
logic clk;
logic  signed[7:0] x2,y2,x,y,z,w;
logic  signed[7:0] x1,y1;
logic signed [15:0] a,b;
logic[7:0] Time;

integer seed;
initial begin seed = 3; end

cpu  #(.n(n))cpu1(.*);

//------------- code starts here ---------
// instruction decoder
initial
begin
 
  clk =  '0;
  SW[9:0]='0;
  a='0;
  b='0;
  Time='0;
  x=8'b0110_0000;//0.75	
  y=8'b0100_0000;//0.5
  z=8'b1100_0000;//-0.5
  w=8'b1110_1100;//-20
  #3ns SW[9] = 1;
  #3ns SW[9] = 0;
  #3ns SW[9] = 1;
  #5ns  forever #5ns clk = ~clk;
end

initial
begin
 //$display("Time:%d", Time);
  #2ns while(Time<=50)
begin
  #100ns SW[8] = '0;
  x1 = $random % 127;

  #50ns SW[7:0] = x1;
  
  //#50ns SW[7:0] = 5; //input x1 5   8'b0000_0101
  //x1=5;
  $display("x1 = %d,%b", x1,x1);
  #50ns SW[8] = '1;
  
  #50ns SW[8] = '0;
  y1 = $random % 127;  
  #50ns SW[7:0] = y1;
  //#50ns SW[7:0] = 8'b1111_1011; //input y1 -5  8'b1111_1011
  //y1=-5;
  $display("y1 = %d,%b", y1,y1);
  #50ns SW[8] = '1;
  
  #200ns SW[8] = '0; //show LED1[7:0]  
	
	        a=x*x1;//0.75*x1;
		//$display("a[14:7]=%b", a[14:7]);
		
		b=y*y1;//0.5*y1;
		//$display("b[14:7]=%b", b[14:7]);
		x2=a[14:7]+b[14:7]+8'b0001_0100;
	 #10ns if(LED==x2)
		$display("LED1 is right!!");
        else 
		$display("LED1 is wrong");
	$display("x2=%b, LED=%b", x2, LED);
  #200ns SW[8] = '1; //show LED2[7:0]
  
 
  	      a=z*x1;//-0.5*x1;
		//$display("a[14:7]=%b, a=%b, z=%b, x1=%b", a[14:7], a, z, x1);
	      b=x*y1;//0.75*y1;
		//$display("b[14:7]=%b", b[14:7]);
	      y2=a[14:7]+b[14:7]+w;
	  #10ns if(LED==y2)
		$display("LED2 is right!!");
        else 
		$display("LED2 is wrong");
	$display("y2=%b, LED=%b", y2, LED);
	Time++;
	SW[9:0]=10'b10_0000_0000;
	$display("Time:%d", Time);
end
end 
  

endmodule //module decoder --------------------------------
