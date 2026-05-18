import counter_pkg::*;

module counter_tb (counter_if.TEST counterif);

    counter_transaction class_trans = new;

    int correct_count , error_count;

    logic [WIDTH-1:0] count_out_ref;
    logic max_count_ref;
    logic zero_ref;

    initial begin
        initial_state();

        reset_assert();

        repeat(1000) begin
            assert(class_trans.randomize() with {load_n == 0; up_down == 1; ce == 1;});
            counterif.rst_n = class_trans.rst_n;
            counterif.load_n = class_trans.load_n;
            counterif.up_down = class_trans.up_down;
            counterif.ce = class_trans.ce;
            counterif.data_load = class_trans.data_load;
            @(negedge counterif.clk);
            check_result(class_trans);
            class_trans.count_out = counterif.count_out;
            class_trans.counter_cvg.sample();
        end

        repeat(100) begin
            assert(class_trans.randomize() with {load_n == 1; up_down == 1; ce == 0;});
            counterif.rst_n = class_trans.rst_n;
            counterif.load_n = class_trans.load_n;
            counterif.up_down = class_trans.up_down;
            counterif.ce = class_trans.ce;
            counterif.data_load = class_trans.data_load;
            @(negedge counterif.clk);
            check_result(class_trans);
            class_trans.count_out = counterif.count_out;
            class_trans.counter_cvg.sample();
        end

        repeat(1000) begin
            assert(class_trans.randomize() with {load_n == 1; up_down == 1; ce == 1;});
            counterif.rst_n = class_trans.rst_n;
            counterif.load_n = class_trans.load_n;
            counterif.up_down = class_trans.up_down;
            counterif.ce = class_trans.ce;
            counterif.data_load = class_trans.data_load;
            @(negedge counterif.clk);
            check_result(class_trans);
            class_trans.count_out = counterif.count_out;
            class_trans.counter_cvg.sample();
        end

        class_trans.load_cst.constraint_mode(1);
        repeat(1000) begin
            assert(class_trans.randomize() with {load_n == 1; up_down == 0; ce == 1;});
            counterif.rst_n = class_trans.rst_n;
            counterif.load_n = class_trans.load_n;
            counterif.up_down = class_trans.up_down;
            counterif.ce = class_trans.ce;
            counterif.data_load = class_trans.data_load;
            @(negedge counterif.clk);
            check_result(class_trans);
            class_trans.count_out = counterif.count_out;
            class_trans.counter_cvg.sample();
        end

        $display("error count = %0d",error_count);
        $display("correct count = %0d",correct_count);

        $stop;
    end

    task initial_state();
        counterif.rst_n = 1;
        counterif.load_n = 0;
        counterif.up_down = 0;
        counterif.ce = 0;
        counterif.data_load = 0;
        repeat(2) @(negedge counterif.clk);
    endtask

    task reset_assert();
        counterif.rst_n = 0;
        repeat(2) @(negedge counterif.clk);
        counterif.rst_n = 1;
    endtask

    task check_result(counter_transaction class_obj);
        golden_model(class_obj);
        if(count_out_ref != counterif.count_out || zero_ref != counterif.zero || max_count_ref != counterif.max_count) begin
            error_count++;
            $display("Error");
        end else begin
            correct_count++;
            $display("Pass");
        end
    endtask

    task golden_model(counter_transaction class_obj);
        if(!class_obj.rst_n) begin
            count_out_ref = 0;
        end 
        else if(!class_obj.load_n) begin
            count_out_ref = class_obj.data_load;
        end
        else if(class_obj.ce)
            if (class_obj.up_down)
                count_out_ref = count_out_ref + 1;
            else 
                count_out_ref = count_out_ref - 1;

        max_count_ref = (count_out_ref == {WIDTH{1'b1}})? 1:0;
        zero_ref = (count_out_ref == 0)? 1:0;
    endtask

endmodule