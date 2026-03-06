module adder(clk, rst_n, a, b, c);
    input [3:0] a, b;
    output [7:0] c;
    input clk, rst_n;
    
    reg [7:0] c_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) 
            c_reg <= 8'h0;
        else 
            c_reg <= a + b;
    end
    
    assign c = c_reg;
endmodule
