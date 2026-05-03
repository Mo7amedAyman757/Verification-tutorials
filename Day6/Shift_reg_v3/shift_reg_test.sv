////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
package shift_reg_test_pkg;
import shift_reg_env_pkg::*;
import shift_reg_config_pkg::*;
import uvm_pkg::*;
import shift_reg_sequence_pkg::*;
`include "uvm_macros.svh"


class shift_reg_test extends uvm_test;
  // Example 1
  // Do the essentials (factory register & Constructor)
  `uvm_component_utils(shift_reg_test)

  shift_reg_env env;
  shift_reg_config shift_reg_cfg;
  shift_reg_reset_sequence reset_seq;
  shift_reg_main_sequence main_seq;

  function new(string name = "shift_reg_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  // Build the enviornment in the build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = shift_reg_env::type_id::create("env",this);
    shift_reg_cfg = shift_reg_config::type_id:: create("shift_reg_cfg");

    main_seq = shift_reg_main_sequence::type_id::create("main_seq");
    reset_seq = shift_reg_reset_sequence::type_id::create("reset_seq");

    if(!uvm_config_db #(virtual shift_reg_if)::get(this,"", "shift_reg_IF", shift_reg_cfg.shift_reg_vif))
      `uvm_fatal("build phase","Test - Unable to get the virtual interface");

      uvm_config_db #(shift_reg_config)::set(this,"*","CFG",shift_reg_cfg);
  endfunction:build_phase

  // Run in the test in the run phase, raise objection, add #100 delay then display a message using `uvm_info, then drop the objection
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    // reset sequence
    `uvm_info("run_phase","Reset asserted", UVM_LOW)
    reset_seq.start(env.sqr);
    `uvm_info("run_phase","Reset deasserted", UVM_LOW)

    // main sequence
    `uvm_info("run_phase","Stimulus generation started", UVM_LOW)
    main_seq.start(env.sqr);
    `uvm_info("run_phase","Stimulus generation ended", UVM_LOW)
    #10;
    phase.drop_objection(this);
  endtask:run_phase

endclass: shift_reg_test
endpackage