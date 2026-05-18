package dff_env_pkg;
import uvm_pkg::*;
import dff_agent_pkg::*;
import dff_scoreboard_pkg::*;
import dff_coverage_pkg::*;
`include "uvm_macros.svh"

    class dff_env extends uvm_env;
        `uvm_component_utils(dff_env)

        dff_agent agt;
        dff_scoreboard sb;
        dff_coverage cov;

        function new(string name = "dff_env", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super. build_phase(phase);
            agt = dff_agent::type_id::create("agt",this);
            sb = dff_scoreboard::type_id::create("sb",this);
            cov = dff_coverage::type_id::create("cov",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super. connect_phase(phase);
            agt.agt_ap.connect(sb.sb_exp);
            agt.agt_ap.connect(cov.cov_exp);
        endfunction

    endclass

endpackage