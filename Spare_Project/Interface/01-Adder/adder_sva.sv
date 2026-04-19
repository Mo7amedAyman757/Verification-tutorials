module adder_sva(adder_if.DUT A_if);

    property reset_behavior;
        @(posedge A_if.clk)
        A_if.reset |=> (A_if.C == 0);
    endproperty

    a_reset_assertion: assert property (reset_behavior);

    a_reset_cover: cover property (reset_behavior);

    property addition;
        @(posedge A_if.clk) disable iff(A_if.reset) 1'b1 |=> (A_if.C == $past(A_if.A) + $past(A_if.B));
    endproperty

    a_addition_assertion: assert property (addition);

    a_addition_cover: cover property (addition);


endmodule