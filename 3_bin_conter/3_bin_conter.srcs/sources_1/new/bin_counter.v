`timescale 1ns / 1ps

module bin_counter(
    input clk,
    input rst,
    output reg led,
    output led2
    );
    
parameter MCNT = 24999999;
wire reset;
assign led2 = rst;
assign reset = ~rst;
reg [24:0]cnt;

always @(posedge clk or posedge reset)
    if(reset)
        cnt <= 25'd0;
    else if(cnt == MCNT)
        cnt <= 25'd0;
    else
        cnt <= cnt + 1'b1;

always@(posedge clk or posedge reset)
    if(reset)
        led <= 1'b1;
    else if(cnt == MCNT)
        led <= ~led;
    else
        led <= led;


ila_0 ila_0 (
	.clk(clk), // input wire clk
	
	.probe0(cnt), // input wire [24:0]  probe0  
	.probe1(led) // input wire [0:0]  probe1
);

endmodule
