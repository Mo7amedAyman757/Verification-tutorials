package dff_sequencer_pkg;
import uvm_pkg::*;
import dff_seqitem_pkg::*;
`include "uvm_macros.svh"

    class dff_sequencer extends uvm_sequencer #(dff_seqitem);
        `uvm_component_utils(dff_sequencer)

        function new(string name = "dff_sequencer", uvm_component parent = null);
            super.new(name, parent);
        endfunction

    endclass

endpackage