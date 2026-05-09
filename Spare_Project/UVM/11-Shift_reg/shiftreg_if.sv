interface shiftreg_if(input logic clk);

    logic reset, serial_in, direction, mode;
    logic [5:0] datain;
    logic [5:0] dataout;

endinterface //shiftreg_if