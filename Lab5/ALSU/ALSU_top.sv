import ALSU_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module ALSU_top();

    bit clk;

    initial begin
        forever #1 clk = ~clk;
    end

    ALSU_if ALSUif(clk);

    ALSU DUT(ALSUif.A, 
             ALSUif.B,
             ALSUif.cin,
             ALSUif.serial_in,
             ALSUif.red_op_A, 
             ALSUif.red_op_B, 
             ALSUif.opcode, 
             ALSUif.bypass_A, 
             ALSUif.bypass_B, 
             ALSUif.clk, 
             ALSUif.rst, 
             ALSUif.direction, 
             ALSUif.leds, 
             ALSUif.out);

    initial begin
        uvm_config_db#(virtual ALSU_if)::set(null,"uvm_test_top","ALSU_IF",ALSUif);
        run_test("alsu_test");
    end

endmodule