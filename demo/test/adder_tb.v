`timescale 1ns / 1ps

`include "adder.v"

module adder_tb;

// 测试信号定义
reg clk;
reg rst_n;
reg [3:0] a;
reg [3:0] b;
wire [7:0] c;

// 实例化被测试模块
adder uut (
    .clk(clk),
    .rst_n(rst_n),
    .a(a),
    .b(b),
    .c(c)
);

// 时钟生成：100MHz (周期10ns)
initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 每5ns翻转，周期10ns
end

// 测试激励
initial begin
    // 初始化信号
    a = 4'b0000;
    b = 4'b0000;
    rst_n = 0;  // 复位有效（低电平）
    
    // 打开波形文件
    $dumpfile("adder_tb.vcd");
    $dumpvars(0, adder_tb);
    
    // 显示测试开始
    $display("========================================");
    $display("加法器测试开始");
    $display("时间\t a\t b\t c");
    $display("========================================");
    
    // 保持复位20ns
    #20;
    rst_n = 1;  // 释放复位
    $display("%0t ns\t 复位释放", $time);
    
    // 测试用例1：2 + 3 = 5
    @(posedge clk);
    a = 4'd2;   // 2
    b = 4'd3;   // 3
    @(posedge clk);
    $display("%0t ns\t %d\t %d\t %d", $time, a, b, c);
    
    // 测试用例2：5 + 7 = 12
    @(posedge clk);
    a = 4'd5;   // 5
    b = 4'd7;   // 7
    @(posedge clk);
    $display("%0t ns\t %d\t %d\t %d", $time, a, b, c);
    
    // 测试用例3：10 + 6 = 16
    @(posedge clk);
    a = 4'd10;  // 10
    b = 4'd6;   // 6
    @(posedge clk);
    $display("%0t ns\t %d\t %d\t %d", $time, a, b, c);
    
    // 测试用例4：15 + 15 = 30 (注意：15+15=30，8位输出足够)
    @(posedge clk);
    a = 4'd15;  // 15
    b = 4'd15;  // 15
    @(posedge clk);
    $display("%0t ns\t %d\t %d\t %d", $time, a, b, c);
    
    // 测试用例5：0 + 0 = 0
    @(posedge clk);
    a = 4'd0;
    b = 4'd0;
    @(posedge clk);
    $display("%0t ns\t %d\t %d\t %d", $time, a, b, c);
    
    // 测试用例6：边界值：1 + 255? 但b只有4位，最大值15
    @(posedge clk);
    a = 4'd8;
    b = 4'd8;   // 8+8=16
    @(posedge clk);
    $display("%0t ns\t %d\t %d\t %d", $time, a, b, c);
    
    // 等待几个时钟周期
    #50;
    
    $display("========================================");
    $display("测试完成 at %0t ns", $time);
    $display("========================================");
    
    $finish;
end

// 监控输出变化（可选）
initial begin
    $monitor("时间 %0t ns: clk=%b rst_n=%b a=%d b=%d c=%d", 
              $time, clk, rst_n, a, b, c);
end

// 仿真时长控制（防止无限仿真）
initial begin
    #500;  // 最多仿真500ns
    $display("仿真超时，强制结束");
    $finish;
end

endmodule
