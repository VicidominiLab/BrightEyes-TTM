import numpy as np


def extractSpadPhotonStreams(data, mode):
    """
    Extract data from specific detector elements from SPAD-FCS time-tagging data
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    data        Object with for each detecor element a 2D array [t, m, F1, F2]
                - t: vector with macrotimes photon arrivals
                - m: microtimes
                - F1, F2, ... filter weights (based on microtimes)
    mode        Either
                - "sum3": sum central 9 detector elements
                - "sum5": sum all detector elements
                TODO
                - a number i between -1 and -26: sum all elements except for i
                - "sum": sum over all detector element and all time points
                - "sum3_5D": sum central 9 detector elements in [z, y, x, t, c] dataset
                - "outer": sum 16 detector elements at the edge of the array
                - "chess0": sum all even numbered detector elements
                - "chess1": sum all odd numbered detector elements
                - "upperleft": sum the 12 upper left detector elements
                - "lowerright": sum the 12 lower right detector elements
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    dataOut     2D matrix with concatenated and sorted detector elements data
    ==========  ===============================================================
    """
    
    if mode == 'sum3':
        # get list of detector fields
        listOfFields = [4, 5, 6, 9, 10, 11, 14, 15, 16]
        listOfFields  = ['det' + str(i) for i in listOfFields]
    
    elif mode == 'sum5':
        # get list of detector fields
        listOfFields = list(data.__dict__.keys())
        listOfFields = [i for i in listOfFields if i.startswith('det')]
        
    # concatenate all photon streams
    for j in range(len(listOfFields)):
        if j == 0:
            datasum = getattr(data, listOfFields[j])
        else:
            datasum = np.concatenate((datasum, getattr(data, listOfFields[j])))
    
    # sort all photon streams
    datasum = datasum[datasum[:,0].argsort()]
    
    # remove photon pairs with the same macrotime
    [dummy, ind] = np.unique(datasum[:,0], return_index=True)
    datasum = datasum[ind,:]
    
    return datasum
