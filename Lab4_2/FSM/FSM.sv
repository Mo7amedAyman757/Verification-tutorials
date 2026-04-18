module FSM();
    
    logic [2:0] cs;
    logic clk;
    logic get_data;

    // Current state internal signal “cs” will always stay one-hot irrespective of the input conditions.
    property SVA_1;
        @(posedge clk) 1 |-> $onehot(cs);
    endproperty

    assert property(SVA_1);

    // If the current state “cs” is "IDLE" and if "get_data" input is raised, then the state is
    // "GEN_BLK_ADDR" the following cycle and 64 cycles later the state should change to "WAITO."
    property SVA_2;
        @(posedge clk) (cs == IDLE && $rose(get_data)) |=> (cs == GEN_BLK_ADDR) ##64 (cs == WAIT0);
    endproperty

    assert property(SVA_1);

endmodule