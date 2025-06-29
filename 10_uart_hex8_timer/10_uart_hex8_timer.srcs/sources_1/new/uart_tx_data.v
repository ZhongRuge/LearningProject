`timescale 1ns / 1ps

module uart_tx_data(
    input clk,
    input reset_n,
    input [39:0]data40,
    input trans_go,
    output uart_tx,
    output reg trans_done
    );

    reg[7:0]data;
    reg send_go;
    wire tx_done;
    
    uart_byte_tx uart_byte_tx(
        .clk(clk),
        .reset_n(reset_n),
        .data(data),
        .send_go(send_go),
        .baud_set(4),
        .uart_tx(uart_tx),
        .tx_done(tx_done)
    );
    
    reg [2:0]state;
    
    always@(posedge clk or negedge reset_n)
    
        if(!reset_n)begin
            state <= 0;
            data <= 0;
            send_go <= 0;
            trans_done <= 0;
        end

        else if(state == 0)begin
            trans_done <= 0;
            if(trans_go)begin
                data <= data40[7:0];
                send_go <= 1;
                state <= 1;
            end
            else begin
                data <= data;
                send_go <= 0;
                state <= 0;
            end
        end

        else if(state == 1)begin
            if(tx_done)begin
                data <= data40[15:8];
                send_go <= 1;
                state <= 2;
            end
            else begin
                data <= data;
                send_go <= 0;
                state <= 1;
            end
        end

        else if(state == 2)begin
            if(tx_done)begin
                data <= data40[23:16];
                send_go <= 1;
                state <= 3;
            end
            else begin
                data <= data;
                send_go <= 0;
                state <= 2;
            end
        end

        else if(state == 3)begin
            if(tx_done)begin
                data <= data40[31:24];
                send_go <= 1;
                state <= 4;
            end
            else begin
                data <= data;
                send_go <= 0;
                state <= 3;
            end
        end

        else if(state == 4)begin
            if(tx_done)begin
                data <= data40[39:32];
                send_go <= 1;
                state <= 5;
            end
            else begin
                data <= data;
                send_go <= 0;
                state <= 4;
            end
        end

        else if(state == 5)begin
            if(tx_done)begin
                send_go <= 0;
                state <= 0;
                trans_done <= 1;
            end
            else begin
                data <= data;
                send_go <= 0;
                state <= 5;
            end
        end

endmodule
