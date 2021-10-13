# License

The Time-Tagging Module (TTM) is an aggregation of different parts with different licenses.

**Unless otherwise stated, they are licensed under a CC-BY-NC 4.0**, 
Creative Commons Attribution-NonCommercial 4.0 International License. [![License: CC BY-NC 4.0](https://licensebuttons.net/l/by-nc/4.0/88x31.png)](https://creativecommons.org/licenses/by-nc/4.0/)

**Please note the following exceptions.**

[FX3 interface module](FPGA/ttm/hdl/to_fxr_workaround.v):
the Verilog module used to interface the FPGA to the Cypress FX3, is derived 
from the Cypress Application note AN65974 - Designing with the EZ-USB™ FX3
slave FIFO interface https://www.cypress.com/documentation/application-notes/an65974-designing-ez-usb-fx3-slave-fifo-interface is under a Cypress License.

[SYLAP](FPGA/ttm/hdl/sylap/):
SYLAP (Simulate Your Laser and Photons) is not part of the TTM module as
it can be disactivated in the top level of the FPGA code. The is has been
aggregated to the TTM for debugging purpose. The license of SYLAP it is 
the License GPLv2.1 the original repository is https://github.com/VicidominiLab/SYLAP

[Data Receiver for Linux](dataReceiver/linux/):
is the License GPLv2 as derivates from cyusb_linux_1.0.5 which is part of
the Cypress EZ-USB FX3 SDK 1.3.4 for Linux. It can be downloaded from 
https://www.cypress.com/documentation/software-and-drivers/ez-usb-fx3-software-development-kit
and it can be found also here https://github.com/Ho-Ro/cyusb_linux 

[Data Receiver for Windows](dataReceiver/windows/):
is the License GPLv2 as derivates from cyusb_linux_1.0.5 which is part of
the Cypress EZ-USB FX3 SDK 1.3.4 for Linux and then adapted to Windows. 
This version uses also libUSB and POSIX Threads for Win32 libraries both
under LGPLv2.1.

[SPAD-FFS libraries](dataProcessing/libs/spad_ffs/):
the libraries for the analysis of confocal laser-scanning microscopy based fluorescence 
fluctuation spectroscopy (FFS) data analysis is under a BSD-3-Clause. The original version 
is https://github.com/VicidominiLab/spad-ffs


The a copy of the text of the above mentioned licenses can be found in the folder [license/](license/).

# Copyright

Time-Tagging Module
Copyright (c) 2021, Molecular Microscopy & Spectroscopy,
Italian Institute of Technology. All rights reserved.
