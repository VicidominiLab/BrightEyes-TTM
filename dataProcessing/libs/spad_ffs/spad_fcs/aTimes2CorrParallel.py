import multiprocessing
from joblib import Parallel, delayed
from spad_fcs.aTimes2Corr import aTimes2Corr
from spad_fcs.FCS2Corr import correlations
import numpy as np
from spad_fcs.extractSpadPhotonStreams import extractSpadPhotonStreams

def aTimes2CorrsParallel(data, listOfCorr, accuracy=50, taumax="auto", performCoarsening=True, split=10):
    """
    Calculate correlations between several photon streams with arrival times
    stored in macrotimes, using parallel computing to speed up the process
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    data        Object having fields det0, det1, ..., det24 which contain
                the macrotimes of the photon arrivals [in a.u.]
    listOfCorr  List of correlations to calculate
                    e.g. [4, 12, 'sum3', 'sum5', 'x1011']
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
        print("Calculating correlation " + str(corr))
        
        # EXTRACT DATA
        crossCorr = False
        if type(corr) == int:
            dataExtr = getattr(data, 'det' + str(corr))
            t0 = dataExtr[:, 0]
            corrname = 'det' + str(corr)
        elif corr == "sum5" or corr == "sum3":
            print("Extracting and sorting photons")
            dataExtr = extractSpadPhotonStreams(data, corr)
            t0 = dataExtr[:, 0]
            corrname = corr
        elif corr[0] == 'x':
            c0 = corr[1:3] # first channel
            c1 = corr[3:5] # second channel
            print("Extracting photons channels " + c0 + " and " + c1)
            dataExtr = getattr(data, 'det' + c0.lstrip('0'))
            t0 = dataExtr[:, 0]
            dataExtr1 = getattr(data, 'det' + c1.lstrip('0'))
            t1 = dataExtr1[:, 0]
            corrname = corr
            crossCorr = True
        
        # CALCULATE CORRELATIONS
        duration = t0[-1] * data.macrotime
        Nchunks = int(np.floor(duration / split))
        # go over all filters
        for j in range(np.shape(dataExtr)[1] - 1):
            print("   Filter " + str(j))
            if crossCorr == False:
                if j == 0:
                    Processed_list = Parallel(n_jobs=multiprocessing.cpu_count() - 1)(delayed(parallelG)(t0, [1], data.macrotime, j, split, accuracy, taumax, performCoarsening, chunk) for chunk in list(range(Nchunks)))
                else:
                    w0 = dataExtr[:, j+1]
                    Processed_list = Parallel(n_jobs=multiprocessing.cpu_count() - 1)(delayed(parallelG)(t0, w0, data.macrotime, j, split, accuracy, taumax, performCoarsening, chunk) for chunk in list(range(Nchunks)))
            else:
                if j == 0:
                    Processed_list = Parallel(n_jobs=multiprocessing.cpu_count() - 1)(delayed(parallelGx)(t0, [1], t1, [1], data.macrotime, j, split, accuracy, taumax, performCoarsening, chunk) for chunk in list(range(Nchunks)))
                else:
                    w0 = dataExtr[:, j+1]
                    w1 = dataExtr1[:, j+1]
                    Processed_list = Parallel(n_jobs=multiprocessing.cpu_count() - 1)(delayed(parallelGx)(t0, w0, t1, w1, data.macrotime, j, split, accuracy, taumax, performCoarsening, chunk) for chunk in list(range(Nchunks)))
            
            for chunk in range(Nchunks):
                setattr(G, corrname + "F" + str(j) + '_chunk' + str(chunk), Processed_list[chunk])
           
            # average over all chunks
            listOfFields = list(G.__dict__.keys())
            listOfFields = [i for i in listOfFields if i.startswith(corrname + "F" + str(j) + "_chunk")]
            Gav = sum(getattr(G, i) for i in listOfFields) / len(listOfFields)
            setattr(G, corrname + "F" + str(j) + '_average', Gav)
    
    if calcAv:
        # calculate average correlation of all detector elements
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


def parallelG(t0, w0, macrotime, filterNumber, split, accuracy, taumax, performCoarsening, chunk):
    tstart = chunk * split / macrotime
    tstop = (chunk + 1) * split / macrotime
    tchunk = t0[(t0 >= tstart) & (t0 < tstop)]
    tchunkN = tchunk - tchunk[0]
    if filterNumber == 0:
        # no filter
        Gtemp = aTimes2Corr(tchunkN, tchunkN, [1], [1], macrotime, accuracy, taumax, performCoarsening)
    else:
        # filters
        wchunk = w0[(t0 >= tstart) & (t0 < tstop)].copy()
        Gtemp = aTimes2Corr(tchunkN, tchunkN, wchunk, wchunk, macrotime, accuracy, taumax, performCoarsening)
    return(Gtemp)


def parallelGx(t0, w0, t1, w1, macrotime, filterNumber, split, accuracy, taumax, performCoarsening, chunk):
    tstart = chunk * split / macrotime
    tstop = (chunk + 1) * split / macrotime
    tchunk0 = t0[(t0 >= tstart) & (t0 < tstop)]
    tchunk1 = t1[(t1 >= tstart) & (t1 < tstop)]
    # normalize time by sutracting first number
    tN = np.min([tchunk0[0], tchunk1[0]])
    tchunk0 = tchunk0 - tN
    tchunk1 = tchunk1 - tN
    if filterNumber == 0:
        # no filter
        Gtemp = aTimes2Corr(tchunk0, tchunk1, [1], [1], macrotime, accuracy, taumax, performCoarsening)
    else:
        # filters
        wchunk0 = w0[(t0 >= tstart) & (t0 < tstop)].copy()
        wchunk1 = w1[(t1 >= tstart) & (t1 < tstop)].copy()
        Gtemp = aTimes2Corr(tchunk0, tchunk1, wchunk0, wchunk1, macrotime, accuracy, taumax, performCoarsening)
    return(Gtemp)

