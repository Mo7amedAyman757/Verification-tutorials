import enc_pkg::*;

module priority_enc_tb ();
    
    enc_transaction enc_obj;

    // declare loca inputs and outputs
    logic  clk;
    logic  rst;
    logic [3:0] D;	
    wire [1:0] Y;	
    wire valid;
    bit [1:0] Y_exp;
    bit Valid_exp;

    // Instantiate the module under test
    priority_enc uut(
        clk,
        rst,
        D,
        Y,
        valid
    );

    // define local parameter for tracking the functionality
    int  count_correct, count_error;

    // define clock
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // General stimulus generation using randomization
    initial begin
        enc_obj = new;
        rst = 1'b0;
        D = 4'b0;
        #5;
        assert_reset;
        repeat(100) begin
            assert(enc_obj.randomize());
            rst = enc_obj.rst;
            D = enc_obj.D;
            check_result(enc_obj);
        end
            $display("Total Correct: %d, Total Errors: %d", count_correct, count_error);
            $stop;

    end

    task assert_reset;
        rst = 1'b1;
        check_reset;
        rst = 1'b0;
    endtask

    task check_reset;
        @(negedge clk)
        if(Y_exp == 0 && Y == 0) begin
            count_correct += 1;
            $display("Reset Asserted");    
        end else begin
            count_error += 1;
            $display("Reset Failed");        
        end
    endtask

    task check_result(enc_transaction enc_obj1);
        golden_model(enc_obj1);
        @(negedge clk)
        if(!enc_obj1.rst) begin
           if (Y_exp== Y && Valid_exp == valid) begin
                count_correct += 1;
                $display("Correct: %t: Y_exp = %0d Y = %0d valid_exp = %0d valid = %0d",$time,Y_exp, Y, Valid_exp, valid);
           end
           else begin
                count_error += 1; 
                $display("ERROR!: %t: Y_exp = %0d Y = %0d valid_exp = %0d valid = %0d",$time,Y_exp, Y, Valid_exp, valid);
           end
        end
    endtask

    task golden_model(enc_transaction enc_obj2);
        if(!enc_obj2.rst) begin
            casex (enc_obj2.D)
                4'b1000: Y_exp = 0;
                4'bX100: Y_exp = 1;
                4'bXX10: Y_exp = 2;
                4'bXXX1: Y_exp = 3;
            endcase
  	        Valid_exp = (~|enc_obj2.D)? 1'b0: 1'b1;
        end else begin
            Y_exp = 0;    
        end
    endtask


endmodule
