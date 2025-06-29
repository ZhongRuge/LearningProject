`timescale 1ns / 1ps

module hex8_HC595(
    input clk,
    input rst_n,
    output [7:0] sel,
    output [7:0] seg,
    output SH_CP,
    output ST_CP,
    output DS
);

    wire [31:0] disp_data;
    hex8_2 hex8_2 (
        .clk(clk),
        .rst_n(rst_n),
        .disp_data(disp_data),
        .sel(sel),
        .seg(seg)
    );


    wire [15:0] Data;
    assign Data = {seg, sel};

    HC595_drv hc595_drv (
        .clk(clk),
        .rst_n(rst_n),
        .data(Data),
        .S_EN(1),
        .SH_CP(SH_CP),
        .ST_CP(ST_CP),
        .DS(DS)
    );

    assign disp_data = 32'h13579bdf;

endmodule
