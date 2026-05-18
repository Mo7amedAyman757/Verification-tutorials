interface dff_if(input logic clk);

    parameter USE_EN = 1;
    logic rst, d, en;
    logic q;

    modport DUT (
    input clk,rst, d, en,
    output q
    );
    
    modport MONITOR (
    input clk, rst, d, en, q
    );

    modport TEST (
    output rst, d, en,
    input clk, q
    );
        
endinterface //dff_if
