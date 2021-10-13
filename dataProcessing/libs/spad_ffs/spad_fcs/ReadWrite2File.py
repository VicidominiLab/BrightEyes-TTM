# -*- coding: utf-8 -*-
"""
Created on Fri Feb 22 11:45:30 2019

@author: SPAD-FCS
"""

import pickle
 
def write2file(obj, fname):
    # 
    f = file(filename, 'rb')

    # Saving the objects:
    with open('objs.pkl', 'wb') as f:
        pickle.dump(countArray, f)

# Getting back the objects:
with open('objs.pkl', 'rb') as f:
    countArray2 = pickle.load(f)