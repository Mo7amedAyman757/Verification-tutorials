package counter_agent_pkg;
import uvm_pkg::*;
import counter_seqitem_pkg::*;
import counter_config_pkg::*;
import counter_sequencer_pkg::*;
import counter_driver_pkg::*;
import counter_monitor_pkg::*;
`include "uvm_macros.svh"

    class counter_agent extends uvm_agent;
        `uvm_component_utils(counter_agent)

        counter_config counter_cfg;
        counter_sequencer sqr;
        counter_driver drv;
        counter_monitor mon;
        uvm_analysis_port #(counter_seqitem) agt_ap;

        function new(string name = "counter_agent", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super. build_phase(phase);

            // get configuration
            if(!uvm_config_db #(counter_config)::get(this,"","CFG",counter_cfg))
                `uvm_fatal("build_phase","Test-unable to get the configuration object")
            
            sqr = counter_sequencer::type_id::create("sqr",this);
            drv = counter_driver::type_id::create("drv",this);
            mon = counter_monitor::type_id::create("mon",this);
           agt_ap = new("agt_ap",this);
            
        endfunction

        function void connect_phase(uvm_phase phase);
            super. connect_phase(phase);
            drv.counter_vif = counter_cfg.counter_vif;
            mon.counter_vif = counter_cfg.counter_vif;
            drv.seq_item_port.connect(sqr.seq_item_export);
            mon.mon_ap.connect(agt_ap);
        endfunction

    endclass

endpackage