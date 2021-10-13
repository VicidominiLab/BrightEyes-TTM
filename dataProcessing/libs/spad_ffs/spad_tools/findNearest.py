import numpy as np


def findNearest(array, value):
    """
    Find nearest value and index of value in array.
    function call: [value2, idx] = findNearest(array, value)
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    array       1D array of values to look into
    value       Number to find in the array
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    value2      Value in array that is closest to value
    idx         Index of this value in the array
    ==========  ===============================================================

    """

    array = np.asarray(array)
    
    idx = (np.abs(array - value)).argmin()
    value2 = array[idx]
    
    return value2, idx
