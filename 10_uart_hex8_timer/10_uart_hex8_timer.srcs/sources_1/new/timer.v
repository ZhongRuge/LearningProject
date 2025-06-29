`timescale 1ns / 1ps

module timer(

    );

    uart_byte_tx uart_byte_tx(
        .clk(clk),
        .reset_n(rst_n),
        .baud_set(baud_set),
        .data(data),
        .send_go(send_go),
        .uart_tx(uart_tx),
        .tx_done(tx_done)
    );


endmodule
