`timescale 1ns / 1ps

module key_filter_tb();

    reg clk;
    reg reset_n;
    reg key;
    wire key_flag;
    wire key_state;

    key_filter key_filter_inst(
        .clk(clk),
        .reset_n(reset_n),
        .key(key),
        .key_flag(key_flag),
        .key_state(key_state)
    );

    initial clk = 1;
    always #10 clk = ~clk;

    initial begin
        reset_n = 0;
        key = 1;
        #201;

        reset_n = 1;
        #3000;

        key = 0;
        #20000;
        key = 1;
        #30000;
        key = 0;
        #20000;
        key = 1;
        #30000;
        key = 0;
        #50000000;


        key = 1;
        #20000;
        key = 0;
        #30000;
        key = 1;
        #20000;
        key = 0;
        #30000;
        key = 1;
        #50000000;

        $stop;
    end

endmodule
