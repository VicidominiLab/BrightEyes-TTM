# libttp

The python libraries for the TTM (Time Tagging Module)

### Installation
Go to in to the folder wher you downloaded libttp in this example (/home/test/Downloads/timetaggingplatform/dataProcessing/libs/libttp)
```
cd /home/test/Downloads/timetaggingplatform/dataProcessing/libs/libttp
```
then install the requirements

* if you are using python in anaconda (or conda):

    ```
    conda install numpy pandas scipy tqdm setuptools matplotlib jupyterlab cython h5py
    ```
* if you are NOT using python in anaconda (or conda):
    ```
    pip3 install -r requirements.txt 
    ```

    or (depending by OS)

    ```
    pip install -r requirements.txt 
    ```

The requirements shoud be installed.

Now,
```
python3 setup.py install
```
And finally in your environment ipython3 or jupyter should be able to
```
import ttp
```
without errors.
