# ICS3203-CAT2-Assembly-Islam-Faruk-Jeizan-150892

---

## **Commands for Running Task 1-4**


1. **Assemble the `.asm` file into an object file:**
   ```bash
   nasm -f elf64 -o Q1.o Q1.asm
   ```
2. **Link the object file to create an executable:**
   ```bash
   ld -m elf_ task?.o -o task?
   ```

3. **Run The Program**
   ```bash
   ./task?

   **replace ? with the task number**

### **Documentation for Each Task**

#### **Task 1: Control Flow and Conditional Logic**

**Purpose**:  
Classifies a number as positive, negative, or zero using assembly’s branching mechanisms.

**Key Features**:  
- Prompts user for a number.
- Uses conditional jumps (`je`, `jl`, `jg`) and an unconditional jump (`jmp`) to manage flow.
- Outputs the corresponding classification message.

**Challenges**:  
Understanding the difference between signed and unsigned comparisons required careful study of conditional jump instructions. Testing edge cases like zero and large negative values helped refine the logic.

---

#### **Task 2: Array Manipulation**

**Purpose**:  
Reverses an array of integers in place, demonstrating pointer arithmetic and loop-based control.

**Key Features**:  
- Accepts an array of integers from the user.
- Uses two pointers: one at the start and one at the end.
- Swaps elements iteratively until the pointers meet.

**Challenges**:  
Direct memory manipulation was tricky, especially ensuring the pointers didn’t overwrite values prematurely. Debugging pointer arithmetic and confirming correct swapping behavior required step-by-step validation with sample inputs.

---

#### **Task 3: Modular Program with Subroutines**

**Purpose**:  
Calculates the factorial of a number using a subroutine, emphasizing modular design and register handling.

**Key Features**:  
- Uses a subroutine to calculate the factorial iteratively.
- Demonstrates stack usage for preserving and restoring registers.
- Stores the result in a general-purpose register.

**Challenges**:  
Managing the stack was difficult initially. Ensuring that all registers used within the subroutine were saved and restored correctly required understanding stack frame conventions. Debugging infinite loops and stack overflows during initial implementation highlighted the need for careful register management.

---

#### **Task 4: Port-Based Simulation**

**Purpose**:  
Simulates a control system that monitors a sensor value and adjusts the motor and alarm states accordingly.

**Key Features**:  
- Reads a simulated sensor value from memory.
- Updates motor and alarm states based on sensor input thresholds.
- Demonstrates logical branching and memory location updates.

**Challenges**:  
Designing the simulation logic to mimic real-world behavior was non-trivial. Translating hardware states into memory operations required careful planning, and ensuring correct bit manipulation without affecting unrelated memory locations needed precision.

---

