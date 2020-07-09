module sequencer #( parameter n = 8) // data bus width
( input logic clk,  
  input logic [9:0] SW, // Switches SW0..SW9
  
  output logic [4:0] writein, output logic [5:0] PCout_out [4:0]);
 
logic [2:0] flag1;

enum {Initial, write_x1, Null, write_y1, show_x1, show_y1} present_state, next_state;

always_ff @(posedge clk, negedge SW[9]) 
begin
	if(~SW[9])
	begin present_state <= Initial; flag1 <= 0;  end
	else if(SW[8]==1 && flag1==0)
	begin present_state <= next_state; flag1<=1;end
	else if(SW[8]==0 && flag1==1)
	begin present_state <= next_state; flag1<=0;end
	else
	;
end

always_comb
begin
	writein='0;
	   case(present_state)
		Initial: begin		   
			PCout_out[0]=6;
			PCout_out[1]=8; 
			PCout_out[2]=22;
			PCout_out[3]=23;
			PCout_out[4]=0;
			next_state=write_x1;
		         end
		write_x1: begin
			writein=5'b00100;
			PCout_out[0]=7;
			next_state=Null;
		          end
		Null: begin
			next_state=write_y1;
			writein=5'b00101;
		          end
		write_y1: begin
			writein=5'b00101;
			PCout_out[1]=9;
			next_state= show_x1;
		          end
		show_x1: begin
			PCout_out[2]=23;
			next_state= show_y1;
		          end
		show_y1: begin
			PCout_out[3]=24;
			PCout_out[4]=24;
			next_state= Initial;
		          end
   		endcase
end
endmodule