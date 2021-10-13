import numpy as np

def plotColors(info):
    """
    return the color for a given plot, depending on what is plotted
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    info        String with plot info:
                    'central'   FCS curve central pixel
                    'sum3'      FCS curve sum 3x3 pixels
                    'sum5'      FCS curve sum 5x5 pixels
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    clr         Color for this plot
    ==========  ===============================================================
    """
    
    colorDict = {
        'central':              '#1f77b4',
        'central_average':      '#1f77b4',
        'auto1_average':        '#1f77b4',
        'sum3':                 '#ff7f0e',
        'sum3_average':         '#ff7f0e',
        'auto2_average':        '#ff7f0e',
        'sum5':                 '#2ca02c',
        'sum5_average':         '#2ca02c',
        'cross12_average':      '#2ca02c',
        'allbuthot':            '#031703',
        'allbuthot_average':    '#031703',
        'cross21_average':      '#031703',
        'chessboard':           '#d62728',
        'chessboard_average':   '#d62728',
        'cross_average':        '#9467bd',
        'chess3_average':       '#d62728',
        'ullr':                 '#9467bd',
        'ullr_average':         '#9467bd',
        'av':                   '#8c564b'
    }
    
    colorArray = ['#1f77b4', '#ff7f0e', '#2ca02c', '#d62728', '#9467bd', '#8c564b']
    
    if isinstance(info, int):
        return colorArray[np.mod(info, 6)]
    else:
        return colorDict.get(info, '#1f77b4')

