////////////////////////////////////////////////////////////////////////////////
// Author: Mohamed Ayman
// Course: Digital Verification using SV & UVM
//
// Description: ALU Design 
// 
////////////////////////////////////////////////////////////////////////////////
module ALU_sva(ALU_if.DUT alu_inst);

    // always_comb begin : reset_check
    //     if(alu_inst.reset)
    //         assert(alu_inst.C == 5'b0);
    // end

    property reset_check;
        @(posedge alu_inst.clk) (alu_inst.reset) |=> (alu_inst.C == 5'b0);
    endproperty

    reset_assertion: assert property(reset_check);
    reset_coverage: cover property(reset_check);

    property alu_out_add;
        @(posedge alu_inst.clk) disable iff(alu_inst.reset) (alu_inst.Opcode == alu_inst.Add) |=> (alu_inst.C == $past(alu_inst.A) + $past(alu_inst.B));
    endproperty

    alu_add_assertion: assert property(alu_out_add);
    alu_add_coverage: cover property(alu_out_add);

    property alu_out_Sub;
        @(posedge alu_inst.clk) disable iff(alu_inst.reset) (alu_inst.Opcode == alu_inst.Sub) |=> (alu_inst.C == $past(alu_inst.A) - $past(alu_inst.B));
    endproperty

    alu_Sub_assertion: assert property(alu_out_Sub);
    alu_Sub_coverage: cover property(alu_out_Sub);

    property alu_out_Not_A;
        @(posedge alu_inst.clk) disable iff(alu_inst.reset) (alu_inst.Opcode == alu_inst.Not_A) |=> (alu_inst.C == ~$past(alu_inst.A));
    endproperty

    alu_Not_A_assertion: assert property(alu_out_Not_A);
    alu_Not_A_coverage: cover property(alu_out_Not_A);

    property alu_out_ReductionOR_B;
        @(posedge alu_inst.clk) disable iff(alu_inst.reset) (alu_inst.Opcode == alu_inst.ReductionOR_B) |=> (alu_inst.C == |$past(alu_inst.B));
    endproperty

    alu_ReductionOR_B_assertion: assert property(alu_out_ReductionOR_B);
    alu_ReductionOR_B_coverage: cover property(alu_out_ReductionOR_B);

endmodule