from readBinFile import readBinFile
from u64ToCounts import u64ToCounts
import numpy as np
import os
from savevar import savevar


class ArrivalTimesObject:
    pass


def binFile2ArrivalTimes(fname, storePickle=False, dwellTime=[]):
    """
    Read a binary FCS data file, containing a list of U64 numbers that
    represent the photon counts per microtime bin of about 1 µs and store the
    arrival times in units of dwellTime.
    Storing arrivaltimes in general reduces the file size significantly
    ===========================================================================
    Input           Meaning
    ---------------------------------------------------------------------------
    fname           Binary file name
    storePickle     Store result in Pickle file
    dwellTime       Pixel dwell time [s]
    ===========================================================================
    Output          Meaning
    ---------------------------------------------------------------------------
    arrivalTimes    26 lists with the arrival times of the photon for each of
                    the 25 detector elements + the sum
    ===========================================================================
    """


    readLength = 8 * 65536

    # Get file size [in bytes]
    fsize = os.path.getsize(fname)

    # Empty object to store photon arrival times
    arrivalTimes = ArrivalTimesObject()
    for i in range(25):
        setattr(arrivalTimes, 'det' + str(i), [])
    arrivalTimes.sum = []
    arrivalTimes.dwellTime = dwellTime

    startPos = 0  # position in the .bin file to start reading
    t = 0  # iterator used to indicate current time bin

    # Go through the file, read a chunk of data, write to the object, and repeat
    while startPos < fsize:
        print(startPos/fsize*100)
        # Read part of the binary file
        data = readBinFile(fname, startPos, readLength)
        startPos += readLength

        # Calculate photon counts
        for i in range(len(data)):
            counts = u64ToCounts(data[i])
            # go through each detector element
            for det in range(25):
                for c in range(counts[det]):
                    getattr(arrivalTimes,
                            'det' + str(det)).append(int(np.floor(t/2)))
            # sum of all detector elements
            for c in range(counts[25]):
                arrivalTimes.sum.append(int(np.floor(t/2)))
            t += 1

    print(100)

    if storePickle:
        print("Storing .pickle file")
        savevar(arrivalTimes, fname[0:-4] + "_arrival_times.pickle")
        print(".pickle file stored")

    return arrivalTimes
