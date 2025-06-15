`timescale 1ns / 1ps

module uart_byte_rx (
    input clk,
    input reset_n,
    input [2:0]baud_set,
    input uart_rx,
    output reg [7:0] data,
    output reg rx_done
    );
    
    
    reg [2:0] r_data[7:0];  // reg width name number
    reg [2:0] sta_bit;
    reg [2:0] sto_bit;
    
    reg [8:0] div_cnt;
    reg rx_en;
    reg [7:0] bps_cnt;
    
    
    // 边缘检测
    reg [1:0] uart_rx_r;
    always @(posedge clk) begin
        uart_rx_r[0] <= uart_rx;
        uart_rx_r[1] <= uart_rx_r[0];
    end
    
    //    wire pedge_uart_rx;
    //    assign pedge_uart_rx = (uart_rx_r == 2'b01);
    
    wire nedge_uart_rx;
    assign nedge_uart_rx = (uart_rx_r == 2'b10);
    
    // 波特率相关
    reg [8:0] bps_DR;
    always @(*)
        case (baud_set)
            0: bps_DR       = 1000000000 / 9600 / 16 / 20 - 1;
            1: bps_DR       = 1000000000 / 19200 / 16 / 20 - 1;
            2: bps_DR       = 1000000000 / 38400 / 16 / 20 - 1;
            3: bps_DR       = 1000000000 / 57600 / 16 / 20 - 1;
            4: bps_DR       = 1000000000 / 115200 / 16 / 20 - 1;
            default: bps_DR = 1000000000 / 9600 / 16 / 20 - 1;
        endcase
    
    wire bps_clk_16x;
    assign bps_clk_16x = (div_cnt == bps_DR / 2);
    
    
    always @(posedge clk or negedge reset_n)
        if (!reset_n)
            rx_en <= 0;
        else if (nedge_uart_rx)
            rx_en <= 1;
        else if (rx_done || sta_bit >= 4)
            rx_en <= 0;
    
    
    
    always @(posedge clk or negedge reset_n)
        if (!reset_n)
            div_cnt <= 0;
        else if (rx_en) begin
            if (div_cnt == bps_DR)
                div_cnt <= 0;
            else
                div_cnt <= div_cnt + 1'b1;
        end
        else
            div_cnt <= 0;
    
    
    
    always @(posedge clk or negedge reset_n)
        if (!reset_n)
            bps_cnt <= 0;
        else if (rx_en) begin
            if (bps_clk_16x) begin
                if (bps_cnt == 160)
                    bps_cnt <= 0;
                else
                    bps_cnt <= bps_cnt + 1'b1;
            end
            else
                bps_cnt <= bps_cnt;
        end
        else
            bps_cnt <= 0;
    
    
    
    // 数据相关
    always @(posedge clk or negedge reset_n)
        if (!reset_n) begin
            sta_bit   <= 0;
            sto_bit   <= 0;
            r_data[0] <= 0;
            r_data[1] <= 0;
            r_data[2] <= 0;
            r_data[3] <= 0;
            r_data[4] <= 0;
            r_data[5] <= 0;
            r_data[6] <= 0;
            r_data[7] <= 0;
        end
        else if (bps_clk_16x) begin
            case (bps_cnt)
                0: begin
                    sta_bit   <= 0;
                    sto_bit   <= 0;
                    r_data[0] <= 0;
                    r_data[1] <= 0;
                    r_data[2] <= 0;
                    r_data[3] <= 0;
                    r_data[4] <= 0;
                    r_data[5] <= 0;
                    r_data[6] <= 0;
                    r_data[7] <= 0;
                end
                5, 6, 7, 8, 9, 10, 11: sta_bit               <= sta_bit + uart_rx;
                21, 22, 23, 24, 25, 26, 27: r_data[0]        <= r_data[0] + uart_rx;
                37, 38, 39, 40, 41, 42, 43: r_data[1]        <= r_data[1] + uart_rx;
                53, 54, 55, 56, 57, 58, 59: r_data[2]        <= r_data[2] + uart_rx;
                69, 70, 71, 72, 73, 74, 75: r_data[3]        <= r_data[3] + uart_rx;
                85, 86, 87, 88, 89, 90, 91: r_data[4]        <= r_data[4] + uart_rx;
                101, 102, 103, 104, 105, 106, 107: r_data[5] <= r_data[5] + uart_rx;
                117, 118, 119, 120, 121, 122, 123: r_data[6] <= r_data[6] + uart_rx;
                133, 134, 135, 136, 137, 138, 139: r_data[7] <= r_data[7] + uart_rx;
                149, 150, 151, 152, 153, 154, 155: sto_bit   <= sto_bit + uart_rx;
                default: ;
            endcase
        end


    always @(posedge clk or negedge reset_n)
        if (!reset_n)
            data <= 0;
        else if(bps_clk_16x && (bps_cnt == 159))begin
            data[0] <= (r_data[0] >= 4) ? 1 : 0;
            data[1] <= (r_data[1] >= 4) ? 1 : 0;
            data[2] <= (r_data[2] >= 4) ? 1 : 0;
            data[3] <= (r_data[3] >= 4) ? 1 : 0;
            data[4] <= (r_data[4] >= 4) ? 1 : 0;
            data[5] <= (r_data[5] >= 4) ? 1 : 0;
            data[6] <= (r_data[6] >= 4) ? 1 : 0;
            data[7] <= (r_data[7] >= 4) ? 1 : 0;
        end


    always @(posedge clk or negedge reset_n)
        if (!reset_n)
            rx_done <= 0;
        else if ((div_cnt == bps_DR/2) && (bps_cnt == 160))
            rx_done <= 1;
        else
            rx_done <= 0;

endmodule