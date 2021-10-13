import numpy as np
from spad_tools.savevar import openvar


def arrivalTimes2TimeTrace(arrivalTimes):
    """
    Convert a list of arrivalTimes to an intensity time trace I(t) for each of
    the detector elements of the SPAD array detector
    ===========================================================================
    Input           Meaning
    ---------------------------------------------------------------------------
    arrivalTimes    Variable with the arrivalTimes for each detector
                    element (in units of dwellTime)
                    --> output of binFile2ArrivalTimes.py
    ===========================================================================
    Output          Meaning
    ---------------------------------------------------------------------------
    data            N x 26 array with for each row the number of photon counts
                    for each channel and the sum of all channels per microbin
    ===========================================================================
    """

    # Number of time bins
    N = arrivalTimes.sum[-1] + 1

    # Allocate data array
    data = np.zeros((N, 26), dtype='H')

    # Detector elements 0-24
    for det in range(25):
        # Create empty time trace
        timeTrace = np.zeros((N, 1), dtype='H')
        singleCh = getattr(arrivalTimes, 'det' + str(det))
        print('Det' + str(det) + ' -> ' + str(len(singleCh)) + ' photons')
        if len(singleCh) != len(set(singleCh)):
            # there exists a time bin with more than one photon in a single bin
            for i in range(len(singleCh)):
                data[singleCh[i], det] += 1
        elif len(singleCh) == 0:
            # no photons in this channel
            # do nothing
            pass
        else:
            timeTrace[singleCh, 0] = 1
            data[:, det] = timeTrace

    # Sum of all elements
    timeTrace = np.zeros((N, 1), dtype='H')
    singleCh = getattr(arrivalTimes, 'sum')
    print('Sum over all channels' + ' -> ' + str(len(singleCh)) + ' photons')
    if len(singleCh) != len(set(singleCh)):
        # there exists a time bin with more than one photon in a single bin
        for i in range(len(singleCh)):
            data[singleCh[i], 25] += 1
    else:
        timeTrace[singleCh, 0] = 1
        data[:, 25] = timeTrace

    return data


def arrivalTimes2Data(fname):
    """
    Import .pickle file with arrival time data for each channel and convert to
    normal data array
    """
    aTimes = openvar(fname)
    data = arrivalTimes2TimeTrace(aTimes)
    return data


def arrivalTimes2TimeTraceBH(arrivalTimes, binLength):
    """
    Convert a list of arrivalTimes to an intensity time trace I(t)
    ===========================================================================
    Input           Meaning
    ---------------------------------------------------------------------------
    arrivalTimes    Variable with the arrivalTimes for each detector
                    element [of ns]
    binLength       Duration of each bin [in ns]
    ===========================================================================
    Output          Meaning
    ---------------------------------------------------------------------------
    data            Vector with intensity trace vs time in bins of binLength
    ===========================================================================
    """
    
    # calculate for each photon in which bin it should be
    photonBins = np.int64(arrivalTimes / binLength)
    
    # number of photon bins
    Nbins = np.max(photonBins) + 1
    
    # create output vector
    data = np.zeros(Nbins, 'int16')
    for i in range(len(photonBins)):
        data[photonBins[i]] += 1
        
    return data
