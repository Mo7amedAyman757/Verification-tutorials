package ALU_env_pkg;
import uvm_pkg::*;
import ALU_agent_pkg::*;
import ALU_scoreboard_pkg::*;
import ALU_coverage_pkg::*;
`include "uvm_macros.svh"   

    class ALU_env extends uvm_env;
        `uvm_component_utils(ALU_env)

        ALU_agent agt;
        ALU_scoreboard sb;
        ALU_coverage cov;

        function new(string name = "ALU_env", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agt = ALU_agent::type_id::create("agt",this);
            sb = ALU_scoreboard::type_id::create("sb",this);
            cov = ALU_coverage::type_id::create("cov",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agt.agt_ap.connect(sb.sb_export);
            agt.agt_ap.connect(cov.cov_export);
        endfunction
        
    endclass //ALSU_env

endpackage