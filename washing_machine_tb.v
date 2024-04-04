module Automatic_Washing_Machine_Test_Bench;
    reg Clock, Reset, Start, Door_Close, Filled, Drained, Detergent_Added, Cycle_Timeout, Spin_Timeout;
    wire Motor_on, Fill_valve_on, Drained_valve_on, Door_Lock, Done;

    Automatic_Washing_Machine Customer1(
        .Clock(Clock),
        .Reset(Reset),
        .Start(Start),
        .Door_Close(Door_Close),
        .Filled(Filled),
        .Drained(Drained),
        .Detergent_Added(Detergent_Added),
        .Cycle_Timeout(Cycle_Timeout),
        .Spin_Timeout(Spin_Timeout),
        .Motor_on(Motor_on),
        .Fill_valve_on(Fill_valve_on),
        .Drained_valve_on(Drained_valve_on),
        .Door_Lock(Door_Lock),
        .Done(Done)
    );

    initial begin
        $monitor("Time=%d,Clock=%b,Reset=%b,Start=%b,Door_Close=%b,Filled=%b,Drained=%b,Detergent_Added=%b,Cycle_Timeout=%b,Spin_Timeout=%b,Motor_on=%b,Fill_valve_on=%b,Drained_valve_on=%b,Door_Lock=%b,Done=%b",
                 $time, Clock, Reset, Start, Door_Close, Filled, Drained, Detergent_Added, Cycle_Timeout, Spin_Timeout, Motor_on, Fill_valve_on, Drained_valve_on, Door_Lock, Done);
    end

    initial begin
        Clock = 0;
        Reset = 1;
        Start = 0;
        Door_Close = 0;
        Filled = 0;
        Drained = 0;
        Detergent_Added = 0;
        Cycle_Timeout = 0;
        Spin_Timeout = 0;

        #5 Reset = 0;
        #5 Start = 1; Door_Close = 1;
        #10 Filled = 1; Start = 0; Door_Close = 0;
        #10 Detergent_Added = 1; Filled = 0;
        #10 Cycle_Timeout = 1; Detergent_Added = 0;
        #10 Drained = 1; Cycle_Timeout = 0;
        #10 Spin_Timeout = 1; Drained = 0; Spin_Timeout = 0;

        // Reset the state machine for the next test case
        Reset = 1;
        #5 Reset = 0;

        // Add additional test cases if needed

        // End the simulation
        $finish;
    end

    always begin
        #5 Clock = ~Clock;
    end
endmodule