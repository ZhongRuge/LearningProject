`timescale 1ns / 1ps
`define CLOCK_PERIOD 20

module bin_counter_tb();

reg clk;
reg rst;
wire led;

bin_counter bin_counter(
    .clk(clk),
    .rst(rst),
    .led(led)
);

initial 
    clk = 1;
    always #(`CLOCK_PERIOD/2)
        clk = ~clk;

initial begin
    rst = 1'b0;
    # 200000
    rst = 1'b1;
    #2000000000;
    $stop;
end

endmodule
