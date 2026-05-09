package shiftreg_driver_pkg;
import uvm_pkg::*;
import shiftreg_seq_item_pkg::*;
import shiftreg_pkg::*;
`include "uvm_macros.svh"    

    class shiftreg_driver extends uvm_driver #(shiftreg_seq_item);
        `uvm_component_utils(shiftreg_driver)

        virtual shiftreg_if shiftreg_vif;
        shiftreg_seq_item drv_seq_item;

        function new(string name = "shiftreg_driver", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            
            forever begin
                drv_seq_item = shiftreg_seq_item::type_id::create("rsp_seq_item",this);
                seq_item_port.get_next_item(drv_seq_item);
                shiftreg_vif.reset = drv_seq_item.reset;
                shiftreg_vif.serial_in = drv_seq_item.serial_in;
                shiftreg_vif.direction = direction_e'(drv_seq_item.direction);
                shiftreg_vif.mode = mode_e'(drv_seq_item.mode);
                shiftreg_vif.datain = drv_seq_item.datain;
                @(negedge shiftreg_vif.clk);
                seq_item_port.item_done();    
            end

        endtask

    endclass

endpackage