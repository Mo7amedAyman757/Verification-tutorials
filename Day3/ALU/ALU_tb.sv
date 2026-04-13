import testing_pkg::*;

module alu_tb();

    transaction alu_obj;

    // Declare local input and outputs 
    byte operand1, operand2;
    bit clk, rst;
    opcode_e opcode;
    byte out;

    // instantiate the ALU
    alu_seq uut (
        operand1, 
        operand2, 
        clk, 
        rst, 
        opcode, 
        out);

    // Clock generation
    initial begin   
        clk = 0;
        forever begin
            #5 clk = ~clk; // 10 time units period
            alu_obj.clk = clk; // Update transaction clock
        end
    end

    // Test stimulus
    initial begin
        alu_obj = new();
        rst = 1'b1; // Assert reset
        @(negedge clk) rst = 1'b0; // Deassert reset

        repeat(32) begin
            assert(alu_obj.randomize());
            rst = alu_obj.rst;
            operand1 = alu_obj.operand1;
            operand2 = alu_obj.operand2;
            opcode = alu_obj.opcode;
            @(negedge clk); // Wait for the next clock cycle
        end
        $stop;
    end

endmodule