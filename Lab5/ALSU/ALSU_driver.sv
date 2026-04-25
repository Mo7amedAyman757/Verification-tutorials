package ALSU_driver_pkg;
import uvm_pkg::*;
import ALSU_config_pkg::*;
`include "uvm_macros.svh"

    class alsu_driver extends uvm_driver;
        `uvm_component_utils(alsu_driver);

        virtual ALSU_if ALSU_vif;
        ALSU_config ALSU_cfg;

        function new(string name = "alsu_driver", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            ALSU_cfg = ALSU_config::type_id::create("ALSU_cfg");

            if(!uvm_config_db#(ALSU_config)::get(this,"","CFG",ALSU_cfg))
                `uvm_fatal("build_phase", "Driver cannot get interface")
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            ALSU_vif = ALSU_cfg.ALSU_vif;
        endfunction

        task run_phase(uvm_phase phase);
            // Reset
            ALSU_vif.rst = 1;
            repeat (2) @(negedge ALSU_vif.clk);
            ALSU_vif.rst = 0;

            // Random driving
            forever begin
                @(negedge ALSU_vif.clk);

                ALSU_vif.A  = $random;
                ALSU_vif.B  = $random;
                ALSU_vif.cin = $random;
                ALSU_vif.serial_in = $random;
                ALSU_vif.red_op_A = $random;
                ALSU_vif.red_op_B = $random;
                ALSU_vif.bypass_A = $random;
                ALSU_vif.bypass_B = $random;
                ALSU_vif.direction = $random;
                ALSU_vif.opcode = $random;
            end
        endtask

    endclass

endpackage