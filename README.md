Repository Structure

This repository is structured as follows:

cnn_accelerator_hw/ – All VHDL source files for the CNN hardware accelerator

cpu_program/ – C application code executed by the Processing System (Dual-core ARM Cortex-A9, e.g., Zynq-7000 PS)

test_bench/ – VHDL test benches for system validation, including only full system simulation

Training file – Currently missing. It will be added to the repository once located

For a detailed technical explanation, refer to the project report.

Project Overview

This project was built to explore hardware acceleration for Convolutional Neural Networks (CNNs) on a heterogeneous embedded platform.

The Processing System (PS) manages control logic, memory transactions, and data movement

The hardware accelerator (PL) performs CNN inference to speed up computation

Verification covers both hardware-level correctness and full system behavior through simulation test benches

Testing & Verification

The included test benches provide:

RTL/module-level verification

End-to-end system simulation including PS + accelerator interaction

Validation of data transfers and inference execution

Design Notes & Trade-offs

Some design choices may seem suboptimal, particularly:

Using AXI-BRAM for data transfers instead of AXI-Stream or optimized AXI burst transactions

This was a deliberate learning decision at the time.
