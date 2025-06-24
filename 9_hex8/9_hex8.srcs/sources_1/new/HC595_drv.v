`timescale 1ns / 1ps

module HC595_drv(
    input clk,
    input rst_n,
    input [15:0]data,
    output reg SH_CP,
    output ST_CP,
    output DS
    );

    // 分频器，产生SH_CP信号 12.5MHz
    reg clk_12_5M;
    reg div_cnt;
    
    always@(posedge clk or negedge rst_n) begin
        if (!rst_n)begin
            div_cnt <= 0;
            SH_CP <= 0;
        end
        else if(div_cnt == 2'b1)begin
            div_cnt <= 0;
            SH_CP <= ~SH_CP;
        end
        else
            div_cnt <= div_cnt + 1;
    end





endmodule
