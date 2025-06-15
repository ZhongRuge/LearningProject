`timescale 1ns / 1ps

module uart_byte_tx_tb();

    reg clk;
    reg reset_n;
    reg [2:0]baud_set;
    reg [7:0]data;
    reg send_en;
    wire uart_tx;
    wire tx_done;
    
    uart_byte_tx uart_byte_tx_init(
        .clk(clk),
        .reset_n(reset_n),
        .baud_set(baud_set),
        .data(data),
        .send_en(send_en),
        .uart_tx(uart_tx),
        .tx_done(tx_done)
    );
    
    initial clk = 1;
    always#10 clk = ~clk;
    
    initial begin
        reset_n = 0;
        data = 0;
        send_en = 0;
        baud_set = 4;
        #201;
        reset_n = 1;
        #100;
        data = 8'h57;
        send_en = 1;
        #20;
        @(posedge tx_done);
        send_en = 0;
        #20000;
        
        data = 8'h75;
        send_en = 1;
        #20;
        @(posedge tx_done);
        #20000;

        $stop;
    
    end

endmodule
