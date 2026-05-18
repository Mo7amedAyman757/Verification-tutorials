// import test & add uvm package
import uvm_pkg::*;
import dff_test_pkg::*;
`include "uvm_macros.svh"

module dff_top();
    
    logic clk;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    dff_if dffif(clk);

    dff dut(dffif.clk,
            dffif.rst,
            dffif.d,
            dffif.q,
            dffif.en
                );

    dff_sva dff_sva_inst(dffif);

    initial begin
        uvm_config_db #(virtual dff_if)::set(null,"uvm_test_top","DFF_IF",dffif);
        run_test("dff_test");
    end

endmodule