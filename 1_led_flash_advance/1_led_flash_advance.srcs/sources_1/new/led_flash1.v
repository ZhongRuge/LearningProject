`timescale 1ns / 1ps


module led_flash1(
    input clk,
    input reset_n,
    input [7:0]serial,
    input [31:0]Time,
    output reg led
    );
    

    reg [31:0]clk_cnt;
    parameter MCNT = 500000;
    
    always@(posedge clk or negedge reset_n)
        if(!reset_n)
            clk_cnt <= 0;
        else if(clk_cnt == Time - 1)
            clk_cnt <= 0;
        else
            clk_cnt <= clk_cnt + 1'b1;
    
    reg [2:0]cnt;
    always@(posedge clk or negedge reset_n)
        if(!reset_n)
            cnt <= 0;
        else if(clk_cnt == Time - 1)
            cnt <= cnt + 1'b1;
            
    
//    always@(posedge clk or negedge reset_n)
//        if(!reset_n)
//            led <= 0;
//        else if(clk_cnt == MCNT/8 -1)
//            led <= serial[1];
//        else if(clk_cnt == MCNT/8 * 2 -1)
//            led <= serial[2];
//        else if(clk_cnt == MCNT/8 * 3 -1)
//            led <= serial[3];
//        else if(clk_cnt == MCNT/8 * 4 -1)
//            led <= serial[4];
//        else if(clk_cnt == MCNT/8 * 5 -1)
//            led <= serial[5];
//        else if(clk_cnt == MCNT/8 * 6 -1)
//            led <= serial[6];
//        else if(clk_cnt == MCNT/8 * 7 -1)
//            led <= serial[7];
//        else if(clk_cnt == MCNT -1)
//            led <= serial[0];
    always@(posedge clk or negedge reset_n)//也能用case代替
        if(!reset_n)
            led <= 0;
        else case(cnt)
            0: led <= serial[0];
            1: led <= serial[1];
            2: led <= serial[2];
            3: led <= serial[3];
            4: led <= serial[4];
            5: led <= serial[5];
            6: led <= serial[6];
            7: led <= serial[7];
            default:
                led <= led;
        endcase
        

endmodule
