package shiftreg_monitor_pkg;
import uvm_pkg::*;
import shiftreg_seq_item_pkg::*;
import shiftreg_pkg::*;
`include "uvm_macros.svh"    

    class shiftreg_monitor extends uvm_monitor;
        `uvm_component_utils(shiftreg_monitor)

        virtual shiftreg_if shiftreg_vif;
        shiftreg_seq_item rsp_seq_item;
        uvm_analysis_port #(shiftreg_seq_item) mon_ap;


        function new(string name = "shiftreg_monitor", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap",this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                rsp_seq_item = shiftreg_seq_item::type_id::create("rsp_seq_item",this);
                @(negedge shiftreg_vif.clk);
                rsp_seq_item.reset = shiftreg_vif.reset;
                rsp_seq_item.serial_in = shiftreg_vif.serial_in;
                rsp_seq_item.direction = direction_e'(shiftreg_vif.direction);
                rsp_seq_item.mode = mode_e'(shiftreg_vif.mode);
                rsp_seq_item.datain = shiftreg_vif.datain;
                rsp_seq_item.dataout = shiftreg_vif.dataout;    
                mon_ap.write(rsp_seq_item);
            end

        endtask

    endclass

endpackage