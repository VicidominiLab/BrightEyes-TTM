from listFiles import listFiles
from binFile2Data import binFile2Data


def allBin2Pickle(directory='C:\\Users\\SPAD-FCS\\OneDrive - Fondazione Istituto Italiano Tecnologia'):

    """
    Convert all FCS bin files in the given directory to picle files.
    Files that already already have a bin file are skipped
    return parameter: data from the last file

    """

    binfiles = listFiles(directory, 'bin')
    picklefiles = listFiles(directory, 'pickle')

    data = []

    for file in binfiles:
        picklefile = file[0:-4] + '_data.pickle'
        if picklefile not in picklefiles:
            print(file)
            data = binFile2Data(file, storePickle=True)

    print('Done.')
    return(data)
