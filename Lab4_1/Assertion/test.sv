module test();

    logic a, b, c;
    logic clk;
    logic [7:0] Y;
    logic [3:0] D;
    logic valid;

    // Write assert property statement, if signal a is high in a positive edge of a clock then signal b
    // should be high after 2 clock cycles 
    property ab_high;
        @(posedge clk) $rose(a) |-> ##2 b;
    endproperty
    // Write assert property statement, If signal a is high and signal b is high then signal c should be
    // high 1 to 3 clock cycle later
    property ab_c;
        @(posedge clk) (a && b) |-> ##[1:3] c;
    endproperty

    // Write a sequence s11b, after 2 positive clock edges, signal b should be low
    sequence s11b;
        ##2 !b;
    endsequence

    // Write a property for the following specs:
    // - 3-to-8 decoder output Y
    // i. At each positive edge of clock, Y output must be only one bit high
    property Y_onebit;
        @(posedge clk) $onehot(Y);
    endproperty

    // 4-to-2 priority encoder output valid (refer to assignment 1)
    // i. At each positive edge of clock, if the input D bits are low then after one clock
    // cycle, output valid must be low.
    property pri_encoder;
        @(posedge clk) (|D == 0) |-> ##1 !valid;
    endproperty
    always @(posedge clk) begin

        assert property (ab_high);
        assert property (ab_c);
        assert property (Y_onebit);
        assert property (pri_encoder);
        
    end

endmodule