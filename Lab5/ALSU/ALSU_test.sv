package ALSU_test_pkg;
import uvm_pkg::*;
import ALSU_env_pkg::*;
import ALSU_config_pkg::*;
`include "uvm_macros.svh"

    class alsu_test extends uvm_test;
        `uvm_component_utils(alsu_test)
        
        alsu_env env;
        ALSU_config ALSU_cfg;

        function new(string name = "aslu_test", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = alsu_env::type_id::create("env",this);
            ALSU_cfg = ALSU_config::type_id::create("ALSU_cfg");

            if(!uvm_config_db #(virtual ALSU_if)::get(this,"","ALSU_IF",ALSU_cfg.ALSU_vif))
                `uvm_fatal("build_phase", "Cannot get interface")

            uvm_config_db #(ALSU_config)::set(this,"*","CFG",ALSU_cfg);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
            #100; `uvm_info("run phase","inside the ALSU test",UVM_MEDIUM);
            phase.drop_objection(this);
        endtask

    endclass

    
endpackage
