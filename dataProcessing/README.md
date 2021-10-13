# Python libraries for data processing

In order to be able to reconstruct and process the data streamed by the BrightEyes-TTM few python libraries have to be previously installed in the host-processing computer. 

Follow the links below for downloading and installing the required librares.

- TTM library for reconstructing and calibrating time-tagging data streamet by the BrightEyes-TTM to the host-PC - [lipttp](/dataProcessing/libs/libttp)

- FFS library for reconstructing the correlation curve and implementing FCS - [spad_ffs](/dataProcessing/libs/spad_ffs)

# Data analysis

Data is acquired in a RAW format from the TTM using the same data protocol for all the possible and different applications. Then depending on the type of information/application needed is unpacked, calibrated and reconstructed (Fig.1).

<figure>
  <img src="/docs/img/DataProcessing.PNG" alt="Xilinx FPGA Board" width="3500"/></br>
  <figcaption>Fig.1 - Data processing procedure</figcaption></br></br>
</figure>


In order to give the user some preliminary tools to process, reconstruct and use the acquired TTM data we developed 3 main examples using Jupyter Notebook and we provide the associated examples dataset on [Zenodo](https://doi.org/10.5281/zenodo.4912656):

1. **TCSPC histogram**

Thanks to the [TCSPC histogram reconstruction Jupyter Notebook example](/dataProcessing/pynotebook/TCSPC_Histogram_reconstruction.ipynb) it is possible to reconstruct and look the data from a simple spectroscopy point of view by building the TCSPC histogram for all the acquired channels. Checkout also the pdf version of the TCSPC histogram reconstruction Jupyter Notebook example - [TCSPC_Histogram_reconstruction.pdf](/dataProcessing/pynotebook/PDF/TCSPC_Histogram_reconstruction.pdf).

2. **Imaging**

If pixel,line and frame clocks are connected to the BrightEyesTTM then intensity images as well as FLIM images can be reconstructed too. The [image reconstruction Jupyter Notebook example](/dataProcessing/pynotebook/Image_reconstruction.ipynb) shows all the steps to reconstruct a **4D dataset (x,y,t,ch)** and visualize microscopy images. Checkout also the pdf version of the image reconstruction Jupyter Notebook example - [Image_reconstruction.pdf](/dataProcessing/pynotebook/PDF/Image_reconstruction.pdf).

  
3. **FCS**

If the final goal of the measurement is to retrieve information from the correlation curve the [FCS Jupyter Notebook example](/dataProcessing/pynotebook/FCS.ipynb) shows how to calculate the correlation curve. Checkout also the pdf version of the FCS Jupyter Notebook example - [FCS.pdf](/dataProcessing/pynotebook/PDF/FCS.pdf).

4. **ISM & FLIM-Phasor analysis**

This Jupyter notebook example can be used for implementing the pixel reassignment algorithm for image scanning microscopy (ISM) applications and for performing FLIM-phasor analysis with time-resolved data. After having used the [image reconstruction Jupyter Notebook example](/dataProcessing/pynotebook/Image_reconstruction.ipynb) for reconstructing a 4D dataset (x,y,t,ch) it is possible to feed this dataset into the [ISM & FLIM-phasor notebook](/dataProcessing/pynotebook/ISM_Decay_Reconstruction_BrightEyes-TTM_v1_opensource.ipynb). NB - time alignment of the fluorescence lifetime decays is required, accross the different available channels (ch), before feeding a 4D dataset into this notebook.


# Zenodo

| Name | Associated example dataset on Zenodo |
| ------ | ------ |
| TSCPC Histogram | **Fluorescence_Spectroscopy_Dataset_40MHz** [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4912656.svg)](https://doi.org/10.5281/zenodo.4912656) |
| Imaging | **FLIM_512x512pixels_dwelltime250us_Dataset_40MHz** [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4912656.svg)](https://doi.org/10.5281/zenodo.4912656) |
| FCS | **FCS_scanfcs_Dataset_40MHz** [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4912656.svg)](https://doi.org/10.5281/zenodo.4912656) |
