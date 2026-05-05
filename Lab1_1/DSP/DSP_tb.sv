module DSP_tb;

// declare local wire and reg
reg clk_tb, rst_tb;
reg [17:0] A_tb, B_tb, D_tb;
reg [47:0] C_tb;
wire [47:0] P_tb;
integer k;
// Instantiate the module under test
DSP uut(
    A_tb,
    B_tb,
    C_tb,
    D_tb,
    clk_tb,
    rst_tb,
    P_tb
);

// General stimuli 

always #5 clk_tb = ~clk_tb;

task assert_reset;
    rst_tb = 1'b0;
    @(negedge clk_tb);
    if (P_tb == 48'b0) begin
        $display("Reset successful");
    end
    rst_tb = 1'b1;
endtask

function [47:0] golden_model;
    input [17:0] A, B, D;
    input [47:0] C;
    reg [17:0] add_result;
    reg [36:0] mult_result;
    begin
        add_result = B + D;
        mult_result = A * add_result;
        golden_model = mult_result + C;
    end
endfunction

task check_result();
    reg [47:0] expected_result;
    expected_result = golden_model(A_tb, B_tb, D_tb, C_tb);
    repeat(4) @(negedge clk_tb);
    if (P_tb !== expected_result) begin
        $display("Test failed: A = %d, B = %d, C = %d, D = %d, Expected P = %d, Actual P = %d", A_tb, B_tb, C_tb, D_tb, expected_result, P_tb);
    end else begin
        $display("Test passed: A = %d, B = %d, C = %d, D = %d, P = %d", A_tb, B_tb, C_tb, D_tb, P_tb);
    end
endtask

initial begin
    clk_tb = 1'b0;
    rst_tb = 1'b1;
    A_tb = 0;
    B_tb = 0;
    C_tb = 0;
    D_tb = 0;

    #5;
    assert_reset;
    #15;
    assert_reset;
    #2;
    for(k = 0; k < 400; k = k + 1) begin
        A_tb = $random;
        B_tb = $random;     
        C_tb = $random;
        D_tb = $random;
        #10; // wait for the result to stabilize
        check_result();
    end

    #100;
     $stop;
end


endmodule