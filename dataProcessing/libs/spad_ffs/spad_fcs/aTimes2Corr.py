import numpy as np
from datetime import datetime
from spad_fcs.extractSpadPhotonStreams import extractSpadPhotonStreams


class correlations:
    pass


def aTimes2Corrs(data, listOfCorr, accuracy=50, taumax="auto", performCoarsening=True, split=10):
    """
    Calculate correlations between several photon streams with arrival times
    stored in macrotimes
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    data        Object having fields det0, det1, ..., det24 which contain
                the macrotimes of the photon arrivals [in a.u.]
    listOfCorr  List of correlations to calculate
    split       Chunk size [s]
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    G           [N x 2] matrix with tau and G values
    ==========  ===============================================================
    """
    
    if taumax == "auto":
        taumax = 1 / data.macrotime
    
    G = correlations()
    
    Ndet = 21
    calcAv = False
    if 'av' in listOfCorr:
        # calculate the correlations of all channels and calculate average
        listOfCorr.remove('av')
        listOfCorr += list(range(Ndet))
        calcAv = True
    
    for corr in listOfCorr:
        # EXTRACT DATA
        if type(corr) == int:
            dataExtr = getattr(data, 'det' + str(corr))
            t0 = dataExtr[:, 0]
            corrname = 'det' + str(corr)
        elif corr == "sum5" or corr == "sum3":
            print("Extracting and sorting photons")
            dataExtr = extractSpadPhotonStreams(data, corr)
            t0 = dataExtr[:, 0]
            corrname = corr
        
        # CALCULATE CORRELATIONS
        duration = t0[-1] * data.macrotime
        Nchunks = int(np.floor(duration / split))
        # go over all filters
        for j in range(np.shape(dataExtr)[1] - 1):
            for chunk in range(Nchunks):
                corrstring = corrname + "F" + str(j) + "_chunk" + str(chunk)
                print("Calculating correlation " + corrstring)
                tstart = chunk * split / data.macrotime
                tstop = (chunk + 1) * split / data.macrotime
                tchunk = t0[(t0 >= tstart) & (t0 < tstop)]
                tchunk -= tchunk[0]
                print("   Nphotons: " + str(len(tchunk)))
                if j == 0:
                    # no filter
                    Gtemp = aTimes2Corr(tchunk, tchunk, [1], [1], data.macrotime, accuracy, taumax, performCoarsening)
                else:
                    # filters
                    w0 = dataExtr[:, j+1]
                    wchunk = w0[(t0 >= tstart) & (t0 < tstop)]
                    Gtemp = aTimes2Corr(tchunk, tchunk, wchunk, wchunk, data.macrotime, accuracy, taumax, performCoarsening)
                setattr(G, corrstring, Gtemp)
            # average over all chunks
            print("   Calculating average correlation")
            listOfFields = list(G.__dict__.keys())
            listOfFields = [i for i in listOfFields if i.startswith(corrname + "F" + str(j) + "_chunk")]
            Gav = sum(getattr(G, i) for i in listOfFields) / len(listOfFields)
            setattr(G, corrname + "F" + str(j) + '_average', Gav)
    
    if calcAv:
        # calculate average correlation
        for f in range(np.shape(dataExtr)[1] - 1):
            # start with correlation of detector 20 (last one)
            Gav = getattr(G, 'det' + str(Ndet-1) + 'F' + str(f) + '_average')
            # add correlations detector elements 0-19
            for det in range(Ndet - 1):
                Gav += getattr(G, 'det' + str(det) + 'F' + str(f) + '_average')
            # divide by the number of detector elements to get the average
            Gav = Gav / Ndet
            # store average in G
            setattr(G, 'F' + str(f) + '_average', Gav)
    
    return G


