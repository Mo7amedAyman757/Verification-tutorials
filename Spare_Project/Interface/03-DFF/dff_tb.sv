import dff_pkg::*;

module dff_tb(dff_if.TEST dff_vif);

    parameter USE_EN = 1;

    dff_transaction dff_trans = new;

    int error_count, correct_count;
    bit q_ref;

    initial begin
        initial_bins();
        assert_reset();

        repeat(100) begin
            assert(dff_trans.randomize());    
            dff_vif.rst = dff_trans.rst;
            dff_vif.d = dff_trans.d;
            dff_vif.en = dff_trans.en;
            @(negedge dff_vif.clk);
            check_result(dff_trans);
            dff_trans.dff_cfg.sample();
        end

        $display("error_count = %0d",error_count);
        $display("correct_count = %0d",correct_count);

        $stop;
    end

    task initial_bins;
        dff_vif.rst = 0;
        dff_vif.d = 0;
        dff_vif.en = 0;
        repeat(2) @(negedge dff_vif.clk);
    endtask

    task assert_reset;
        dff_vif.rst = 1;
        repeat(2) @(negedge dff_vif.clk);
        dff_vif.rst = 0;
    endtask

    task check_result(dff_transaction dff_trans);
        golden_model(dff_trans);
        if(q_ref != dff_vif.q) begin
            error_count++;
            $display("Failed");
        end else begin
            correct_count++;
            $display("Passed");
        end

    endtask

    task golden_model(dff_transaction dff_trans);
         if (dff_trans.rst)
            q_ref = 0;
        else
            if(USE_EN)
                if (dff_trans.en)
                    q_ref = dff_trans.d;
            else 
                q_ref = dff_trans.d;
    endtask


endmodule