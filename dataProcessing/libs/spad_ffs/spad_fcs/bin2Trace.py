def bin2Trace(fname, btime):
    """    
    Read a binary FCS data file, containing a list of U64 numbers that
    represent the photon counts per time bin of 1 µs. Each pair of two numbers
    contains the information of all 25 detector elements in a single time bin.
    The data is binned with bins of btime µs
    
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    fname       Binary file name
    btime       Bin time in µs
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    I           Intensity (vector) as a function of time
    t           Time (vector)
    ==========  ===============================================================
    """
    
    # import functions
    import math
    import numpy as np
    import time
    
    tstart = time.time()
    
    # Open .bin file
    with open(fname, mode='rb') as file:
        rawdata = list(file.read())
    
    # number of data points
    N = len(rawdata) / 8 # 8 bytes per U64 number

    # number of samples per bin
    NsamplesPerBin = btime * 2

    # number of time bins
    Nbins = math.ceil(N / NsamplesPerBin)
    
    # Create vector data with the U64 numbers
    data = np.zeros((Nbins, 26))
#    data = [[0] * 26] * Nbins
    
    # Go through each line and add data point to binned data
    counter = 0 # keep track of number of samples stored in current bin
    currentTime = 0 # keep track of current bin time
    for i in range(round(N)):
        counts = getCountsFromDataLine(rawdata, i)
        data[currentTime][:] = data[currentTime][:] + counts
        counter += 1
        if counter >= NsamplesPerBin:
            counter = 0
            currentTime += 1
    
    # Return data vector
    print(str(time.time() - tstart))
    return data


def getCountsFromDataLine(rawdata, i):    
    # import functions
    from u64ToCounts import u64ToCounts
    
    start = 8 * i # number of bytes wrt the start of the file where number i is stored
    newRawDataPoint = rawdata[start:start+8] # Each U64 consists of 8 bytes
    newDataPoint = newRawDataPoint[0] # byte 0
    # bytes 1-7:
    for j in range(7):
        newDataPoint = (newDataPoint << 8) + newRawDataPoint[j+1]
        
    counts = u64ToCounts(newDataPoint)
    
    return counts