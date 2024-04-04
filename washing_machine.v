module Washing_Machine (
    input Clock,
    input Reset,
    input Start,
    input Door_Close,
    input Filled,
    input Drained,
    input Detergent_Added,
    input Cycle_Timeout,
    input Spin_Timeout,
    output reg Motor_on,
    output reg Fill_valve_on,
    output reg Drained_valve_on,
    output reg Door_Lock,
    output reg Done
);

    parameter Check_Door = 3'b000;
    parameter Fill_Water = 3'b001;
    parameter Add_Detergent = 3'b010;
    parameter Cycle = 3'b011;
    parameter Drain_Water = 3'b100;
    parameter Spin = 3'b101;

    reg [2:0] Current_State, Next_State;

    always @(posedge Clock, negedge Reset) begin
        if (Reset == 0) begin
            Current_State <= Check_Door;
        end else begin
            Current_State <= Next_State;
        end
    end

    always @(*) begin
        case (Current_State)
            Check_Door: begin
                if (Start == 1 && Door_Close == 1) begin
                    Next_State = Fill_Water;
                    Motor_on <= 0;
                    Fill_valve_on <= 0;
                    Drained_valve_on <= 0;
                    Door_Lock <= 1;
                    Done <= 0;
                end else begin
                    Next_State = Current_State;
                    Motor_on <= 0;
                    Fill_valve_on <= 0;
                    Drained_valve_on <= 0;
                    Door_Lock <= 0;
                    Done <= 0;
                end
            end

            Fill_Water: begin
                if (Filled == 1) begin
                    Next_State = Add_Detergent;
                    Motor_on <= 0;
                    Fill_valve_on <= 0;
                    Drained_valve_on <= 0;
                    Door_Lock <= 1;
                    Done <= 0;
                end else begin
                    Next_State = Current_State;
                    Motor_on <= 0;
                    Fill_valve_on <= 1;
                    Drained_valve_on <= 0;
                    Door_Lock <= 1;
                    Done <= 0;
                end
            end

            Add_Detergent: begin
                if (Detergent_Added == 1) begin
                    Next_State = Cycle;
                    Motor_on <= 0;
                    Fill_valve_on <= 0;
                    Drained_valve_on <= 0;
                    Door_Lock <= 1;
                    Done <= 0;
                end else begin
                    Next_State = Current_State;
                    Motor_on <= 0;
                    Fill_valve_on <= 0;
                    Drained_valve_on <= 0;
                    Door_Lock <= 1;
                    Done <= 0;
                end
            end

            Cycle: begin
                if (Cycle_Timeout == 1) begin
                    Next_State = Drain_Water;
                    Motor_on <= 0;
                    Fill_valve_on <= 0;
                    Drained_valve_on <= 0;
                    Door_Lock <= 1;
                    Done <= 0;
                end else begin
                    Next_State = Current_State;
                    Motor_on <= 1;
                    Fill_valve_on <= 0;
                    Drained_valve_on <= 0;
                    Door_Lock <= 1;
                    Done <= 0;
                end
            end

            Drain_Water: begin
                if (Drained == 1) begin
                    Next_State = Spin;
                    Motor_on <= 0;
                    Fill_valve_on <= 0;
                    Drained_valve_on <= 1;
                    Door_Lock <= 1;
                    Done <= 0;
                end else begin
                    Next_State = Current_State;
                    Motor_on <= 0;
                    Fill_valve_on <= 0;
                    Drained_valve_on <= 1;
                    Door_Lock <= 1;
                    Done <= 0;
                end
            end

            Spin: begin
                if (Spin_Timeout == 1) begin
                    Next_State = Check_Door;
                    Motor_on <= 0;
                    Fill_valve_on <= 0;
                    Drained_valve_on <= 0;
                    Door_Lock <= 0;
                    Done <= 1;
                end else begin
                    Next_State = Current_State;
                    Motor_on <= 0;
                    Fill_valve_on <= 0;
                    Drained_valve_on <= 1;
                    Door_Lock <= 1;
                    Done <= 0;
                end
            end

            default: begin
                Next_State = Check_Door;
            end
        endcase
    end

endmodule