package counter_env_pkg;
import uvm_pkg::*;
import counter_agent_pkg::*;
import counter_scoreboard_pkg::*;
import counter_coverage_pkg::*;
`include "uvm_macros.svh"

    class counter_env extends uvm_env;
        `uvm_component_utils(counter_env)

        counter_agent agt;
        counter_scoreboard sb;
        counter_coverage cov;

        function new(string name = "counter_env", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super. build_phase(phase);
            agt = counter_agent::type_id::create("agt",this);
            sb = counter_scoreboard::type_id::create("sb",this);
            cov = counter_coverage::type_id::create("cov",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super. connect_phase(phase);
            agt.agt_ap.connect(sb.sb_exp);
            agt.agt_ap.connect(cov.cov_exp);
        endfunction

    endclass

endpackage