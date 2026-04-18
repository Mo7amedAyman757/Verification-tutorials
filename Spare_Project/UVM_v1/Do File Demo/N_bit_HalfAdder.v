// n_bit adder
module N_bit_HalfAdder(A, B, C); 

    parameter n = 1;
    input  [n-1:0] A, B; 
    output [n-1:0] C; 

    assign C = A + B;  


endmodule