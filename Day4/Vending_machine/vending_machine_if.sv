////////////////////////////////////////////////////////////////////////////////
// Author: Mohamed Ayman
// Course: Digital Verification using SV & UVM
//
// Description: Vending machine example
// 
////////////////////////////////////////////////////////////////////////////////
interface vending_machine_if(clk);
    // 1. Add the parameters (WAIT = 0, Q_25 = 1, Q_50 =2)
    parameter WAIT = 2'b00;
    parameter Q_25 = 2'b01;
    parameter Q_50 = 2'b11;

    // 2. Add the clock as an input port
    input clk;

    // 3. Add the internal signals of the interface
    logic Q_in, D_in, reset, dispense, change;

    // 4. Add the modports
    modport DUT (input Q_in, D_in, reset, clk, output dispense, change);

    modport TEST(output Q_in, D_in, reset, input clk, dispense, change);

    modport MONITOR (input Q_in, D_in, reset, clk, dispense, change);

endinterface //vending_machine_if