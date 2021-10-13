import matplotlib.pyplot as plt
import numpy as np
from binData import binData


def plotIntensityTraces(data, dwellTime=1, binsize=1, yscale='log', listOfChannels="all"):
    """
    Convert SPAD-FCS data to correlation curves
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    data        Data variable, i.e. output from binFile2Data
    dwellTime   Bin time [in µs]
    binsize     Number of data points in one bin
    yscale      "linear" or "log" y scale
    listOfChannels List with channel numbers to be plotted, e.g. [0, 12, 24]
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    plot with all intensity traces
    ==========  ===============================================================

    """

    # number of channels
    Nc = np.size(data, 1)

    # channels to plot
    if listOfChannels == "all":
        listOfChannels = list(range(np.min([Nc, 25])))
    
    # bin data
    databin = binData(data, binsize)
    # number of time points in binned data
    Nt = np.size(databin, 0)
    
    # create figure
    leg = []  # figure legend
    h = plt.figure()
    
    # bin time
    binTime = 1e-6 * dwellTime * binsize
    
    # time vector
    time = list(range(0, Nt))
    time = [i * binTime for i in time]
    
    ymax = 0
    for i in listOfChannels:
        # rescale intensity values to frequencies
        PCR = databin[:, i] / binTime
        # for lag plot in Hz, else in kHz
        scaleFactor = 1000
        if yscale == 'log':
            scaleFactor = 1
        PCRscaled = PCR / scaleFactor
        plt.plot(time, PCRscaled)
        leg.append('Pixel ' + str(i))
        ymax = np.max([ymax, np.max(PCRscaled)])
    
    plt.xlabel('Time [s]')
    plt.xlim([0, 2*time[-1] - time[-2]])
    if yscale == 'linear':
        plt.ylim([0, 1.1 * ymax])
    if scaleFactor == 1000:
        plt.ylabel('Photon count rate [kHz]')
    else:
        plt.ylabel('Photon count rate [Hz]')
    if len(listOfChannels) < 10:
        plt.legend(leg)
    plt.rcParams.update({'font.size': 20})
    plt.tight_layout()
    plt.yscale(yscale)

    return h