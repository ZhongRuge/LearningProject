module uart_tx_data2(
    input clk,
    input reset_n,
    input [39:0]data40,
    input [7:0]total_byte,  // 要发送的字节数
    input trans_go,
    output uart_tx,
    output reg trans_done
);

    reg[7:0]data;
    reg send_go;
    wire tx_done;
    reg state;
    reg [7:0]cnt_byte_num;
    
    uart_byte_tx uart_byte_tx(
        .clk(clk),
        .reset_n(reset_n),
        .data(data),
        .send_go(send_go),
        .baud_set(4),
        .uart_tx(uart_tx),
        .tx_done(tx_done)
    );
    
    always @(*) begin
        case(cnt_byte_num)
            0: data = data40[7:0];
            1: data = data40[15:8];
            2: data = data40[23:16];
            3: data = data40[31:24];
            4: data = data40[39:32];
            default: data = 8'h00;
        endcase
    end
    
    always@(posedge clk or negedge reset_n) begin
        if(!reset_n) begin
            state <= 0;
            send_go <= 0;
            trans_done <= 0;
            cnt_byte_num <= 0;
        end
        else if(trans_go) begin
            trans_done <= 0;
            cnt_byte_num <= 0;
            if(state == 0) begin
                send_go <= 1;
                state <= 1;
            end
        end
        else if(state == 1) begin
            if(tx_done) begin
                if(cnt_byte_num + 1 >= total_byte) begin
                    send_go <= 0;
                    state <= 0;
                    trans_done <= 1;
                    cnt_byte_num <= 0;
                end
                else begin
                    cnt_byte_num <= cnt_byte_num + 1;
                    send_go <= 1;
                end
            end
            else begin
                send_go <= 0;
            end
        end
    end

endmodule