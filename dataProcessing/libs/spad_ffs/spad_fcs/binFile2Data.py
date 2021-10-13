import numpy as np
from savevar import savevar


class arrivalTimes:
    pass

def binFile2Data(fname, storePickle=False):
    """
    Read a binary FCS data file, containing a list of U64 numbers that
    represent the photon counts per microtime bin of about 1 µs.

    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    fname       Binary file name
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    countArray  N x 26 array with for each row the number of photon counts
                for each channel and the sum of all channels per microbin
    ==========  ===============================================================
    """

    from readBinFile import readBinFile
    from u64ToCounts import u64ToCounts
    import numpy as np
    import os
    from savevar import savevar

    readLength = 8 * 65536

    # Get file size [in bytes]
    fsize = os.path.getsize(fname)

    # Empty array to store photon counts
    countArray = np.zeros((int(fsize/2/8), 26), dtype='H')

    startPos = 0  # position in the .bin file to start reading
    row = 0  # row of countArray to write to

    # Go through the file, read a chunk of data, write to the array, and repeat
    while startPos < fsize:
        print(startPos/fsize*100)
        # Read part of the binary file
        data = readBinFile(fname, startPos, readLength)
        startPos += readLength

        # Calculate photon counts
        for i in range(len(data)):
            counts = u64ToCounts(data[i])
            # add counts to array
            countArray[int(np.floor(row/2))][:] = np.add(
                    countArray[int(np.floor(row/2))][:],
                    counts)
            row += 1

    print(100)
    
    if storePickle:
        print("Storing .pickle file")
        savevar(countArray, fname[0:-4] + "_data")
        print(".pickle file stored")
    
    return countArray


def binFile2DataAle(fname, storePickle=False):
    """
    Read a binary data file from Ale's FPGA, containing a list of U32 numbers
    that represent photon arrival times
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    fname       Binary file name
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    data        Class with 32 fields, each one containing a list of the arrival
                times of the photons in that channel. With the 5x5 SPAD array
                detector, only the 25 first fields are used, the others are
                empty. The arrival times are in units of 12.5 ns, i.e.
                multiply each list by 12.5 to get the arrival times in ns.
    ==========  ===============================================================

    """
    # Open .bin file
    print("Opening .bin file.")
    with open(fname, mode='rb') as file:
        rawdata = list(file.read())
    print("Binfile opened.")
    
    # Number of bytes per line
    NB = 4
    
    # Number of addresses
    NA = 8
    
    # number of data points
    N = len(rawdata) / NB  # 4 bytes per 32 bit number

    # convert list into list of lists with each sublist containing 4 numbers
    # rawdata2 = [rawdata[i:i+NB] for i in range(0, len(rawdata), NB)]

    # reverse order of the bytes in each list item
    # rawdata = [list(reversed(rawdata[i])) for i in range(0, len(rawdata))]

    # Create vector data with the macro arrival times
    data = arrivalTimes()
    for i in range(NA):
        for j in range(NB):
            setattr(data, "pixel" + str(i*NB + j), [])
    
    # go through data set
    oldTimeArr = np.zeros(NA)  # keep track of time
    k = np.zeros(NA)  # keep track of number of macrotimes of each address
    for i in range(round(N)):
        if np.mod(i, 10000) == 0:
            print("{0:.3f} %".format(100 * i/N))
        start = 4 * i
        newRawDataPoint = rawdata[start:start+NB]
        newRawDataPoint = list(reversed(newRawDataPoint))
        address = getAddress(newRawDataPoint)
        time = getTime(newRawDataPoint)
        ch = getChannel(newRawDataPoint)
        # print("time: " + str(time) + " - oldTime: " + str(oldTime))
        # print(ch)
        if time < oldTimeArr[address]:
            k[address] += 1
        oldTimeArr[address] = time
        time = int(k[address] * 4096 + time)
        if ch > 0 and address >= 0:
            pixel = address * 4 + ch - 1
            getattr(data, "pixel" + str(pixel)).append(time)
    
    if storePickle:
        print("Storing .pickle file")
        savevar(data, fname[0:-4] + "_data")
        print(".pickle file stored")
    
    return(data)
        

def getAddress(data):
    address = data[0]
    address = list('{0:08b}'.format(int(address)))
    address = address[0:3]
    address = int("".join(str(x) for x in address), 2)
    return address


def getTime(data):
    byte0 = data[3]
    byte0 = list('{0:08b}'.format(int(byte0)))
    byte1 = data[2]
    byte1 = list('{0:08b}'.format(int(byte1)))
    byte1 = byte1[4:8]
    time = byte1 + byte0
    time = int("".join(str(x) for x in time), 2)
    return time


def getChannel(data):
    byte2 = data[1]
    byte2 = list('{0:08b}'.format(int(byte2)))
    byte3 = data[0]
    byte3 = list('{0:08b}'.format(int(byte3)))
    ch1 = byte2[7]
    ch2 = byte2[6]
    ch3 = byte3[7]
    ch4 = byte3[6]
    channels = [ch1, ch2, ch3, ch4]
    channels = list(map(int, channels))
    if np.sum(channels) > 1 or np.sum(channels) == 0:
        return -1
    return channels.index(1) + 1