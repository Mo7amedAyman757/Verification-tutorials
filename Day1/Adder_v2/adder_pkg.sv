package adder_pkg;

    typedef enum {MAXNEG = -8, ZERO = 0, MAXPOS = 7 } AB_val;
    class adder_transaction;
        rand bit reset;
        rand bit signed [3:0] A;
        rand bit signed [3:0] B;
        rand AB_val most_val;
    

        constraint reset_c{
            reset dist {1 := 2, 0 := 98};
        }

        constraint A_B_c{
            A dist{most_val :/ 75, [-7:6] :/ 25};
            B dist{most_val :/ 75, [-7:6] :/ 25};
        }
    endclass
endpackage
