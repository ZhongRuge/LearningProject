`timescale 1ns / 1ps

module uart_tx_data_tb();

    reg clk;
    reg reset_n;
    reg [39:0]data40;
    reg [7:0]total_byte;
    reg trans_go;
    wire uart_tx;
    wire trans_done;
    
    uart_tx_data2 uart_tx_data2(
        .clk(clk),
        .reset_n(reset_n),
        .data40(data40),
        .total_byte(total_byte),
        .trans_go(trans_go),
        .uart_tx(uart_tx),
        .trans_done(trans_done)
    );

    initial clk = 1;
    always#10 clk = !clk;
    
    initial begin 
        reset_n = 0;
        data40 = 0;
        trans_go = 0;
        #201;
        #200;
        reset_n = 1;
        total_byte = 4;
        data40 = 40'h123456789A;
        trans_go = 1;
        #20;
        trans_go = 0;
        @(posedge trans_done);
        #200000;
        
        total_byte = 4;
        data40 = 40'hA987654321;
        trans_go = 1;
        #20;
        trans_go = 0;
        @(posedge trans_done);
        #200000;
        $stop;
    end



endmodule
