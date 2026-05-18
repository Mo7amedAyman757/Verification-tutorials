package counter_sequencer_pkg;
import uvm_pkg::*;
import counter_seqitem_pkg::*;
`include "uvm_macros.svh"

    class counter_sequencer extends uvm_sequencer #(counter_seqitem);
        `uvm_component_utils(counter_sequencer)

        function new(string name = "counter_sequencer", uvm_component parent = null);
            super.new(name, parent);
        endfunction

    endclass

endpackage