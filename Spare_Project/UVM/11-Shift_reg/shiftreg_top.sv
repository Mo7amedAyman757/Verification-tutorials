import uvm_pkg::*;
import shiftreg_test_pkg::*;
`include "uvm_macros.svh"    

module shiftreg_top();
    
    logic clk;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    shiftreg_if shiftregif(clk);

    shift_reg dut (shiftregif.clk,
                   shiftregif.reset, 
                   shiftregif.serial_in, 
                   shiftregif.direction, 
                   shiftregif.mode,
                   shiftregif.datain, 
                   shiftregif.dataout);

    shiftreg_sva shiftreg_sva_inst(shiftregif);

    initial begin
        uvm_config_db #(virtual shiftreg_if)::set(null,"uvm_test_top","SHIFTREG_IF",shiftregif);
        run_test("shiftreg_test");
    end


endmodule