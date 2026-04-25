module priority_enc_sva (priority_enc_if.DUT enc_if);

    property rst_assert;
        @(posedge enc_if.clk) (enc_if.rst) |=> (enc_if.Y == 2'b00);
    endproperty

    rst_assertion : assert property(rst_assert);
    rst_cover : cover property(rst_assert);

    property p_not_valid;
        @(posedge enc_if.clk) disable iff (enc_if.rst) ($countones(enc_if.D) == 0) |=> (enc_if.valid == 0);    
    endproperty

    p_not_valid_assertion : assert property(p_not_valid);
    p_not_valid_cover : cover property(p_not_valid);

    property p_valid;
        @(posedge enc_if.clk) disable iff (enc_if.rst) ($countones(enc_if.D) > 0) |=> enc_if.valid;    
    endproperty

    p_valid_assertion : assert property(p_valid);
    p_valid_cover : cover property(p_valid);

    property Y_00;
        @(posedge enc_if.clk) disable iff (enc_if.rst) (enc_if.D[3] == 1'b1 && enc_if.D[2:0] == 3'b000) |=> (enc_if.Y == 2'b00);
    endproperty

    Y_00_assertion : assert property(Y_00);
    Y_00_cover : cover property(Y_00);

    property Y_01;
        @(posedge enc_if.clk) disable iff (enc_if.rst) (enc_if.D[2] == 1'b1 && enc_if.D[1:0] == 2'b00) |=> (enc_if.Y == 2'b01);
    endproperty

    Y_01_assertion : assert property(Y_01);
    Y_01_cover : cover property(Y_01);

    property Y_10;
        @(posedge enc_if.clk) disable iff (enc_if.rst) (enc_if.D[1] == 1'b1 && enc_if.D[0] == 1'b0) |=> (enc_if.Y == 2'b10);
    endproperty

    Y_10_assertion : assert property(Y_10);
    Y_10_cover : cover property(Y_10);


    property Y_11;
        @(posedge enc_if.clk) disable iff (enc_if.rst) (enc_if.D[0] == 1'b1) |=> (enc_if.Y == 2'b11);
    endproperty

    Y_11_assertion : assert property(Y_11);
    Y_11_cover : cover property(Y_11);

endmodule