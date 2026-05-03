////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
import uvm_pkg::*;
import shift_reg_test_pkg::*;
`include "uvm_macros.svh"

module top();
  // Clock generation
    bit clk = 0;

    initial begin
      forever #1 clk = ~clk;
    end
    
  // Instantiate the interface and DUT
  shift_reg_if shift_regif(clk);
  shift_reg DUT (shift_regif.clk, shift_regif.reset, shift_regif.serial_in, shift_regif.direction, shift_regif.mode, shift_regif.datain, shift_regif.dataout);
  
  // run test using run_test task
  initial begin
    uvm_config_db #(virtual shift_reg_if)::set(null,"uvm_test_top","shift_reg_IF",shift_regif);
    run_test("shift_reg_test");
  end

endmodule