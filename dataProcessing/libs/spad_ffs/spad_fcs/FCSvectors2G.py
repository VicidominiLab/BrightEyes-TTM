import numpy as np
from FCS2Corr import correlations


def FCSvectors2G(tau, G, fieldName='central'):
    Gmatrix = np.zeros((np.size(tau, 0), 2))
    Gmatrix[:, 0] = tau
    Gmatrix[:, 1] = G
    G = correlations()
    setattr(G, fieldName, Gmatrix)
    return G
    