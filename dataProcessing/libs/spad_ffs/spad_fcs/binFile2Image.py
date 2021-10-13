import numpy as np
from savevar import savevar


class arrivalTimes:
    pass

def binFile2Image(fname, storePickle=False):
    """
    Read a binary image data file, containing a list of U64 numbers that
    represent the photon counts per microtime bin of about 1 µs per pixel.

    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    fname       Binary file name
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    countArray  N x 26 array with for each row the number of photon counts
                for each channel and the sum of all channels per microbin
    ==========  ===============================================================
    """

    from readBinFile import readBinFile
    from u64ToCounts import u64ToCounts
    import os

    readLength = 8 * 65536

    # Image dimensions
    Nf = 1      # number of frames
    Nl = 500    # number of lines
    Np = 500    # number of pixels per line
    Nt = 10     # number of time bins per pixel
    Nd = 25     # number of detector element rows

    # Get file size [in bytes]
    fsize = os.path.getsize(fname)

    # Empty array to store photon counts
    countArray = np.zeros((Nf, Nl, Np, Nt, Nd+1), dtype='H')

    startPos = 0  # position in the .bin file to start reading
    frame = 0  # row of countArray to write to
    scany = 0
    scanx = 0
    timebin = 0
    cluster = 0

    # Go through the file, read a chunk of data, write to the array, and repeat
    while startPos < fsize:
        print(startPos/fsize*100)
        # Read part of the binary file
        data = readBinFile(fname, startPos, readLength)
        startPos += readLength

        # Calculate photon counts
        for i in range(len(data)):
            counts = u64ToCounts(data[i])
            # add counts to array
            # sum two clusters
            clusterSum = np.add(countArray[frame][scany][scanx][timebin][:], counts)
            countArray[frame][scany][scanx][timebin][:] = clusterSum
            cluster += 1
            if cluster == 2:
                cluster = 0
                timebin += 1
            if timebin == Nt:
                timebin = 0
                scanx += 1
            if scanx == Np:
                scanx = 0
                scany += 1
            if scany == Nl:
                scany = 0
                frame += 1
    print(100)
    
    if storePickle:
        print("Storing .pickle file")
        savevar(countArray, fname[0:-4] + "_data")
        print(".pickle file stored")
    
    return countArray
