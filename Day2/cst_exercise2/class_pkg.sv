package class_pkg;

    class exercise2;
        rand bit [7:0] addr;
        rand bit [3:0] data;

        constraint addr_c{
            addr dist{
                4'd0 :/ 10,
                [1:14] :/ 80,
                4'd15 :/ 10
            };
        }

        constraint data_c{
            data == 5;
        } 

        function void display();
            $display("data = %0d address = %0d", data, addr);
        endfunction

    endclass

    
endpackage