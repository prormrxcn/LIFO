// Code your testbench here
// or browse Examples
module lifo_tb();
    // Testbench signals
    reg clk;
    reg rst;
    reg push;
    reg pop;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire full;
    wire empty;
    wire error;
    integer i;
    // Instantiate the LIFO module
    lifo uut (
        .clk(clk),
        .rst(rst),
        .push(push),
        .pop(pop),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty),
        .error(error)
    );
    
    // Clock generation
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end
    
    // Test procedure
    initial begin
        // Initialize inputs
        rst = 1;
        push = 0;
        pop = 0;
        data_in = 0;
        
        // Reset the system
        #10;
        rst = 0;
        #10;
        // Test 1: Basic push operations
        $display("Test 1: Basic push operations");
        push = 1;
        for ( i = 1; i <= 16; i = i + 1) begin
            data_in = i;
            #10;
            $display("Pushed: %0d, Top: %0d, Full: %b, Empty: %b", 
                     data_in, uut.top, full, empty);
        end
        push = 0;
        
        // Test 2: Basic pop operations
        $display("\nTest 2: Basic pop operations");
        pop = 1;
        for ( i = 0; i < 16; i = i + 1) begin
            #10;
            $display("Popped: %0d, Top: %0d, Full: %b, Empty: %b", 
                     data_out, uut.top, full, empty);
        end
        pop = 0;
        
        // Test 3: Overflow and underflow conditions
        $display("\nTest 3: Error conditions");
        // Try to push when full (should be empty now)
        push = 1;
        data_in = 8'hAA;
        #10;
        $display("Push on empty (should work), Error: %b", error);
        
        // Try to pop when empty
        push = 0;
        pop = 1;
        #10;
        $display("Pop on empty, Error: %b", error);
        pop = 0;
        
        // Fill the stack again
        push = 1;
        for ( i = 0; i < 16; i = i + 1) begin
            data_in = i + 100;
            #10;
        end
        push = 0;
        
        // Try to push when full
        data_in = 8'hFF;
        #10;
        $display("Push on full, Error: %b", error);
        
        // Test 4: Simultaneous push and pop
        $display("\nTest 4: Simultaneous push/pop");
        push = 1;
        pop = 1;
        data_in = 8'h55;
        #10;
        $display("Simultaneous op, Data out: %h, Error: %b", data_out, error);
        
        // Check stack content
        push = 0;
        pop = 1;
        #10;
        $display("Popped after simultaneous: %h", data_out);
        pop = 0;
        
        // Test 5: Reset during operation
        $display("\nTest 5: Reset test");
        push = 1;
        data_in = 8'h11;
        #5;
        rst = 1;
        #5;
        rst = 0;
        #10;
        $display("After reset, Empty: %b, Top: %0d", empty, uut.top);
        
        // End simulation
        #100;
        $display("\nAll tests completed");
        $finish;
    end
    
    // Monitor changes
    always @(posedge clk) begin
        if (error) begin
            $display("Error detected at time %0t", $time);
        end
    end
    
    // Dump VCD for waveform viewing
    initial begin
        $dumpfile("lifo.vcd");
        $dumpvars(0, lifo_tb);
    end
endmodule