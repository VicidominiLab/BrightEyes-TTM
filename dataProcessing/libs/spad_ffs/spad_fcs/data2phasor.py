import numpy as np
from phasor import phasor


def data2phasor(data):
    """
    Calculate phasors for all histograms in data object
    ===========================================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    data        Object with histograms for each channel
    ===========================================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    data
    ===========================================================================
    """
    
    histList = [i for i in list(data.__dict__) if i.startswith('hist')]
    N = len(histList)
    
    phasors = np.zeros(N, dtype=complex)
    
    for i in range(N):
        hist = getattr(data, histList[i])
        hist = hist[:,1]
        phasors[i] = phasor(hist)
    
    data.phasors = phasors
    
    return data