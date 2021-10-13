import numpy as np

def binData(data, binsize):
    """
    Sum elements in "data" in groups of size "binsize", creating a new vector
    with summed data

    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    data        Vector with data
    binsize     Number of data points per bin
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    bdata       Binned data
    ==========  ===============================================================
    """

    cumdata = np.array(np.zeros([1, np.size(data, 1)]), dtype="uint32")
    cumdata = np.append(cumdata, np.uint32(np.cumsum(data, axis=0)), axis=0)
    bdata = cumdata[0::binsize, :]
    
    for i in range(np.size(data, 1)):
        bdata[0:-1, i] = np.ediff1d(bdata[:, i])
        
    bdata = bdata[0:-1]
    
    return bdata


def binDataChunks(data, binsize):
    bdata = np.empty((0, np.size(data, 1)), int)
    N = np.size(data, 0)
    chunksize = int(binsize * np.floor(10e6 / binsize))
    Nchunks = int(np.floor(N/chunksize))
    for i in range(Nchunks):
        print("Chunk " + str(i+1) + " of " + str(Nchunks))
        newbindata = binData(data[i*chunksize:(i+1)*chunksize, :], binsize)
        np.size(newbindata)
        bdata = np.append(bdata, newbindata, axis=0)
    return bdata