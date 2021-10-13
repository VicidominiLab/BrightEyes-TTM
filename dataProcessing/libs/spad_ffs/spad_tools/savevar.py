# -*- coding: utf-8 -*-
"""
Created on Fri Apr 12 12:01:51 2019

@author: SPAD-FCS
"""

import pickle
from spad_tools.checkfname import checkfname


def savevar(var, fname):
    fname = checkfname(fname, 'pickle')
    with open(fname, 'wb') as f:
        pickle.dump(var, f)


def openvar(fname):
    fname = checkfname(fname, 'pickle')
    with open(fname, 'rb') as f:
        data = pickle.load(f)
        return data
