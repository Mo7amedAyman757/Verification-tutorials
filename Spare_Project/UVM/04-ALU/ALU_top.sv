// import test & add uvm package
import uvm_pkg::*;
import ALU_test_pkg::*;
`include "uvm_macros.svh"

module ALU_top();
    
    logic clk;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    ALU_if ALUif(clk);

    ALU_4_bit dut(ALUif.clk,
                ALUif.reset,
                ALUif.Opcode,
                ALUif.A,
                ALUif.B,
                ALUif.C
                );

    ALU_sva ALU_sva_inst(ALUif);

    initial begin
        uvm_config_db #(virtual ALU_if)::set(null,"uvm_test_top","ALU_IF",ALUif);
        run_test("ALU_test");
    end

endmodule