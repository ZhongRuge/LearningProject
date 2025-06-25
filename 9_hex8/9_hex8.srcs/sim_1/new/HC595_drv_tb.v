`timescale 1ns / 1ps

module HC595_drv_tb();

    reg clk;
    reg rst_n;
    reg [15:0] data;
    reg S_EN;
    wire SH_CP;
    wire ST_CP;
    wire DS;

    HC595_drv hc595_drv (
        .clk(clk),
        .rst_n(rst_n),
        .data(data),
        .S_EN(S_EN),
        .SH_CP(SH_CP),
        .ST_CP(ST_CP),
        .DS(DS)
    );

    initial clk = 0;
    always #10 clk = ~clk;

    initial begin
        rst_n = 0;
        data = 0;
        S_EN = 0;
        #201;
        rst_n = 1;
        #500;

        S_EN = 1;
        data = 16'h47a9;
        #20;
        S_EN = 0;
        #4000;

        data = 16'h5832;
        S_EN = 1;
        #20;
        S_EN = 0;
        #4000;

        $stop;
    end


endmodule
