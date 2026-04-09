module stream_led(
	input				clk_i,
	input				rst_i,
	output reg [7:0]	led_o
);
	
  	reg [10:0]	clk_cnt;

	always @(posedge clk_i or posedge rst_i) begin
		// asynchronous reset: active high
		if (rst_i) begin
			// clear all regs
			clk_cnt <= 0;
			// set the output
			led_o <= 8'b0000_0001;
		end

		// stream led
		else begin
			// clk: 100MHz => 1T = 1 / 100MHz = 0.01us
			// Delay 10us: 10us = 1000 * 0.01us => clock counter counts up to 1000
			if (clk_cnt == 11'd999) begin
				// reset the clock counter
				clk_cnt <= 11'd0;
				// shift left circularly
				if (led_o[7] == 1'b1) begin
					led_o <= 8'b0000_0001;
				end
				else begin
					led_o <= led_o << 1;
				end
			end
			else begin
				clk_cnt <= clk_cnt + 11'd1;
			end
		end
	end

endmodule
