import ALU_pkg::*;

module ALU_tb;
    ALU_transaction ALU_obj;

    // Declare local wire and reg
    logic clk;
    logic reset;
    opcode_t opcode;
    logic signed [3:0] A;
    logic signed [3:0] B;
    wire signed [4:0] C;

    bit signed [4:0] C_exp;

    // Instantiate the module under test
    ALU_4_bit uut(
        clk,
        reset,
        opcode,
        A,
        B,
        C
    );

    // define local parameter for tracking the functionality
    int  count_correct, count_error;

    // define clock
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // General stimuli 
    initial begin
        ALU_obj = new();
        reset = 0;
        A = 0;
        B = 0;

        assert_reset;

        repeat(100) begin
            assert(ALU_obj.randomize());
            reset = ALU_obj.reset;
            A = ALU_obj.A;
            B = ALU_obj.B;
            opcode = ALU_obj.Opcode;
            check_result(ALU_obj);
        end   

        $display("Total Correct: %d, Total Error: %d", count_correct, count_error);
        $stop;
    end


    // assert reset
    task assert_reset;
        reset = 1'b1;
        check_reset;
        reset = 1'b0;
    endtask

    task check_reset;
        @(negedge clk) 
        if (C == 0) begin
            count_correct += 1;
            $display("Reset Asserted");    
        end else begin
            count_error += 1;
            $display("Reset Failed");    
        end
    endtask

    task check_result(ALU_transaction ALU_obj2);
        golden_model(ALU_obj2);
         @(negedge clk);
        if (C_exp !== C) begin
            count_error += 1;            
            $display("%t: A = %d, B = %d, Opcode = %b, expected = %d, Actual = %d", $time, ALU_obj2.A, ALU_obj2.B, ALU_obj2.Opcode, C_exp, C);
        end
        else begin
            count_correct += 1;
            $display("%t: Result Correct for A = %d, B = %d, Opcode = %b, expected = %d, Actual = %d", $time, ALU_obj2.A, ALU_obj2.B, ALU_obj2.Opcode, C_exp, C );
        end

    endtask

    task golden_model(ALU_transaction ALU_obj1);
        if (ALU_obj1.reset) begin
            C_exp = 0;
        end else begin
        case (ALU_obj1.Opcode)
            Add: C_exp = ALU_obj1.A + ALU_obj1.B;
            Sub: C_exp = ALU_obj1.A - ALU_obj1.B;
            Not_A: C_exp = ~ALU_obj1.A;
            ReductionOR_B: C_exp = |ALU_obj1.B;
            default: C_exp = 0;
        endcase
        end
    endtask

endmodule