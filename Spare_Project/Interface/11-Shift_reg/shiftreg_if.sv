interface shiftreg_if(input logic clk);

    logic reset, serial_in, direction, mode;
    logic [5:0] datain;
    logic [5:0] dataout;

    modport DUT(input clk, reset, serial_in, direction, mode, datain, 
                output dataout);

    modport MONITOR(input clk, reset, serial_in, direction, mode, datain, 
                    dataout);

    modport TEST(output reset, serial_in, direction, mode, datain, 
                 input clk, dataout);    

endinterface