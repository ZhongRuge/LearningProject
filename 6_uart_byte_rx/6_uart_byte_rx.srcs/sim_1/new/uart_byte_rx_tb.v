`timescale 1ns / 1ps

module tb_uart_byte_rx();

    reg clk;
    reg reset_n;
    reg uart_rx;
    wire rx_done;
    reg [2:0] baud_set;
    wire [7:0] data;

uart_byte_rx uart_byte_rx(
    .clk(clk),
    .reset_n(reset_n),
    .baud_set(baud_set),
    .uart_rx(uart_rx),
    .data(data),
    .rx_done(rx_done)
);

    initial clk = 1;
    always #10 clk = ~clk;

    initial begin
        reset_n = 0;
        uart_rx = 1;
        baud_set = 4;
        #201;
        reset_n = 1;
        #200;
        uart_tx_byte(8'h5a);
        # 90000;
        uart_tx_byte(8'ha5);
        # 90000;
        uart_tx_byte(8'h86);
        # 90000;
        $stop;
    end


    task uart_tx_byte;
        input[7:0] tx_data;
        begin
            uart_rx = 1;
            #20;
            uart_rx = 0;// start bit
            #8680;
            uart_rx = tx_data[0];
            #8680;
            uart_rx = tx_data[1];
            #8680;
            uart_rx = tx_data[2];
            #8680;
            uart_rx = tx_data[3];
            #8680;
            uart_rx = tx_data[4];
            #8680;
            uart_rx = tx_data[5];
            #8680;
            uart_rx = tx_data[6];
            #8680;
            uart_rx = tx_data[7];
            #8680;
            uart_rx = 1; // stop bit
            #8680;
        end
    endtask

endmodule