# BrightEyes-TTM Mainboard

**(based on Kintex-7 evaluation board)**

BrightEyes-TTM is based on a commercially available and low cost [field-programmable-gate-array (FPGA)](https://en.wikipedia.org/wiki/Field-programmable_gate_array) evaluation Board (Fig.1), equipped with a state-of-the-art FPGA (the [Kintex 7](https://www.xilinx.com/products/silicon-devices/fpga/kintex-7.html), XC7K325T-2FFG900C) and a series of [I/Os connectors](docs/img/TTM_Assembly.png) granting an easy interface of the board with the laser scanning microscope controller, the detector(s) and the personal computer.


Xilinx® FPGA Kintex-7 KC705 Evaluation Board

- *Brand:* Xilinx®
- *Product code:* EK-K7-KC705-G
- *Link to the product:* <https://www.xilinx.com/products/boards-and-kits/ek-k7-kc705-g.html>


The BrightEyes-TTM project has been designed, synthesed and implementated with the software Xilinx Vivado 2017.4 more info [Xilinx Vivado Design Suite](https://www.xilinx.com/products/design-tools/vivado.html). After having downloaded and installed [Vivado Design Suite](https://www.xilinx.com/products/design-tools/vivado.html) (Xilinx FPGA Programming software environment) the Xilinx FPGA evaluation card can be directly programmed with a precompiled firmware available here below. 
The source code VHDL/Verilog is available on the GitHub repository [BrightEyes-TTM FPGA VHDL/Verilog code](https://github.com/VicidominiLab/BrightEyes-TTM/v2.0/main/FPGA/ttm/hdl)


:::{figure} img/KC705_FPGA.png
:align: center
:alt: Xilinx FPGA Board
:width: 50%

Fig.1 - Xilinx FPGA Board
:::

## BrightEyes-TTM Firmware
(ttmfirmware)=

The current firmware (.bit files) ready to flash the Xilinx KC705 Kintex-7 Evaluation board are available here:
- [BrightEyes-TTM FPGA firmware](https://github.com/VicidominiLab/BrightEyes-TTM/raw/v2.0/FPGA/ttm/project/ttm.runs/impl_1/top_single_ended.bit): 25 channels, single-ended inputs, new protocol (v.2.0)
- [BrightEyes-TTM FPGA firmware](https://github.com/VicidominiLab/BrightEyes-TTM/raw/v2.0/FPGA/ttm/project/ttm.runs/impl_1/top_diff.bit): 25 channels, differential inputs, new protocol (v.2.0)


Legacy firmware:
- [BrightEyes-TTM FPGA firmware](https://github.com/VicidominiLab/BrightEyes-TTM/raw/v1.0/FPGA/ttm/project/ttm.runs/impl_1/top.bit): 21 channels, single-ended inputs, old protocol (v.1.0)

If you want modify the project or you want know more about the BrightEyes-TTM firmware design see the [BrightEyes-TTM FPGA architecture](architecture.md).
