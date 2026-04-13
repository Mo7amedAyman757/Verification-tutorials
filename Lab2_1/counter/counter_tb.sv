import counter_pkg::*;

module counter_tb();

    counter_class stimulus = new();

    //1 declare local wire and reg
    bit clk_tb, rst_n_tb, load_n_tb, up_down_tb, ce_tb;
    bit [stimulus.COUNTER_WIDTH-1:0] data_load_tb;
    logic [stimulus.COUNTER_WIDTH-1:0] count_out_tb, count_out_exp;
    logic max_count_tb, max_count_exp;
    logic zero_tb, zero_exp;

    int error_count, correct_count;

    //2 Instantiate the module under test
    counter #(.WIDTH(stimulus.COUNTER_WIDTH)) uut(
            clk_tb,
            rst_n_tb,
            load_n_tb, 
            up_down_tb, 
            ce_tb, 
            data_load_tb, 
            count_out_tb, 
            max_count_tb, 
            zero_tb);

    //3 General stimuli using always and initial
    initial begin
        clk_tb = 0;
        forever #5 clk_tb = ~clk_tb; // Generate a clock signal with a period of 10 time units
    end

    // Stimulus test 
    initial begin
        assert_reset();
        repeat(10000) begin
            assert (stimulus.randomize());
            rst_n_tb = stimulus.rst_n;
            load_n_tb = stimulus.load_n;
            ce_tb = stimulus.ce;   
            up_down_tb = stimulus.up_down;
            data_load_tb = stimulus.data_load; 
            check_result(stimulus);
        end
        $display("Total Correct: %0d, Total Errors: %0d", correct_count, error_count);
        $stop;
    end

    // Task to assert reset
    task assert_reset;
        rst_n_tb = 1'b0;
        check_reset;
        rst_n_tb = 1'b1;
    endtask

    // Task to check reset behavior
    task check_reset;
        @(negedge clk_tb);
        if ((count_out_tb !== 0) && (zero_tb !== 1) && (max_count_tb !== 0)) begin
            error_count += 1;
            $display("%t: ERROR for asserting reset--> count_out_tb = %0d, zero_tb = %0d, max_count_tb = %0d",
                    $time, count_out_tb, zero_tb, max_count_tb);     
        end else begin
            correct_count += 1;
            $display("%t: SUCCESS for asserting reset--> count_out_tb = %0d, zero_tb = %0d, max_count_tb = %0d",
                    $time, count_out_tb, zero_tb, max_count_tb);     
            
        end
    endtask

    // Task to implement the golden model and check results
    task golden_model(input counter_class stimulus_c);
        if (!stimulus_c.rst_n)
            count_out_exp = 0;
        else if (!stimulus_c.load_n)
            count_out_exp = data_load_tb;
        else if (stimulus_c.ce)
            if (stimulus_c.up_down)
                count_out_exp = count_out_exp + 1;
            else 
                count_out_exp = count_out_exp - 1;
        max_count_exp = (count_out_exp == {COUNTER_WIDTH{1'b1}})? 1:0;
        zero_exp = (count_out_exp == 0)? 1:0;
    endtask

    // Task to check results against the golden model
    task check_result(input counter_class stimulus_t);
        golden_model(stimulus_t);
        if(stimulus_t.rst_n !== 0) begin
            @(negedge clk_tb);
            if ((count_out_tb !== count_out_exp) || (zero_tb !== zero_exp) || (max_count_tb !== max_count_exp)) begin
            error_count += 1;
            $display("%t: ERROR--> count_out_tb = %0d,count_out_exp = %0d, zero_tb = %0d, zero_exp = %0d, max_count_tb = %0d,max_count_exp = %0d",
                     $time,count_out_tb, count_out_exp, zero_tb, zero_exp, max_count_tb, max_count_exp);     
            end
            else begin
                correct_count += 1;   
                $display("%t: SUCCESS--> count_out_tb = %0d,count_out_exp = %0d, zero_tb = %0d, zero_exp = %0d, max_count_tb = %0d,max_count_exp = %0d",
                         $time,count_out_tb, count_out_exp, zero_tb, zero_exp, max_count_tb, max_count_exp);  
            end
        end else begin
            check_reset;    
        end
    endtask

endmodule
