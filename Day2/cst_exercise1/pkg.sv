package pkg;
    
    class memTrans;
        logic [7:0] data_in;
        logic [3:0] address;

        function new(bit [7:0] data_in = 0, bit [3:0] address = 0);
            this.data_in = data_in;
            this.address = address;
        endfunction

        function void display_data();
            $display("data_in = 0x%0h address = 0x%0h", this.data_in, this.address);
        endfunction

    endclass


endpackage