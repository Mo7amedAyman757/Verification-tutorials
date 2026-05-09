package shiftreg_agent_pkg;
import uvm_pkg::*;
import shiftreg_sequencer_pkg::*;
import shiftreg_seq_item_pkg::*;
import shiftreg_monitor_pkg::*;
import shiftreg_driver_pkg::*;
import shiftreg_config_pkg::*;
`include "uvm_macros.svh"    

    class shiftreg_agent extends uvm_agent;
        `uvm_component_utils(shiftreg_agent)

        shiftreg_sequencer sqr;
        shiftreg_monitor mon;
        shiftreg_driver drv;
        shiftreg_config shiftreg_cfg;

        uvm_analysis_port #(shiftreg_seq_item) agt_ap;

        function new(string name = "shiftreg_agent", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            if(!uvm_config_db #(shiftreg_config)::get(this,"","CFG",shiftreg_cfg))
                `uvm_fatal("build_phase","Agent-unable to get the virtual interface of the shift register from the uvm_config_db")

            sqr = shiftreg_sequencer::type_id::create("sqr",this);
            mon = shiftreg_monitor::type_id::create("mon",this);
            drv = shiftreg_driver::type_id::create("drv",this);
            agt_ap = new("agt_ap",this);

        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            drv.shiftreg_vif = shiftreg_cfg.shiftreg_vif;
            mon.shiftreg_vif = shiftreg_cfg.shiftreg_vif;
            drv.seq_item_port.connect(sqr.seq_item_export);
            mon.mon_ap.connect(agt_ap);
        endfunction


    endclass

endpackage