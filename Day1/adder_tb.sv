module adder_tb;
// Declare the stimulus signals and the response signal
    reg clk_tb;
    reg reset_tb;
    reg signed [3:0] A;
    reg signed [3:0] B;
    wire signed [4:0] C;
// Declare error_count and correct_count as integer.
    int error_count, correct_count;

// Declare localparams MAXPOS and MAXNEG
    localparam MAXPOS = 7,
               MAXNEG = -8;
// Instantiate the design under test (adder).
    adder uut(
        clk_tb,
        reset_tb,
        A,
        B,
        C
    );

task check_result(int expected_sum);
    @(negedge clk_tb);
        if (expected_sum !== C) begin
            error_count += 1;
            $display("A = %d, B = %d, expected = %d, Actual = %d",A,B,expected_sum,C);
        end
        else 
            correct_count += 1;
endtask

task assert_reset;
    reset_tb = 1;
    check_result(0);
    reset_tb = 0;  
endtask

always begin
    #5 clk_tb = ~clk_tb;    
end

initial begin
    clk_tb = 0;
    A = 0;
    B = 0;  
    reset_tb = 0;

    #5;
    // call assert_reset
    assert_reset;

    #5;
    // call assert_reset
    assert_reset;
    
    A = 0;
    B = 0;
    check_result(0);
     B = MAXPOS;
    check_result(MAXPOS);
    B = MAXNEG;
    check_result(MAXNEG);

    A = MAXPOS;
    B = 0;
    check_result(MAXPOS);
    B = MAXPOS;
    check_result(MAXPOS + MAXPOS);
    B = MAXNEG;
    check_result(MAXPOS + MAXNEG);

    A = MAXNEG;
    B = 0;
    check_result(MAXNEG);
    B = MAXPOS;
    check_result(MAXPOS + MAXNEG);
    B = MAXNEG;
    check_result(MAXNEG);

    A = 0;
    B = 0;
    check_result(0);
     $display("Error count = %d and Correct count = %d",error_count,correct_count);
    $stop;
end

endmodule