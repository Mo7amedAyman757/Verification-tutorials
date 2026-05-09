package shiftreg_config_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"    

    class shiftreg_config extends uvm_object;
        `uvm_object_utils(shiftreg_config);

        virtual shiftreg_if shiftreg_vif;

        function new(string name = "shiftreg_config");
            super.new(name);
        endfunction

    endclass
endpackage