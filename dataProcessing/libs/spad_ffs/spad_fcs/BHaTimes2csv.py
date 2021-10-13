from readBHspc import readBHspc
from arrivalTimes2TimeTrace import arrivalTimes2TimeTraceBH
from FCS2Corr import FCS2CorrSplit
from corr2csv import corr2csv
from FCS2Corr import plotFCScorrelations


def BHaTimes2csv(fname, bintime=500, accuracy=50, split=20):
    """
    Convert Becker and Hickl FCS data to correlation curves stored in .csv files
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    fname       File name with BH single photon arrival times (.asc file)
    bintime     Bin time [ns]
    accuracy    Accuracy calculation autocorrelation
    split       Number of fragments in which to split the time trace.
                    For each fragment the autocorrelation is calculated, as
                    well as the average correlation
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    G           Object with all autocorrelations
    .csv file   File with all the correlations
    ==========  ===============================================================
    """

    # load data
    data = readBHspc(fname)

    # bin data
    dataBin = arrivalTimes2TimeTraceBH(data, bintime)
    
    # calculate G
    G = FCS2CorrSplit(dataBin, bintime/1000, ['det0'], accuracy, split)
    
    # plot G
    plotFCScorrelations(G, ['det0_average'])
    
    # save as .csv file
    corr2csv(G, fname[0:-4])

