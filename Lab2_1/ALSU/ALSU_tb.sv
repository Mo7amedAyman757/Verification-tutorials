import ALSU_pkg::*;

module ALSU_tb;

    // 1- declare parameter, classes, local wire and reg

    parameter INPUT_PRIORITY = "A";
    parameter FULL_ADDER = "ON";
    bit clk, cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
    bit signed [2:0] A, B;
    opcode_t opcode;
    logic [15:0] leds;
    bit [15:0] leds_exp;
    logic signed [5:0] out;
    bit signed [5:0] out_exp;

    // Internals to register the stimulus for golden model
    bit red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
    bit signed [1:0] cin_reg;
    bit [2:0] opcode_reg;
    bit signed [2:0] A_reg, B_reg;


    int error_count = 0;
    int correct_count = 0;
    
        
    ALSU_cst ALSU_obj = new(); 

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
        
        repeat(1000) begin
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
            if(ALSU_obj.rst) begin
                check_reset();
                reset_internals();
            end else begin
                golden_model();
                check_result();
            end
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
            reset_internals();
        end
    endtask

    task reset_internals();
        {red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg} = 6'b00_0000;
        cin_reg = 2'b00;
        opcode_reg = 3'b000;
        {A_reg,B_reg} = 2'b00;
    endtask

    // function to check validation
    function bit is_invalid();
        bit invalid;
        if((red_op_A_reg || red_op_B_reg) && (opcode_reg > 3'b001))
            invalid = 1'b1;
        else if (opcode_reg == INVALID6 || opcode_reg == INVALID7) 
            invalid = 1'b1;
        else 
            invalid = 1'b0;
        return invalid;
    endfunction

    // Task to implement the golden model and check results
    task golden_model ();
        if (is_invalid()) begin
            leds_exp = ~leds_exp;
        end
        else begin
            leds_exp = 0;
        end

        if(bypass_A_reg) 
            out_exp = A_reg;
        else if(bypass_B_reg)
            out_exp = B_reg;

        else if(is_invalid())
            out_exp = 0;

        else begin
            if(opcode_reg == OR) begin
                if(red_op_A_reg) 
                    out_exp = |A_reg;
                else if (red_op_B_reg)
                    out_exp = |B_reg;
                else
                    out_exp = A_reg | B_reg;     
            end

            else if(opcode_reg == XOR) begin
                if(red_op_A_reg) 
                    out_exp = ^A_reg;
                else if (red_op_B_reg)
                    out_exp = ^B_reg;    
                else
                    out_exp = A_reg ^ B_reg;   
            end

            else if(opcode_reg == ADD) 
                out_exp = A_reg + B_reg + cin_reg;
            
            else if(opcode_reg == MULT)
                out_exp = A_reg * B_reg;

            else if (opcode_reg == SHIFT) begin
                if(direction_reg) 
                    out_exp = {out_exp[4:0], serial_in_reg};
                else
                    out_exp = {serial_in_reg, out_exp[5:1]};
            end

            else if (opcode_reg == ROTATE) begin
                if(direction_reg) 
                    out_exp = {out_exp[4:0], out_exp[5]};
                else
                    out_exp = {out_exp[0], out_exp[5:1]};
            end
        end
        update_internals();

    endtask

    task update_internals();
        cin_reg = cin;
        red_op_A_reg = red_op_A;
        red_op_B_reg = red_op_B;
        bypass_A_reg = bypass_A;
        bypass_B_reg = bypass_B;
        direction_reg = direction;
        serial_in_reg = serial_in;
        opcode_reg = opcode;
        A_reg = A;
        B_reg = B;
    endtask

    // Task to check results against the golden model
    task check_result();
        @(negedge clk);
        if ((out_exp !== out) || (leds_exp !== leds)) begin
            error_count += 1;
            $display("%t: ERROR--> A = %0d B = %0d opcode = %s, red_op_A = %0d, red_op_B = %0d bypass_A_reg = %0d, bypass_B_reg = %0d direction_reg = %0d serial_in_reg = %0d",
                     $time,ALSU_obj.A, ALSU_obj.B, ALSU_obj.opcode, ALSU_obj.red_op_A, ALSU_obj.red_op_B, ALSU_obj.bypass_A, ALSU_obj.bypass_B,
                     ALSU_obj.direction, ALSU_obj.serial_in);
            $display("out = %0d,out_exp = %0d, leds = %0d, leds_exp = %0d",
                     out, out_exp, leds, leds_exp);     

        end
        else begin
            correct_count += 1;   
            $display("%t: SUCCESS--> A = %0d B = %0d opcode = %s, red_op_A = %0d, red_op_B = %0d bypass_A_reg = %0d, bypass_B_reg = %0d direction_reg = %0d serial_in_reg = %0d",
                     $time, ALSU_obj.A, ALSU_obj.B, ALSU_obj.opcode, ALSU_obj.red_op_A, ALSU_obj.red_op_B, ALSU_obj.bypass_A, ALSU_obj.bypass_B,
                     ALSU_obj.direction, ALSU_obj.serial_in);
            $display("out = %0d,out_exp = %0d, leds = %0d, leds_exp = %0d",
                     out, out_exp, leds, leds_exp); 
        end
    endtask
    


endmodule
