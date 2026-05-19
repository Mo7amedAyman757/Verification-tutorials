package ALU_sequencer_pkg;
import uvm_pkg::*;
import ALU_seqitem_pkg::*;
`include "uvm_macros.svh"    

    class ALU_sequencer extends uvm_sequencer #(ALU_seqitem);
        `uvm_component_utils(ALU_sequencer)

        function new(string name = "ALU_sequencer",uvm_component parent = null);
            super.new(name, parent);
        endfunction //new()
        
    endclass //ALU_sequencer 
    
endpackage