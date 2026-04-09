import testing_pkg::*;

module ALU_tb();

    // 1- delcare local wire and reg
    transaction tr = new();
    byte operand1, operand2;
    opcode_e opcode;
    bit clk, rst;
    byte out;

    // 2- Instantiate the module under test
    alu_seq uut(
        operand1,
        operand2,
        clk,
        rst,
        opcode,
        out
    );

    // 3- Define the clock
    initial begin
        clk = 1'b0;
        forever begin 
        #5 clk = ~clk;
        tr.clk = clk;
        end
    end

    // 4- General stimuli 
    initial begin
        rst = 1'b1;
        @(negedge clk);
        rst = 1'b0;
        
        repeat(1000) begin
            assert (tr.randomize()); 
            rst = tr.rst;
            opcode = tr.opcode;
            operand1 = tr.operand1;
            operand2 = tr.operand2;
            @(negedge clk);
        end
        $stop;
    end

endmodule