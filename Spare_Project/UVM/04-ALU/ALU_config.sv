package ALU_config_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"    

    class ALU_config extends uvm_object;
        `uvm_object_utils(ALU_config)

        virtual ALU_if ALU_vif;

        function new(string name = "ALU_config");
            super.new(name);
        endfunction //new()

    endclass //ALU_config
    
endpackage