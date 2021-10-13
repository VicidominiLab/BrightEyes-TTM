import numpy as np

def distance2detElements(det1, det2):
    """    
    Calculate the distance between two SPAD detector elements in a.u.
    
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    det1        Number of the first detector element
    det2        Number of the second detector element
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    distance    Distance between the two elements
    ==========  ===============================================================
    """
    
    row1 = np.floor(det1 / 5)
    col1 = np.mod(det1, 5)
    
    row2 = np.floor(det2 / 5)
    col2 = np.mod(det2, 5)
    
    distance = np.sqrt((row2 - row1)**2 + (col2 - col1)**2)
    
    return distance


def SPADcoordFromDetNumb(det):
    x = np.mod(det, 5)
    y = int(np.floor(det / 5))
    return([y, x])


def SPADshiftvectorCrossCorr(vector=[0, 0], N=5):
    CC = []
    shifty = vector[0]
    shiftx = vector[1]
    for det1 in range(25):
        [det1y, det1x] = SPADcoordFromDetNumb(det1)
        for det2 in range(25):
            [det2y, det2x] = SPADcoordFromDetNumb(det2)
            # only use subset of pixels: central 3x3 or 5x5 region
            distanceFromCenter = np.array([np.abs(det2y-2), np.abs(det2x-2), np.abs(det1y-2), np.abs(det1x-2)])
            if det2y-det1y == shifty and det2x-det1x == shiftx and np.all(distanceFromCenter <= (N-1)/2):
                CC.append('det' + str(det1) + 'x' + str(det2))
    return CC
    
