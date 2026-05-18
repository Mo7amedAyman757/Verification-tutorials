module dff_sva(dff_if.DUT dff_vif);

    property reset_check;
        @(posedge dff_vif.clk)
        (dff_vif.rst) |=> (dff_vif.q == 0);
    endproperty

    a_reset_assertion: assert property(reset_check);

    a_reset_coverage: cover property(reset_check);

    property  param_en_ON;  
        @(posedge dff_vif.clk) disable iff(dff_vif.rst) 
        (dff_vif.en && dff_vif.USE_EN) |=> (dff_vif.q == $past(dff_vif.d));
    endproperty
    
    param_en_ON_assertion: assert property(param_en_ON);

    param_en_ON_coverage: cover property(param_en_ON);

    property  param_ON_en_off;  
        @(posedge dff_vif.clk) disable iff(dff_vif.rst) 
        (!dff_vif.en && dff_vif.USE_EN) |=> (dff_vif.q == $past(dff_vif.q));
    endproperty
    
    param_ON_en_off_assertion: assert property(param_ON_en_off);

    param_ON_en_off_coverage: cover property(param_ON_en_off);

    property  param_off;  
        @(posedge dff_vif.clk) disable iff(dff_vif.rst) 
        (!dff_vif.USE_EN) |=> (dff_vif.q == $past(dff_vif.q));
    endproperty
    
    param_off_assertion: assert property(param_off);

    param_off_coverage: cover property(param_off);

endmodule
