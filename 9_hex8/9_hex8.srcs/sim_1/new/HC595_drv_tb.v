`timescale 1ns / 1ps

module HC595_drv_tb();

    reg clk;
    reg rst_n;
    reg [15:0] data;
    wire SH_CP;
    wire ST_CP;
    wire DS;

    HC595_drv hc595_drv (
        .clk(clk),
        .rst_n(rst_n),
        .data(data),
        .SH_CP(SH_CP),
        .ST_CP(ST_CP),
        .DS(DS)
    );

    initial clk = 0;
    always #10 clk = ~clk;

    initial begin
        rst_n = 0;
        data = 16'h0000;
        #201;
        rst_n = 1;
        #10000000;
        $stop;
    end


endmodule
