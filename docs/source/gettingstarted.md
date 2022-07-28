# Getting started
In this section you will find the hardware and software needed to build and run the BrightEyes-TTM.

## Microscope
The BrightEyes-TTM can be connected to commercial or custom imaging microscopes as long as they provide the following synchronization outputs:
|   |    |
|------|-----|
| Laser SYNC | needed |
| Pixel | needed <br /> for imaging |
| Line | needed <br /> for imaging |
| Frame | needed <br /> for imaging |

...and of course the detector signals.

The FPGA synchronization inputs have LVTTL level so if you need to adapt the signal see "MPD NIM 2 TTL" and "8xDigiBuffer" in the Hardware list here below.

### Detector
The BrightEyes-TTM channel inputs supports either LVTTL or LVDS level input signals. Depending from the type of signal you will need to use a specific firmware and a specific version of "I/O to FMC adapter board" in the Hardware list here below. This means that the BrightEyes-TTM can use as input channel PMT (+CFD) or APD, and of course SPAD array detectors. BrightEyes-TTM has been designed for SPAD prototype with 25 channel (LVTTL levels) and for commercial SPAD with 49 channel (LVDS levels). 

## Hardware
Here the list of the hardware requirments.

|      |     |     |
|------|-----|-----|
|PC  <br /> Minimum Requirements:  <br /> USB 3.0, >= 1.5 GHz CPU, <br /> >= 16 GB RAM, SSD hard disk, |  commercial   | needed <br /> (strongly suggested<br /> Linux OS)   |
|[Xilinx Kintex-7 KC705 evaluation board](FPGABoard.md)| commercial  | |
|[Cypress FX3™ SuperSpeed Explorer Kit](FMCAdapter.md)| commercial  | |
|[I/O to FMC adapter board](IOConnectorBoard.md) | custom |      |
|[MPD NIM 2 TTL](NIM2TTL.md) | commercial| strongly suggested   |
|[8xDigiBuffer](DigiBuffer.md) | custom | strongly suggested | 

## Firmware
Here the list of the firmwares needed to use the BrightEyes-TTM.

|      |     |
|------|-----|
|[Cypress FX3™ SuperSpeed Explorer Kit](USB3.md)| firmware external  |
|[BrightEyes-TTM](FPGABoard.md) | firmware custom and open-source  |

## Software

```{note}
The software to acquire data and the script to analyze tham was developed is Linux native. Even if it should run in Windows 10 / 11 we strongly suggest to use it on a Linux distribution Debian derivate (Debian 11, Ubuntu 20.04 LTS, Linux Mint 20.3 etc...).
```

### Data Acquisition
|      |     |
|------|-----|
| [datareceiver](datareceiver.md) | Linux / Windows |


### Data Analysis libraries
The `libttp` is needed in order to convert the raw data from the BrightEyes-TTM acquisition to a dataframe or a HDF5 file. The `spadffs` are needed instead for perform FCS analysis. More details here [BrightEyes-TTM libraries](dataprocessing.md).


### Data Processing (Python Notebooks)
The data processing example are given here:
|      |     |
|------|-----|
| [BrightEyes-TTM dataprocessing](dataprocessing.md) | Python Notebook examples |

