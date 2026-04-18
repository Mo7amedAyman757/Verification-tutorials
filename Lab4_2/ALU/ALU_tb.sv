////////////////////////////////////////////////////////////////////////////////
// Author: Mohamed Ayman
// Course: Digital Verification using SV & UVM
//
// Description: ALU Design 
// 
////////////////////////////////////////////////////////////////////////////////


module ALU_tb(ALU_if.TEST alu_inst);
    
    // reset initial values for inputs
    initial begin

        alu_inst.reset = 0; 
        #2;
        alu_inst.reset = 1;
        repeat(2) @(posedge alu_inst.clk);
        alu_inst.reset = 0;

        alu_inst.Opcode = 0;
        alu_inst.A = 0;
        alu_inst.B = 0;

        // Add operation
        alu_inst.Opcode = alu_inst.Add;
        for(int i = 0; i < 4; i++) begin
            @(posedge alu_inst.clk);
            alu_inst.A = $random;
            alu_inst.B = $random;
        end

        repeat(2) @(posedge alu_inst.clk);

        // Sub operation
        alu_inst.Opcode = alu_inst.Sub;
        for(int i = 0; i < 4; i++) begin
            @(posedge alu_inst.clk);
            alu_inst.A = $random;
            alu_inst.B = $random;
        end

        repeat(2) @(posedge alu_inst.clk);
        
        // Not_A operation
        alu_inst.Opcode = alu_inst.Not_A;
        for(int i = 0; i < 4; i++) begin
            @(posedge alu_inst.clk);
            alu_inst.A = $random;
            alu_inst.B = $random;
        end

        repeat(2) @(posedge alu_inst.clk);

        // ReductionOR_B operation
        alu_inst.Opcode = alu_inst.ReductionOR_B;
        for(int i = 0; i < 4; i++) begin
            @(posedge alu_inst.clk);
            alu_inst.A = $random;
            alu_inst.B = $random;
        end

        alu_inst.Opcode = alu_inst.Add;
        repeat(2) @(posedge alu_inst.clk);

        #100; $stop;
    end
endmodule