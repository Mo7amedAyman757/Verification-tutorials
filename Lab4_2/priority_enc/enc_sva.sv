////////////////////////////////////////////////////////////////////////////////
// Author: Mohamed Ayman
// Course: Digital Verification using SV & UVM
//
// Description: priority_enc Design 
// 
////////////////////////////////////////////////////////////////////////////////

module enc_sva(enc_if.DUT e_if);

    //
    property reset_active;
        @(posedge e_if.clk) e_if.rst |=> (e_if.Y == 2'b00);
    endproperty  

    reset_assertion : assert property (reset_active);
    reset_coverage : cover property (reset_active); 

    //
    property valid_low_check;  
        @(posedge e_if.clk)  (~|e_if.D == 1) |=> (e_if.valid == 0);
    endproperty

    valid_low_assertion: assert property (valid_low_check);
    valid_low_coverage: cover property (valid_low_check); 

    property valid_high_check;  
        @(posedge e_if.clk)  (|e_if.D == 1) |=> (e_if.valid == 1);
    endproperty

    valid_high_assertion: assert property (valid_high_check);
    valid_high_coverage: cover property (valid_high_check); 

    property D_0;
        @(posedge e_if.clk) disable iff (e_if.rst) e_if.D[0] |=> (e_if.Y == 3);
    endproperty

    D_0_assertion: assert property (D_0);
    D_0_cover: cover property (D_0);

    property D_1;
        @(posedge e_if.clk) disable iff (e_if.rst) (!e_if.D[0] && e_if.D[1]) |=> (e_if.Y == 2);
    endproperty

    D_1_assertion: assert property (D_1);
    D_1_cover: cover property (D_1);

    property D_2;
        @(posedge e_if.clk) disable iff (e_if.rst) (!e_if.D[0] && !e_if.D[1] && e_if.D[2]) |=> (e_if.Y == 1);
    endproperty

    D_2_assertion: assert property (D_2);
    D_2_cover: cover property (D_2);

    property D_3;
        @(posedge e_if.clk) disable iff (e_if.rst) (!e_if.D[0] && !e_if.D[1] && !e_if.D[2] && e_if.D[3]) |=> (e_if.Y == 0);
    endproperty

    D_3_assertion: assert property (D_3);
    D_3_cover: cover property (D_3);
    
endmodule