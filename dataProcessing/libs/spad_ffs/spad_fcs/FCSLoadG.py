from spad_tools.listFiles import listFiles
from spad_fcs.FCS2Corr import correlations
import os
from spad_tools.csv2array import csv2array

def FCSLoadG(fnameRoot, folderName="", printFileNames=True):
    """
    Load correlations from .asc files into data object
    ===========================================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    fnameRoot   'Root' of the file names. E.g. if the .asc files are named
                'FCS_beads_central', 'FCS_beads_sum3', and 'FCS_beads_sum5',
                then 'FCS_beads_' is the common root
    folderName  Name of the folder to look into
    printFileNames
                Print the names of the files that were found
    ===========================================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    G           Data object with G.central, G.sum3, G.sum5 etc. the correlation
                functions
    ===========================================================================
    """
    G = correlations()
    files = listFiles(folderName, "csv", fnameRoot)
    for file in files:
        setattr(G, stripGfname(file, fnameRoot, printFileNames), csv2array(file, ','))
    G.dwellTime = 1e6 * csv2array(file, ',')[1, 0] # in µs
    print('--------------------------')
    print(str(len(files)) + ' files found.')
    print('--------------------------')
    return G


def stripGfname(fname, fnameRoot, printFileNames=True):
    fname = os.path.basename(fname)
    dummy, file_extension = os.path.splitext(fname)
    index = fname.find(fnameRoot)
    fname = fname[index + len(fnameRoot):-len(file_extension)]
    if printFileNames:
        print(fname)
    return fname
    
