interface counter_if(input logic clk);
    parameter WIDTH = 4;
    
    logic rst_n;
    logic load_n;
    logic up_down;
    logic ce;
    logic [WIDTH-1:0] data_load;
    logic [WIDTH-1:0] count_out;
    logic  max_count;
    logic zero;

endinterface //counter_if