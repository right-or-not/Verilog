module stopwatch(
	input				clk_i,
	input				rst_i,
	input				trig_i,
	output reg [10:0]	millisec_o,
	output reg [5:0]	second_o,
	output reg			valid_o
);
	
	reg [3:0]	base_cnt;
	reg [10:0]	millisec;
	reg [5:0]	second;
	
	always @(posedge clk_i or posedge rst_i) begin
		// asynchronous reset: active high
		if (rst_i) begin
			// clear all regs
			base_cnt <= 4'd0;
			millisec <= 11'd0;
			second <= 6'd0;
			// clear all output regs
			millisec_o <= 11'd0;
			second_o <= 6'd0;
			valid_o <= 1'b0;
		end

		// update timer regs
		else begin
			// basic counter: T_cnt = 8
			if (base_cnt == 4'd7) begin
				// reset base_cnt
				base_cnt <= 4'd0;

				// millisec counter: T_millisec = 1024
				if (millisec == 11'd1023) begin
					// reset millisec
					millisec <= 11'd0;

					// second counter: T_second = 60
					if (second == 6'd59) begin
						second <= 6'd0;
					end
					else begin
						second <= second + 6'd1;
					end
				end
				else begin
					millisec <= millisec + 11'd1;
				end
			end
			else begin
				base_cnt <= base_cnt + 4'd1;
			end

			// trigger signal: output the time or not
			if (trig_i) begin
				millisec_o <= millisec;
				second_o <= second;
				valid_o <= 1'b1;
			end
			else begin
				valid_o <= 1'b0;
			end
		end
	end
	
endmodule
