`timescale 1ns / 1ps

module HC595_drv(
    input clk,
    input rst_n,
    input [15:0]data,
    input S_EN,
    output reg SH_CP,
    output reg ST_CP,
    output reg DS
    );


    reg [15:0] data_r;
    always@(posedge clk)
        if(S_EN)
            data_r <= data;


    parameter CNT_MAX = 2;
    reg [7:0] div_cnt;
    wire sck_plus;
    assign sck_plus = (div_cnt == CNT_MAX - 1);
    
    always@(posedge clk or negedge rst_n) begin
        if (!rst_n)
            div_cnt <= 0;
        else if(div_cnt == CNT_MAX - 1)
            div_cnt <= 0;
        else
            div_cnt <= div_cnt + 1;
    end

    reg [5:0] SHCP_EDGE_CNT; //传16位的数据，用32个时钟周期
    always@(posedge clk or negedge rst_n) begin
        if (!rst_n)
            SHCP_EDGE_CNT <= 0;
        else if (sck_plus) begin
            if(SHCP_EDGE_CNT == 6'd32)
                SHCP_EDGE_CNT <= 0;
            else
                SHCP_EDGE_CNT <= SHCP_EDGE_CNT + 1;
        end
    end


    always@(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            SH_CP <= 0;
            ST_CP <= 0;
            DS <= 0;
        end
        else begin
            case(SHCP_EDGE_CNT)
                0: begin SH_CP <= 0; ST_CP <= 0; DS <= data_r[15]; end
                1: SH_CP <= 1;
                2: begin SH_CP <= 0; DS <= data_r[14]; end
                3: SH_CP <= 1;
                4: begin SH_CP <= 0; DS <= data_r[13]; end
                5: SH_CP <= 1;
                6: begin SH_CP <= 0; DS <= data_r[12]; end
                7: SH_CP <= 1;
                8: begin SH_CP <= 0; DS <= data_r[11]; end
                9: SH_CP <= 1;
                10: begin SH_CP <= 0; DS <= data_r[10]; end
                11: SH_CP <= 1;
                12: begin SH_CP <= 0; DS <= data_r[9]; end
                13: SH_CP <= 1;
                14: begin SH_CP <= 0; DS <= data_r[8]; end
                15: SH_CP <= 1;
                16: begin SH_CP <= 0; DS <= data_r[7]; end
                17: SH_CP <= 1;
                18: begin SH_CP <= 0; DS <= data_r[6]; end
                19: SH_CP <= 1;
                20: begin SH_CP <= 0; DS <= data_r[5]; end
                21: SH_CP <= 1;
                22: begin SH_CP <= 0; DS <= data_r[4]; end
                23: SH_CP <= 1;
                24: begin SH_CP <= 0; DS <= data_r[3]; end
                25: SH_CP <= 1;
                26: begin SH_CP <= 0; DS <= data_r[2]; end
                27: SH_CP <= 1;
                28: begin SH_CP <= 0; DS <= data_r[1]; end
                29: SH_CP <= 1;
                30: begin SH_CP <= 0; DS <= data_r[0]; end
                31: SH_CP <= 1;
                32: ST_CP <= 1;
                default: begin SH_CP <= 0; ST_CP <= 0; DS <= 0; end
            endcase
        end
    end

endmodule
