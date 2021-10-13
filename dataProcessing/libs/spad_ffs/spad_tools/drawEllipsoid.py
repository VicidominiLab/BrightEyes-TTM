import numpy as np
import matplotlib.pyplot as plt


def drawEllipsoid(rx, ry, rz, plotFig=True, res=100):
    """
    Calculate and draw ellipsoid
    ===========================================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    rx, ry, rz  Radius of the ellipsoid in x, y, z
    plotFig     Plot figure [True / False]
    res         Resolution, i.e. number of data points
    ===========================================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    [x, y, z]   List of x, y, z coordinates of the ellipsoid
    Figure      Plot with ellipsoid if plotFig==True
    ===========================================================================
    """
    
    # Set of all spherical angles:
    u = np.linspace(0, 2 * np.pi, res)
    v = np.linspace(0, np.pi, res)
    
    # Cartesian coordinates that correspond to the spherical angles:
    # (this is the equation of an ellipsoid):
    x = rx * np.outer(np.cos(u), np.sin(v))
    y = ry * np.outer(np.sin(u), np.sin(v))
    z = rz * np.outer(np.ones_like(u), np.cos(v))
    
    # Plot:
    if plotFig:
        fig = plt.figure()
        ax = plt.axes(projection = "3d")
        ax.plot_surface(x, y, z,  rstride=4, cstride=4, color='b', alpha=0.2)
        Min = np.min([np.min(x), np.min(y), np.min(z)])
        Max = np.max([np.max(x), np.max(y), np.max(z)])
        ax.set_xlim([Min, Max])
        ax.set_ylim([Min, Max])
        ax.set_zlim([Min, Max])
    
    return([x, y, z])
