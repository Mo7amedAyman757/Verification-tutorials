module counter_sva (counter_if.DUT counterif);

    property reset_check;
        @(posedge counterif.clk)
        (!counterif.rst_n) |=> (counterif.count_out == 0);
    endproperty

    a_reset_assertion: assert property(reset_check);

    a_reset_coverage: cover property(reset_check);

    property  load_active;  
        @(posedge counterif.clk) disable iff(!counterif.rst_n)  
        !counterif.load_n |=> (counterif.count_out == $past(counterif.data_load));
    endproperty

    a_load_active_assertion: assert property(load_active);

    a_load_active_coverage: cover property(load_active);

    property  load_inactive_en_off;  
        @(posedge counterif.clk) disable iff(!counterif.rst_n) 
        (counterif.load_n && !counterif.ce) |=> $stable(counterif.count_out);
    endproperty
    
    a_hold_assertion: assert property(load_inactive_en_off);

    a_hold_coverage: cover property(load_inactive_en_off);

    property  load_inactive_en_on_up;  
        @(posedge counterif.clk) disable iff(!counterif.rst_n) 
        (counterif.load_n && counterif.ce && counterif.up_down) |=>  counterif.count_out == $past(counterif.count_out) + 1'b1;
    endproperty

    a_increment_assertion: assert property(load_inactive_en_on_up);

    a_increment_coverage: cover property(load_inactive_en_on_up);

    property  load_inactive_en_on_down;  
        @(posedge counterif.clk) disable iff(!counterif.rst_n) 
        (counterif.load_n && counterif.ce && !counterif.up_down)|=>  counterif.count_out == $past(counterif.count_out) - 1'b1;
    endproperty

    a_decrement_assertion: assert property(load_inactive_en_on_down);

    a_decrement_coverage: cover property(load_inactive_en_on_down);


    property max_count_check;
        @(posedge counterif.clk) disable iff (!counterif.rst_n) 
        (counterif.count_out == {counterif.WIDTH{1'b1}}) |-> (counterif.max_count == 1);
    endproperty

    a_max_count_assertion: assert property(max_count_check);

    a_max_count_coverage: cover property(max_count_check);

    property zero_check;
        @(posedge counterif.clk) disable iff (!counterif.rst_n) 
        (counterif.count_out == 0) |-> (counterif.zero == 1);
    endproperty

    a_zero_assertion: assert property(zero_check);

    a_zero_coverage: cover property(zero_check);


endmodule