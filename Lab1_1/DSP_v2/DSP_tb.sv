import DSP_pkg::*;

module DSP_tb();

    DSP_transaction tr;

    // declare local inputs and outputs 
    // declare local wire and reg
    logic clk, rst;
    logic [17:0] A, B, D;
    logic [47:0] C;
    wire [47:0] P;

    bit [47:0] P_expected;

    int correct_count = 0, error_count = 0;
    // Instantiate the module under test
    DSP uut(
        A,
        B,
        C,
        D,
        clk,
        rst,
        P
    );

    // clock generation
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // General stimuli 
    initial begin
        tr = new();
        rst = 1'b0;
        A = 0;
        B = 0;
        C = 0;
        D = 0;

        assert_reset;

        repeat(100) begin  
            assert(tr.randomize());
            rst = tr.rst_n;
            A = tr.A;
            B = tr.B;
            C = tr.C;
            D = tr.D;
            check_result(tr);
        end
        $display("correct_count = %d, error_count = %d", correct_count, error_count);
        $stop;

    end

  
    task assert_reset;
        rst = 1'b0;
        check_reset();
        rst= 1'b1;
    endtask

    task check_reset;
        @(negedge clk);
        if (P == 48'b0) begin
            $display("Reset successful");
            correct_count++;
        end else begin
            $display("Reset failed");
            error_count++;
        end
    endtask

    task check_result(DSP_transaction DSP_obj);
        P_expected = golden_model(DSP_obj);
        repeat(4) @(negedge clk);
        if (P !== P_expected) begin
            error_count++;
            $display("Test failed at time %t: A = %h, B = %h, C = %h, D = %h, Expected P = %h, Actual P = %h", $time, DSP_obj.A, DSP_obj.B, DSP_obj.C, DSP_obj.D, P_expected, P);
        end else begin
            correct_count++;  
            $display("Test passed at time %t: A = %h, B = %h, C = %h, D = %h, Expected P = %h, Actual P = %h", $time, DSP_obj.A, DSP_obj.B, DSP_obj.C, DSP_obj.D, P_expected, P);
        end
    endtask


    function [47:0] golden_model(DSP_transaction DSP_obj);
        reg [17:0] add_result;
        reg [36:0] mult_result;
        if (DSP_obj.rst_n == 1'b0) begin
            golden_model = 48'b0;
        end else begin
            add_result = DSP_obj.B + DSP_obj.D;
            mult_result = DSP_obj.A * add_result;
            golden_model = mult_result + DSP_obj.C;
        end
    endfunction

endmodule
