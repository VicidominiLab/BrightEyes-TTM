import pickle


def checkfname(fname):
    if len(fname) <= 7 or fname[-7:] != ".pickle":
        fname = fname + ".pickle"
    return fname


def savefig(h, fname):
    fname = checkfname(fname)
    pickle.dump(h, open(fname, 'wb'))


def openfig(fname):
    fname = checkfname(fname)
    pickle.load(open(fname, 'rb'))
