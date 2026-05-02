module mix_coloumns(
	input wire [127:0] Col_in,
	output wire [127:0] Col_out 
);

	function [7:0] Mul_2;
		input [7:0] A;
		begin
			Mul_2 = (A[7]) ? ((A << 1) ^ 8'h1b) : (A << 1);
		end
	endfunction

	function [7:0] Mul_3;
		input [7:0] A;
		begin
			Mul_3 = Mul_2(A) ^ A;
		end
	endfunction

	integer idx;
	reg [7:0] in [0:15];
	reg [7:0] out [0:15];
	
	always @(*) begin
		for (idx = 0; idx <= 15; idx = idx + 1) begin
			in[idx] = Col_in[127 -(8*idx) -: 8];
		end
		
		for (idx = 0; idx <= 3; idx = idx + 1) begin
			out[4*idx] = Mul_2(in[4*idx]) ^ Mul_3(in[4*idx+1]) ^ in[4*idx+2] ^ in[4*idx+3]; 
			out[4*idx+1] = in[4*idx] ^ Mul_2(in[4*idx+1]) ^ Mul_3(in[4*idx+2]) ^ in[4*idx+3]; 
			out[4*idx+2] = in[4*idx] ^ in[4*idx+1] ^ Mul_2(in[4*idx+2]) ^ Mul_3(in[4*idx+3]); 
			out[4*idx+3] = Mul_3(in[4*idx]) ^ in[4*idx+1] ^ in[4*idx+2] ^ Mul_2(in[4*idx+3]); 
		end
	end

	generate
		genvar k;
		for(k = 0; k <= 15; k = k + 1) begin : out_for
			assign Col_out[127-(8*k) -: 8] = out[k];
		end
	endgenerate
endmodule