def aTimes2Corr(t0, t1, w0, w1, macroTime, accuracy=50, taumax="auto", performCoarsening=True):
    """
    Calculate correlation between two photon streams with arrival times t0 and t1
    Inspired by Wahl et al., Opt. Expr. 11 (26), 2003
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    t0, t1      Vector with arrival times channel 1 and 2 [a.u.]
    w0, w1      Vector with (filtered) weights channel 1 and 2 [a.u.]
    accuracy    Number of tau values for which G is calculated before delta
                tau is doubled
                E.g. accuracy = 3 yields:
                    tau = [1, 2, 3, 5, 7, 9, 13, 17, 21, 29, 37, 45,...]
    macroTime   Multiplication factor for the arrival times vectors [s]
    taumax      Maximum tau value for which to calculate the correlation
                If left empty, 1/10th of the measurement duration is used
    performCoarsening
                Apply time trace coarsening for more efficient (and more accurate)
                correlation calculation
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    G           [N x 2] matrix with tau and G values
    ==========  ===============================================================
    """
    
    # convert t0 and t1 lists to array
    t0 = np.asarray(t0)
    t1 = np.asarray(t1)
    
    # check max tau value
    if taumax=="auto":
        taumax = t0[-1] / 10
    
    # generate list [tau] with logarithmically distributed tau values
    t = 0
    tau = []
    step = 1
    while t <= taumax:
        for i in range(accuracy):
            t += step
            # make sure t is multiple of step (needed for coarsing)
            t = int(np.round(t / step) * step)
            tau.append(t)
        step *= 2
    tau = [i for i in tau if i <= taumax]
    
    # create array for g and weights
    N = len(tau)
    g = np.zeros(N)
    if len(w0) == 1:
        w0 = np.ones(len(t0))
    if len(w1) == 1:
        w1 = np.ones(len(t1))
    
    # coarse factor
    c = 1

    printDateTime = False
    if len(t0) > 100000:
        printDateTime = True
    
    # calculate g for each tau value
    if printDateTime:
        print(datetime.now())
    for i in range(N):
        t = tau[i]
        if performCoarsening and np.mod(i, accuracy) == 0 and i != 0:
            # change in step size: perform coarsening
            c *= 2
            [t0, w0, ind] = timeCoarsening(t0, w0)
            [t1, w1, ind] = timeCoarsening(t1, w1)
        # print("Calculating g(" + str(t) + ")\t t/c = " + str(t/c) + " \t - c = " + str(c))
        g[i] = aTimes2CorrSingle(t0, t1, w0, w1, t/c, c)
    if printDateTime:
        print(datetime.now())
    
    tau = np.asarray(tau) * macroTime
    
    return np.transpose([tau, g])


def aTimes2CorrSingle(t0, t1, w0, w1, tau, c):
    """
    Calculate single correlation value between two photon streams with arrival
    times t0 and t1, weight vectors w0 and w1, and tau value tau
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    t0, t1      Vector with arrival times channel 1 and 2 (np.array)
                    [multiples of minimum coarsed macrotime]
    w0, w1      Vector with weight values channel 1 and 2 (np.array)
    tau         tau value for which to calculate the correlation
                    [multiples of minimum coarsed macrotime]
    c           Coarsening factor (power of 2)
    I0, I1      Average intensity channels 1 and 2
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    g           Single value g(tau)
    ==========  ===============================================================
    """
    
    # calculate time shifted vector
    t1 = t1 + tau
    
    # find intersection between t0 and t1
    [tauDouble, idxt0, idxt1] = np.intersect1d(t0, t1, return_indices=True)
    
    # overlap time
    T = (t0[-1] - tau + 1) * c
    
    # calculate autocorrelation value
    G = np.sum(w0[idxt0] * w1[idxt1]) / T / c
    
    # normalize G
    I0 = np.sum(w0[t0 >= tau]) / T
    I1 = np.sum(w1[t1<=t0[-1]]) / T
    g = G / I0 / I1 - 1
    
    return g


def timeCoarsening(t, w):
    # divide all arrival times by 2
    t = np.floor(t / 2)
    
    # check for duplicate values
    ind = np.where(np.diff(t) == 0)[0]
    
    # sum weights
    w[ind] += w[ind+1]
    
    # delete duplicates
    w = np.delete(w, ind+1)
    t = np.delete(t, ind+1)
    
    return [t, w, ind]
    
