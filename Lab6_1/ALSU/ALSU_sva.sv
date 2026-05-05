import ALSU_pkg::*;

module ALSU_sva(ALSU_if vif);

    reg invalid_red_op, invalid_opcode, invalid;

    assign invalid_red_op = (vif.red_op_A | vif.red_op_B) & (vif.opcode[1] | vif.opcode[2]);
    assign invalid_opcode = vif.opcode[1] & vif.opcode[2];
    assign invalid = invalid_red_op | invalid_opcode;

    property reset_check;
        @(posedge vif.clk)  vif.rst |=> (vif.leds == 0 && vif.out == 0);
    endproperty
    assert_reset: assert property(reset_check);
    cover_reset: cover property(reset_check);

    property invalid_leds_out;
        @(posedge vif.clk) disable iff (vif.rst) 
        (invalid) 
        |=>##1 (vif.leds == ~$past(vif.leds));
    endproperty

    assert_invalid_led: assert property(invalid_leds_out) else $display("Invalid input combination not detected at time %0t: red_op_A = %0b, red_op_B = %0b, opcode = %0b", $time, vif.red_op_A, vif.red_op_B, vif.opcode);
    cover_invalid_led: cover property(invalid_leds_out);

    property invalid_out;
        @(posedge vif.clk) disable iff (vif.rst) 
        ( ( ((vif.red_op_A) | (vif.red_op_B)) & ((vif.opcode[1]) | (vif.opcode[2])) )
          | ((vif.opcode[1]) & (vif.opcode[2])) & !(vif.bypass_A & vif.bypass_B)) 
        |=> (vif.out == 0);
    endproperty

    assert_invalid_out: assert property(invalid_out) else $display("Invalid input combination not detected at time %0t: red_op_A = %0b, red_op_B = %0b, opcode = %0b", $time, vif.red_op_A, vif.red_op_B, vif.opcode);
    cover_invalid_out: cover property(invalid_out);

    property add_check;
        @(posedge vif.clk) disable iff (vif.rst) 
        (!invalid && $past(vif.opcode) == ADD)
        |=> (vif.out == $past(vif.A) + $past(vif.B));
    endproperty

    assert property (add_check);

endmodule