package shiftreg_test_pkg;
import uvm_pkg::*;
import shiftreg_sequence_pkg::*;
import shiftreg_config_pkg::*;
import shiftreg_env_pkg::*;
`include "uvm_macros.svh"    

    class shiftreg_test extends uvm_test;
        `uvm_component_utils(shiftreg_test)

        shiftreg_config shiftreg_cfg;
        shiftreg_env env;
        shiftreg_reset_sequence rst_seq;
        shiftreg_main_sequence main_seq;
        
        function new(string name = "shiftreg_test", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            env = shiftreg_env::type_id::create("env",this);
            shiftreg_cfg = shiftreg_config::type_id:: create("shiftreg_cfg");
            rst_seq = shiftreg_reset_sequence::type_id::create("rst_seq");
            main_seq = shiftreg_main_sequence::type_id::create("main_seq");

            if(!uvm_config_db #(virtual shiftreg_if)::get(this,"","SHIFTREG_IF",shiftreg_cfg.shiftreg_vif))
                `uvm_fatal("build_phase","Test-unable to get the virtual interface of the shift register from the uvm_config_db")

            uvm_config_db #(shiftreg_config)::set(this,"*","CFG",shiftreg_cfg);   
        endfunction

        task run_phase (uvm_phase phase);
            super.run_phase (phase);

            phase.raise_objection(this);
            
            `uvm_info("run_phase","Reset Asserted",UVM_LOW)
                rst_seq.start(env.agt.sqr);
            `uvm_info("run_phase","Reset Deasserted",UVM_LOW)

            `uvm_info("run_phase","Stimulus start",UVM_LOW)
                main_seq.start(env.agt.sqr);
            `uvm_info("run_phase","Stimulus end",UVM_LOW)

            phase.drop_objection(this);
            
        endtask //run_phase

    endclass //shiftreg_test

endpackage