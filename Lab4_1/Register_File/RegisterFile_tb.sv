typedef enum {  adc0_reg  = 0    ,   
                adc1_reg         ,   
                temp_sensor0_reg ,   
                temp_sensor1_reg ,                   
                analog_test      ,                   
                digital_test     ,                   
                amp_gain         ,                   
                digital_config} reg_file;                  


module RegisterFile_tb();

    // inputs and outputs
    logic clk, write ,reset;
    logic [2:0] address;
    logic [15:0] data_in;
    logic [15:0] data_out;

    // DUT
    config_reg DUT(
        clk,
        reset,
        write,
        data_in,
        address,
        data_out    
    );

    reg_file reg_selection;

    logic [15:0] reset_assoc[string];

    // Clock
    always #5 clk = ~clk;

    // task for reset
    task reset_assert;
        reset = 1'b1;
        write = 1'b0;
        #10; 
        reset = 1'b0;   
    endtask

    // task for check 
    task check_result(string name, input [15:0] expected_res);
        if(data_out !== expected_res) begin
            $display("ERROR in %s: Expected = %h, Got = %h", name, expected_res, data_out);    
        end else begin
            $display("PASS in %s: Value = %h", name, data_out);
        end
    endtask

    // task for write
    task write_reg(reg_file reg_r, logic [15:0] val);
        @(posedge clk);
        address = reg_r;
        data_in = val;
        write = 1'b1;
        @(posedge clk);
        write = 1'b0;
    endtask

    // general stimuli
    initial begin
        clk = 0;

        reset_assoc["adc0_reg"] = 16'hFFFF;
        reset_assoc["adc1_reg"] = 16'h0;
        reset_assoc["temp_sensor0_reg"] = 16'h0;
        reset_assoc["temp_sensor1_reg"] = 16'h0;              
        reset_assoc["analog_test"] = 16'hABCD;                   
        reset_assoc["digital_test"] = 16'h0;        
        reset_assoc["amp_gain"] = 16'h0;                  
        reset_assoc["digital_config"] = 16'h1;

        // assert reset
        reset_assert();

        $display("-----------------------Check Reset assertion-----------------------");
        // check reset
        reg_selection = reg_selection.first();
        repeat(reg_selection.num()) begin
            address = reg_selection;
            #1;
            check_result(reg_selection.name(), reset_assoc[reg_selection.name()]);
            reg_selection = reg_selection.next();
        end

        $display("-----------------------Check write disable-----------------------");
        // write disable Test
        reg_selection = reg_selection.first();
            address = adc0_reg;
            data_in = 16'h1234;
            write = 0;
            #10;
            check_result("adc0_reg", 16'hFFFF);

        $display("-----------------------Check write 1-----------------------");
        // write and read
        reg_selection = reg_selection.first();
        repeat(reg_selection.num()) begin
            write_reg(reg_selection, 16'hA5A5);

            address = reg_selection;
            #1;

            check_result(reg_selection.name(), 16'hA5A5);
            reg_selection = reg_selection.next();
        end

        $display("-----------------------Check write 2-----------------------");
        // write and read
        reg_selection = reg_selection.first();
        repeat(reg_selection.num()) begin
            write_reg(reg_selection, 16'hFFFF);

            address = reg_selection;
            #1;

            check_result(reg_selection.name(), 16'hFFFF);
            reg_selection = reg_selection.next();
        end

        $display("-----------------------Check write 3-----------------------");
        // write and read
        reg_selection = reg_selection.first();
        repeat(reg_selection.num()) begin
            write_reg(reg_selection, 16'h8000);

            address = reg_selection;
            #1;

            check_result(reg_selection.name(), 16'h8000);
            reg_selection = reg_selection.next();
        end

        #50; $stop;

    end

endmodule