`timescale 1ns / 1ps

module hex8(
    input clk,
    input rst_n,
    input [31:0] disp_data,
    output reg [7:0] sel,
    output reg [7:0] seg

);



    // 分频器
    reg clk_1k;
    reg [14:0] div_cnt;

    always@(posedge clk or negedge rst_n) begin
        if (!rst_n)
            div_cnt <= 0;
        else if(div_cnt >= 24999)
            div_cnt <= 0;
        else
            div_cnt <= div_cnt + 1;
    end

    always@(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_1k <= 0;
        else if (div_cnt == 24999)
            clk_1k <= ~clk_1k;
    end



    reg [2:0] num_cnt;
    always@(posedge clk_1k or negedge rst_n) begin
        if (!rst_n)
            num_cnt <= 0;
        else
            num_cnt <= num_cnt + 1;
    end

    always @(*) begin
        case(num_cnt)
            3'b000: sel = 8'b00000001;
            3'b001: sel = 8'b00000010;
            3'b010: sel = 8'b00000100;
            3'b011: sel = 8'b00001000;
            3'b100: sel = 8'b00010000;
            3'b101: sel = 8'b00100000;
            3'b110: sel = 8'b01000000;
            3'b111: sel = 8'b10000000;
            default: sel = 8'b00000000;
        endcase
    end

    reg [3:0] disp_tmp;
    always @(*) begin
        case(num_cnt)
            3'b000: disp_tmp = disp_data[31:28];
            3'b001: disp_tmp = disp_data[27:24];
            3'b010: disp_tmp = disp_data[23:20];
            3'b011: disp_tmp = disp_data[19:16];
            3'b100: disp_tmp = disp_data[15:12];
            3'b101: disp_tmp = disp_data[11:8];
            3'b110: disp_tmp = disp_data[7:4];
            3'b111: disp_tmp = disp_data[3:0];
            default: disp_tmp = 4'b0000;
        endcase
    end

    always@(*)
        case(disp_tmp)
            4'h0: seg = 8'b11000000; // 0
            4'h1: seg = 8'b11111001; // 1
            4'h2: seg = 8'b10100100; // 2
            4'h3: seg = 8'b10110000; // 3
            4'h4: seg = 8'b10011001; // 4
            4'h5: seg = 8'b10010010; // 5
            4'h6: seg = 8'b10000010; // 6
            4'h7: seg = 8'b11111000; // 7
            4'h8: seg = 8'b10000000; // 8
            4'h9: seg = 8'b10010000; // 9
            4'ha: seg = 8'b10001000; // A
            4'hb: seg = 8'b10000011; // B
            4'hc: seg = 8'b11000110; // C
            4'hd: seg = 8'b10100001; // D
            4'he: seg = 8'b10000110; // E
            4'hf: seg = 8'b10001110; // F
            default: seg = 8'b11111111; // All segments off
        endcase


endmodule
