package counter_test_pkg;
import uvm_pkg::*;
import counter_env_pkg::*;
import counter_config_pkg::*;
import counter_sequence_pkg::*;
`include "uvm_macros.svh"

    class counter_test extends uvm_test;
        `uvm_component_utils(counter_test)

        counter_config counter_cfg;
        counter_resetsequence rst_seq;
        counter_mainsequence main_seq;
        counter_env env;

        function new(string name = "counter_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super. build_phase(phase);

            env = counter_env::type_id::create("env",this);
            counter_cfg = counter_config::type_id:: create("counter_cfg");
            rst_seq = counter_resetsequence::type_id::create("rst_seq");
            main_seq = counter_mainsequence::type_id::create("main_seq");

            if(!uvm_config_db#(virtual counter_if)::get(this,"","COUNTER_IF",counter_cfg.counter_vif))
                `uvm_fatal("build_phase","Test-unable to get the virtual interface of the counter from the uvm_config_db")

            uvm_config_db#(counter_config)::set(this,"*","CFG",counter_cfg);
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