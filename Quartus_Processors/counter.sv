// counter for slow clock
module counter #(parameter n = 24) //clock divides by 2^n, adjust n if necessary
  (input logic fastclk, input logic [9:0] SW, output logic clk);
  
logic [n-1:0] count;

always_ff @(posedge fastclk, negedge SW[9])
if(~SW[9])    
	count <= 0;
else   begin count <= count + 1;  end

assign clk = count[n-1]; // slow clock

endmodule