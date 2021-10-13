def readBinFile(fname):
    """    
    Read a binary FCS data file, containing a list of U64 numbers that
    represent the photon counts per time bin of 1 µs. Each pair of two numbers
    contains the information of all 25 detector elements in a single time bin.
    
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    fname       Binary file name
    ==========  ===============================================================
    
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    data        List of U64 numbers
    ==========  ===============================================================
    
    """
    # Open .bin file    
    with open(fname, mode='rb') as file:
        rawdata = list(file.read())
    
    # number of data points
    N = len(rawdata) / 8 # 8 bytes per U64 number
    
    # Create vector data with the U64 numbers
    data = []
    for i in range(round(N)):
        start = 8 * i
        newRawDataPoint = rawdata[start:start+8]
        newDataPoint = newRawDataPoint[0]
        for j in range(7):
            newDataPoint = (newDataPoint << 8) + newRawDataPoint[j+1]
        data.append(newDataPoint)
    
    # Return data vector
    return data