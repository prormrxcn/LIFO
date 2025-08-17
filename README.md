# LIFO Memory (Stack) – Verilog Implementation

## 📌 Project Info
- **College:** IIST  
- **Engineer:** Daksh Vaishnav  
- **Project Name:** Memory  
- **Design Name:** LIFO (Last-In First-Out) Stack  
- **Target Device:** xc7a35t-cpg236-1 (Basys 3 FPGA – Artix-7)  
- **Tool Version:** Vivado 2024.2  

---

## 📝 Description
This project implements a **16-depth stack (LIFO)** in Verilog.  
The stack supports **push**, **pop**, and simultaneous **push+pop** operations with **overflow/underflow error handling**.

---

## ⚙️ Features
- 8-bit wide data input/output  
- 16 entries (depth = 16)  
- `push` and `pop` signals for control  
- `full` and `empty` status flags  
- `error` signal for overflow/underflow  

---

## 🔧 Verilog Code
```verilog
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
```

---

## 🧪 Testbench
A testbench is included to validate the push/pop operations and error conditions.  

---

## 🚀 Usage
1. Clone this repository:
   ```bash
   git clone https://github.com/prormrxcn/LIFO.git
   cd LIFO
   ```
2. Open the project in **Vivado 2024.2** (or compatible tool).  
3. Simulate the design using the provided testbench.  
4. Implement and program on Basys 3 FPGA.  

---

## 📂 Files
- `lifo.v` – Verilog source file  
- `lifo_tb.v` – Testbench  
- `README.md` – Project documentation  

---

## ✅ Status
- [x] RTL Design  
- [x] Simulation Tested  
- [ ] FPGA Hardware Validation (WIP)  

---

## 📸 Screenshot (Optional)
*(Add waveform simulation screenshot here)*

---

## 👨‍💻 Author
**Daksh Vaishnav**  
