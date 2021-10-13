# 8xDigiBuffer

The 8xDigiBuffer is a custom built circuital component used as signal level (voltage) and impedance matching device. It is used as front-end logic to adapt and buffer external signals to the LVTTL 50 Ohm requirements of the  Xilinx® KC705 Evaluation kit.

The 8xDigiBuffer accomodates 8x inputs and it is capable of translating the input voltage levels into  LVTTL 50 Ohm in real-time.

In the current application and implementation, the 8xDigiBuffer, is used to make the pixel, line and frame clocks in a suitable form to be read bythe Xilinx® KC705 Evaluation kit SMA ports (Fig. 1).


<figure>
  <img src="/docs/img/8xDigiBuffer_connections.PNG" alt="I/Os SMA-FMC connector Board" width="600"/>
  <figcaption>Fig.1 - 8xDigiBuffer connections </figcaption>
</figure>

At the links in the table below all the needed information for building a 8xDigiBuffer:


| Name | Where to get |
| ------ | ------ |
| 8xDigiBuffer gerber soucer files | [DigiBuff8_rev2_GerberFiles.zip](/boards/8xDigiBuffer/files/DigiBuff8_rev2_GerberFiles.zip) |
| 8xDigiBuffer build of materials | [BOM_DIGIBUFF8_rev2.xlsx](/boards/8xDigiBuffer/doc/BOM_DIGIBUFF8_rev2.xlsx) |
| 8xDigibuffer circuit schematic | [DigiBuff8_rev2_sch.pdf](/boards/8xDigiBuffer/doc/DigiBuff8_rev2_sch.pdf) |
| 8xDigibuffer pcb views | [DigiBuff8_rev2_pcb.pdf](/boards/8xDigiBuffer/doc/DigiBuff8_rev2_pcb.pdf) |

