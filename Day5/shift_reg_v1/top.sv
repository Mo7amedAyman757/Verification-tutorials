////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
import uvm_pkg::*;
`include "uvm_macros.svh"
import shift_reg_test_pkg::*;

module top();
  // Example 1
  // Clock generation
    bit clk;

    initial begin
      forever #1 clk = ~clk;
    end
    
  // Instantiate the interface and DUT
  shift_reg_if shift_regif(clk);
  shift_reg DUT (shift_regif.clk, shift_regif.reset, shift_regif.serial_in, shift_regif.direction, shift_regif.mode, shift_regif.datain, shift_regif.dataout);
  // run test using run_test task
  initial begin
    run_test("shift_reg_test");
  end
  // Example 2
  // Set the virtual interface for the uvm test
endmodule