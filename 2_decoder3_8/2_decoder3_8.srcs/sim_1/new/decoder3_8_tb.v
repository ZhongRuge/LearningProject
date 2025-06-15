`timescale 1ns / 1ps

module decoder3_8_tb();

    reg a;
    reg b;
    reg c;
    wire [7:0] out;
    
    decoder3_8 decoder3_8(
        .a(a),
        .b(b),
        .c(c),
        .out(out)
    );
    
    initial begin
        a = 0;b = 0;c = 0; //在 0 时刻三个输入均为 0
        #200; //经过 200ns 的延时
        a = 0;b = 0;c = 1; //在 200ns 时输入信号的值
        #200; //又经过 200ns 的延时
        a = 0;b = 1;c = 0; //在 400ns 时输入信号的值
        #200; //又经过 200ns 的延时
        a = 0;b = 1;c = 1; //在 600ns 时输入信号的值
        #200;
        a = 1;b = 0;c = 0;
        #200;
        a = 1;b = 0;c = 1;
        #200;
        a = 1;b = 1;c = 0;
        #200;
        a = 1;b = 1;c = 1;
        #200;
        $stop; //停止仿真
    end

endmodule
