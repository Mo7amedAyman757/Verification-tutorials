class sequencer;

    transaction tr;
    mailbox #(transaction) mb_seq_drv;

    function new(mailbox #(transaction) mb_from_env);
        this.mb_seq_drv = mb_from_env;
    endfunction

    task run(int num);
        $display("==========Sequencer started==========");

        for(int i=0; i<num; i++) begin
            tr = new();
            assert(tr.randomize());
            tr.transaction_id = i;
            tr.display_transaction();
            mb_seq_drv.put(tr); 
        end

    endtask

endclass