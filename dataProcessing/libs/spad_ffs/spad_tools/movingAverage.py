import numpy as np


def movingAverage(data, n=3):
    """
    calculate moving average from list of values
    ===========================================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    data        np.array with data values
    n           width of the window
    ===========================================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    data        np.array with data values with moving average applied
    ===========================================================================
    """
    
    dataCum = np.cumsum(data, dtype=float)
    dataCum[n:] = dataCum[n:] - dataCum[:-n]
    
    return dataCum[n-1:] / n
