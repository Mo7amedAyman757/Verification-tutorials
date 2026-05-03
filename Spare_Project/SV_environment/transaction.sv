class transaction;

    rand logic valid_in;
    rand logic [3:0] a;
    rand logic [3:0] b;
    rand logic cin;
    rand logic [3:0] ctl;

    logic valid_out;
    logic [3:0] alu;
    logic carry;
    logic zero;

    static int fail_count = 0;
    static int pass_count = 0;

    int transaction_id;

    function void display_transaction();
        $display("Transaction ID=%0d valid_in=%0b a=%0d b=%0d cin=%0b ctl=%0h | out=%0b alu=%0d carry=%0b zero=%0b",
                  transaction_id, valid_in, a, b, cin, ctl,
                  valid_out, alu, carry, zero);
    endfunction

endclass