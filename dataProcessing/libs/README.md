# Requirements
You can install the libraries where and how you prefer. In Linux distributions you can install directly system-wide, or if you prefer you can install in avirtualenv. In Windows OS it is strongly suggest to use Anaconda python distribution.


## Linux distributions (Debian/Ubuntu/Mint)
### Create virtual enviroment with virtualenv

```
sudo apt-get install virtualenv git python3-dev python3-venv ipython3
```
Then you can create your enviroment

```
python3 -m venv ttm-env
```
In order to activate the virtualenv:

```
. ttm-env/bin/activate
```

In order to install the requirements needed for both libttp, spad_ffs you need to run
```
pip3 install numpy pandas scipy tqdm setuptools matplotlib jupyterlab cython joblib multipletau h5py
```

## Windows/Linux 
### Create virtual enviroment with Anaconda / Conda.

You can create an env or use the "base" env. In order to install the requirements needed for both libttp, spad_ffs you need to run

```
conda install numpy pandas scipy tqdm setuptools matplotlib jupyterlab cython install joblib h5py
pip install multipletau
```


# How to install libttp and spad_ffs?

Link to [libttp](libttp/README.md).

Link to [spad_ffs](spad_ffs/README.md).

# How to install the MIPLIB library?

The MIPLIB library is needed to run the "ISM Decay Reconstruction BrightEyes" example. Please follow the instructions at the following link: https://github.com/VicidominiLab/miplib


