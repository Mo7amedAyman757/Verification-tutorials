import ALSU_enum::*;
import ALSU_pkg::*;

module ALSU_sva(ALSU_if.DUT ALSU_vif);

    bit invalid;

    assign invalid =
                (
                    ((ALSU_vif.opcode inside {ADD,MULT,SHIFT,ROTATE}) &&
                    (ALSU_vif.red_op_A || ALSU_vif.red_op_B))
                    ||
                    (ALSU_vif.opcode inside {INVALID_6, INVALID_7})
                );

    property reset_check;
        @(posedge ALSU_vif.clk)
        (ALSU_vif.rst) |=> (ALSU_vif.leds == 0 && ALSU_vif.out == 0);
    endproperty   

    assert property(reset_check);
    cover property(reset_check);    

    property invalid_led_check;
        @(posedge ALSU_vif.clk) disable iff (ALSU_vif.rst)
        (invalid) 
        |=> ##1 (ALSU_vif.leds == ~$past(ALSU_vif.leds));
    endproperty        

    assert property(invalid_led_check);
    cover property(invalid_led_check); 

    property invalid_out_check;
        @(posedge ALSU_vif.clk) disable iff (ALSU_vif.rst)
        (invalid && (!ALSU_vif.bypass_A && !ALSU_vif.bypass_B))
        |=> ##1 (ALSU_vif.out == 0);
    endproperty        

    assert property(invalid_out_check);
    cover property(invalid_out_check); 

    property opcode_add_check;
        @(posedge ALSU_vif.clk) disable iff (ALSU_vif.rst)
        (ALSU_vif.opcode == ADD && ALSU_vif.FULL_ADDER == "ON" && !ALSU_vif.red_op_A && !ALSU_vif.red_op_B && !ALSU_vif.bypass_A && !ALSU_vif.bypass_B)
        |=> ##1 (ALSU_vif.out == $past(ALSU_vif.A,2) + $past(ALSU_vif.B,2) + $past(ALSU_vif.cin,2));
    endproperty        

    assert property(opcode_add_check);
    cover property(opcode_add_check); 

    property opcode_mult_check;
        @(posedge ALSU_vif.clk) disable iff (ALSU_vif.rst)
        (ALSU_vif.opcode == MULT  && !ALSU_vif.red_op_A && !ALSU_vif.red_op_B && !ALSU_vif.bypass_A && !ALSU_vif.bypass_B)
        |=> ##1 (ALSU_vif.out == $past(ALSU_vif.A,2) * $past(ALSU_vif.B,2));
    endproperty        

    assert property(opcode_mult_check);
    cover property(opcode_mult_check); 

    property bypass_A_only_check;
        @(posedge ALSU_vif.clk) disable iff (ALSU_vif.rst)
        (ALSU_vif.bypass_A && !ALSU_vif.bypass_B)
        |=> ##1 (ALSU_vif.out == $past(ALSU_vif.A,2));
    endproperty

    assert property(bypass_A_only_check);
    cover property(bypass_A_only_check); 


    property bypass_both_A_priority_check;
        @(posedge ALSU_vif.clk) disable iff (ALSU_vif.rst)
        (ALSU_vif.INPUT_PRIORITY == "A" && ALSU_vif.bypass_A && ALSU_vif.bypass_B)
        |=> ##1 (ALSU_vif.out == $past(ALSU_vif.A,2));
    endproperty        

    assert property(bypass_both_A_priority_check);
    cover property(bypass_both_A_priority_check); 

    property bypass_B_only_check;
        @(posedge ALSU_vif.clk) disable iff (ALSU_vif.rst)
        (!ALSU_vif.bypass_A && ALSU_vif.bypass_B)
        |=> ##1 (ALSU_vif.out == $past(ALSU_vif.B,2));
    endproperty        

    assert property(bypass_B_only_check);
    cover property(bypass_B_only_check); 
    

    property red_op_or_both_check;
        @(posedge ALSU_vif.clk) disable iff (ALSU_vif.rst)
        (ALSU_vif.opcode == OR && ALSU_vif.INPUT_PRIORITY == "A" && ALSU_vif.red_op_A && ALSU_vif.red_op_B && !ALSU_vif.bypass_A && !ALSU_vif.bypass_B)
        |=> ##1 (ALSU_vif.out == |$past(ALSU_vif.A,2));
    endproperty        

    assert property(red_op_or_both_check);
    cover property(red_op_or_both_check); 

    property red_op_or_A_check;
        @(posedge ALSU_vif.clk) disable iff (ALSU_vif.rst)
        (ALSU_vif.opcode == OR  && ALSU_vif.red_op_A && !ALSU_vif.red_op_B && !ALSU_vif.bypass_A && !ALSU_vif.bypass_B)
        |=> ##1 (ALSU_vif.out == |$past(ALSU_vif.A,2));
    endproperty        

    assert property(red_op_or_A_check);
    cover property(red_op_or_A_check); 

    property red_op_or_B_check;
        @(posedge ALSU_vif.clk) disable iff (ALSU_vif.rst)
        (ALSU_vif.opcode == OR && !ALSU_vif.red_op_A && ALSU_vif.red_op_B && !ALSU_vif.bypass_A && !ALSU_vif.bypass_B)
        |=> ##1 (ALSU_vif.out == |$past(ALSU_vif.B,2));
    endproperty        

    assert property(red_op_or_B_check);
    cover property(red_op_or_B_check); 

    property red_op_or_check;
        @(posedge ALSU_vif.clk) disable iff (ALSU_vif.rst)
        (ALSU_vif.opcode == OR && !ALSU_vif.red_op_A && !ALSU_vif.red_op_B && !ALSU_vif.bypass_A && !ALSU_vif.bypass_B)
        |=> ##1 (ALSU_vif.out == $past(ALSU_vif.A,2) | $past(ALSU_vif.B,2));
    endproperty        

    assert property(red_op_or_check);
    cover property(red_op_or_check); 

    
    property red_op_xor_A_check;
        @(posedge ALSU_vif.clk) disable iff (ALSU_vif.rst)
        (ALSU_vif.opcode == XOR && ALSU_vif.INPUT_PRIORITY == "A" && ALSU_vif.red_op_A && !ALSU_vif.bypass_A && !ALSU_vif.bypass_B)
        |=> ##1 (ALSU_vif.out == ^$past(ALSU_vif.A,2));
    endproperty        

    assert property(red_op_xor_A_check);
    cover property(red_op_xor_A_check); 

    property red_op_xor_B_check;
        @(posedge ALSU_vif.clk) disable iff (ALSU_vif.rst)
        (ALSU_vif.opcode == XOR && !ALSU_vif.red_op_A && ALSU_vif.red_op_B && !ALSU_vif.bypass_A && !ALSU_vif.bypass_B)
        |=> ##1 (ALSU_vif.out == ^$past(ALSU_vif.B,2));
    endproperty        

    assert property(red_op_xor_B_check);
    cover property(red_op_xor_B_check); 

        property red_op_xor_check;
        @(posedge ALSU_vif.clk) disable iff (ALSU_vif.rst)
        (ALSU_vif.opcode == XOR && !ALSU_vif.red_op_A && !ALSU_vif.red_op_B && !ALSU_vif.bypass_A && !ALSU_vif.bypass_B)
        |=> ##1 (ALSU_vif.out == $past(ALSU_vif.A,2) ^ $past(ALSU_vif.B,2));
    endproperty        

    assert property(red_op_xor_check);
    cover property(red_op_xor_check);

    
    property opcode_shift_left_check;
        @(posedge ALSU_vif.clk) disable iff (ALSU_vif.rst)
        (ALSU_vif.opcode == SHIFT  && ALSU_vif.direction && !ALSU_vif.bypass_A && !ALSU_vif.bypass_B && !ALSU_vif.red_op_A && !ALSU_vif.red_op_B)
        |=> ##1 (ALSU_vif.out == {$past(ALSU_vif.out[4:0],1), $past(ALSU_vif.serial_in,2)});
    endproperty        

    assert property(opcode_shift_left_check);
    cover property(opcode_shift_left_check);

    property opcode_shift_right_check;
        @(posedge ALSU_vif.clk) disable iff (ALSU_vif.rst)
        (ALSU_vif.opcode == SHIFT  && !ALSU_vif.direction && !ALSU_vif.bypass_A && !ALSU_vif.bypass_B && !ALSU_vif.red_op_A && !ALSU_vif.red_op_B)
        |=> ##1 (ALSU_vif.out =={$past(ALSU_vif.serial_in,2), $past(ALSU_vif.out[5:1],1)});
    endproperty        

    assert property(opcode_shift_right_check);
    cover property(opcode_shift_right_check);

    property opcode_rotate_left_check;
        @(posedge ALSU_vif.clk) disable iff (ALSU_vif.rst)
        
        (ALSU_vif.opcode == ROTATE  && ALSU_vif.direction && !ALSU_vif.bypass_A && !ALSU_vif.bypass_B && !ALSU_vif.red_op_A && !ALSU_vif.red_op_B)
        |=> ##1 (ALSU_vif.out =={$past(ALSU_vif.out[4:0],1), $past(ALSU_vif.out[5],1)});
    endproperty        

    assert property(opcode_rotate_left_check);
    cover property(opcode_rotate_left_check);

    property opcode_rotate_right_check;
        @(posedge ALSU_vif.clk) disable iff (ALSU_vif.rst)
        (ALSU_vif.opcode == ROTATE  && !ALSU_vif.direction && !ALSU_vif.bypass_A && !ALSU_vif.bypass_B && !ALSU_vif.red_op_A && !ALSU_vif.red_op_B)
        |=> ##1 (ALSU_vif.out =={$past(ALSU_vif.out[0],1), $past(ALSU_vif.out[5:1],1)});
    endproperty        

    assert property(opcode_rotate_right_check);
    cover property(opcode_rotate_right_check);

endmodule