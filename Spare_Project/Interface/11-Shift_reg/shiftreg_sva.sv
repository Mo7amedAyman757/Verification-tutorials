module shiftreg_sva (shiftreg_if.DUT shiftreg_vif);

    property reset_check;
        @(posedge shiftreg_vif.clk) 
        (shiftreg_vif.reset) |=> (shiftreg_vif.dataout == 0);
    endproperty

    assert property(reset_check);

    cover property(reset_check);

    property rotate_left_check;
        @(posedge shiftreg_vif.clk) disable iff(shiftreg_vif.reset) 
        (shiftreg_vif.mode && shiftreg_vif.direction) |=> (shiftreg_vif.dataout == {$past(shiftreg_vif.datain[4:0]), $past(shiftreg_vif.datain[5])});
    endproperty

    assert property(rotate_left_check);

    cover property(rotate_left_check);

    property rotate_right_check;
        @(posedge shiftreg_vif.clk) disable iff(shiftreg_vif.reset) 
        (shiftreg_vif.mode && !shiftreg_vif.direction) |=> (shiftreg_vif.dataout == {$past(shiftreg_vif.datain[0]), $past(shiftreg_vif.datain[5:1])});
    endproperty

    assert property(rotate_right_check);

    cover property(rotate_right_check);

    property shift_left_check;
        @(posedge shiftreg_vif.clk) disable iff(shiftreg_vif.reset) 
        (!shiftreg_vif.mode && shiftreg_vif.direction) |=> (shiftreg_vif.dataout == {$past(shiftreg_vif.datain[4:0]), $past(shiftreg_vif.serial_in)});
    endproperty

    assert property(shift_left_check);

    cover property(shift_left_check);

    property shift_right_check;
        @(posedge shiftreg_vif.clk) disable iff(shiftreg_vif.reset) 
        (!shiftreg_vif.mode && !shiftreg_vif.direction) |=> (shiftreg_vif.dataout == {$past(shiftreg_vif.serial_in), $past(shiftreg_vif.datain[5:1])});
    endproperty

    assert property(shift_right_check);

    cover property(shift_right_check);

endmodule