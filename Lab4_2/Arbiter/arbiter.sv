module arbiter();

    logic request, grant, clk;
    logic frame, irdy;

    // Upon rising of the signal “request” by a master, the arbiter should raise the “grant” within 2 to 5
    // clock cycles.
    property SVA_1;
        @(posedge clk) $rose(request) |-> ##[2:5] grant;
    endproperty

    assert property(SVA_1);

    // Once the “grant” is raised, the master should acknowledge acceptance in the same clock cycle
    // by lowering the "frame" and "irdy" signals after they were high in the previous cycle.
    property SVA_2;
        @(posedge clk) $rose(grant) |-> $fell(frame) && $fell(irdy);
    endproperty

    assert property(SVA_2);

    // Once the master completes the transaction it raises the "frame" and "irdy" signals, followed by
    // that, the arbiter should lower the "grant" signal on the next clock cycle after it was high.
    property SVA_3;
        @(posedge clk) ($rose(frame) && $rose(irdy)) |=> $fell(grant);
    endproperty

    assert property(SVA_3);

endmodule