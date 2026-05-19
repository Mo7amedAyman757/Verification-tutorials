module ALU_sva (ALU_if ALU_vif);

    property reset_check;
        @(posedge ALU_vif.clk)
        (ALU_vif.reset) |=> (ALU_vif.C == 0);
    endproperty

    reset_check_assertion : assert property(reset_check);
    reset_check_coverage : cover property(reset_check);

    property ADD_check;
        @(posedge ALU_vif.clk) disable iff(ALU_vif.reset) 
        (ALU_vif.Opcode == 2'b00) |=> (ALU_vif.C == $past(ALU_vif.A) + $past(ALU_vif.B));
    endproperty

    ADD_check_assertion : assert property(ADD_check);
    ADD_check_coverage : cover property(ADD_check);

    property SUB_check;
        @(posedge ALU_vif.clk) disable iff(ALU_vif.reset) 
        (ALU_vif.Opcode == 2'b01) |=> (ALU_vif.C == $past(ALU_vif.A) - $past(ALU_vif.B));
    endproperty

    SUB_check_assertion : assert property(SUB_check);
    SUB_check_coverage : cover property(SUB_check);

    property NOT_A_check;
        @(posedge ALU_vif.clk) disable iff(ALU_vif.reset) 
        (ALU_vif.Opcode == 2'b10) |=> (ALU_vif.C == ~$past(ALU_vif.A));
    endproperty

    NOT_A_check_assertion : assert property(NOT_A_check);
    NOT_A_check_coverage : cover property(NOT_A_check);

    property ReductionOR_B_check;
        @(posedge ALU_vif.clk) disable iff(ALU_vif.reset) 
        (ALU_vif.Opcode == 2'b11) |=> (ALU_vif.C == |$past(ALU_vif.B));
    endproperty

    ReductionOR_B_check_assertion : assert property(ReductionOR_B_check);
    ReductionOR_B_check_coverage : cover property(ReductionOR_B_check);


endmodule