`timescale 1ns / 1ps

module hex8_tb();

    // 测试信号定义
    reg clk;
    reg rst_n;
    reg [31:0] disp_data;
    wire [7:0] sel;
    wire [7:0] seg;
    
    // 实例化被测试模块
    hex8 hex8 (
        .clk(clk),
        .rst_n(rst_n),
        .disp_data(disp_data),
        .sel(sel),
        .seg(seg)
    );
    
    initial clk = 0;
    always #10 clk = ~clk;  // 50MHz 时钟周期为20

    initial begin
        rst_n = 0;
        disp_data = 32'h00000000;
        #201;
        rst_n = 1;

        #2000;
        disp_data = 32'h12345678;
        #10000000;
        disp_data = 32'h9abcdef0;
        #10000000;
        $stop;
    end

endmodule
