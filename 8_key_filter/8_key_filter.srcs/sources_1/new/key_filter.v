`timescale 1ns / 1ps

module key_filter(
    input clk,
    input reset_n,
    input key,

    // output reg key_p_flag,
    // output reg key_r_flag,
    output key_flag,
    output reg key_state
    );

    reg key_p_flag;
    reg key_r_flag;
    assign key_flag = key_p_flag | key_r_flag;

    reg [1:0] r_key;
    always@(posedge clk)
        r_key <= {r_key[0], key}; //位拼接操作

    wire pedge_key = (r_key == 2'b01);
    wire nedge_key = (r_key == 2'b10);


    localparam IDLE = 0;
    reg [19:0] cnt;
    reg [1:0] state;

    always@(posedge clk or negedge reset_n) begin
        if(!reset_n)begin
            state <= IDLE;
            cnt <= 0;
            key_p_flag <= 0;
            key_r_flag <= 0;
            key_state <= 1;
        end
        else begin
            case(state)
                0:begin
                    key_r_flag <= 0;
                    if(nedge_key)
                        state <= 1;
                    else
                        state <= 0;
                end
                1:
                    if(pedge_key && cnt < 999999)begin
                        state <= 0;
                        cnt <= 0;
                    end
                    else if(cnt >= 1000000)begin
                        state <= 2;
                        key_p_flag <= 1;
                        key_state <= 0;
                        cnt <= 0;
                    end
                    else
                        cnt <= cnt + 1;
                2:begin
                    key_p_flag <= 0;
                    if(pedge_key) 
                        state <= 3;
                    else
                        state <= 2;
                end
                3:
                    if(nedge_key && cnt < 999999)begin
                        state <= 2;
                        cnt <= 0;
                    end
                    else if(cnt >= 1000000) begin
                        state <= 0;
                        key_r_flag <= 1;
                        key_state <= 1;
                        cnt <= 0;
                    end
                    else
                        cnt <= cnt + 1;
            endcase
        end
    end



endmodule