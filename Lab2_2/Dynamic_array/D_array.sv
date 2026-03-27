module D_array();

    bit [11:0] my_array [4];

    initial begin
        my_array = '{12'h012, 12'h345, 12'h678, 12'h9AB};

        for (int i = 0; i < $size(my_array); i++) begin
            $display("Bits[5:4] of %b is %b",my_array[i],my_array[i][5:4]);
        end
        
        $display("-----------------------------------");
        foreach(my_array[i]) begin
            $display("Bits[5:4] of %b is %b",my_array[i],my_array[i][5:4]);
        end
    end

endmodule