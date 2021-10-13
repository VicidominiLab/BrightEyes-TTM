import numpy as np
from numpy import genfromtxt
from spad_tools.checkfname import checkfname

def csv2array(file, dlmt='\t'):
    data = genfromtxt(file, delimiter=dlmt)
    return data


def array2csv(data, fname='test.csv', dlmt='\t'):
    data = np.asarray(data)
    fname = checkfname(fname, 'csv')
    np.savetxt(fname, data, delimiter=dlmt)
