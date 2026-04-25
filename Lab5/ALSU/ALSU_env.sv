package ALSU_env_pkg;
import uvm_pkg::*;
import ALSU_driver_pkg::*;
`include "uvm_macros.svh"

    class alsu_env extends uvm_env;
        `uvm_component_utils(alsu_env);

        alsu_driver driver;

        function new(string name = "aslu_env", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            driver = alsu_driver::type_id::create("driver",this);
        endfunction

    endclass

endpackage