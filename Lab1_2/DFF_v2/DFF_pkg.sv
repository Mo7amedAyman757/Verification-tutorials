package DFF_pkg;

    parameter USE_EN = 1;

    class DFF_transaction;
    rand bit rst, d, en;

    constraint c_rst {
        rst dist {1:=10, 0:=90}; 
    }

    constraint c_d {
        d dist {0:=30, 1:=70}; 
    }

    constraint use_en {
        if (USE_EN) {
            en dist {0:=10, 1:=90};
        }
    }

    endclass


endpackage
