package FIFO_test_pkg;
import uvm_pkg::*;
import FIFO_config_pkg::*;
import FIFO_env_pkg::*;
import FIFO_sequence_pkg::*;

`include "uvm_macros.svh"

    class FIFO_test extends uvm_test;
        `uvm_component_utils(FIFO_test);

        // add environment class 
        FIFO_env env;
        // add sequence class 
        FIFO_reset_sequence reset_seq;
        FIFO_write_sequence wr_seq;
        FIFO_read_sequence rd_seq;
        FIFO_rd_wr_sequence rd_wr_seq;
        //FIFO_main_sequence main_seq;
        virtual FIFO_if fifoif;
        FIFO_config FIFO_cfg;

        function new(string name = "FIFO_test", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = FIFO_env::type_id::create("env",this);
            FIFO_cfg = FIFO_config::type_id::create("FIFO_cfg");
            reset_seq = FIFO_reset_sequence::type_id::create("reset_seq",this);
            wr_seq = FIFO_write_sequence::type_id::create("wr_seq",this);
            rd_seq = FIFO_read_sequence::type_id::create("rd_seq",this);
            rd_wr_seq = FIFO_rd_wr_sequence::type_id::create("rd_wr_seq",this);

            if(!uvm_config_db#(virtual FIFO_if)::get(this,"","FIFO_IF",FIFO_cfg.fifo_vif))
                `uvm_fatal("build phase","Test - Unable to get the virtual interface");

            uvm_config_db#(FIFO_config)::set(this,"*","CFG", FIFO_cfg);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            phase.raise_objection(this);

            `uvm_info("run_phase","Reset asserted", UVM_LOW)
            reset_seq.start(env.agt.sqr);
            `uvm_info("run_phase","Reset dasserted", UVM_LOW)

            `uvm_info("run_phase","Stimulus generation started", UVM_LOW)
            wr_seq.start(env.agt.sqr);
            rd_seq.start(env.agt.sqr);
            rd_wr_seq.start(env.agt.sqr);
            `uvm_info("run_phase","Stimulus generation ended", UVM_LOW)
            
            #10;
            phase.drop_objection(this);
        endtask
    endclass
endpackage