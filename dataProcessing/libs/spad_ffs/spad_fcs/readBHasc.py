import numpy as np
from savevar import savevar


class dataObj:
    pass

def readBHasc(fname, storePickle=False):
    """
    Read an ascii BH FCS file which contains the autocorrelation curve and
    return this curve

    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    fname       *asc file name
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    data        Object containing information about the FCS file
    ==========  ===============================================================
    """

    # OPEN FILE
    print("Opening .asc file.")
    with open(fname, mode='r') as file:
        rawdata = file.read()
    print("File opened.")
    
    # CREATE DATA OBJECT
    data = dataObj()

    # SEARCH FCS VALUE
    start = rawdata.find("FCS_value")
    if start == -1:
        # no fcs data found
        pass
    else:
        start = rawdata.find("\n", start) + 1
        stop =  rawdata.find("*END", start)
        Npoints = rawdata.count("\n", start, stop)
        G = np.zeros([Npoints, 2])
        Gn = np.zeros([Npoints, 2])
        for i in range(Npoints):
            stop = rawdata.find(" ", start)
            tp = float(rawdata[start:stop])
            start = stop + 1
            stop = rawdata.find("\n", start)
            Gp = float(rawdata[start:stop])
            G[i, 0] = tp
            G[i, 1] = Gp
            Gn[i, 0] = 1e-6 * tp
            Gn[i, 1] = Gp - 1
            start = stop + 1
        data.G = G
        data.Gn = Gn
        
    
    if storePickle:
        print("Storing .pickle file")
        savevar(data, fname[0:-4] + "_BHdata")
        print(".pickle file stored")
    
    return data
