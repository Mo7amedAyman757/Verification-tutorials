package shiftreg_env_pkg;
import uvm_pkg::*;
import shiftreg_agent_pkg::*;
import shiftreg_scoreboard_pkg::*;
import shiftreg_coverage_pkg::*;
`include "uvm_macros.svh"    

    class shiftreg_env extends uvm_env;
        `uvm_component_utils(shiftreg_env)

        shiftreg_agent agt;
        shiftreg_scoreboard sb;
        shiftreg_coverage cov;

        function new(string name = "shiftreg_env", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agt = shiftreg_agent::type_id::create("agt",this);
            sb = shiftreg_scoreboard::type_id::create("sb",this);
            cov = shiftreg_coverage::type_id::create("cov",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agt.agt_ap.connect(sb.sb_export);
            agt.agt_ap.connect(cov.cov_export);
        endfunction

    endclass

endpackage
