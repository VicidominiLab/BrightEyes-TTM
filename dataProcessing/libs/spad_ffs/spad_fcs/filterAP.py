import numpy as np
import matplotlib.pyplot as plt


def filterAP(ks, tau, T, b, normExp=False, plotOn=True):
    """
    Use fluorescence lifetime to generate filters that remove afterpulsing
    from FCS data, based on ideal exponential decay
    Based on Enderlein and Gregor, Rev. Sci. Instr., 76, 2005 and
    Kapusta et al., J. Fluor., 17, 2007.
    ===========================================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    ks          Parameter describing ??
    tau         Fluorescence lifetime from exponential fit of the histogram
    T           Number of data points in time
    b           Background value from exponential fit of the histogram
    normExp     Normalize the histogram of the exponential decay by setting
                the sum of the bins to 1. For a full decay, this is always
                the case, since the integral of (1/tau * exp(-t/tau)) running
                from 0 to inf is 1.
    ===========================================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    F           2D array with 2 rows, one row for each filter function
    ===========================================================================
    Function call examples:
        F = filterAP(0, 23.78, T, 0.028)
    ===========================================================================
    """

    t = np.linspace(0, T-1, int(T))

    # histogram 1 with the fluorescence decay
    decayNorm = (1/tau) * np.exp(-t/tau) / (1 + 0.5 * ks * t / tau)
    if normExp:
        decayNorm = decayNorm / np.sum(decayNorm)
    
    # histogram 2 with the background, always normalized
    decayNorm2 = np.ones((1,T)) / T
    
    # concatenate both row vectors vertically
    decayNorm = np.concatenate((np.transpose(decayNorm[:,np.newaxis]), decayNorm2), axis=0)
    
    # total average decay as expected from theory
    ItheorTOT = b + np.exp(-t/tau) / (1 + 0.5 * ks * t / tau)
    
    # matrix D as in Enderlein paper
    D = np.diag(1 / ItheorTOT)
    
    # filter formula
    F = np.matmul(np.matmul(decayNorm, D), np.transpose(decayNorm))
    F = np.linalg.inv(F)
    F = np.matmul(np.matmul(F, decayNorm), D)
    
    if plotOn:
        plt.figure()
        plt.plot(F[0,:])
        plt.plot(F[1,:])
    
    return F


def filter2C(hist1, hist2, b, plotFig=True):
    """
    Use histogram information to generate filters to split the data in two
    time traces
    ===========================================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    hist1, hist2 Vector with the histogram values for component 1 and 2
                 (can be theoretical or experimental curve
                  can - but does not have to - be normalized
    b            Number, scaling factor describing the weight of hist2
                 with respect to hist1
                 equal to amplitude(hist2) / amplitude(hist1) for unnormalized
                 histograms
    plotFig      Plot figure with two filter functions
    ===========================================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    F           2D array with 2 rows, one row for each filter function
    ===========================================================================
    Function call examples:
        F = filterAP(histFluor, np.array(ones(500)))
    ===========================================================================
    """
    
    # normalize histograms
    hist1 = hist1 / np.sum(hist1)
    hist2 = hist2 / np.sum(hist2)
    
    # concatenate both row vectors vertically
    histAll = np.concatenate((np.transpose(hist1[:,np.newaxis]), np.transpose(hist2[:,np.newaxis])), axis=0)
    
    # total histogram
    histTot = hist1 / np.max(hist1) + b * hist2 / np.max(hist2)
    
    # matrix D as in Enderlein paper
    D = np.diag(1 / histTot)
    
    # filter formula
    F = np.matmul(np.matmul(histAll, D), np.transpose(histAll))
    F = np.linalg.inv(F)
    F = np.matmul(np.matmul(F, histAll), D)
    
    if plotFig:
        plt.figure()
        plt.plot(F[0,:])
        plt.plot(F[1,:])
    
    return F