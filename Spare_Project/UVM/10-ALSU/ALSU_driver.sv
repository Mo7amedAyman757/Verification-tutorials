package ALSU_driver_pkg;
import uvm_pkg::*;
import ALSU_pkg::*;
import ALSU_seqitem_pkg::*;
`include "uvm_macros.svh"

    class ALSU_driver extends uvm_driver #(ALSU_seqitem);
        `uvm_component_utils(ALSU_driver)
        
        ALSU_seqitem drv_seq_item;
        virtual ALSU_if alsu_vif;

        function new(string name = "ALSU_driver", uvm_component parent = null);
            super.new(name,parent);    
        endfunction //new()

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                drv_seq_item = ALSU_seqitem::type_id::create("drv_seq_item",this);
                seq_item_port.get_next_item(drv_seq_item);
                alsu_vif.A  = drv_seq_item.A;
                alsu_vif.B  = drv_seq_item.B;
                alsu_vif.cin = drv_seq_item.cin;
                alsu_vif.serial_in = drv_seq_item.serial_in;
                alsu_vif.red_op_A = drv_seq_item.red_op_A;
                alsu_vif.red_op_B = drv_seq_item.red_op_B;
                alsu_vif.opcode = drv_seq_item.opcode;
                alsu_vif.bypass_A  = drv_seq_item.bypass_A;
                alsu_vif.bypass_B  = drv_seq_item.bypass_B;
                alsu_vif.rst = drv_seq_item.rst;
                alsu_vif.direction = drv_seq_item.direction;
                @(negedge alsu_vif.clk);
                seq_item_port.item_done();
            end    
        endtask //run_phase
        
    endclass //ALSU_driver

endpackage