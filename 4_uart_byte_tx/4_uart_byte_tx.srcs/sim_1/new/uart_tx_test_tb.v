`timescale 1ns / 1ps

module uart_tx_test_tb();

    reg clk;
    reg reset_n;
    wire uart_tx;
    
    uart_tx_test uart_tx_test(
        .clk(clk),
        .reset_n(reset_n),
        .uart_tx(uart_tx)
    );
    
    initial clk = 1;
    always#10 clk = ~clk;
    
    initial begin
        reset_n = 0;
        #201;
        reset_n = 1;
        #50000000;
        $stop;
    end

endmodule
