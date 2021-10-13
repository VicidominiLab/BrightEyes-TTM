import numpy as np
from savevar import savevar


class dataObj:
    pass

def readBHhist(fname, storePickle=False):
    """
    Read an ascii BH histogram file
    ===========================================================================
    Input       Meaning
    ---------------------------------------------------------------------------
    fname       *asc file name
    ===========================================================================
    Output      Meaning
    ---------------------------------------------------------------------------
    hist        np.array with histogram
    ===========================================================================

    """

    # OPEN FILE
    print("Opening .asc file.")
    with open(fname, mode='r') as file:
        rawdata = file.read()
    print("File opened.")
    
    # CREATE DATA OBJECT
    data = dataObj()

    # SEARCH FCS VALUE
    start = rawdata.find("*BLOCK ")
    if start == -1:
        # no fcs data found
        pass
    else:
        start = rawdata.find("\n", start) + 1
        stop =  rawdata.find("*END", start)
        Npoints = rawdata.count("\n", start, stop)
        histogr = np.zeros(Npoints)        
        for i in range(Npoints):
            stop = rawdata.find("\n", start)
            I = float(rawdata[start:stop])
            histogr[i] = I
            start = stop + 1
        
    if storePickle:
        print("Storing .pickle file")
        savevar(data, fname[0:-4] + "_BHdata")
        print(".pickle file stored")
    
    return histogr
