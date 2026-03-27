import ALSU_pkg::*;

module ALSU_tb;

    // 1- declare parameter, classes, local wire and reg
    ALSU_cst ALSU_obj = new(); 

    parameter INPUT_PRIORITY = "A";
    parameter FULL_ADDER = "ON";
    bit clk, cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
    opcode_t opcode;
    bit  signed [2:0] A, B;
    logic [15:0] leds;
    bit [15:0] leds_exp;
    logic signed [5:0] out;
    bit signed [5:0] out_exp;
    bit signed [5:0] prev_out_exp;

    int error_count = 0;
    int correct_count = 0;

    // 2- Instantiate the module under test
        ALSU #(.INPUT_PRIORITY(INPUT_PRIORITY), .FULL_ADDER(FULL_ADDER)) uut(
        .clk(clk),
        .cin(cin),
        .rst(rst),
        .red_op_A(red_op_A),
        .red_op_B(red_op_B),
        .bypass_A(bypass_A),
        .bypass_B(bypass_B),
        .direction(direction),
        .serial_in(serial_in),
        .opcode(opcode),
        .A(A),
        .B(B),
        .leds(leds),
        .out(out)
    );

    // 3- Generate the clock
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // 4- General stimuli
    initial begin
        #5;
        // assert reset 
        assert_reset;
        
        repeat(10000) begin
            assert(ALSU_obj.randomize());
            cin = ALSU_obj.cin;
            rst = ALSU_obj.rst;
            red_op_A = ALSU_obj.red_op_A;
            red_op_B = ALSU_obj.red_op_B;   
            bypass_A = ALSU_obj.bypass_A;
            bypass_B = ALSU_obj.bypass_B;
            direction = ALSU_obj.direction;
            serial_in = ALSU_obj.serial_in;
            opcode = ALSU_obj.opcode;
            A = ALSU_obj.A;
            B = ALSU_obj.B;

            check_result(ALSU_obj);
        end

        $display("Total Correct: %0d, Total Errors: %0d", correct_count, error_count);
        $stop;
    end

    // Task to assert reset 
    task assert_reset;
        rst = 1'b1;
        @(negedge clk);
        check_reset;
        rst = 1'b0;
    endtask

    // Task to check reset behavior
    task check_reset;
        @(negedge clk);
        if ((leds !== 0) || (out !== 0)) begin
            error_count += 1;
            $display("%t: ERROR for asserting reset--> leds = %0d, out = %0d",
                    $time, leds, out);   
        end else begin
            correct_count += 1;
            $display("%t: SUCCESS for asserting reset--> leds = %0d, out = %0d",
                    $time, leds, out);
        end
    endtask

    // function to check validation
    function bit is_invalid(input ALSU_cst ALSU_obj1);
        bit valid;
        if((ALSU_obj1.red_op_A || ALSU_obj1.red_op_B) && (ALSU_obj1.opcode[1] | ALSU_obj1.opcode[2]))
            valid = 1'b1;
        else if (ALSU_obj1.opcode[1] & ALSU_obj1.opcode[2]) 
            valid = 1'b1;
        else 
            valid = 1'b0;
        return valid;
    endfunction

    // Task to implement the golden model and check results
    task golden_model (input ALSU_cst ALSU_obj2);
        if (ALSU_obj2.rst == 1'b1) begin
            leds_exp = 0;
            out_exp = 0;  
            prev_out_exp = 0;  
        end else begin
            if (is_invalid(ALSU_obj2)) begin
                leds_exp = 16'hFFFF;
            end
            else begin
                leds_exp = 0;
            end
        end

        if (ALSU_obj2.bypass_A && ALSU_obj2.bypass_B)
             out_exp = (INPUT_PRIORITY == "A")? A: B;
        else if (ALSU_obj2.bypass_A)
            out_exp = A;
        else if (ALSU_obj2.bypass_B)
            out_exp = B;
        else if (is_invalid(ALSU_obj2)) 
            out_exp = 0;
        else begin
            case (ALSU_obj2.opcode)
            OR: begin 
                if (ALSU_obj2.red_op_A && ALSU_obj2.red_op_B)
                out_exp = (INPUT_PRIORITY == "A")? |A: |B;
                else if (ALSU_obj2.red_op_A) 
                out_exp = |A;
                else if (ALSU_obj2.red_op_B)
                out_exp = |B;
                else 
                out_exp = A | B;
            end
            XOR: begin
                if (ALSU_obj2.red_op_A && ALSU_obj2.red_op_B)
                out_exp = (INPUT_PRIORITY == "A")? ^A: ^B;
                else if (ALSU_obj2.red_op_A) 
                out_exp = ^A;
                else if (ALSU_obj2.red_op_B)
                out_exp = ^B;
                else 
                out_exp = A ^ B;
            end
            ADD: begin
                if (FULL_ADDER == "ON") begin
                out_exp = A + B + cin;
                end else begin
                out_exp = A + B;
                end
            end
            MULT: out_exp = A * B;
            SHIFT: begin
                if (ALSU_obj2.direction)
                out_exp = {prev_out_exp[4:0], ALSU_obj2.serial_in};
                else
                out_exp = {ALSU_obj2.serial_in, prev_out_exp[5:1]};
            end
            ROTATE: begin
                if (ALSU_obj2.direction)
                out_exp = {prev_out_exp[4:0], prev_out_exp[5]};
                else
                out_exp = {prev_out_exp[0], prev_out_exp[5:1]};
            end
            default: out_exp = 0;
            endcase
        end 
        prev_out_exp = out_exp; // Update prev_out_exp for the next cycle
    endtask

    // Task to check results against the golden model
    task check_result(input ALSU_cst ALSU_obj3);
        golden_model(ALSU_obj3);
        if(!ALSU_obj3.rst) begin
            @(negedge clk);
            if ((out_exp !== out) || (leds_exp !== leds)) begin
            error_count += 1;
            $display("%t: ERROR--> out = %0d,out_exp = %0d, leds = %0d, leds_exp = %0d",
                     $time,out, out_exp, leds, leds_exp);     
            end
            else begin
                correct_count += 1;   
                $display("%t: SUCCESS--> out = %0d,out_exp = %0d, leds = %0d, leds_exp = %0d",
                         $time,out, out_exp, leds, leds_exp);  
            end
        end else begin
            check_reset;    
        end
    endtask
    

endmodule
