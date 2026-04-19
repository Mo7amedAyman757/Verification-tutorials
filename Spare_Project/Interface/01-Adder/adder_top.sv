module adder_top();

    // 1. Generate the clock
    bit clk;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // 2. instantiate the interface, and pass the clock
    adder_if A_if(clk);

    // 3. instantiate the tb, DUT, monitor, and pass the interface
    adder dut(A_if);

    adder_monitor monitor(A_if);

    adder_tb tb(A_if);
    // 4. bind the SVA module to the design, and pass the interface
    bind adder adder_sva adder_sva_inst(A_if);

endmodule