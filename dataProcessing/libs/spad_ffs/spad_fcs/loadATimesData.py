import numpy as np
import pandas as pd
from spad_fcs.FCS2ArrivalTimes import aTimesData
import h5py
import ttp
import os
from spad_tools.listFiles import listFiles
from spad_tools.closefile import closefile


def loadATimesData(fname, channels=21, sysclk_MHz=240):
    """
    Load multichannel arrival times data from .hdf5 file and store in data object
    for further processing
    ===========================================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    fname       Filename [.hdf5]
                containing the tables ['det0', 'det1', 'det2', ..., 'det20']
                with each table containing the macro and microtimes
    channels    Either number describing the number of channels (typically 21)
                or list of channels that have to be loaded, e.g. [15, 17, 18]
    ===========================================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    data        Data object with a field for each channel
                Each field contains a [Np x 2] np.array
                with Np the number of photons,
                column 1 the absolute macrotimes,
                column 2 the absolute microtimes
    ===========================================================================
    """
    
    if isinstance(channels, int):
        # total number of channels is given, e.g. 21
        Nchannels = channels
        channels = [str(x) for x in range(channels)]
    else:
        # individual channel numbers are given, e.g. [15, 17, 18]
        channels = [str(x) for x in channels]
    
    data = aTimesData()
    
    if fname[-4:] == "hdf5":
        with h5py.File(fname, 'r') as f:
            for ch in channels:
                print('Loading channel ' + ch)
                setattr(data, 'det' + ch, f['det' + ch][()])
        f.close()
    elif fname[-2:] == "h5":
        calibDict=ttp.calculateCalibFromH5(filenameH5=fname, listChannel=range(0,Nchannels))
        data = aTimesData()
        for ch in channels:
            print('Loading channel ' + ch)
            df = ttp.applyCalibDict(fname, channel=int(ch), calibDict=calibDict)
            macrotime = df['cumulative_step'] / (1e6 * sysclk_MHz) * 1e12
            microtime = df['dt_' + ch]            
            setattr(data, 'det' + ch, np.transpose([macrotime, microtime]))
        closefile(fname)
    
    return data


def writeATimesData(data, channels, fname):
    """
    Write multichannel arrival times data to .hdf5
    ===========================================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    data        Arrival times data, i.e. output from loadATimesDataPandas()
    channels    Either number describing the number of channels (typically 21)
                or list of channels that have to be loaded, e.g. [15, 17, 18]
    fname       Filename [.hdf5]
    ===========================================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    data        Data object with a field for each channel
                Each field contains a [Np x 2] np.array
                with Np the number of photons,
                column 1 the absolute macrotimes,
                column 2 the aboslute microtimes
    ===========================================================================
    """
    if isinstance(channels, int):
        # total number of channels is given, e.g. 21
        channels = [str(x) for x in range(channels)]
    else:
        # individual channel numbers are given, e.g. [15, 17, 18]
        channels = [str(x) for x in channels]
    
    with h5py.File(fname, 'w') as f:
        for ch in range(21):
            f.create_dataset('det' + str(ch), data=getattr(data, 'det' + str(ch)))


def loadATimesDataPandas(fname, chunksize=1000000, macroFreq=240e6):
    """
    Load multichannel arrival times data from h5 file and store in data object
    for further processing
    ===========================================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    fname       Filename
    chunksize   Number of rows to read in a single chunk
    macroFreq   Conversion factor to go from relative macrotimes to absolute
                macrotimes
    ===========================================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    data        Data object with a field for each channel
                Each field contains a [Np x 2] np.array
                with Np the number of photons,
                column 1 the absolute macrotimes,
                column 2 the absolute microtimes
    ===========================================================================
    """

    # convert macrotime frequency to macrotime step size
    macroStep = 1 / macroFreq
    
    # read hdf file
    dataR = pd.read_hdf(fname, iterator=True, chunksize=chunksize)
    
    # number of data chunks to read
    Nchunks = int(np.ceil(len(dataR.coordinates) / chunksize))
    
    myIter = iter(dataR)
    
    chunk = 1
    for dataChunk in myIter:
        print('Loading data chunk ' + str(chunk) + '/' + str(Nchunks))
        if chunk == 1:
            # initialize data object
            data = aTimesData()
            listOfChannels = [name[12:] for name in dataChunk.columns if name.startswith('microtime_ch')]
            for chNr in listOfChannels:
                setattr(data, "det" + chNr, np.array([]))
        # go through each channel
        cumstep = dataChunk['cumulative_step']
        for chNr in listOfChannels:
            dataSingleCh = dataChunk['microtime_ch' + chNr]
            microtime = dataSingleCh[dataSingleCh.notna()]
            macrotime = macroStep * cumstep[dataSingleCh.notna()]
            dataSingleCh = np.transpose([macrotime, microtime])
            dataSingleChTot = getattr(data, "det" + chNr)
            setattr(data, "det" + chNr, np.vstack([dataSingleChTot, dataSingleCh]) if dataSingleChTot.size else dataSingleCh)
        chunk += 1
    
    return data


