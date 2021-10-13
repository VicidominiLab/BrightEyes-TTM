# SPAD-FFS

Pyhon code for the analysis of confocal laser-scanning microscopy based fluorescence fluctuation spectroscopy (FFS) data. The code is designed to analyze FFS data obtained with a 5x5 pixel SPAD array detector, instead of the typical point-detector. Includes code for:

- reading raw data files
- calculating autocorrelations and cross-correlations
- fitting the correlation curves with various fit models

## How do I use it?

Under Examples, a Jupyter notebook is available with an example. The raw data set used here is available on [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4161418.svg)](https://doi.org/10.5281/zenodo.4161418). This data set contains the fluorescence intensity time traces for the 25 pixels for a freely diffusing antibody conjugated Alexa 488 dye. The time traces can be analyzed in various ways, such as spot-variation FCS, two-focus or pair-correlation FCS, and intensity mean-squared-displacement analysis.

## How to install?


* If you are using python in anaconda (or conda)

    Before you need to install the requirements:

    ```
    conda install numpy pandas scipy tqdm setuptools matplotlib jupyterlab cython joblib h5py
    pip install multipletau 
    ```
    
    Then you can install the library:

    ```
    python setup.py install
    ```

* if you are NOT using python in anaconda (or conda)

    Before you need to install the requirements:

    (Please note that in some OS "pip3" is "pip", and "python3" is "python")


    ```
    pip install -r requirements.txt
    ```   

    If you are using a virtualenv or similar you can install with the following command
    
    ```
    python setup.py install
    ```

    If you want to install directly in to the system
    ```
    python setup.py install --user
    ```


## Only for dev

If you are going to modify the library code directly into the folder where you extract it you can use the following command

```
cd spad_ffs
python setup.py develop --user
```



