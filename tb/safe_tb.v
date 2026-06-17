`timescale 1ns/1ps

module safe_tb;

    reg clk;
    reg enter;
    reg [15:0] entered_password;

    wire [15:0] stored_password;
    wire unlocked;
    wire alarm;
    wire [1:0] attempts;

    password pm (
        .stored_password(stored_password)
    );

    safe sc (
        .clk(clk),
        .enter(enter),
        .entered_password(entered_password),
        .stored_password(stored_password),
        .unlocked(unlocked),
        .alarm(alarm),
        .attempts(attempts)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        enter = 0;
        entered_password = 0;

        #10;

        entered_password = 16'd1234;
        enter = 1;
        #10;
        enter = 0;

        #30;

        entered_password = 16'd1111;
        enter = 1;
        #10;
        enter = 0;

        #20;

        entered_password = 16'd2222;
        enter = 1;
        #10;
        enter = 0;

        #20;

        entered_password = 16'd3333;
        enter = 1;
        #10;
        enter = 0;

        #50;

        $finish;

    end

endmodule