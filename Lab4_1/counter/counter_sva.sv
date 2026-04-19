////////////////////////////////////////////////////////////////////////////////
// Author: Mohamed Ayman
// Course: Digital Verification using SV & UVM
//
// Description: Counter Design 
// 
////////////////////////////////////////////////////////////////////////////////
module counter_sva(counter_if.DUT c_if);

    // When the load control signal is active, then the dout has the value of the din
    property  load_active;  
        @(posedge c_if.clk) disable iff(!c_if.rst_n)  !c_if.load_n |=> (c_if.count_out == $past(c_if.data_load));
    endproperty

    a_load_active_assertion: assert property(load_active);

    a_load_active_coverage: cover property(load_active);

    // When the load control signal is not active, and the enable is off then the dout does not change
    property  load_inactive_en_off;  
        @(posedge c_if.clk) disable iff(!c_if.rst_n) (c_if.load_n && !c_if.ce) |=> $stable(c_if.count_out);
    endproperty
    
    a_hold_assertion: assert property(load_inactive_en_off);

    a_hold_coverage: cover property(load_inactive_en_off);

    // When the load control signal is not active and the enable is active, and the up_down is high
    // then the dout is incremented.
    property  load_inactive_en_on_up;  
        @(posedge c_if.clk) disable iff(!c_if.rst_n) (c_if.load_n && c_if.ce && c_if.up_down) |=>  c_if.count_out == $past(c_if.count_out) + 1'b1;
    endproperty

    a_increment_assertion: assert property(load_inactive_en_on_up);

     a_increment_coverage: cover property(load_inactive_en_on_up);

    // When the load control signal is not active and the enable is active, and the up_down is low
    // then the dout is decremented.
    property  load_inactive_en_on_down;  
        @(posedge c_if.clk) disable iff(!c_if.rst_n) (c_if.load_n && c_if.ce && !c_if.up_down)|=>  c_if.count_out == $past(c_if.count_out) - 1'b1;
    endproperty

    a_decrement_assertion: assert property(load_inactive_en_on_down);

    a_decrement_coverage: cover property(load_inactive_en_on_down);

    property async_reset;
        @(posedge c_if.clk) !c_if.rst_n |=>  (c_if.count_out == 0); 
    endproperty

    a_reset_assertion: assert property(async_reset);

    a_reset_coverage: cover property(async_reset);

    property max_count_check;
        @(posedge c_if.clk) disable iff(!c_if.rst_n) (c_if.count_out== {c_if.WIDTH{1'b1}}) |=>  $past(c_if.max_count);
    endproperty

    a_max_count_assertion: assert property(max_count_check);

    a_max_count_coverage: cover property(max_count_check);

    property zero_check;
    @(posedge c_if.clk) (c_if.count_out == 0) |=> $past(c_if.zero);
    endproperty

    a_zero_assertion: assert property(zero_check);

    a_zero_coverage: cover property(zero_check);


endmodule