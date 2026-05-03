package ALSU_test_pkg;
import uvm_pkg::*;
import ALSU_env_pkg::*;
import ALSU_config_pkg::*;
import ALSU_sequence_pkg::*;
`include "uvm_macros.svh"

    class ALSU_test extends uvm_test;
       `uvm_component_utils(ALSU_test)

       virtual ALSU_if ALSUif;
       ALSU_env env;
       ALSU_config ALSU_cfg;
       ALSU_reset_sequence reset_seq;
       ALSU_main_sequence main_seq;

       function new(string name = "ALSU_test",uvm_component parent = null);
            super.new(name,parent);
       endfunction

       function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = ALSU_env::type_id::create("env",this);
            ALSU_cfg = ALSU_config::type_id::create("ALSU_cfg");
            reset_seq =  ALSU_reset_sequence::type_id::create("reset_seq",this);
            main_seq =  ALSU_main_sequence::type_id::create("main_seq",this);

            if (!uvm_config_db#(virtual ALSU_if)::get(this,"","ALSU_IF",ALSU_cfg.ALSU_vif))
                `uvm_fatal("build_phase","Test- unable to get the virtual interface");

            uvm_config_db#(ALSU_config)::set(this,"*","CFG",ALSU_cfg);
       endfunction
       
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            // reset sequence
            phase.raise_objection(this);
            `uvm_info("run_phase","Reset asserted", UVM_LOW)
            reset_seq.start(env.agt.sqr);
            `uvm_info("run_phase","Reset deasserted", UVM_LOW)

            // main sequence
            `uvm_info("run_phase","Stimulus generation started", UVM_LOW)
            main_seq.start(env.agt.sqr);
            `uvm_info("run_phase","Stimulus generation ended", UVM_LOW)
            #10;
            phase.drop_objection(this);

        endtask
       
    endclass

    
endpackage
