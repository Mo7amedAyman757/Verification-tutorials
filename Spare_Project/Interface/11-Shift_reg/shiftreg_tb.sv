import shiftreg_pkg::*;

module shiftreg_tb (shiftreg_if.TEST shiftreg_vif);

    logic [5:0] dataout_ref;

    int error_count, correct_count;

    shiftreg shiftreg_txn = new;

    initial begin
        initialize();

        #3; 

        assert_reset();

        repeat(1000) begin
            assert(shiftreg_txn.randomize());    
            shiftreg_vif.reset = shiftreg_txn.reset;
            shiftreg_vif.serial_in = shiftreg_txn.serial_in;
            shiftreg_vif.direction = shiftreg_txn.direction;
            shiftreg_vif.mode = shiftreg_txn.mode;
            shiftreg_vif.datain = shiftreg_txn.datain;
            @(negedge shiftreg_vif.clk);
            check_result(shiftreg_txn);
            shiftreg_txn.shiftreg_cvg.sample();
        end

        $display("error count = %0d",error_count);
        $display("correct count = %0d",correct_count);

        $stop;
    end

    task initialize;
        shiftreg_vif.reset = 0;
        shiftreg_vif.serial_in = 0;
        shiftreg_vif.direction = 0;
        shiftreg_vif.mode = 0;
        shiftreg_vif.datain = 0;
        error_count = 0;
        correct_count = 0;    
    endtask

    task assert_reset;
        shiftreg_vif.reset = 1;
        repeat(2) @(negedge shiftreg_vif.clk);
        shiftreg_vif.reset = 0;    
    endtask

    task check_result(shiftreg  shiftreg_txn1);
        golden_model(shiftreg_txn1);
        if (shiftreg_vif.dataout != dataout_ref) begin
            $display("Error!");
            error_count++;
        end else begin
            $display("Success!");
            correct_count++;    
        end

    endtask

    task golden_model(shiftreg  shiftreg_txn1);
        if (shiftreg_txn1.reset) begin
            dataout_ref = 0;
        end 
        
        else 
            if (shiftreg_txn1.mode) // rotate
                if (shiftreg_txn1.direction) // left
                    dataout_ref = {shiftreg_txn1.datain[4:0], shiftreg_txn1.datain[5]};
                else
                    dataout_ref = {shiftreg_txn1.datain[0], shiftreg_txn1.datain[5:1]};
            else // shift
                if (shiftreg_txn1.direction) // left
                    dataout_ref = {shiftreg_txn1.datain[4:0], shiftreg_txn1.serial_in};
                else
                    dataout_ref = {shiftreg_txn1.serial_in, shiftreg_txn1.datain[5:1]};    
    endtask

endmodule