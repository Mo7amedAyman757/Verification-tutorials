import adder_pkg::*;

module adder_tb(adder_if.TEST A_if);

    adder_transaction adder_txn = new;

    initial begin
        assert_reset;

        repeat(1000) begin
            assert(adder_txn.randomize());
            A_if.reset = adder_txn.reset;
            A_if.A = adder_txn.A;
            A_if.B = adder_txn.B;
            @(negedge A_if.clk);
            adder_txn.Covergrp_A.sample();
            adder_txn.Covergrp_B.sample();
        end    
        $stop;
    end

    task assert_reset;
        A_if.reset = 1;
        repeat(4) @(negedge A_if.clk);
        A_if.reset = 0;    
    endtask

endmodule