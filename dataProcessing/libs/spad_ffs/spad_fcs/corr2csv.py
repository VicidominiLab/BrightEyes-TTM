import csv
import numpy as np


def corr2csv(G, fname, limits=[0, 0], chunks=1):
    """
    Save all autocorrelations to separate .csv files for fit analysis in e.g.
    PyCorrFit.
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    G           Autocorrelation data
    fname       filename base to store data (without file extension)
    limits      crop data, indices of the start and stop index in lag time
                use cropGgui to get this variable
    chunks      0: do not store fields with the word 'chunk' in it
                1: store all fields
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    .csv files
    ==========  ===============================================================
    """
    Glist = list(G.__dict__.keys())
    start = limits[0]
    stop = limits[1]
    for corr in Glist:
        if corr == 'dwellTime' or ('chunk' in corr and chunks==0):
            pass
        else:
            Gsingle = np.copy(getattr(G, corr))
            if len(np.shape(Gsingle)) == 2:
                # normal G(tau) data found
                pass
            else:
                # 3D array with cross-correlations found
                dim = np.shape(Gsingle)
                Greshaped = np.zeros([dim[2], dim[0]*dim[1]])
                for row in range(dim[0]):
                    for col in range(dim[1]):
                        Greshaped[:,row*dim[1]+col] = Gsingle[row, col, :]
                Gsingle = Greshaped
            if stop == 0:
                # stop = end
                stop = len(Gsingle)
            Gsingle = Gsingle[start:stop, :]
            # Gsingle[:, 0] = Gsingle[:, 0] * 1000  # convert time stamps to ms
            GsingleList = Gsingle.tolist()
    
            csv.register_dialect('myDialect',
                                 quoting=csv.QUOTE_MINIMAL,
                                 skipinitialspace=True)
    
            with open(fname + '_' + corr + '.csv', 'w', newline='') as f:
                writer = csv.writer(f) # dialect='myDialect'
                for row in GsingleList:
                    writer.writerow(row)
            f.close()
