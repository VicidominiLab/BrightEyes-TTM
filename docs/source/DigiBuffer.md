# 8xDigiBuffer

I/O multichannel (8x) digital buffer to match the impedance of external reference signals with the input impedance of the Xilinx® KC705 Evaluation kit

- *Brand:* *custom-built*
- *Product code:* *custom-built*
- **Gerber File:** [8xDigiBuffer_Gerber.zip](https://github.com/VicidominiLab/BrightEyes-TTM/raw/v2.0/boards/8xDigiBuffer/files/DigiBuff8_rev2_GerberFiles.zip)

The 8xDigiBuffer is a custom built circuital component used as signal level (voltage) and impedance matching device. It is used as front-end logic to adapt and buffer external signals to the LVTTL 50 Ohm requirements of the  Xilinx® KC705 Evaluation kit.

The 8xDigiBuffer accomodates 8x inputs and it is capable of translating the input voltage levels into  LVTTL 50 Ohm in real-time.

In the current application and implementation, the 8xDigiBuffer, is used to make the pixel, line and frame clocks in a suitable form to be read bythe Xilinx® KC705 Evaluation kit SMA ports (Fig. 1).

:::{figure} img/8xDigiBuffer_connections.PNG
:align: center
:alt: I/Os SMA-FMC connector Board
:width: 600

Fig.1 - 8xDigiBuffer connections.
:::

At the links in the table below all the needed information for building a 8xDigiBuffer:

```{eval-rst}
.. list-table::
   :header-rows: 1

   * - Name
     - Where to get
   * - 8xDigiBuffer gerber soucer files
     - `DigiBuff8_rev2_GerberFiles.zip <https://github.com/VicidominiLab/BrightEyes-TTM/raw/v2.0/boards/8xDigiBuffer/files/DigiBuff8_rev2_GerberFiles.zip>`_
   * - 8xDigiBuffer build of materials
     - `BOM_DIGIBUFF8_rev2.xlsx <https://github.com/VicidominiLab/BrightEyes-TTM/raw/v2.0/boards/8xDigiBuffer/doc/BOM_DIGIBUFF8_rev2.xlsx>`_
   * - 8xDigibuffer circuit schematic
     - `DigiBuff8_rev2_sch.pdf <https://github.com/VicidominiLab/BrightEyes-TTM/raw/v2.0/boards/8xDigiBuffer/doc/DigiBuff8_rev2_sch.pdf>`_
   * - 8xDigibuffer pcb views
     - `DigiBuff8_rev2_pcb.pdf <https://github.com/VicidominiLab/BrightEyes-TTM/raw/v2.0/boards/8xDigiBuffer/doc/DigiBuff8_rev2_pcb.pdf>`_
```
