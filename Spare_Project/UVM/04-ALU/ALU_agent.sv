package ALU_agent_pkg;
import uvm_pkg::*;
import ALU_driver_pkg::*;
import ALU_monitor_pkg::*;
import ALU_config_pkg::*;
import ALU_sequencer_pkg::*;
import ALU_seqitem_pkg::*;
`include "uvm_macros.svh"   

    class ALU_agent extends uvm_agent;
        `uvm_component_utils(ALU_agent)
        
        ALU_config ALU_cfg;
        ALU_driver drv;
        ALU_monitor mon;
        ALU_sequencer sqr;
        uvm_analysis_port #(ALU_seqitem) agt_ap;


        function new(string name = "ALU_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction //new()

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            // check configuration 
            if(!uvm_config_db#(ALU_config)::get(this,"","CFG",ALU_cfg))
                `uvm_fatal("build_phase","Agent-unable to get configuration of ALU from the uvm_config_db")

            drv = ALU_driver::type_id::create("drv",this);
            mon = ALU_monitor::type_id::create("mon",this);
            sqr = ALU_sequencer::type_id::create("sqr",this);
            agt_ap = new("agt_ap",this);

        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            drv.ALU_vif = ALU_cfg.ALU_vif;
            mon.ALU_vif = ALU_cfg.ALU_vif;
            drv.seq_item_port.connect(sqr.seq_item_export);
            mon.mon_ap.connect(agt_ap);
        endfunction

    endclass //ALU_agent             

endpackage