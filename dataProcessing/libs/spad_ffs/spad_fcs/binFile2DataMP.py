from readBinFile import readBinFile
from u64ToCounts import u64ToCounts
import numpy as np
import os
import multiprocessing as mp
from multiprocessing import Pool
from functools import partial


def binFile2DataMP(fname, storePickle=False):
    """
    Read a binary FCS data file, containing a list of U64 numbers that
    represent the photon counts per microtime bin of about 1 µs.

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

    # Check number of cpu's
    Ncpu = mp.cpu_count()

    # User 75% of the cpu's
    Ncpu = int(np.floor(0.75 * Ncpu))

    readLength = 8 * 65536

    # Get file size [in bytes]
    fsize = os.path.getsize(fname)

    # Empty array to store photon counts
    # countArray = np.zeros((int(np.ceil(fsize/2/8)), 26), dtype='H')

    # multiprocessing function
    func = partial(f, fname, readLength)

    Nclust = np.ceil(fsize/readLength)
    with Pool(Ncpu) as p:
        countArray = p.map(func, (np.arange(Nclust)).tolist())
        p.close()
        p.join()

    countArray = np.concatenate(countArray, axis=0)

    return countArray


def f(fname, readLength, clustNumb):
    # Calculate photon counts in a chunck of data
    clustNumb = int(clustNumb)
    row = 0
    startPos = clustNumb * readLength
    data = readBinFile(fname, startPos, readLength)
    countArrayClust = np.zeros((int(len(data) / 2), 26), dtype='H')
    for i in range(len(data)):
        counts = u64ToCounts(data[i])
        # add counts to array
        countArrayClust[int(np.floor(row/2))][:] = np.add(
                countArrayClust[int(np.floor(row/2))][:],
                counts)
        row += 1
    return countArrayClust
