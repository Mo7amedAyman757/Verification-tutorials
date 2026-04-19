module adder_monitor(adder_if.MONITOR A_if);

    always @(posedge A_if.clk) begin
        $display("Time=%0t | reset=%b A=%0d B=%0d C=%0d",
                  $time, A_if.reset, A_if.A, A_if.B, A_if.C);
    end

endmodule