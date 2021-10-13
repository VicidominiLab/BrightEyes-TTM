import numpy as np


class aTimesData:
    pass


def arrivalTimes2FilteredTimeTrace(data, filterFunction, microbinLength, macrobinLength):
    """
    Convert a list of arrivalTimes to an intensity time trace I(t)
    ===========================================================================
    Input           Meaning
    ---------------------------------------------------------------------------
    data            Object with for each detector element field with a 2D int
                    array, e.g.:
                        data.det0 = np.array(N x 2)
                            with N the number of photons
                            First column: macro arrival times [a.u.]
                            Second column: micro arrival times [a.u.]
                        data.macrotime: macroTime [s]
                        data.microtime: microTime [s]
    filterFunction  np.array(M x Nf) with the filter functions
                        M: number of lifetime bins
                        Nf: number of filters, tyically 2 (1 fluor, 1 afterpulse)
                            sum of each row = 1
                    For multiple detector elements, and thus multiple filters,
                    this variable is np.array(Ndet x M x Nf)
    microbinLength  Duration of each bin of the lifetime histogram [s]
    macrobinLength  Duration of each bin of the final intensity trace [s]
    ===========================================================================
    Output          Meaning
    ---------------------------------------------------------------------------
    timeTraceF      Object with for each filter function a np.array(K x L) with
                        K the number of photon bins of duration binLength
                        L the number of detector elements
    ===========================================================================
    """
    
    # get list of detector fields
    listOfFields = list(data.__dict__.keys())
    listOfFields = [i for i in listOfFields if i.startswith('det')]
    Ndet = len(listOfFields)
    
    # get total measurement time
    Mtime = 0
    for i in range(Ndet):
        dataSingleDet = getattr(data, listOfFields[i])
        Mtime = np.max((Mtime, dataSingleDet[-1, 0]))
    Mtime *= data.macrotime # [s]
    print(str(Mtime))
    
    # number of time bins for binned and filtered intensity traces
    Nbins = int(np.ceil(Mtime / macrobinLength))
    
    # make sure filterFunction is a 3D array
    if len(np.shape(filterFunction)) == 2:
        filterFunction = np.expand_dims(filterFunction, 0)
    
    # create empty arrays to store output traces
    Nfilt = np.shape(filterFunction)[-1]
    timeTraces = np.zeros((Ndet, Nbins, Nfilt), dtype=float)
    
    # go through each channel and create filtered intensity trace
    for det in range(Ndet):
        print("Calculating filtered intensity trace " + listOfFields[det])
        dataSingleDet = getattr(data, listOfFields[det])
        # calculate for each photon in which bin it should be
        photonMacroBins = np.int64(dataSingleDet[:,0] * data.macrotime / macrobinLength)
        photonMicroBins = np.int64(dataSingleDet[:,1] * data.microtime / microbinLength)
        for i in range(len(photonMacroBins)):
            for filt in range(Nfilt):
                timeTraces[det, photonMacroBins[i], filt] += filterFunction[det, photonMicroBins[i], filt]

    return np.squeeze(timeTraces)


def aTimesFiltered(data, filterFunction, microBin=False):
    """
    Filter a list of arrivalTimes
    ===========================================================================
    Input           Meaning
    ---------------------------------------------------------------------------
    data            Object with for each detector element field with a 2D int
                    array, e.g.:
                        data.det0 = np.array(N x 2)
                            with N the number of photons
                            First column: macro arrival times [a.u.]
                            Second column: micro arrival times [*]
                        data.macrotime: macro time [s]
                        data.microtime: micro time [s]
                        data.microbintime: micro bin time [s]
    filterFunction  np.array(M x Nf) with the filter functions
                        M: number of lifetime bins
                        Nf: number of filters, tyically 2 (1 fluor, 1 afterpulse)
                            sum of each row = 1
                    For multiple detector elements, and thus multiple filters,
                    this variable is np.array(Ndet x M x Nf)
    microBin        Boolean
                        True if micro arrival times [*] are in bin numbers
                        False if micro arrival times [*] are in [a.u.]
                            In this case, the bin numbers are calculated as
                            bin = t * data.microtime / data.microbintime
                            with data.microtime the microtime unit in s
                            and data.microbintime the bin time in s
    ===========================================================================
    Output          Meaning
    ---------------------------------------------------------------------------
    data            Same object as input but data.det0 is now np.array(N x 2+Nf)
                        For every detector element, Nf columns are added with 
                        the filtered weights for the arrival times
    ===========================================================================
    """
    
    # get list of detector fields
    listOfFields = list(data.__dict__.keys())
    listOfFields = [i for i in listOfFields if i.startswith('det')]
    Ndet = len(listOfFields)
    
    # make sure filterFunction is a 3D array (detector, microbin, filter function)
    if len(np.shape(filterFunction)) == 2:
        filterFunction = np.expand_dims(filterFunction, 0)
    
    # number of filters
    Nf = np.shape(filterFunction)[2]
    
    # number of time bins
    M = np.shape(filterFunction)[1]
    
    # micro times normalization factor
    microN = 1
    if not microBin:
        microN = data.microtime / data.microbintime
    
    # go through each channel and create filtered intensity trace
    for det in range(Ndet):
        print("Calculating filtered photon streams " + listOfFields[det])
        # get photon streams single detector element
        dataSingleDet = getattr(data, listOfFields[det])
        # remove exessive columns which may already contain filtered photon streams
        dataSingleDet = dataSingleDet[:, 0:2]
        # calculate for each photon the filtered values
        photonMicroBins = np.int64(np.floor(dataSingleDet[:,1] * microN))
        photonMicroBins = np.clip(photonMicroBins, 0, M-1)
        for filt in range(Nf):
            filteredValues = np.expand_dims(np.take(np.squeeze(filterFunction[det, :, filt]), photonMicroBins), 1)
            dataSingleDet = np.concatenate((dataSingleDet, filteredValues), axis=1)
        setattr(data, listOfFields[det], dataSingleDet)

    return data