package ALSU_sequence_pkg;
import uvm_pkg::*;
import ALSU_seq_item_pkg::*;
import ALSU_pkg::*;
`include "uvm_macros.svh"
    
    class ALSU_reset_sequence extends uvm_sequence #(ALSU_seq_item);
        `uvm_object_utils(ALSU_reset_sequence)
        ALSU_seq_item seq_item;

        function new(string name = "ALSU_reset_sequence");
            super.new(name);
        endfunction

        task body();
            seq_item = ALSU_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst = 1;
            seq_item.cin = 0;
            seq_item.red_op_A = 0;
            seq_item.red_op_B = 0;
            seq_item.bypass_A = 0;
            seq_item.bypass_B = 0;
            seq_item.direction = 0;
            seq_item.serial_in = 0;
            seq_item.opcode = opcode_e'(0);
            seq_item.A = 0;
            seq_item.B = 0;
            finish_item(seq_item);
        endtask

    endclass

    class ALSU_main_sequence extends uvm_sequence #(ALSU_seq_item);
        `uvm_object_utils(ALSU_main_sequence)
        ALSU_seq_item seq_item;

        function new (string name = "ALSU_main_sequence");
            super.new(name);
        endfunction

        task body();
            seq_item = ALSU_seq_item::type_id::create("seq_item");

            // TASK 1: constraint A only
            seq_item.opcode_cst.constraint_mode(1);
            seq_item.opcode_seq_con.constraint_mode(0);
            repeat(1000) begin
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end

            // TASK 2: constraint B only
            seq_item.opcode_cst.constraint_mode(0);
            seq_item.opcode_seq_con.constraint_mode(1);
            repeat (1000) begin
                assert(seq_item.randomize() with {seq_item.rst == 0;});
                for (int i = 0; i < 6; i++) begin
                    start_item(seq_item);
                    seq_item.opcode = seq_item.opcode_valid[i];
                    finish_item(seq_item);
                end

            end
        endtask
    endclass
endpackage