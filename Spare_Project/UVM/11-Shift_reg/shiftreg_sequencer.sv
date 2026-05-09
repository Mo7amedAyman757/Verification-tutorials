package shiftreg_sequencer_pkg;
import uvm_pkg::*;
import shiftreg_seq_item_pkg::*;
`include "uvm_macros.svh"    


    class shiftreg_sequencer extends uvm_sequencer #(shiftreg_seq_item);
        `uvm_component_utils(shiftreg_sequencer)

        function new(string name = "shiftreg_sequencer", uvm_component parent = null);
            super.new(name,parent);
        endfunction //new()

    endclass
    
endpackage