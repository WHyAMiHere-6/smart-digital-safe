module safe_controller(

    input clk,
    input enter,
    input [15:0] entered_password,
    input [15:0] stored_password,

    output reg unlocked,
    output reg alarm,
    output reg [1:0] attempts

);

parameter IDLE   = 2'b00;
parameter CHECK  = 2'b01;
parameter UNLOCK = 2'b10;
parameter ALARM  = 2'b11;

reg [1:0] state;
reg [1:0] unlock_counter;
reg [1:0] alarm_counter;

initial begin
    state = IDLE;
    unlocked = 0;
    alarm = 0;
    attempts = 0;
    unlock_counter = 0;
    alarm_counter = 0;
end

always @(posedge clk)
begin

    case(state)

        IDLE:
        begin
            unlocked <= 0;
            alarm <= 0;

            if(enter)
                state <= CHECK;
        end

        CHECK:
        begin
            if(entered_password == stored_password)
            begin
                state <= UNLOCK;
                unlock_counter <= 2;
                attempts <= 0;
            end
            else
            begin
                if(attempts == 2)
                begin
                    state <= ALARM;
                    alarm_counter <= 2;
                end
                else
                begin
                    attempts <= attempts + 1;
                    state <= IDLE;
                end
            end
        end

        UNLOCK:
        begin
            unlocked <= 1;

            if(unlock_counter > 0)
                unlock_counter <= unlock_counter - 1;
            else
            begin
                unlocked <= 0;
                state <= IDLE;
            end
        end

        ALARM:
        begin
            alarm <= 1;

            if(alarm_counter > 0)
                alarm_counter <= alarm_counter - 1;
            else
            begin
                alarm <= 0;
                attempts <= 0;
                state <= IDLE;
            end
        end

    endcase

end

endmodule