import numpy as np


class BHspcInfo():
    pass


def readBHspc(fname):
    """
    Read an asci BH FCS file and return the FCS photon arrival times
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    fname       *asc file name
                To convert BH .spc file to ascii, use the Spcm software:
                    - main > convert > FIFO files
                    - setup file name: .set file
                    - source file name: .spc file name
                    - file format: ASCII with info header
                    - extract photons data to ASCII file
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    data        Matrix containing the arrival times of all photons
                [units of clock time]
                    - Column 1: photon arrival times, macrotimes [a.u.]
                    - Column 2: photon arrival times, microtimes [a.u.]
                    - Column 3: routing channel
                    - Column 4: invalid flag
    info        Object containing the metadata
                    - info.macrotime: macro time clock [s]
                    - info.microtime: micro time unit [s]
                    - info.fifotype: FIFO type
                    - info.photons: total number of photons
                    - info.invalidphotons: total number of invalid photons
                    - info.fifooverruns: number of FIFO overruns
    ==========  ===============================================================
    """

    # Open file
    print("Opening spc ASCII file.")
    with open(fname, mode='r') as file:
        rawdata = file.read()
    print("File opened.")
    
    # Variable to store metadata
    info = BHspcInfo()
    
    # Find macrotime
    MacroTimeStart = rawdata.find("Macro Time Clock [ns]", 0)
    MacroTimeStart = rawdata.find(": ", MacroTimeStart)
    MacroTimeStart += 2
    MacroTimeStop = rawdata.find(" ", MacroTimeStart)
    MacroTime = float(rawdata[MacroTimeStart:MacroTimeStop])
    info.macrotime = 1e-9 * MacroTime
    
    # Find microtime
    MicroTimeStart = rawdata.find("Micro Time Unit [ps]", 0)
    MicroTimeStart = rawdata.find(": ", MicroTimeStart)
    MicroTimeStart += 2
    MicroTimeStop = rawdata.find("\n", MicroTimeStart)
    MicroTime = float(rawdata[MicroTimeStart:MicroTimeStop])
    info.microtime = 1e-12 * MicroTime
    
    # Find FIFO time
    FifoTypeStart = rawdata.find("FIFO type ", 0)
    FifoTypeStart = rawdata.find(": ", FifoTypeStart)
    FifoTypeStart += 2
    FifoTypeStop = rawdata.find(" ", FifoTypeStart)
    FifoType = float(rawdata[FifoTypeStart:FifoTypeStop])
    info.fifotype = FifoType
    
    # Find number of photons
    NphotonsStart = rawdata.find("Total number of extracted photons", 0)
    NphotonsStart = rawdata.find(": ", NphotonsStart)
    NphotonsStart += 2
    NphotonsStop = rawdata.find("\n", NphotonsStart)
    Nphotons = rawdata[NphotonsStart:NphotonsStop]
    Nphotons = int(Nphotons)
    info.photons = Nphotons
    
    # Find number of invalid photons
    NphotonsInvStart = rawdata.find("invalid", NphotonsStop)
    NphotonsInvStart = rawdata.find(": ", NphotonsInvStart)
    NphotonsInvStart += 2
    NphotonsInvStop = rawdata.find("\n", NphotonsInvStart)
    NphotonsInv = rawdata[NphotonsInvStart:NphotonsInvStop]
    NphotonsInv = int(NphotonsInv)
    info.invalidphotons = NphotonsInv
    
    # Find number of FIFO overruns
    NfifoOverRunsStart = rawdata.find("number of fifo overruns", 0)
    NfifoOverRunsStart = rawdata.find(": ", NfifoOverRunsStart)
    NfifoOverRunsStart += 2
    NfifoOverRunsStop = rawdata.find("\n", NfifoOverRunsStart)
    NfifoOverRuns = rawdata[NfifoOverRunsStart:NfifoOverRunsStop]
    NfifoOverRuns = int(NfifoOverRuns)
    info.fifooverruns = NfifoOverRuns
    
    # Create empty array for photon arrival times
    data = np.zeros((Nphotons, 4), 'int64')
    
    # Check each line and extract photon arrival time
    # Find start position in the file
    start = rawdata.find("End of info header\n", 0)
    start = rawdata.find("\n", start)
    start += 1
    start = rawdata.find("\n", start)
    start += 1
    print(str(Nphotons) + " photons found.")
    for i in range(Nphotons):
        # macrotime
        stop = rawdata.find(" ", start)
        photonMacroTime = int(rawdata[start:stop])
        data[i, 0] = photonMacroTime
        # microtime
        start = stop + 1
        stop = rawdata.find(" ", start)
        photonMicroTime = int(rawdata[start:stop])
        data[i, 1] = photonMicroTime
        # routing channel
        start = stop + 2
        stop = rawdata.find(" ", start)
        photonChannel = int(rawdata[start:stop])
        data[i, 2] = photonChannel
        # invalid flag
        start = stop + 1
        stop = rawdata.find("\n", start)
        flag = int(rawdata[start:stop])
        data[i, 3] = flag
        # new line
        start = rawdata.find("\n", stop)

    return data, info
