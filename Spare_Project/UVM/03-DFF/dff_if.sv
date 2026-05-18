interface dff_if(input logic clk);

    parameter USE_EN = 1;
    logic rst, d, en;
    logic q;

endinterface //dff_if