/* Reem Hamada */
`timescale 1ns / 1ns

module N_bit_ALU_tb();

        parameter N = 4; 
        reg [N-1:0] in1, in2; 
        reg [1:0]   op;
        wire[N-1:0] final;

        integer err_count, corr_count;   

        reg [N-1:0] expected; 
        N_bit_ALU #(4)uut(.A(in1), .B(in2), .opcode(op), .rslt(final));

        initial begin 
                err_count  = 0; 
                corr_count = 0;   

                repeat(50) begin 
                        in1 = $random;
                        in2 = $random;
                        op  = $random;
                        
                        case(op)
                                2'b00: expected = in1 + in2; // sum
                                2'b01: expected = in1 - in2; // subtract 
                                2'b10: expected = in1 | in2;//or
                                2'b11: expected = in1 ^ in2;//or
                        endcase

                        #10; 
                        if (final !== expected) begin 
                                err_count = err_count + 1; 
                                $display("ERROR: in1=%0b (%0d) | in2=%0b (%0d)| opcode = %0b (%0d)| resulted sum=%0b (%0d)| Expected=%0b", in1, in1, in2, in2, op, op, final, final, expected, expected);
                        end else begin 
                                corr_count = corr_count + 1;           
                        end
                end
                $display("SUCCESS: correct counts =%0d, error counts = %0d", corr_count, err_count);
                $stop; 
        end 

endmodule