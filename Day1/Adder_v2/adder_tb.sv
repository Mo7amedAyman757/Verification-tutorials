import adder_pkg::*;

module adder_tb();

    adder_transaction addr_obj;
    
    // declare local input and outptut
    logic clk, reset;
    logic signed [3:0] A, B;
    wire signed [4:0] C;

    bit signed [4:0] C_exp;

    // Declare error_count and correct_count as integer.
    int error_count, correct_count;

    // Instantiate the design under test (adder).
    adder uut(
        clk,
        reset,
        A,
        B,
        C
    );

    // Write a clock generator block that toggles clk_tb every 5 time units.
    initial begin
        clk =1'b0;
        forever #5 clk = ~clk;
    end

    // General stimuli
    initial begin

      addr_obj = new();
      reset = 1'b0;
      A = 4'b0;
      B = 4'b0;
      
      #2;
      reset = 1'b1;

      assert_reset;

      repeat(100) begin
        assert(addr_obj.randomize());
        reset = addr_obj.reset;
        A = addr_obj.A;
        B = addr_obj.B;   
        check_result(addr_obj);
      end  
      $stop;
    end

    task assert_reset;
        reset = 1;
        check_reset;
        reset = 0;
    endtask

    task check_reset;
        @(negedge clk);
        if (C == 0) begin
            correct_count += 1;
            $display("reset asserted");    
        end else begin
            error_count += 1;
            $display("reset failed");       
        end
    endtask

    task check_result(adder_transaction addr_obj1);
        golden_model(addr_obj1);
        @(negedge clk);
        if(!addr_obj1.reset) begin
            if (C == C_exp) begin
                correct_count += 1;
                $display("correct_count = %0d at %t: C = %0d and C_exp = %0d",correct_count, $time, C, C_exp);    
            end else begin
                error_count += 1;
                $display("error_count = %0d at %t: C = %0d and C_exp = %0d",error_count, $time, C, C_exp);       
            end
        end
    endtask

    task golden_model(adder_transaction addr_obj2);
        if(addr_obj2.reset) begin
            C_exp = 0;
        end else begin
            C_exp = addr_obj2.A + addr_obj2.B;     
        end
    endtask


endmodule
