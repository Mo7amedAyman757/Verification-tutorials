package ALU_seqitem_pkg;
import uvm_pkg::*;
import ALU_pkg::*;
`include "uvm_macros.svh"    

    class ALU_seqitem extends uvm_sequence_item;
        `uvm_object_utils(ALU_seqitem)

        rand logic reset;
        rand opcode_e Opcode;
        rand logic signed [3:0] A, B;	
        logic signed [4:0] C; 
        
        function new(string name = "ALU_seqitem");
            super.new(name);
        endfunction //new()
        
        function string convert2string();
            return $sformatf("%s reset = 0b%0b, Opcode = 0b%0b
                              A = 0b%0b, B = 0b%0b
                              C = 0b%0b,", super.convert2string(),
                              reset, Opcode, A, B, C);            
        endfunction

        function string convert2string_stimulus();
            return $sformatf("reset = 0b%0b, Opcode = 0b%0b
                              A = 0b%0b, B = 0b%0b
                              C = 0b%0b,",
                              reset, Opcode, A, B, C);                     
        endfunction

        constraint rst_cst{
            reset dist{1 := 4, 0:= 96};
        }

        constraint A_cst{
            A dist{MAXNEG := 25, [-7:-1] := 10, ZERO := 25, [1:6] := 10, MAXPOS := 25};
        }

        constraint B_cst{
            B dist{MAXNEG := 25, [-7:-1] := 10, ZERO := 25, [1:6] := 10, MAXPOS := 25};
        }

        constraint op_cst{
            Opcode dist{Add := 30, Sub := 40, Not_A := 20, ReductionOR_B := 20};
        }

    endclass //ALU_seqitem 
    
endpackage