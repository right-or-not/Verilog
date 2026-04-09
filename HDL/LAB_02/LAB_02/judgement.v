//judgement.v
module judgement(	
	input			clk_i,
	input			rst_i,
	input	[1:0]	jack_i,
	input	[1:0]	rose_i,
	input			valid_i,
	output	reg		jack_win_o,		
	output	reg		rose_win_o,
	output	reg 	win_valid_o	
);

	reg	[1:0]	compare_result;

	// input encoding
	parameter	ROCK = 2'b00,
				PAPER = 2'b01,
				SCISSORS = 2'b10,
				ILLEGAL = 2'b11;

	//  output encoding
	parameter	JACK_WIN = 2'b10,
				ROSE_WIN = 2'b01,
				TIE = 2'b00,
				INVALID = 2'b11;

	// funtction: compare two inputs and return the result
	function [1:0] compare(
		input [1:0]		a,
		input [1:0]		b
	);
		if (a == ILLEGAL || b == ILLEGAL) begin: COMPARE_ILLEGAL
			compare = INVALID;
		end
		else if (a == b) begin: COMPARE_TIE
			compare = TIE;
		end
		else begin: COMPARE_JACK_OR_ROSE_WIN
			case ({a, b})
				// Jack wins: Rock beats Scissors, Paper beats Rock, Scissors beats Paper
				{ROCK, SCISSORS}, {PAPER, ROCK}, {SCISSORS, PAPER}: 
					compare = JACK_WIN;
				// Rose wins: Scissors beats Rock, Rock beats Paper, Paper beats Scissors
				{SCISSORS, ROCK}, {ROCK, PAPER}, {PAPER, SCISSORS}: 
					compare = ROSE_WIN;
				// Invalid: Enhance code robustness (will not be in this case actually)
				default
					compare = INVALID;
			endcase
		end
	endfunction

	//add your code here
	// reset and valid logic
	always @(posedge clk_i or posedge rst_i) begin
		// High-level Reset: reset all outputs and internal registers
		if (rst_i) begin
			{jack_win_o, rose_win_o} <= INVALID;
			win_valid_o <= 0;
			compare_result <= 0;
		end
		// Valid input: compare and output the result
		else if (valid_i) begin
			
			// update outputs based on compare result
			{jack_win_o, rose_win_o} <= compare_result;

			// output valid
			// result is valid: set output valid
			if (compare_result != INVALID) begin: OUTPUT_VALID
				win_valid_o <= 1;
			end
			// result is invalid: clear output valid
			else begin: OUTPUT_INVALID
				win_valid_o <= 0;
			end
		end
		// No valid input: clear output valid
		else begin
			win_valid_o <= 0;
		end
	end

	// combinational logic
	// calculate compare_result realtime
	always @(*) begin
		// update compare result
		compare_result <= compare(jack_i, rose_i);
	end

endmodule

