package ALSU_sequencer_pkg;
import uvm_pkg::*;
import ALSU_seqitem_pkg::*;
`include "uvm_macros.svh"  

    class ALSU_sequencer extends uvm_sequencer #(ALSU_seqitem);
        `uvm_component_utils(ALSU_sequencer)

        function new(string name = "ALSU_sequencer", uvm_component parent = null);
            super.new(name,parent);    
        endfunction //new()

    endclass //ALSU_sequencer_pkg
    
endpackage