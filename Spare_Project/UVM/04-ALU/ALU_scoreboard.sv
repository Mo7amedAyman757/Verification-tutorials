package ALU_scoreboard_pkg;
import uvm_pkg::*;
import ALU_pkg::*;
import ALU_seqitem_pkg::*;
`include "uvm_macros.svh"   

    class ALU_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(ALU_scoreboard)

        uvm_analysis_export #(ALU_seqitem) sb_export;
        uvm_tlm_analysis_fifo #(ALU_seqitem) sb_fifo;
        ALU_seqitem sb_seqitem;

        int correct_count , error_count;

        logic [4:0] C_ref;


        function new(string name = "ALU_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction //new()

        function void build_phase(uvm_phase phase);
            super. build_phase(phase);
            sb_export = new("sb_export",this);
            sb_fifo = new("sb_fifo",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super. connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super. run_phase(phase);
            forever begin
                sb_fifo.get(sb_seqitem);
                check_result(sb_seqitem);
            end
        endtask

        task check_result(ALU_seqitem seqitem);
        golden_model(seqitem);
        if(C_ref != seqitem.C) begin
            error_count++;
            $display("Failed");
        end else begin
            correct_count++;
            $display("Passed");
        end
    endtask

    task golden_model(ALU_seqitem seqitem);
        if(seqitem.reset) 
            C_ref = 0;
        else begin
            case(seqitem.Opcode)
                Add:            C_ref = seqitem.A + seqitem.B;
                Sub:            C_ref = seqitem.A - seqitem.B;
                Not_A:          C_ref = ~seqitem.A;
                ReductionOR_B:  C_ref = |seqitem.B;
                default:  C_ref = 5'b0;
            endcase
        end    
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase",$sformatf("Total successful transaction : %0d",correct_count),UVM_MEDIUM);
        `uvm_info("report_phase",$sformatf("Total failed transaction : %0d",error_count),UVM_MEDIUM);
    endfunction
    
    endclass
    
endpackage