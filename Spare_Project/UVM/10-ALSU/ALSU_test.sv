package ALSU_test_pkg;
import uvm_pkg::*;
import ALSU_pkg::*;
import ALSU_sequence_pkg::*;
import ALSU_env_pkg::*;
import ALSU_config_pkg::*;
import ALSU_seqitem_pkg::*;
`include "uvm_macros.svh"

    class ALSU_test extends uvm_test;
        `uvm_component_utils(ALSU_test)

        ALSU_env env;
        ALSU_reset_sequence rst_seq;
        ALSU_main_sequence main_seq;
        ALSU_config alsu_cfg;
        

        function new(string name = "ALSU_test", uvm_component parent = null);
            super.new(name,parent);    
        endfunction //new()


        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            env = ALSU_env::type_id::create("env",this);
            rst_seq = ALSU_reset_sequence::type_id::create("rst_seq");
            main_seq = ALSU_main_sequence::type_id::create("main_seq");
            alsu_cfg = ALSU_config::type_id::create("alsu_cfg");

            if(!uvm_config_db #(virtual ALSU_if)::get(this,"","ALSU_IF",alsu_cfg.alsu_vif))
                `uvm_fatal("build_phase","Test-unable to get the virtual interface of the shift register from the uvm_config_db")

            uvm_config_db #(ALSU_config)::set(this,"*","CFG",alsu_cfg);

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

        endtask

    endclass

endpackage