# Assembly Instructions

The Xilinx® KC705 Evaluation board, the Cypress® FX3™ SuperSpeed Explorer Kit and the connector card can be easily stacked together, using FMC connectors, as shown below (Fig. 3). I/Os connections are also labeled for a more intuitive assembly and mapped in the [I/O pins table](IOConnectorBoard.md) which shows the correspondence between inputs (typically the digital output from the SPAD array detector elements, named photon chaneels) and the connection pins. For a correct use of the BrightEyes-TTM the [dip switches](https://en.wikipedia.org/wiki/DIP_switch) in the orange BOX (always Fig.3) should be all set to the OFF position.

The Cypress® FX3™ SuperSpeed Explorer Kit board interlock into the FMC-LPC connector block. While the I/Os connector cards is connected to the FMC-HPC connector.

:::{figure} TTM_Assembled.jpg
:align: center
:alt: Assembly
:width: 3500

Fig.3 - BrightEyes-TTM detailed assembly.
:::

In the current application the BrightEyes-TTM provides the duplication of the central channel. 

- The single-ended inputs firmware, designed for the I/O SMA/B-to-FMC adapter board, the central channel (PX10 on SPAD-25ch, J37 on the adapter board) is duplicated on the J17 on the adapter board.

- The differential inputs firmware,  designed for the I/O 7x7SPAD-to-FMC adapter board, the central channel (PX24 on SPAD-49ch) is duplicated on the J9 on the adapter board.



