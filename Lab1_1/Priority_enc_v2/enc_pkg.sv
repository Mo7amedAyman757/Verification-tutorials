package enc_pkg;

    class enc_transaction;
    rand bit rst;
    rand bit [3:0] D;

    constraint rst_c{
        rst dist {1 := 2 , 0 := 98};
    }

    constraint D_c{
        D dist {0 := 10, 1 := 30, 2:= 30, 4:= 30, 8:= 30, [5:7]:= 20, [9:15] := 20};
        
    }

    endclass

endpackage
