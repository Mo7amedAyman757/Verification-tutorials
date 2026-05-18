package dff_test_pkg;
import uvm_pkg::*;
import dff_env_pkg::*;
import dff_config_pkg::*;
import dff_sequence_pkg::*;
`include "uvm_macros.svh"

    class dff_test extends uvm_test;
        `uvm_component_utils(dff_test)

        dff_config dff_cfg;
        dff_resetsequence rst_seq;
        dff_mainsequence main_seq;
        dff_env env;

        function new(string name = "dff_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super. build_phase(phase);

            env = dff_env::type_id::create("env",this);
            dff_cfg = dff_config::type_id:: create("dff_cfg");
            rst_seq = dff_resetsequence::type_id::create("rst_seq");
            main_seq = dff_mainsequence::type_id::create("main_seq");

            if(!uvm_config_db#(virtual dff_if)::get(this,"","DFF_IF",dff_cfg.dff_vif))
                `uvm_fatal("build_phase","Test-unable to get the virtual interface of the dff from the uvm_config_db")

            uvm_config_db#(dff_config)::set(this,"*","CFG",dff_cfg);
        endfunction

        task run_phase(uvm_phase phase);
            super. run_phase(phase);
            phase.raise_objection(this);

            `uvm_info("run_phase","Reset Asserted",UVM_LOW)
                rst_seq.start(env.agt.sqr);
            `uvm_info("run_phase","Reset Deasserted",UVM_LOW)

            `uvm_info("run_phase","Stimulus start",UVM_LOW)
                main_seq.start(env.agt.sqr);
            `uvm_info("run_phase","Stimulus end",UVM_LOW)

            phase.drop_objection(this);
        endtask

    endclass

endpackage