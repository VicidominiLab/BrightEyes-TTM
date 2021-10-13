# -*- coding: utf-8 -*-
"""
Created on Wed May 22 10:46:35 2019

@author: SPAD-FCS
"""

from FCS2Corr import plotFCScorrelations
import matplotlib.pyplot as plt
import numpy as np


def cropGgui(G):
    """
    Crop autocorrelation data in time. A plot of G is shown. The user selects
    the start and stop lag times. The function returns these limits.

    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    G           Autocorrelation data
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    limits      List with lower and upper index of G and tau
    ==========  ===============================================================
    """

    # plot correlations
    h = plotFCScorrelations(G)

    # get axis limits
    # xlim = plt.gca().axes.get_xlim()
    ylim = plt.gca().axes.get_ylim()

    # ask user input start value
    start = plt.ginput(1)
    start = start[0][0]
    # start = np.max([start, xlim[0]])
    plt.plot([start, start], [ylim[0], ylim[1]])
    h.canvas.draw()

    # ask user input stop value
    stop = plt.ginput(1)
    stop = stop[0][0]
    plt.plot([stop, stop], [ylim[0], ylim[1]])
    h.canvas.draw()

    Glist = list(G.__dict__.keys())
    k = 0
    if Glist[k] == 'dwellTime':
        k = 1
    Gsingle = np.copy(getattr(G, Glist[k]))
    print(str(np.size(Gsingle)))
    startidx = (np.abs(Gsingle[:, 0] - start)).argmin()
    stopidx = (np.abs(Gsingle[:, 0] - stop)).argmin()
    limits = [startidx, stopidx]

    h = plotFCScorrelations(G, 'all', limits)
    return(limits)


def cropG(G, limits):
    # this function is not used
    Glist = list(G.__dict__.keys())
    # remove dwellTime from the list
    if 'dwellTime' in Glist:
        Glist.remove('dwellTime')
    start = limits[0]
    stop = limits[1]
    for corr in Glist:
        Gsingle = np.copy(getattr(G, corr))
        startidx = (np.abs(Gsingle[:, 0] - start)).argmin()
        stopidx = (np.abs(Gsingle[:, 0] - stop)).argmin()
        Gsingle = Gsingle[startidx:stopidx, :]
        setattr(G, corr, Gsingle)

    return(G)
