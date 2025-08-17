
//////////////////////////////////////////////////////////////////////////////////
// Company: iist
// Engineer: daksh vaishnav
// 
// Create Date: 08/17/2025 06:39:58 PM
// Design Name: lifo
// Module Name: lifo
// Project Name: memory
// Target Devices: xc7a35t-cpg236-1
// Tool Versions: 2024.2
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module lifo(
    input clk,
    input rst,
    input push,
    input pop,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output full,
    output empty,
    output reg error
);
    reg [7:0] stack [0:15];   // 16-depth stack
    reg [4:0] top;            // stack pointer (0-16)
    
    wire doing_push = push && (!pop || !empty);
    wire doing_pop = pop && (!push || !full);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 0;
            data_out <= 0;
            error <= 0;
        end else begin
            error <= 0;  // clear error each cycle unless triggered
            
            case ({push, pop})
                2'b10: begin // push only
                    if (!full) begin
                        stack[top] <= data_in;
                        top <= top + 1;
                    end else begin
                        error <= 1; // overflow attempt
                    end
                end
                2'b01: begin // pop only
                    if (!empty) begin
                        data_out <= stack[top-1];
                        top <= top - 1;
                    end else begin
                        error <= 1; // underflow attempt
                    end
                end
                2'b11: begin // push and pop
                    if (!full && !empty) begin
                        // replace top element
                        stack[top-1] <= data_in;
                        data_out <= stack[top-1]; // output old value
                    end else if (empty) begin
                        // treat as push only
                        if (!full) begin
                            stack[top] <= data_in;
                            top <= top + 1;
                        end else begin
                            error <= 1;
                        end
                    end else if (full) begin
                        // treat as pop only
                        data_out <= stack[top-1];
                        top <= top - 1;
                    end
                end
                default: ; // no operation
            endcase
        end
    end

    // Status flags
    assign empty = (top == 0);
    assign full  = (top == 16);
endmodule
// Testbench for lifo module

