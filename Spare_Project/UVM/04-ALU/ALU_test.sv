package ALU_test_pkg;
import uvm_pkg::*;
import ALU_env_pkg::*;
import ALU_config_pkg::*;
import ALU_sequence_pkg::*;
`include "uvm_macros.svh"

    class ALU_test extends uvm_test;
        `uvm_component_utils(ALU_test)

        ALU_config ALU_cfg;
        ALU_reset_sequence rst_seq;
        ALU_main_sequence main_seq;
        ALU_env env;

        function new(string name = "ALU_test", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super. build_phase(phase);

            env = ALU_env::type_id::create("env",this);
            ALU_cfg = ALU_config::type_id:: create("ALU_cfg");
            rst_seq = ALU_reset_sequence::type_id::create("rst_seq");
            main_seq = ALU_main_sequence::type_id::create("main_seq");

            if(!uvm_config_db#(virtual ALU_if)::get(this,"","ALU_IF",ALU_cfg.ALU_vif))
                `uvm_fatal("build_phase","Test-unable to get the virtual interface of the ALU from the uvm_config_db")

            uvm_config_db#(ALU_config)::set(this,"*","CFG",ALU_cfg);
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