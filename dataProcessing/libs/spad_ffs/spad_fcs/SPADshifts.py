import numpy as np


def SPADshifts():
    shifts = []
    for xx in range(9):
        for yy in range(9):
            shifts.append(np.sqrt((xx-4)**2 + (yy-4)**2))
            
    shift = np.asarray(shifts)
    
    return shift