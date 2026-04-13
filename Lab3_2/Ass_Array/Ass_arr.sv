module ass_arr();

    // 24-bit word width, 20-bit address space (2^20 words)
    bit [23:0] mem [bit[19:0]];

    bit [19:0] addr;
    initial begin
        mem[20'h00000] = 24'hA50400; // location 0 to add the reset values
        mem[20'h00400] = 24'h123456; // Instruction 1 located at location 0x400
        mem[20'h00401] = 24'h789ABC; // Instruction 2 located at location 0x401
        mem[20'hFFFFF] = 24'h0F1E2D; // (ISR) is at the maximum possible address.

        foreach(mem[addr]) begin
            $display("Address = 0x%05h Data = 0x%06h",addr, mem[addr]);
        end
        
    end

endmodule