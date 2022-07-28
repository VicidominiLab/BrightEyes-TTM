## SMA/SMB-to-FMC board
FMC daugther card to interface the BrightEyes-TTM with external photon-signals on SMA (or SMB) connectors. The input signals of this board are single-ended with impedance 50 Ohm. 

- *Brand:* *custom-built*
- *Product code:* *custom-built*
- **Gerber File:** [Gerber_SMA_FMC.zip](https://github.com/VicidominiLab/BrightEyes-TTM/raw/v2.0/boards/IOconnectorBoard/Gerber_SMA_FMC.zip)

The BrightEyes-TTM interfaces with the photon-signals thanks to a custom-built I/0s FMC daughter card (Fig.1) connected via the FPGA mezzanine connector (FMC-HPC). In principle, if needed, also the I/0s FMC daughter card can be modfied, further developed and yet manufactured to adapt the BrightEyes-TTM to any type of LSM signals.

:::{figure} img/SMA_FMC_IO_daughtercard.PNG
:align: center
:alt: I/Os SMA-FMC connector Board
:width: 50%

Fig.1 - I/Os SMA-FMC connector Board
:::

The custom-built I/0s FMC daughter card interlocks with the Xilinx KC705 Evaluation kit as shown in Fig.2 below:

:::{figure} img/ConnectorBoard_connections.PNG
:align: center
:alt: ConnectorBoard_connections
:width: 50%

Fig.2 - I/Os SMA-FMC connector Board
:::

In this repository the following files are available for builing a SMA-FMC connector board:

```{eval-rst}
.. list-table::
   :header-rows: 1

   * - Name
     - Where to get
   * - Connector card gerber files
     - `Gerber_SMA_FMC.zip <https://github.com/VicidominiLab/BrightEyes-TTM/raw/v2.0/boards/IOconnectorBoard/Gerber_SMA_FMC.zip>`_
   * - Connector card circuit schematic
     - `SMA_FMC-schematic.pdf <https://github.com/VicidominiLab/BrightEyes-TTM/raw/v2.0/boards/IOconnectorBoard/SMA_FMC-schematic.pdf>`_
   * - Connector card pcb
     - `SMA_FMC-pcb.pdf <https://github.com/VicidominiLab/BrightEyes-TTM/raw/v2.0/boards/IOconnectorBoard/SMA_FMC-pcb.pdf>`_
   * - Connector card 3D model
     - `SMA_FMC-3D.pdf <https://github.com/VicidominiLab/BrightEyes-TTM/raw/v2.0/boards/IOconnectorBoard/SMA_FMC-3D.pdf>`_

```

Starting from these general open-source design files the FMC connector board can be engineered for interfacing the TTM to any type of detectors or microscope setups.

Check the tables below for the connection map:

### Pinout I/Os SMA/B-to-FMC board

|   **SPAD 5x5 PX**   | **SMA/B-FMC** | **CH  (VHDL)** |       **NET**      | **HPC** | **XDC** |
|:-------------------:|:-------------:|:--------------:|:------------------:|:-------:|:-------:|
|          1          |       J2      |        0       |   FMC_HPC_LA20_P   |   G21   |   E19   |
|          2          |       J7      |        1       |   FMC_HPC_LA20_N   |   G22   |   D19   |
|          3          |      J30      |        2       |   FMC_HPC_LA06_P   |   C10   |   H30   |
|          5          |      J10      |        3       |   FMC_HPC_LA06_N   |   C11   |   G30   |
|          6          |      J24      |        4       |   FMC_HPC_LA10_P   |   C14   |   D29   |
|          7          |       J8      |        5       |   FMC_HPC_LA10_N   |   C15   |   C30   |
|          8          |      J33      |        6       |   FMC_HPC_LA14_P   |   C18   |   B28   |
|          9          |      J28      |        7       |   FMC_HPC_LA14_N   |   C19   |   A28   |
|        **10**       |    **J37**    |      **8**     | **FMC_HPC_LA27_P** | **C26** | **C19** |
|          11         |      J16      |        9       |   FMC_HPC_LA27_N   |   C27   |   B19   |
|          12         |       J5      |       10       |   FMC_HPC_LA05_P   |   D11   |   G29   |
|          13         |      J34      |       11       |   FMC_HPC_LA05_N   |   D12   |   F30   |
|          14         |      J19      |       12       |   FMC_HPC_LA09_P   |   D14   |   B30   |
|          15         |       J9      |       13       |   FMC_HPC_LA09_N   |   D15   |   A30   |
|          16         |      J13      |       14       |   FMC_HPC_LA13_P   |   D17   |   A25   |
|          17         |      J23      |       15       |   FMC_HPC_LA13_N   |   D18   |   A26   |
|          18         |      J22      |       16       |   FMC_HPC_LA23_P   |   D23   |   B22   |
|          19         |      J27      |       17       |   FMC_HPC_LA23_N   |   D24   |   A22   |
|          21         |      J32      |       18       |   FMC_HPC_LA26_P   |   D26   |   B18   |
|          22         |      J11      |       19       |   FMC_HPC_LA26_N   |   D27   |   A18   |
|          23         |      J25      |       20       |   FMC_HPC_LA03_P   |    G9   |   H26   |
|          0          |      J20      |       21       |   FMC_HPC_LA03_N   |   G10   |   H27   |
|          4          |      J39      |       22       |   FMC_HPC_LA08_P   |   G12   |   E29   |
|          24         |      J29      |       23       |   FMC_HPC_LA08_N   |   G13   |   E30   |
|          20         |      J35      |       24       |   FMC_HPC_LA02_P   |    H7   |   H24   |
|                     |      J40      |       25       |   FMC_HPC_LA02_N   |    H8   |   H25   |
|                     |      J15      |       26       |   FMC_HPC_LA04_P   |   H10   |   G28   |
|                     |       J4      |       27       |   FMC_HPC_LA04_N   |   H11   |   F28   |
|                     |      J14      |       28       |   FMC_HPC_LA12_P   |   G15   |   C29   |
|                     |       J3      |       29       |   FMC_HPC_LA12_N   |   G16   |   B29   |
|                     |      J18      |       30       |   FMC_HPC_LA16_P   |   G18   |   B27   |
|                     |      J38      |       31       |   FMC_HPC_LA16_N   |   G19   |   A27   |
|                     |      J12      |                |   FMC_HPC_LA22_P   |   G24   |   C20   |
| **PX10 duplicated** |    **J17**    |                | **FMC_HPC_LA22_N** | **G25** | **B20** |
|                     |       J1      |                |   FMC_HPC_LA25_P   |   G27   |   G17   |
|                     |       J6      |                |   FMC_HPC_LA25_N   |   G28   |   F17   |
|                     |      J21      |                |   FMC_HPC_LA29_P   |   G30   |   C17   |
|                     |      J26      |                |   FMC_HPC_LA29_N   |   G31   |   B17   |
|                     |      J31      |                |   FMC_HPC_LA31_P   |   G33   |   G22   |
|                     |      J36      |                |   FMC_HPC_LA31_N   |   G34   |   F22   |
