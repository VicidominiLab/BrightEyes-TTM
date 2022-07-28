# Hardware
In the table below you can find the complete list of all the needed hardware components for builing the BrightEyes-TTM.

```{toctree}
FPGABoard
FMCAdapter
IOConnectorBoard
```

## Optional hardware parts

```{toctree}
NIM2TTL
DigiBuffer
```

## How to assemble / setup the harware

The Xilinx® KC705 Evaluation board, the Cypress® FX3™ SuperSpeed Explorer Kit and the connector card can be easily stacked together, using FMC connectors, as shown below (Fig. 3). I/Os connections are also labeled for a more intuitive assembly and mapped in the [I/O pins table](IOConnectorBoard.md) which shows the correspondence between inputs (typically the digital output from the SPAD array detector elements, named photon chaneels) and the connection pins. For a correct use of the BrightEyes-TTM the [dip switches](https://en.wikipedia.org/wiki/DIP_switch) in the orange BOX (always Fig.3) should be all set to the OFF position.

The Cypress® FX3™ SuperSpeed Explorer Kit board interlock into the FMC-LPC connector block. While the I/Os connector cards is connected to the FMC-HPC connector.

:::{figure} TTM_Assembled.jpg
:align: center
:alt: Assembly
:width: 3500

Fig.3 - BrightEyes-TTM detailed assembly.
:::

In the current application the BrightEyes-TTM provides the duplication of the central channel. 

|  Firmware  version |  Conn. | SPAD | Board    |  Central PX       |  Dupl. output on | 
| ------------ |----------- | ----------- | ----------------- |  -----------| -----------| 
|  Single-Ended inputs | SMA/SMB | 25 ch. | [I/O SMA/B-to-FMC adapter board](pinout5x5.md)  | PX10 (J13) |J17| 
|  Differentials inputs | HPC |49 ch. | [I/O 7x7SPAD-to-FMC](pinout7x7.md)  | PX24  | J9| 


## PC requirements

```{eval-rst}
.. list-table::
   :header-rows: 1

   * -
     -
   * - PC interface
     - USB 3.0 SuperSpeed
   * - PC requirements
     - min. 1.5 GHz CPU clock, min. 8 GB RAM memory (suggested >=64 GB), SSD hard disk
   * - Operating system
     - Linux (native) / Windows (ported)
```
