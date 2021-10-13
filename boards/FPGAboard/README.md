# Kintex-7 evaluation board

BrightEyes-TTM is based on a commercially available and low cost [field-programmable-gate-array (FPGA)](https://en.wikipedia.org/wiki/Field-programmable_gate_array) evaluation Board (Fig.1), equipped with a state-of-the-art FPGA (the [Kintex 7](https://www.xilinx.com/products/silicon-devices/fpga/kintex-7.html), XC7K325T-2FFG900C) and a series of [I/Os connectors](docs/img/TTM_Assembly.PNG) granting an easy interface of the board with the laser scanning microscope controller, the detector(s) and the personal computer.

After having downloaded and installed [Vivado Design Suite](https://www.xilinx.com/products/design-tools/vivado.html) (Xilinx FPGA Programming software environment) the Xilinx FPGA evaluation card can be directly programmed with a standard precompiled [BrightEyes-TTM firmware](/FPGA/ttm/project/ttm.runs/impl_1/top.bit) (see the BrightEyes-TTM FPGA architecture section below for further info on the standard firmware design) or by synthesizing a new project solution starting from the low-level [VHDL/verilog open-source code](/FPGA/ttm/hdl).

<figure>
  <img src="/docs/img/KC705_FPGA.png" alt="Xilinx FPGA Board" width="250"/>
  <figcaption>Fig.1 - Xilinx FPGA Board</figcaption>
</figure>

Follow the links below for downloading the complete project solution:

- [BrightEyes-TTM main board](/boards/FPGAboard) - the Xilinx FPGA evaluation board used in the BrightEyes-TTM project
- [BrightEyes-TTM FPGA firmware](/FPGA/ttm/project/ttm.runs/impl_1/top.bit) - .bit firmware ready to be downloaded into the evaluation FPGA board
- [BrightEyes-TTM FPGA VHDL/Verilog code](/FPGA/ttm/hdl) - VHDL and Verilog open-source codes for future TTM developments and modifications
- [Vivado Design Suite](https://www.xilinx.com/products/design-tools/vivado.html) - required Xilinx FPGA Programming software
 environment for handling the BrightEyes-TTM project

The BrightEyes-TTM implementation was conceived and designed having in mind the fluorescence applications thus providing a good compromise between cost, photon-timing precision and resolution, temporal range, electronics dead-time, maximum photon-flux. The low FPGA resource in the current implementation ensures the highly scalability of the architecture, potentially enabling more channels and, in general, new applications. We chose an FPGA approach to grant both quick prototyping and versatility, and to give the miscroscopy community the posibility of further modifing the TTM depending on future and always-evolving needs.

 
<details><summary>The BrightEyes-TTM FPGA architecture</summary>


VHDL source code TTM architecture components:

- [Hit filter](/FPGA/ttm/hdl/hit_filter.vhd) - The hit-filter component is engineered and deployed to shape the incoming photons and sync signal lengths based on the sampling FPGA clock period and, at the same time, for generating a toggle signal event (the photon or sync enable signal) for each detected photon or laser pulse event.
- [Flash TDC](/FPGA/ttm/hdl/tdc_module.vhd) - The core constituent of the flash TDC module is a tapped delay line (TDL). The TDL is made up by a series of small delay elements (CARRY4 elements for the Kintex-7 FPGA used - for more info check page 43 of [7 Series FPGAs Configurable Logic Block
User Guide](https://www.xilinx.com/support/documentation/user_guides/ug474_7Series_CLB.pdf)) joined in a chain architecture and is used to delay an input (photon/START) signal with respect to a reference-sampling FPGA digital clock. Whitin the Flash TDC module also a thermometer-to-binary encoder (T2B) is embedded: a dedicated FPGA circuit is needed to interpret and decode the TDL output data. The T2B converts the TDL readout into a binary format allowing for a more effective data registration in terms of memory resources utilisation.
- [FIFO memory](/FPGA/ttm/hdl/fifo_iit.v) - First-In First-Out (FIFO) internal FPGA memory used to store the registered photons and laser sync events before sending their info out to a host processing unit.
- [Data interface module](/FPGA/ttm/hdl/to_fxr_workaround.v) - Module component that allows the data to be transfered from the FPGA to the  EZ-USB® FX3™ SuperSpeed Explorer Kit.
- [START,STOP,REF signals map](/FPGA/ttm/xdc/top_fpga.xdc) - .xdc file for the pin map to match the different BrightEyes-TTM inputs with the FPGA pins.

The BrightEyes-TTM architecture (Fig.2) combines N+1 (N = 21 photon channels in this implementation) tapped delay lines (TDLs) and a coarse counter running at 240 MHz to obtain N fine TDCs with tens of picoseconds precision (for the start-stop time of each photon channel), and M coarse TDCs with a nanosecond precision (M = 3 reference channels in this implementation).

<figure>
  <img src="/docs/img/BrightEyesTTM_architecture.PNG" alt="BrightEyes TTM architecture" width="300"/> </br>
  <figcaption>Fig.2 - BrightEyes TTM architecture</figcaption> </br> </br>
</figure>

</details>
