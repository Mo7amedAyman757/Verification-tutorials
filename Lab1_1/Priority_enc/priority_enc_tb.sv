module priority_enc_tb;

    // Declare local wire and reg
    reg clk_tb;
    reg reset_tb;
    reg [3:0] D_tb;
    wire [1:0] Y_tb;
    wire valid_tb;

    // Instantiate the module under test
    priority_enc uut(
        clk_tb,
        reset_tb,
        D_tb,
        Y_tb,
        valid_tb
    );

    // define local parameter for tracking the functionality
    int  count_correct, count_error;

     // define clock
    localparam T = 20;

    always begin
        clk_tb = 1'b0;
        #(T/2);
        clk_tb = 1'b1;
        #(T/2);
    end

     // define task for checking
    task checking(int expected_result,expected_validation);
        @(negedge clk_tb);
        if (expected_result !== Y_tb | expected_validation !== valid_tb) begin
            count_error += 1;            
            $display("A = %d, expected_out = %d, Actual_out = %d, expected_valid = %d, Actual_valid = %d",D_tb,expected_result,Y_tb,expected_validation,valid_tb);
        end
        else begin
            count_correct += 1;
        end
    endtask

    // define task for reset functionality
    task assert_reset;
        reset_tb = 1'b1;
        checking(2'b00,1'b0);
        reset_tb = 1'b0;
    endtask

    initial begin
        clk_tb = 1'b0; 
        reset_tb = 1'b0;
        D_tb = 4'b0;
        checking(2'bxx,1'b0);

        #10;
        assert_reset;   
        #10;
        assert_reset;

        #10;
        D_tb = 4'b0001;
        checking(2'b11,1'b1);

        #10;
        D_tb = 4'b0100;
        checking(2'b01,1'b1);

        #10;
        D_tb = 4'b1000;
        checking(2'b00,1'b1);

        #10;
        D_tb = 4'b0010; 
        checking(2'b10,1'b1);

        #10;
        D_tb = 4'b0000; 
        checking(2'b10,1'b0);
        
        #10;
        $$display("Correct count = %d and Error count = %d",count_correct,count_error);
        $stop;
    end

endmodule