`timescale 1ns / 1ps

module uart_tx_test(
    input clk,
    input reset_n,
    output uart_tx
);
    
    reg send_go;
    reg [7:0]data;

    uart_byte_tx uart_byte_tx_init(
        .clk(clk),
        .reset_n(reset_n),
        .baud_set(3'd4),
        .data(data),
        .send_go(send_go),
        .uart_tx(uart_tx),
        .tx_done(tx_done)
    );
    
    reg[18:0] counter;
    always@(posedge clk or negedge reset_n)
        if(!reset_n)
            counter <= 0;
        else if(counter == 499999)
            counter <= 0;
        else
            counter <= counter + 1'b1;

    always@(posedge clk or negedge reset_n)
        if(!reset_n)
            send_go <= 0;
        else if(counter == 1)
            send_go <= 1;
        else
            send_go <= 0;


    always@(posedge clk or negedge reset_n)
        if(!reset_n)
            data <= 0;
        else if(tx_done)
            data <= data + 1'b1;



endmodule
