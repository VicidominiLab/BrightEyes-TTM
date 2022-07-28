# FMC-to-USB Adapter

FMC Interconnect Board for the EZ-USB® FX3™, to connect a Xilinx® FPGA board with the EZ-USB® FX3™ SuperSpeed Explorer Kit

The USB-FMC needs two component the interconnection board and the USB-FX3 chip.

:::{figure} img/USBchip_adapter_assembly.PNG
:align: center
:alt: I/Os SMA-FMC connector Board
:width: 100%

Fig.1 - Assembly for CYUSB3ACC-005 FMC Interconnect Board and the EZ-USB® FX3™ SuperSpeed Explorer Kit
:::

## Interconnect board

- *Brand:* Cypress®
- *Product code:* CYUSB3ACC-005
- *Link to the product:* <https://www.cypress.com/documentation/development-kitsboards/cyusb3acc-005-fmc-interconnect-board-ez-usb-fx3-superspeed>

The [CYUSB3ACC-005 FMC Interconnect Board for the EZ-USB® FX3™ SuperSpeed Explorer Kit](https://www.cypress.com/documentation/development-kitsboards/cyusb3acc-005-fmc-interconnect-board-ez-usb-fx3-superspeed) is used to interconnect with the Xilinx® KC705 Evaluation kit FPGA board with the EZ-USB® FX3™ SuperSpeed Explorer Kit.

Follow the [Quick start guide](https://www.cypress.com/file/133861/download) or Fig.1 below on how to interconnect the different components.

## USB data chip

EZ-USB® FX3™ SuperSpeed Explorer Kit

- *Brand:* Cypress®
- *Product code:* CYUSB3KIT-003 EZ-USB
- *Link to the product:* <https://www.infineon.com/cms/en/product/evaluation-boards/cyusb3kit-003/>


The BrightEyes-TTM design transmits the data to the PC via USB 3.0, a [FX3-based board](https://github.com/VicidominiLab/BrightEyes-TTM/v2.0/main/boards/USB3.0/mainboard) (Fig.1 - Cypress SuperSpeed Explorer kit board, CYUSB3KIT) connected through an [adapter card (CYUSB3ACC)](USB3.md) to LPC-FMC connector of the Kintex-7 evaluation board. In order to use the FX3 chip, a dedicated module in the FPGA was developed. It has a simple interface (essentially FIFO with a data-valid flag) for the data transmission and it manages the FX3 control signals and the data-bus. The module was designed to work with the FX3 programmed with the SF_streamIN firmware part of the [AN65974](https://www.infineon.com/cms/en/design-support/software/code-examples/usb-controllers-code-examples/usb-super-speed-code-examples/) example provided by Cypress.

The [Cypress SuperSpeed Explorer kit Board](https://github.com/VicidominiLab/BrightEyes-TTM/v2.0/main/boards/USB3.0/mainboard) and its [FMC adapter connector card](USB3.md) for the FPGA board are available at these links:

- [Cypress SuperSpeed Explorer kit](https://www.cypress.com/documentation/development-kitsboards/cyusb3kit-003-ez-usb-fx3-superspeed-explorer-kit)
- [FMC adapter card](https://www.cypress.com/documentation/development-kitsboards/cyusb3acc-005-fmc-interconnect-board-ez-usb-fx3-superspeed)
 

#### Firmware

The Cypress SuperSpeed Explorer kit main board has to be programmed, to work with TTM FPGA firmware, with the SF_streamIN, which is part of the Cypress Application Note "AN65974 - Designing with the EZ-USB™ FX3". The file AN65974.zip which contains the **firmware SF_streamIN.img can be downloaded from this** [link](https://www.infineon.com/cms/en/design-support/software/code-examples/usb-controllers-code-examples/usb-super-speed-code-examples/). This allow for the acquired data to be trasmitted to a host-PC.

:::{figure} img/FX3_Cypress.PNG
:align: center
:alt: Cypress SuperSpeed Explorer kit
:width: 50%

Fig.1 - Cypress SuperSpeed Explorer kit
:::

Follow the [Quick start guide](https://www.cypress.com/file/133861/download) or Fig.2 below on how to interconnect the different components.

:::{figure} img/USBchip_adapter_assembly.PNG
:align: center
:alt: I/Os SMA-FMC connector Board
:width: 50%

Fig.2 - Assembly for CYUSB3ACC-005 FMC Interconnect Board and the EZ-USB® FX3™ SuperSpeed Explorer Kit
:::

[CYUSB3KIT-003 EZ-USB® FX3™ SuperSpeed Explorer Kit](https://www.cypress.com/documentation/development-kitsboards/cyusb3kit-003-ez-usb-fx3-superspeed-explorer-kit)

[Programming guide](https://www.cypress.com/file/133836/download) from page #20

Programming firmware [link](https://www.infineon.com/dgdl/Infineon-AN65974-ApplicationNotes-v17_00-EN.zip?fileId=8ac78c8c7cdc391c017d073967ed5de5)
