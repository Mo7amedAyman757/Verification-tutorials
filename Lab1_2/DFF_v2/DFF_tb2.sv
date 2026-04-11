import DFF_pkg::*;

module DFF_tb2;

    DFF_transaction tr;

    parameter USE_EN = 0;
    // declare local wire and reg
    logic clk, rst, d, en;
    wire q;
    bit q_exp;
    
    int correct_count, error_count;
    // instantiate the module under test
    dff  #(.USE_EN(USE_EN)) uut(
        clk, 
        rst, 
        d, 
        q, 
        en);

    // general stimuli
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        tr = new();
        correct_count = 0;
        error_count = 0;
        clk = 0;    
        rst = 1'b0;
        d = 0;
        en = 0;
    
        reset_assert;

        repeat(50) begin
            assert(tr.randomize());
            d = tr.d;
            en = tr.en;
            rst = tr.rst;
            check_result(tr);
        end
        
        $display("correct_count = %0d, error_count = %0d", correct_count, error_count);
      #100 $stop;
    end

    task reset_assert;
        rst = 1'b1;
        check_reset;
        rst = 1'b0;
    endtask

    task check_reset;
        @(negedge clk);
        if (q !== 0) begin
            $display("FAIL reset assertion q=%b expected=0", q);
            error_count++;
        end
        else begin
            $display("PASS reset assertion q=%b", q);
            correct_count++;
        end
    endtask

    task check_result(DFF_transaction DFF_obj);  
        golden_model(DFF_obj);
        @(negedge clk);
        if (q !== q_exp)    
            $display("FAIL d=%b en=%b q=%b expected=%b",
                  d,en,q,q_exp);
    else
        $display("PASS d=%b en=%b q=%b",
                  d,en,q);
    endtask

    task golden_model(DFF_transaction DFF_obj);
        if (DFF_obj.rst) begin
            q_exp = 0;
        end else  begin 
            if (USE_EN) begin
                if (DFF_obj.en) begin
                    q_exp = DFF_obj.d;
                end else begin
                    q_exp = q; // hold state
                end
            end else begin
                q_exp = DFF_obj.d;
            end
        end
    endtask

endmodule

