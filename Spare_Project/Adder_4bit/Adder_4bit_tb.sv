module Adder_4bit_tb();
    
    reg clk;
    reg rst;
    reg [3:0] x, y;
    wire [4:0] s;
    

    // define local parameter for tracking the functionality
    int  count_correct, count_error;

    // Instantiate the full adder
    full_adder uut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y),
        .s(s)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    task checking(int expected_res);
        @(negedge clk);
        if (expected_res !== s) begin
            count_error += 1;
            $display("A = %d, B = %d, expected = %d, Actual = %d",x,y,expected_res,s);
        end else begin
            count_correct += 1;
        end
    endtask

    // define task for reset functionality
    task assert_reset;
        rst = 1'b1;
        checking(0);
        rst = 1'b0;
    endtask


    integer i;
    // Test stimulus
    initial begin
        // Initialize inputs
        rst = 1'b0; x = 4'b0000; y = 4'b0000;
        #10; // Wait for reset
            
        assert_reset;
        #10; 
        // Test cases
        for(i = 0; i < 16; i = i + 1) begin
            @(negedge clk);
            x = $random % 16; // Random 4-bit value
            y = $random % 16; // Random 4-bit value

            @(posedge clk); // DUT captures data here
            checking(x + y);
        end
        
        $stop; // End simulation
    end

    initial begin
        $monitor("Time: %0t | A: %b | B: %b | Sum: %b", $time, x, y, s);
    end

endmodule
