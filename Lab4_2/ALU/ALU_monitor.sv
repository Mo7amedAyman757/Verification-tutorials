////////////////////////////////////////////////////////////////////////////////
// Author: Mohamed Ayman
// Course: Digital Verification using SV & UVM
//
// Description: ALU Design 
// 
////////////////////////////////////////////////////////////////////////////////
module ALU_monitor(ALU_if.MONITOR alu_inst);

    initial begin
        $monitor("reset = %b opcode = %b A = %b B = %b C = %b",alu_inst.reset, alu_inst.Opcode, alu_inst.A, alu_inst.B, alu_inst.C);
    end

endmodule