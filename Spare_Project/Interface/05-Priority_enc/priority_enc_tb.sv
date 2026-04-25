import priority_enc_pkg::*;

module priority_enc_tb (priority_enc_if.TEST enc_if);

    enc_transaction enc_txn = new();

    initial begin

        assert_reset();
        enc_if.D = 4'b0;
        repeat(3) @(negedge enc_if.clk);

        repeat(100) begin
            assert(enc_txn.randomize());
            enc_if.rst = enc_txn.rst;
            enc_if.D = enc_txn.D;
            @(negedge enc_if.clk);
            enc_txn.D_cvg.sample();
        end

        enc_if.D = 4'b0;
        repeat(3) @(negedge enc_if.clk);
        
        $stop;

    end

    task assert_reset;
        enc_if.rst = 1'b1;
        repeat(3) @(negedge enc_if.clk);
        enc_if.rst = 1'b0;
    endtask
    
endmodule