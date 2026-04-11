
module dff_tb2;

// declare local wire and reg
    reg clk, rst, d, en;
    wire q;
    
// instantiate the module under test
    dff  #(.USE_EN(0)) uut(
        clk, 
        rst, 
        d, 
        q, 
        en);

// general stimuli
    always #5 clk = ~clk;

    

    task check_result(int d_val);;
        if (q !== d_val)    
            $display("FAIL d=%b en=%b q=%b expected=%b",
                  d,en,q,d_val);
    else
        $display("PASS d=%b en=%b q=%b",
                  d,en,q);
   
    endtask

    task reset_assert;
        rst = 1'b1;
        @(posedge clk);
        check_result(0);
        rst = 1'b0;
    endtask

    initial begin
        clk = 0;    
        rst = 1'b1;
        d = 0;
        en = 0;
    
        #5 rst = 0;
        #5;
        reset_assert;
        for (int i=0; i<10; i = i + 1) begin
            d = $random;
            en = $random;
            @(posedge clk);
            check_result(d);
        end
        
    #100 $stop;
    end

endmodule
