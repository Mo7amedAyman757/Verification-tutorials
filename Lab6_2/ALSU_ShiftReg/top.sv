////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
import uvm_pkg::*;
import shift_reg_test_pkg::*;
import ALSU_test_pkg::*;
import shared_pkg::*;
`include "uvm_macros.svh"

module top();
  // Clock generation
    bit clk = 0;

    initial begin
      forever #1 clk = ~clk;
    end
    
  // Instantiate the interface and DUT
  ALSU_if ALSUif(clk);
  shift_reg_if shift_regif();
  shift_reg Shiftreg_dut (shift_regif.serial_in, shift_regif.direction, shift_regif.mode, shift_regif.datain, shift_regif.dataout);
  ALSU    ALSU_dut(ALSUif.A, 
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

  assign shift_regif.datain = ALSU_if.out;
  assign ALSU_if.out_shift_reg = shift_regif.dataout;
  assign shift_regif.serial_in = ALSU_if.serial_in_reg;
  assign shift_regif.direction = direction_e'(ALSU_if.direction_reg);
  assign shift_regif.mode = mode_e'(ALSU_if.opcode_reg[0]);
  // run test using run_test task
  initial begin
    uvm_config_db #(virtual shift_reg_if)::set(null,"uvm_test_top","shift_reg_IF",shift_regif);
    uvm_config_db#(virtual ALSU_if)::set(null,"uvm_test_top","ALSU_IF",ALSUif);
    run_test("ALSU_test");

  end

endmodule