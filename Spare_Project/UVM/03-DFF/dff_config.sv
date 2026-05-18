package dff_config_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

    class dff_config extends uvm_object;
        `uvm_object_utils(dff_config)

        virtual dff_if dff_vif;

        function new(string name = "dff_config");
            super.new(name);
        endfunction

    endclass


endpackage