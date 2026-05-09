import ALSU_enum::*;
import ALSU_pkg::*;

module ALSU_tb(ALSU_if.TEST ALSU_vif);

    ALSU_txn ALSU_transaction = new;

    parameter INPUT_PRIORITY = "A";
    parameter FULL_ADDER = "ON";

    bit cin_reg, red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
    bit [2:0] opcode_reg;
    bit signed [2:0] A_reg, B_reg;

    bit [15:0] leds_exp;
    bit signed [5:0] out_exp;

    int correct_count = 0;
    int error_count = 0;

    initial begin

        initialize();
        repeat(2) @(negedge ALSU_vif.clk);
        assert_reset();

        repeat(20000) begin
            assert(ALSU_transaction.randomize());
            @(negedge ALSU_vif.clk);
            ALSU_vif.rst = ALSU_transaction.rst;
            ALSU_vif.red_op_A = ALSU_transaction.red_op_A;
            ALSU_vif.red_op_B = ALSU_transaction.red_op_B;
            ALSU_vif.bypass_A = ALSU_transaction.bypass_A;
            ALSU_vif.bypass_B = ALSU_transaction.bypass_B;
            ALSU_vif.direction = ALSU_transaction.direction;
            ALSU_vif.serial_in = ALSU_transaction.serial_in;
            ALSU_vif.cin = ALSU_transaction.cin;
            ALSU_vif.opcode = ALSU_transaction.opcode;
            ALSU_vif.A = ALSU_transaction.A;
            ALSU_vif.B = ALSU_transaction.B; 
            @(posedge ALSU_vif.clk);
            #1;
            check_result(ALSU_transaction);
            ALSU_transaction.AB_cvg.sample();
        end

        $display("error count = %0d",error_count);
        $display("correct count = %0d",correct_count);

        $stop;
    end

    task initialize;
        ALSU_vif.rst = 0;
        ALSU_vif.red_op_A = 0;
        ALSU_vif.red_op_B = 0;
        ALSU_vif.bypass_A = 0;
        ALSU_vif.bypass_B = 0;
        ALSU_vif.direction = 0;
        ALSU_vif.serial_in = 0;
        ALSU_vif.cin = 0;
        ALSU_vif.opcode = 0;
        ALSU_vif.A = 0;
        ALSU_vif.B = 0;
    endtask

    task assert_reset;
            ALSU_vif.rst = 1;
            @(negedge ALSU_vif.clk);
            reset_internals();
            ALSU_vif.rst = 0;
    endtask

    task reset_internals;
        {red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg} = 6'b00_0000; 
        cin_reg = 1'b0;
        opcode_reg = 3'b000;
        {A_reg, B_reg} = 6'b000_000;   
        out_exp = 6'b0;
        leds_exp = 16'b0;
    endtask

    function bit isinvalid();
        bit invalid;
        if((opcode_reg == INVALID_6) || (opcode_reg == INVALID_7))
            invalid = 1;
        else if((opcode_reg > 3'b001) && (red_op_A_reg || red_op_B_reg))
            invalid = 1;
        else
            invalid = 0;
        return invalid;
    endfunction

    task update_internals(ALSU_txn ALSU_trans);

        red_op_A_reg = ALSU_trans.red_op_A;
        red_op_B_reg = ALSU_trans.red_op_B;
        bypass_A_reg = ALSU_trans.bypass_A;
        bypass_B_reg = ALSU_trans.bypass_B;
        direction_reg = ALSU_trans.direction;
        serial_in_reg = ALSU_trans.serial_in;
        cin_reg = ALSU_trans.cin;
        opcode_reg = ALSU_trans.opcode;
        A_reg = ALSU_trans.A;
        B_reg = ALSU_trans.B; 

    endtask

    task check_result(ALSU_txn ALSU_trans);
        golden_model(ALSU_trans);
        if ((ALSU_vif.out != out_exp) || (ALSU_vif.leds != leds_exp)) begin
            error_count++;
            $display("%t: ERROR--> A = %0d B = %0d opcode = %0d red_op_A = %0d, red_op_B = %0d bypass_A_reg = %0d, bypass_B_reg = %0d direction_reg = %0d serial_in_reg = %0d",
                     $time, ALSU_trans.A, ALSU_trans.B, ALSU_trans.opcode, ALSU_trans.red_op_A, ALSU_trans.red_op_B, ALSU_trans.bypass_A, ALSU_trans.bypass_B,
                     ALSU_trans.direction, ALSU_trans.serial_in);
            $display("out = %0d,out_exp = %0d, leds = %0d, leds_exp = %0d",
                     ALSU_vif.out, out_exp, ALSU_vif.leds, leds_exp);   
        end else begin
            correct_count++;
            $display("%t: SUCCESS--> A = %0d B = %0d opcode = %0d  red_op_A = %0d, red_op_B = %0d bypass_A_reg = %0d, bypass_B_reg = %0d direction_reg = %0d serial_in_reg = %0d",
                     $time, ALSU_trans.A, ALSU_trans.B, ALSU_trans.opcode, ALSU_trans.red_op_A, ALSU_trans.red_op_B, ALSU_trans.bypass_A, ALSU_trans.bypass_B,
                     ALSU_trans.direction, ALSU_trans.serial_in);
            $display("out = %0d,out_exp = %0d, leds = %0d, leds_exp = %0d",
                     ALSU_vif.out, out_exp, ALSU_vif.leds, leds_exp); 
        end
    endtask


    task golden_model(ALSU_txn ALSU_trans);

        if(ALSU_trans.rst) begin
            reset_internals(); 
            return;
        end 
        else begin

            if(isinvalid()) begin
                leds_exp = ~leds_exp;    
            end else begin
                leds_exp = 0;    
            end

            if (bypass_A_reg && bypass_B_reg)
                out_exp = (INPUT_PRIORITY == "A")? A_reg: B_reg;
            else if (bypass_A_reg)
                out_exp = A_reg;
            else if (bypass_B_reg)
                out_exp = B_reg;
            else if (isinvalid()) 
                out_exp = 0;

            else begin
                case (opcode_reg)
                    OR: begin 
                        if (red_op_A_reg && red_op_B_reg)
                            out_exp = (INPUT_PRIORITY == "A")? |A_reg: |B_reg;
                        else if (red_op_A_reg) 
                            out_exp = |A_reg;
                        else if (red_op_B_reg)
                            out_exp = |B_reg;
                        else 
                            out_exp = A_reg | B_reg;
                    end
                    XOR: begin
                        if (red_op_A_reg && red_op_B_reg)
                        out_exp = (INPUT_PRIORITY == "A")? ^A_reg: ^B_reg;
                        else if (red_op_A_reg) 
                        out_exp = ^A_reg;
                        else if (red_op_B_reg)
                        out_exp = ^B_reg;
                        else 
                        out_exp = A_reg ^ B_reg;
                    end
                ADD : begin
                    if (FULL_ADDER == "ON") begin
                        out_exp = A_reg + B_reg + cin_reg;
                    end else begin
                        out_exp = A_reg + B_reg;
                    end
                end
            MULT : out_exp = A_reg * B_reg;
            SHIFT : begin
                if (direction_reg)
                out_exp = {out_exp [4:0], serial_in_reg};
                else
                out_exp = {serial_in_reg, out_exp [5:1]};
            end
            ROTATE : begin
                if (direction_reg)
                out_exp = {out_exp [4:0], out_exp [5]};
                else
                out_exp = {out_exp [0], out_exp [5:1]};
            end
            default: out_exp = 0;
            endcase
            end
        end
        update_internals(ALSU_trans);
    endtask

endmodule