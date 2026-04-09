//judgement_tb.v
`timescale 1ns / 1ps

`include "./judgement_seq.v"

module judgement_tb;
    reg         clk;
    reg         rst;
    reg [1:0]   jack;
    reg [1:0]   rose;
    reg         valid;
    wire        jack_win;
	wire        rose_win;
	wire        win_valid;

	parameter   ROCK = 2'b00,
				PAPER = 2'b01,
				SCISSORS = 2'b10;


	//add your code here
    // add instance of judgement
    judgement inst_judgement(
        .clk_i(clk),
        .rst_i(rst),
        .jack_i(jack),
        .rose_i(rose),
        .valid_i(valid),
        .jack_win_o(jack_win),
        .rose_win_o(rose_win),
        .win_valid_o(win_valid)
    );

    // init basic signal
    initial begin
        // init inputs
        jack <= 1'b0;
        rose <= 1'b0;
        valid <= 1'b0;
        // reset the module first
        rst <= 1'b1;
        #100;
        rst <= 1'b0;
    end

    // clock = 100MHz => T = 10ns
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // test the judgement module
    // generate valid signal
    initial begin
        // wait for the reset
        #100;
        // generate valid signal
        #20;
        forever begin
            valid = 1'b1;
            #10 valid = 1'b0;
            #90;
        end
    end

    // generate jack
    initial begin
        // wait for the reset
        #100;
        // generate jack signal
        forever begin
            #100 jack = jack + 1;
        end
    end

    // generate rose
    initial begin
        // wait for the reset
        #100;
        // generate rose signal
        forever begin
            #400 rose = rose + 1;
        end
    end


    // output vcd file
    initial begin
        $dumpfile("game.vcd");
		$dumpvars;

        // wait
        #100000;
        $display("[Game Finish]");
        $finish;
    end



endmodule 
	
	
	
	
	
	