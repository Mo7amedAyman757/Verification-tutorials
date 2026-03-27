import ALU_pkg::*;

module ALU_tb;

    // Declare local wire and reg
    reg clk_tb;
    reg reset_tb;
    reg [1:0] opcode_tb;
    reg signed [3:0] A_tb;
    reg signed [3:0] B_tb;
    wire signed [4:0] C_tb;

    bit signed [4:0] expected_result;
    // Instantiate the module under test
    ALU_4_bit uut(
        clk_tb,
        reset_tb,
        opcode_tb,
        A_tb,
        B_tb,
        C_tb
    );

    // define local parameter for tracking the functionality
    integer  count_correct, count_error;

   initial begin
    clk_tb = 1'b0;
    forever #5 clk_tb = ~clk_tb;
   end

    // create object of class
    ALU_cls ALU_obj = new();

    // golden model
    task golden_model (input ALU_cls ALU_obj1);
        if(ALU_obj1.reset) begin
            expected_result = 5'b0;    
        end else begin
            case (ALU_obj1.opcode)
                ADD:            expected_result = A_tb + B_tb;
                SUB:            expected_result = A_tb - B_tb;
                NOT_A:          expected_result = ~A_tb;
                ReductionOR_B:  expected_result = |B_tb;
                default:  expected_result = 5'b0;
            endcase
        end

    endtask

    // define task for checking
    task checking(input signed [4:0] expected_result);
        @(negedge clk_tb);
        if (expected_result !== C_tb) begin
            count_error += 1;            
            $display("A = %d, B = %d, expected = %d, Actual = %d",A_tb,B_tb,expected_result,C_tb);
        end
        else begin
            count_correct += 1;
        end
    endtask

    // define task for reset functionality
    task assert_reset;
        reset_tb = 1'b1;
        checking(0);
        reset_tb = 1'b0;
    endtask

    initial begin

        count_correct = 0;
        count_error = 0;    
        reset_tb = 1'b0;
        #17;

        assert_reset;
        repeat(100) begin
            ALU_obj.randomize();
            reset_tb = ALU_obj.reset;
            A_tb = ALU_obj.A;
            B_tb = ALU_obj.B;
            opcode_tb = ALU_obj.opcode;
            golden_model(ALU_obj);
            checking(expected_result);
        end
        $display("Total correct cases = %d", count_correct);
        $display("Total error cases = %d", count_error);
        $stop;
    end
endmodule
