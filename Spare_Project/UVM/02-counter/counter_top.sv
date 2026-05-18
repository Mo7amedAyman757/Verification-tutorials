// import test & add uvm package
import uvm_pkg::*;
import counter_test_pkg::*;
`include "uvm_macros.svh"

module counter_top();
    
    logic clk;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    counter_if counterif(clk);

    counter dut(counterif.clk,
                counterif.rst_n,
                counterif.load_n,
                counterif.up_down,
                counterif.ce,
                counterif.data_load,
                counterif.count_out,
                counterif.max_count,
                counterif.zero
                );

    counter_sva counter_sva_inst(counterif);

    initial begin
        uvm_config_db #(virtual counter_if)::set(null,"uvm_test_top","COUNTER_IF",counterif);
        run_test("counter_test");
    end

endmodule