# RISC-V Standard Expansion of Instruction sets M and F

This open source project is part of Francis Fuentes' Master in Telecommunication Engineering dissertation (2020/21), Escola d'Enginyeria, UAB, Spain.

The objective of this project is to carry out the required modifications to a 5-stages RISC-V 32-bit core, develope and implement the modules capables of expanding the core with the instruction sets M and F of the ISA standard (RV32M and RV32F).

Authors of previous project used as starting point of this project are:
 - Pau Casacoverta Orta for implementing a base core RV32I compliant with the base instruction set fixed by the ISA standard.
 - Raimon Casanova Mohr for tutoring and adding pipeline structure to the core, facilitating the addition of expansions and increasing the data througput.
 - The open source PULPino's HW infraestructure authors (https://github.com/pulp-platform/pulpino), as this project uses their external core build at the synthesis phase on FPGA board to use the various I/O interfaces like SPI, UART, GPIO, between others.

All hardware design is performed using Verilog HDL and some System Verilog when necessary. The project folders are distributed by type of sub-project used in the prototyping of different parts of the project:
 - "Core" includes the files of the last update on the whole RISC-V core. The MULDIV module implementation is finished, but is expected to offer two different modules with different multiplication IP libraries in the future.
 - "MULDIV" includes the files of the modules capable of implementing the instruction set M.
    At the moment, a LPM_MULT IP library is being used to perform unsigned multiplications, so the ".comp_sv" file in the sim folder details the new way to perform simulations loading correctly the LPM libraries. If the LPM libraries are exempt, there's also the possibility of using the old multiplication reference design "MULgold.v", but is required to change the module that performs the multiplication operation LPM_MULT32 to the old one MULgold.

    There's multiple implementation options for the DIV module, but all follow a restoring divisor design:
    - tDIVrest32u - Theoretical restoring divisor without any upgrade. 32 clock cycles every division, no matter what are the input operands.
    - bDIVrest32u - Basic restoring divisor. Checks if dividend "a" is lower than divisor "b", which skips the division operation (does it in one clock cycle).
    - qsDIVrest32u - Quick start restoring divisor. Pushes the dividend to the left-most position in the quotient register at the start, which skips "n" number of left zeros the dividend has in clock cycles. Great when the dividend has a low value (for example, if a 4-bit dividend is 0010, this model saves 2 clock cycles).
    - eqsDIVrest32u - Even quicker start restoring divisor. Pushes the dividend to the highest bit position of the divisor in the remainder/quotient registers, which makes it to start even faster than the quick start version. The number of clock cycles saved equals to the number of left zeros the dividend has, plus the number of bits to the right from the leftmost '1' of the divisor. Great when the dividend has a low value and when the divisor has a high value, but the dividend cannot be lower than the divisor because skips it (for example, if a 4-bit dividend is 0010 and 4-bit divisor is 001X, the number of clock cycles saved are 2+1, the two left dividend zeros and the one right bit of the divisor).
    - seDIVrest32u - Skip execution restoring divider. Uses pretty much the same resources as the eqsDIV, but applies the same concept both at the start and during the operation, skipping many '0' quotient resulting bits iterations. The only disadvantatge from the eqsDIV version is its combinational logic added in the loop phase, increasing the combinational latency in that sector, which could limit the frequency of operation if is the critic path.
    - dDIVrest32u - Double restoring divider. Uses two subtractor units in order to push two quotient result bits each cycles, halving the total of clock cycles it takes to finish the loop phase.
    - deqsDIVrest32u - Double even quicker start restoring divider. Mixes both eqsDIV and dDIV designs providing a better performing model, but also the most resource demanding and with a higher combinational latency as the critical path has increased (not that important if doesn't ends being part of the critical path in the whole core, which is what really limits the operation frequency).
    - dseDIVrest32u - Double skip execution restoring divider. Mixes both dDIV and seDIV designs, performing the best of all the 32bit developed versions. The only thing against it is the increased latency in the loop phase, which for this model is two subtraction units and the shifting system, but in resource allocation is pretty much the same as re-uses the same internal logic as the deqsDIV.

    All divisor models presented have a clock latency maximum of 32 clock cycles. Only the qs and eqs versions have a dynamic clock cycle latency, which depends on the input operands. A more dynamic in-operation version might be developed in the future if there's enough time.

- "FPunit" will include the files of the Floating-point unit capable of implementing the expansion insctruction set F.

The other folders contain a variety of prototype modules used in other modules or discarded because they don't work, but enough time has been put into them and might be revisited in the future. For example, the newton division model follows the Newton-Raphson divisor design, but by time constrains and the complexity it carries, it has been put on hold at the moment and might get totally abandoned.

The files distribution in each folder contain:
 - src: Source Verilog files of the synthesizable HW models.
 - tb: Testbench Verilog files used to simulate the HW models.
 - sim: All output simulation files end here, including scripts used for developing and testing. For example, on the "Core/sim" folder there's the "sv_files" which contains the dynamic directory of all the files of that project. Just execute "do .comp_sv" while in that directory to compile all the project files (you might have to flush the "work" folder and re-create it before the compilation). The file "wave.do" in the same directory is used to add many wave signals during the "load_store_test" simulation to debug that particular execution. Other scripts might be added, so check the .txt in the same directory in the future when it'll have many more scripts.
 
TODO:
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
