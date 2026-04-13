import testing_pkg::*;

module alu_tb();

    transaction alu_obj;

    // Declare local input and outputs 
    byte operand1, operand2;
    bit clk, rst;
    opcode_e opcode;
    byte out;
    byte out_exp;

    int correct_count, error_count;

    // instantiate the ALU
    alu_seq uut (
        operand1, 
        operand2, 
        clk, 
        rst, 
        opcode, 
        out);

    // Clock generation
    initial begin   
        clk = 0;
        forever begin
            #5 clk = ~clk; // 10 time units period
            alu_obj.clk = clk; // Update transaction clock
        end
    end

    // Test stimulus
    initial begin
        // initialization
        alu_obj = new();
        rst = 0;
        operand1 = 0;
        operand2 = 0;
        opcode = ADD;
        correct_count = 0;
        error_count = 0;

        #2;
        assert_reset();
        #2;
        assert_reset(); // Call reset twice to ensure it works consistently

        repeat(50) begin
            assert(alu_obj.randomize());
            rst = alu_obj.rst;
            operand1 = alu_obj.operand1;
            operand2 = alu_obj.operand2;
            opcode = alu_obj.opcode;
            check_result(alu_obj);
        end
        $display("correct_count =  %0d error_count = %0d", correct_count, error_count);
        $stop;
    end

    task assert_reset();
        rst = 1'b1;
        @(negedge clk);
        if (out !== 0) begin
            $display("%t: Reset failed: out = %0d, expected 0",$time, out);
            error_count++;
        end else begin
            correct_count++;
            $display("%t: Reset succeed: out = %0d",$time, out);
        end
        rst = 1'b0;
    endtask


    task check_result(transaction alu_obj2);
        golden_model(alu_obj2);
        @(negedge clk);
        if (out == out_exp) begin
            correct_count++;
            $display("%t: out = %0d, expected = %0d",$time, out, out_exp);    
        end else begin
            error_count++;
            $display("%t: out = %0d, expected = %0d",$time, out, out_exp);        
        end
    endtask


    task golden_model(transaction alu_obj1);
        if(alu_obj1.rst) begin
            out_exp = 0;    
        end else begin
            case (alu_obj1.opcode)
			ADD: out_exp = alu_obj1.operand1 + alu_obj1.operand2;
			SUB: out_exp = alu_obj1.operand1 - alu_obj1.operand2;
			MULT:out_exp = alu_obj1.operand1 * alu_obj1.operand2; 
			DIV: out_exp = (alu_obj1.operand2 != 0) ? alu_obj1.operand1 / alu_obj1.operand2 : 0;
			default: out_exp <= 0;
		endcase
        end
    endtask

endmodule