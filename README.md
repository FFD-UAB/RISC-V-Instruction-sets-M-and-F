# RISC-V Standard Expansion of Instruction sets M and F

This open source project is part of Francis Fuentes' Master in Telecommunication Engineering dissertation (2020/21), Escola d'Enginyeria, UAB, Spain.

The objective of this project is to carry out the required modifications to a 5-stages RISC-V 32-bit core, develope and implement the modules capables of expanding the core with the instruction sets M and F of the ISA standard (RV32M and RV32F).

Authors of previous project used as starting point of this project are:
 - Pau Casacoverta Orta for implementing a base core RV32I compliant with the base instruction set fixed by the ISA standard.
 - Raimon Casanova Mohr for tutoring and adding pipeline structure to the core, facilitating the addition of expansions and increasing the data througput.
 - The open source PULPino's HW infraestructure authors (https://github.com/pulp-platform/pulpino), as this project uses their external core build at the synthesis phase on FPGA board to use the various I/O interfaces like SPI, UART, GPIO, between others.

All hardware design is performed using Verilog HDL and some System Verilog when necessary. The project folders are distributed by type of sub-project used in the prototyping of different parts of the project:
 - "Core" includes the files of the last update on the whole RISC-V core. The MULDIV module implementation is in WIP.
 - "MULDIV" includes the files of the modules capable of implementing the instruction set M.
    As the MUL operations are expected to use a open source IP capable of implementing a single-cycle unsigned operation, the current model used is the reference.
    There's multiple implementation options for the DIV module, but all follow a restoring divisor design:
    - tDIVrest32u - Theoretical restoring divisor without any upgrade. 32 clock cycles every division, no matter what are the input operands.
    - bDIVrest32u - Basic restoring divisor. Checks if dividend "a" is lower than divisor "b", which skips the division operation (does it in one clock cycle).
    - qsDIVrest32u - Quick start restoring divisor. Pushes the dividend to the left-most position in the quotient register at the start, which skips "n" number of left zeros the dividend has in clock cycles. Great when the dividend has a low value (for example, if a 4-bit dividend is 0010, this model saves 2 clock cycles).
    - eqsDIVrest32u - Even quicker start restoring divisor. Pushes the dividend to the highest bit position of the divisor in the remainder/quotient registers, which makes it to start even faster than the quick start version. The number of clock cycles saved equals to the number of left zeros the dividend has, plus the number of bits to the right from the leftmost '1' of the divisor. Great when the dividend has a low value and when the divisor has a high value, but the dividend cannot be lower than the divisor because skips it (for example, if a 4-bit dividend is 0010 and 4-bit divisor is 001X, the number of clock cycles saved are 2+1, the two left dividend zeros and the one right bit of the divisor).

    All divisor models presented have a clock latency maximum of 32 clock cycles. Only the qs and eqs versions have a dynamic clock cycle latency, which depends on the input operands. A more dynamic in-operation version might be developed in the future if there's enough time.

- "FloatP" will include the files of the Floating-point unit capable of implementing the expansion insctruction set F.

The other folders contain a variety of prototype modules used in other modules or discarded because they don't work, but enough time has been put into them and might be revisited in the future. For example, the newton division model follows the Newton-Raphson divisor design, but by time constrains and the complexity it carries, it has been put on hold at the moment and might get totally abandoned.

The files distribution in each folder contain:
 - src: Source Verilog files of the synthesizable HW models.
 - tb: Testbench Verilog files used to simulate the HW models.
 - sim: All output simulation files end here, including scripts used for developing and testing. For example, on the "Core/sim" folder there's the "sv_files" which contains the dynamic directory of all the files of that project. Just execute "do .comp_sv" while in that directory to compile all the project files (you might have to flush the "work" folder and re-create it before the compilation). The file "wave.do" in the same directory is used to add many wave signals during the "load_store_test" simulation to debug that particular execution. Other scripts might be added, so check the .txt in the same directory in the future when it'll have many more scripts.
 
TODO:
- Adequate the core for the instruction set M expansion. WIP
- Write the testbenchs of the instruction set M for the whole core, including the autoformat instruction.
- Debug the instruction set M on the core.
- Synthesize and reconfigure the modifications performed on the core to make it be low on resource usage and low latency as much as possible.
- Design the module that implements the instruction set F expansion.
- Write the testbench of the instruction set F module.
- Debug the instruction set F module.
- Synthesize and reconfigure the floating-point module to make it to be low resource usage and low latency as much as possible.
- Adequate the core for the instruction set F expansion.
- Write the testbenchs of the instruction set F for the whole core, including the autoformat instruction.
- Debug the instruction set F on the core.
- Synthesize and reconfigure the modifications performed on the core to make it be low on resource usage and low latency as much as possible.
- Synthesize the core in a FPGA platform to perform real frequency clock testing.
