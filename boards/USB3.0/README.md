# USB data transmission chip

The BrightEyes-TTM design transmits the data to the PC via USB 3.0, a [FX3-based board](/boards/USB3.0/mainboard) (Fig.1 - Cypress SuperSpeed Explorer kit board, CYUSB3KIT) connected through an [adapter card (CYUSB3ACC)](/boards/USB3.0/FMCadapter) to LPC-FMC connector of the Kintex-7 evaluation board. In order to use the FX3 chip, a dedicated module in the FPGA was developed. It has a simple interface (essentially FIFO with a data-valid flag) for the data transmission and it manages the FX3 control signals and the data-bus. The module was designed to work with the FX3 programmed with the SF\_streamIN firmware part of the [AN65974](https://www.cypress.com/documentation/application-notes/an65974-designing-ez-usb-fx3-slave-fifo-interface) example provided by Cypress.

The [Cypress SuperSpeed Explorer kit Board](/boards/USB3.0/mainboard) and its [FMC adapter connector card](/boards/USB3.0/FMCadapter) for the FPGA board are available at these links:

- [Cypress SuperSpeed Explorer kit](https://www.cypress.com/documentation/development-kitsboards/cyusb3kit-003-ez-usb-fx3-superspeed-explorer-kit)

- [FMC adapter card](https://www.cypress.com/documentation/development-kitsboards/cyusb3acc-005-fmc-interconnect-board-ez-usb-fx3-superspeed)

The Cypress SuperSpeed Explorer kit main board has to be programmed, to work with TTM FPGA firmware, with the SF_streamIN, which is part of the Cypress Application Note "AN65974 - Designing with the EZ-USB™ FX3". The file AN65974.zip which contains the firmware SF_streamIN.img can be downloaded from this [link](https://www.cypress.com/documentation/application-notes/an65974-designing-ez-usb-fx3-slave-fifo-interface). This allow for the acquired data to be trasmitted to a host-PC.

<figure>
  <img src="/docs/img/FX3_Cypress.PNG" alt="Cypress SuperSpeed Explorer kit" width="250"/>
  <figcaption>Fig.1 - Cypress SuperSpeed Explorer kit</figcaption>
</figure>

Follow the [Quick start guide](https://www.cypress.com/file/133861/download) or Fig.2 below on how to interconnect the different components.

<figure>
  <img src="/docs/img/USBchip_adapter_assembly.PNG" alt="I/Os SMA-FMC connector Board" width="3500"/>
  <figcaption>Fig.2 - Assembly for CYUSB3ACC-005 FMC Interconnect Board and the EZ-USB® FX3™ SuperSpeed Explorer Kit</figcaption>
</figure>
