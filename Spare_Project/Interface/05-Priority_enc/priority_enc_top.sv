module priority_enc_top ();

    // declare clk
    bit clk;
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // initialize the interface
    priority_enc_if enc_if(clk);

    // connect dut, monitor, test
    priority_enc dut(enc_if);

    priority_enc_monitor monitor(enc_if);

    priority_enc_tb tb(enc_if);

    // bind the dut and assertion
    bind priority_enc priority_enc_sva priority_enc_sva_inst(enc_if);
    
endmodule