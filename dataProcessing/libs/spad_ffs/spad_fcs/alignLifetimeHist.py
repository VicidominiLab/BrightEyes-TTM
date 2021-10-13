import numpy as np
from spad_tools.movingAverage import movingAverage
import copy


def alignLifetimeHist(data, n=15):
    """
    Align lifetime histograms of different channels. Calculate moving averaged
    histograms, caculate derivative and find peak. Then shift everything
    so that the peaks are aligned.
    ===========================================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    data        data object with microtime histograms
    n           width of the window for the calculation of the moving average
    ===========================================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    data        same data object as input, but with histograms aligned in time
    ===========================================================================
    """
    
    histList = [i for i in list(data.__dict__.keys()) if i.startswith('hist')]
    
    for hist in histList:
        # get histogram
        histD = copy.deepcopy(getattr(data, hist))
        # calculate moving average
        IAv = movingAverage(histD[:,1], n=n)
        # calculate derivative
        derivative = IAv[1:] - IAv[0:-1]
        # find maximum of derivative
        maxInd = np.argmax(derivative)
        # shift histogram
        histD[:,1] = np.roll(histD[:,1], -maxInd)
        # store shifted histogram in data object
        setattr(data, 'A' + hist, histD)
    
    return data
