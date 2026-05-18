package dff_agent_pkg;
import uvm_pkg::*;
import dff_seqitem_pkg::*;
import dff_config_pkg::*;
import dff_sequencer_pkg::*;
import dff_driver_pkg::*;
import dff_monitor_pkg::*;
`include "uvm_macros.svh"

    class dff_agent extends uvm_agent;
        `uvm_component_utils(dff_agent)

        dff_config dff_cfg;
        dff_sequencer sqr;
        dff_driver drv;
        dff_monitor mon;
        uvm_analysis_port #(dff_seqitem) agt_ap;

        function new(string name = "dff_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super. build_phase(phase);

            // get configuration
            if(!uvm_config_db #(dff_config)::get(this,"","CFG",dff_cfg))
                `uvm_fatal("build_phase","Test-unable to get the configuration object")
            
            sqr = dff_sequencer::type_id::create("sqr",this);
            drv = dff_driver::type_id::create("drv",this);
            mon = dff_monitor::type_id::create("mon",this);
           agt_ap = new("agt_ap",this);
            
        endfunction

        function void connect_phase(uvm_phase phase);
            super. connect_phase(phase);
            drv.dff_vif = dff_cfg.dff_vif;
            mon.dff_vif = dff_cfg.dff_vif;
            drv.seq_item_port.connect(sqr.seq_item_export);
            mon.mon_ap.connect(agt_ap);
        endfunction

    endclass

endpackage