from spad_fcs.FCS2Corr import getFCSinfo
import numpy as np
from spad_fcs.meas_to_count import file_to_FCScount


class aTimesData:
    pass


def FCS2ArrivalTimes(fname, macrotime, split=10):
    """
    Load SPAD-FCS data in chunks (of 10 s) and convert to arrivaltimes vectors
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    fname       File name with the .bin data
    macroTime   Macrotime multiplication factor / dwell time [s]
    split       Number of seconds of each chunk to split the data into
                E.g. split=10 will divide a 60 second stream in 6 ten-second
                traces and calculate G for each individual trace
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    data        Object with following fields:
                    data.det0chunk0    arrival times chunk 0 detector 0
                    ...
                    data.det24chunk10  arrival times chunk 10 detector 24
                    data.macrotime      macrotime
                    data.duration       measurement duration [s]
    ==========  ===============================================================
    """
    
    info = getFCSinfo(fname[:-4] + "_info.txt")
    dwellTime = info.dwellTime
    duration = info.duration
    
    data = aTimesData()
    data.macrotime = dwellTime
    data.duration = duration
    
    N = np.int(np.floor(duration / split)) # number of chunks

    chunkSize = int(np.floor(split / dwellTime))
    for chunk in range(N):
        # ---------------- CALCULATE CORRELATIONS SINGLE CHUNK ----------------
        print("+-----------------------")
        print("| Loading chunk " + str(chunk))
        print("+-----------------------")
        dataChunk = file_to_FCScount(fname, np.uint8, chunkSize, chunk*chunkSize)
        if np.max(dataChunk) > 1:
            print("Max too high.")
        else:
            for det in range(np.shape(dataChunk)[1]):
                setattr(data, "det" + str(det) + "chunk" + str(chunk), np.nonzero(dataChunk[:,det])[0])
    
    return data
