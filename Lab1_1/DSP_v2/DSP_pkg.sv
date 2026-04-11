package DSP_pkg;

    class DSP_transaction;

        rand bit  [17:0] A, B, D;
        rand bit  [47:0] C;
        rand bit rst_n;

        constraint c_rst_n { 
            rst_n dist {0 := 3, 1 := 97}; 
        }
    
        constraint A_B_D_cst {
            A < 18'h3FFFF;
            B < 18'h3FFFF;
            D < 18'h3FFFF;
        }

        constraint C_cst {
            C < 48'h1_FFFF_FFFF_FFFF;
        }

    endclass

    
endpackage
