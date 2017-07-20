`timescale 1ps/1ps

module multiplier(output reg[63:0] m, input[31:0] m1, input[31:0] m2); 
	integer       i;
	always @* begin
		m = 0;

		for (i=0; i<32; i=i+1)
			if ( m2[i] == 1 )
				m = m + ( m1 << i );

	end

endmodule

module divider(); 
reg [31:0] dividend, divisor, quotient, remainder; 
initial begin  
	dividend = 156; 
	divisor = 23; 
	tdivide(dividend, divisor, quotient, remainder); 
	$display(" dividend = %d divisor = %d quotient = %d, remainder = %d", dividend, divisor, quotient, remainder); 
	dividend = 0; 
	divisor = 1; 
	tdivide(dividend, divisor, quotient, remainder); 
	$display(" dividend = %d divisor = %d quotient = %d, remainder = %d", dividend, divisor, quotient, remainder); 
	dividend = 156; 
	divisor = 0; 
	tdivide(dividend, divisor, quotient, remainder); 
	$display(" dividend = %d divisor = %d quotient = %d, remainder = %d", dividend, divisor, quotient, remainder); 
	dividend = 1; 
	divisor = 10421; 
	tdivide(dividend, divisor, quotient, remainder); 
	$display(" dividend = %d divisor = %d quotient = %d, remainder = %d", dividend, divisor, quotient, remainder); 
	dividend = 1132456; 
	divisor = 231352; 
	tdivide(dividend, divisor, quotient, remainder); 
	$display(" dividend = %d divisor = %d quotient = %d, remainder = %d", dividend, divisor, quotient, remainder); 
end  

task tdivide(input [31:0] dividend, input [31:0] divisor, output [31:0] quotient, output [31:0] remainder); 
	integer bits;
	integer count; 
	reg [31:0] olddividend; 
	reg orbit; 
	begin 
	remainder = 0; 
	quotient  = 0; 
	if (divisor == 0) begin  //always 0
		quotient = 0; 
		remainder = divisor + 1; 
	end 
	else if (divisor == dividend) 
		quotient = 1; 
	else if (divisor > dividend) 
		remainder = dividend; 
	else begin 
		bits = 32; 
		while (remainder < divisor) begin //this loop goes one too far 
			remainder = (remainder << 1) | (dividend>>31); 
			olddividend = dividend; //so we save the last dividend to reverse it after 
			dividend = dividend << 1; 
			bits = bits - 1; 
		end  
		dividend = olddividend; 
		remainder = remainder >> 1; 
		bits = bits + 1; 
		for (count = 0; count < bits; count = count + 1) begin 
			remainder = (remainder << 1) | (dividend>>31); 
			orbit = (remainder-divisor) >> 31;
			orbit = ~orbit; 
			dividend = dividend << 1; 
			quotient = (quotient << 1) | orbit; 
			if (orbit) begin
				remainder = (remainder-divisor); 
			end
		end  
	end  
	end 
endtask 
endmodule  

