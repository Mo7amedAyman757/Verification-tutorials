module N_bit_ALU(A, B, opcode, rslt);
    parameter N = 3'b100; 

    input     [N-1:0] A, B; 
    input     [1:0] opcode;
    output reg[N-1:0] rslt;  

    wire [N-1:0] SUM; 

    N_bit_HalfAdder #(4) uut (.A(A), .B(B), .C(SUM)); 

    always@(*) begin 
        case(opcode)
            2'b00: rslt = SUM;      // sum
            2'b01: rslt = A - B;    //subtract 
            2'b10: rslt = A | B;    //OR
            2'b11: rslt = A ^ B;    //XOR
        endcase

    end 


endmodule