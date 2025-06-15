`timescale 1ns / 1ps

module led_flash1_tb();

    reg clk;
    reg reset_n;
    wire led;
    reg [7:0]serial;
    reg [31:0]Time;
    
    led_flash1 led_flash1(
        .clk(clk),
        .reset_n(reset_n),
        .led(led),
        .serial(serial),
        .Time(Time)
    );
    //defparam  led_flash1.MCNT = 50000;
    

    initial clk = 1;
    always #10 clk = !clk;
 
    initial begin
        Time = 0;
        serial = 8'b11000100;
        reset_n = 0;
        # 200;
        reset_n = 1;
        #2000
        Time = 2500;
        #2000000000;
        $stop;
    end
    
endmodule