def aTimesH5toHDF5(fname, chunksize=1000000, macroFreq=240e6, channels=21):
    """
    Load multichannel arrival times data from .h5 file, remove NaN and
    store as .hdf5 file
    ===========================================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    fname       .h5 filename
    chunksize   Number of rows to read in a single chunk
    macroFreq   Conversion factor to go from relative macrotimes to absolute
                macrotimes
    ===========================================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    .hdf5 file
    ===========================================================================
    """
    data = loadATimesDataPandas(fname, chunksize, macroFreq)
    writeATimesData(data, channels, fname[:-3] + '.hdf5')


def aTimesRaw2H5All(folder, sysclk_MHz=240, laser_MHz=40, Nch=21, destinationFolder=""):
    """
    Load multichannel arrival times data from raw data files and store as .h5
    files. Repeat this for all raw data files in a given folder.
    
    +------------------------------------------------------------------------+
    | > THIS IS USUALLY THE FIRST FUNCTION TO CAlL AFTER A TTM MEASUREMENT < |
    +------------------------------------------------------------------------+
    
    Note: this function expects the files to have the .ttm file extension
    Change this manually if not the case
    ===========================================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    folder      Folder to look into
    sysclk_MHz  System clock frequency [MHz]
    laser_MHz   Laser clock frequency [MHz]
    Nch         Number of channels
    destinationFolder   Location to store the .h5 file
                If left empty, the current working directory will be taken
    ===========================================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    .h5 file    Each file will be converted to a .h5 file
    ===========================================================================
    """
    
    files = listFiles(directory=folder, filetype='ttm', substr=False)
    
    for file in files:
        aTimesRaw2H5(file, sysclk_MHz=sysclk_MHz, laser_MHz=laser_MHz, Nch=Nch, destinationFolder=destinationFolder)
    print("All files converted.")


def aTimesRaw2H5(fname, sysclk_MHz=240, laser_MHz=40, Nch=21, destinationFolder=""):
    """
    Load multichannel arrival times data from raw data file and store as .h5
    file.
    ===========================================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    fname       Raw data file name
    sysclk_MHz  System clock frequency [MHz]
    laser_MHz   Laser clock frequency [MHz]
    Nch         Number of channels
    destinationFolder   Location to store the .h5 file
                If left empty, the current working directory will be taken
    ===========================================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    .h5 file
    ===========================================================================
    """
    
    list_of_channels=np.arange(0,Nch)
    
    if destinationFolder == "":
        destinationFolder = os.getcwd()
    
    ttp.convertDataRAW(filenameToRead = fname,
                                sysclk_MHz = sysclk_MHz,
                                laser_MHz = laser_MHz,
                                list_of_channels = list_of_channels, # list of channel [0,1,2,3]
                                compressionLevel = 1,                # Compression HDF5 file
                                #metadata=metadataDict,              # If present append metadata to the HDF5
                                destinationFolder = "",              # If not selected the default output folder is filenameFolder/output/
                                ignorePixelLineFrame = True,         # Does not calculate x,y,frame
                                )
    print('Done.')


def H5aTimes2data(fname, Nch, sysclk_MHz=240):
    """
    Load multichannel arrival times data from h5 file and store in data object
    for further processing - newer version
    ===========================================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    fname       File name
    Nch         Number of channels
    sysclk_MHz  System clock frequency [MHz]
    ===========================================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    data        Data object with a field for each channel
                Each field contains a [Np x 2] np.array
                with Np the number of photons,
                column 1 the absolute macrotimes,
                column 2 the absolute microtimes
    ===========================================================================
    """
    calibDict=ttp.calculateCalibFromH5(filenameH5=fname, listChannel=range(0,Nch))
    data = aTimesData()
    for ch in range(Nch):
        print('Loading channel ' + str(ch))
        df = ttp.applyCalibDict(fname, channel=ch, calibDict=calibDict)
        
        macrotime = df['cumulative_step'] / (sysclk_MHz * 1e6)
        microtime = df['dt_' + str(ch)]
        
        setattr(data, 'det' + str(ch), np.transpose([macrotime, microtime]))
    
    return data
