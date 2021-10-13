import matplotlib.pyplot as plt
import numpy as np
from spad_fcs.distance2detElements import distance2detElements
from spad_tools.castData import castData

def plotAiry(data, showPerc=True, dtype='int64', normalize=False, savefig=0):

    """
    Make Airy plot of SPAD-FCS data with 25 channels.

    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    data        Nx26 or Nx25 array with the FCS data
                 or data object with data.det0 etc. arrival times
    showPerc    Show percentages
    dtype       Data type
    normalize   Convert total counts to average counts per bin if True
    savefig     Path to store figure
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    airy        26 element vector with the sum of the rows and plot
    ==========  ===============================================================
    """

    if type(data) == np.ndarray:
        # data is numpy array with intensity traces
        if len(np.shape(data)) > 1:
            # if 2D array, convert to dtype and sum over all rows
            data = castData(data, dtype)
            airy = np.sum(data, axis=0)
        else:
            airy = data
        airy2 = airy[0:25]
    else:
        # data is FCS2ArrivalTimes.aTimesData object
        airy2 = np.zeros(25)
        # *  0  1  2  *
        # 3  4  5  6  7
        # 8  9  10 11 12
        # 13 14 15 16 17
        # *  18 19 20 *
        dets = [1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 22, 23]
        for det in range(21):
            if hasattr(data, 'det' + str(det)):
                airy2[dets[det]] = len(getattr(data, 'det' + str(det)))
            else:
                airy2[dets[det]] = 0
            airy = airy2
    
    if normalize:
        airy2 = airy2 / np.size(data, 0)
    
    airyMax = np.max(airy2)
    airyMin = np.min(airy2)
    airyCentPerc = (0.2 * (airyMax - airyMin) + airyMin) / airyMax * 100
        
    airy2 = airy2.reshape(5, 5)
    
    
    plt.figure()
    fontSize = 20
    plt.rcParams.update({'font.size': fontSize})
    plt.rcParams['mathtext.rm'] = 'Arial'
    
    plt.imshow(airy2, cmap='hot', interpolation='nearest')
    ax = plt.gca()
    
    # Major ticks
    ax.set_xticks([])
    ax.set_yticks([])
    # Labels for major ticks
    ax.set_xticklabels([])
    ax.set_yticklabels([])
    # Minor ticks
    ax.set_xticks(np.arange(-0.5, 4.5, 1), minor=True)
    ax.set_yticks(np.arange(-0.5, 5.5, 1), minor=True)
    # Gridlines based on minor ticks
    #ax.grid(which='minor', color='w', linestyle='-', linewidth=1)
    ax.tick_params(axis=u'both', which=u'both',length=0)
    
    cbar = plt.colorbar()
    cbar.ax.tick_params(labelsize=fontSize)

    if type(showPerc) is str and showPerc=="numbers":
        for i in range(5):
            for j in range(5):
                perc = round(airy2[i, j] / airyMax * 100)
                c="k"
                if perc < airyCentPerc:
                    c="w"
                plt.text(j, i, '{:.1f}'.format(airy2[i, j]), ha="center", va="center", color=c, fontsize=18)    
    elif showPerc:
        for i in range(5):
            for j in range(5):
                perc = round(airy2[i, j] / airyMax * 100)
                c="k"
                if perc < airyCentPerc:
                    c="w"
                plt.text(j, i, '{:.0f}%'.format(perc), ha="center", va="center", color=c, fontsize=18)

    if savefig != 0:
        plt.tight_layout()
        plt.savefig(savefig, format=savefig[-3:])

    return airy

def plotDetDist():
    det = []
    for i in range(25):
        det.append(distance2detElements(i, 12))
    det = np.resize(det, (5, 5))
    plt.figure()
    plt.imshow(det, cmap='viridis')
