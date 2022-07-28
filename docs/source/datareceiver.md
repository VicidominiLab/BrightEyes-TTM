# Data Receiver

There are two version of the BrightEyes-TTM data receiver. The "Old Protocol" version for the firmware (v1.0)  and the "New Protocol" version for the firmware (v2.0). The data receiver the libraries _libusb_ and save the stream of data from USB 3.0 to a raw file. We suggest to use the Linux version but it is available also a Windows porting. Link to the folder in the repository [dataReceiver](https://github.com/VicidominiLab/BrightEyes-TTM/tree/v2.0/dataReceiver).


## DataReceiver Linux


### Requirements

```
sudo apt-get install libusb-dev libusb-1.0-0-dev
```

### How to compile?

```
(Legacy Protocol - Bright-TTM firmware v1.0)
gcc "dataReceiver.c" -O2 -g `pkg-config libusb-1.0 --libs --cflags`  -lpthread -o "dataReceiver"
```
```
("new" Protocol - Bright-TTM firmware >=v2.0)
gcc "dataReceiver-newProt.c" -O2 -g `pkg-config libusb-1.0 --libs --cflags`  -lpthread -o "dataReceiver-newProt"
```

### How to run?

The software crash if the subfolder **data/** is it not present in the folder where the **dataReceiver** is executed.
Create the  **data/** folder:

```
mkdir data
```

Then you can run

```
(Legacy Protocol - Bright-TTM firmware v1.0)
./dataReceiver
```

or 

```
("new" Protocol - Bright-TTM firmware >=v2.0)
./dataReceiver-newProt
```

:::{figure} img/dataReceiver/dataReceiverNew.png
:align: center
:width: 100%
Fig. The dataReceiver-newProt running in Linux
:::




---

## DataReceiver Windows (only firmware v1.0)


The DataReceiverW is the porting of the DataReceiver for Linux to Windows. It based on the libusb-win32 driver and it is in an experimental phase.
The installation of the libusb-win32 drivers can be done with the tool Zadig. It is a software that allows to install and to switch different drivers on the USB devices in Windows. It can be downloaded the site https://zadig.akeo.ie/ .

### How to install libusb-32 driver in Windows 10

* Download Zadig from  https://zadig.akeo.ie/ 
* Run Zadig and grant the permission to change your system.

:::{figure} img/dataReceiver/zadig_0.png
:align: center
:width: 50%
:::


:::{figure} img/dataReceiver/zadig_1.png
:align: center
:width: 100%
:::

:::{figure} img/dataReceiver/zadig_2.png
:align: center
:width: 100%
:::


Select in the menu **Options --> List All Devices**

:::{figure} img/dataReceiver/zadig_3.png
:align: center
:width: 100%
:::


Select in the list of devices **FX3** 

:::{figure} img/dataReceiver/zadig_4.png
:align: center
:width: 100%
:::


Select in the scrollbox **libusb-win32** and click on **"Replace Driver"** and wait for the installation

:::{figure} img/dataReceiver/zadig_5.png
:align: center
:width: 100%
:::

:::{figure} img/dataReceiver/zadig_6.png
:align: center
:width: 100%
:::

Now the libusb-win32 drivers should be correctly installed.

### How to run DataReceiverW

:::{figure} img/dataReceiver/datawriterW.png
:align: center
:width: 100%
:::


The **dataReceiverW.exe** executable file is present in the repository at the following link [dataReceiverW (v1)](https://github.com/VicidominiLab/BrightEyes-TTM/tree/v2.0/dataReceiver/windows/v1/bin) and [dataReceiverW-newProt (v2)](https://github.com/VicidominiLab/BrightEyes-TTM/tree/v2.0/dataReceiver/windows/v2/bin). It is a command-line interface CLI software, so it is suggested to run into a Command Prompt (cmd.exe). To run correctly the dataReceiverW needs the library **libpthread.dll** and **libusb-1.0.dll**. The software crash if the subfolder **data\\** is it not present in the folder where the dataReceiverW is executed. 
