# -*- coding: utf-8 -*-
"""
Created on Wed May 22 10:46:35 2019

@author: SPAD-FCS
"""

class correlations:
    pass

def selectG(G, selection='average'):
    """
    Return a selection of the autocorrelations

    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    G           Object with all autocorrelations, i.e. output of e.g.
                FCS2CorrSplit
    selection   Default value 'average': select only the autocorrelations that 
                are averaged over multiple time traces.
                E.g. if FCS2CorrSplit splits a time trace in 10 pieces,
                calculates G for each trace and then calculates the average G, 
                all autocorrelations are stored in G. This function removes all
                of them except for the average G.
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    G           Autocorrelation object with only the pixel dwell time and the 
                average autocorrelations stored. All other autocorrelations are
                removed.
    ==========  ===============================================================
    """

    # get all attributes of G
    Glist = list(G.__dict__.keys())
    
    if selection == 'average':
        # make a new list containing only 'average' attributes
        Glist2 = [s for s in Glist if "average" in s]
    else:
        Glist2 = Glist
    
    # make a new object with the average attributes
    Gout = correlations()
    for i in Glist2:
        setattr(Gout, i, getattr(G, i))
        
    # add dwell time
    Gout.dwellTime = G.dwellTime
    
    return(Gout)
