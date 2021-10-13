import matplotlib.pyplot as plt
import numpy as np
from scipy.optimize import least_squares

def fitPSF(image, pxsize=1, fitRange=15, Nbeads=5):
    """
    Show image of beads. The user selects 5 beads. Gaussians are fitted to get
    the width/height of the PSF.
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    image       2D/3D array with image data
    pxsize      pixel size (currently not used)
    fitRange    number of pixels up, down, left and right used as fit region
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    Print of the fit results, width is 1/e^2 radius
    ==========  ===============================================================
    """
    
    # check if data is 2D or 3D
    Ndim = len(np.shape(image))
    
    # sum all z positions for 3D data
    if Ndim == 2:
        imageSum = image
    else:
        imageSum = np.sum(image, 2)
    
    # plot image
    plt.figure()
    plt.imshow(imageSum)
    dataPoints = plt.ginput(Nbeads, show_clicks=True)
    
    # store results
    if Ndim == 2:
        listOfResults = np.zeros([Nbeads, 7])
    else:
        listOfResults = np.zeros([Nbeads, 10])

    for i in range(Nbeads):
        print(i)
        # go through all chosen points and fit 2D/3D Gaussian around this
        # center coordinates of the Gaussian
        x0 = int(dataPoints[i][0])
        y0 = int(dataPoints[i][1])
        # check region around center to not be out of bounds
        xmin, xmax = checkRange(x0, fitRange, 0, np.size(image, 1))
        ymin, ymax = checkRange(y0, fitRange, 0, np.size(image, 0))
        # get local image
        imageLoc = imageSum[ymin:ymax, xmin:xmax]
        plt.figure()
        plt.imshow(imageLoc)
        # fit Gaussian
        if Ndim == 2:
            imageLoc = image[ymin:ymax, xmin:xmax]
            res_lsq = gaussfitRes(imageLoc, [fitRange, fitRange+1, 3, 3, 1, 0, 0.01])
            # x0, y0, wx, wy, A, offset
            print(res_lsq.x)
            plt.figure()
            plt.imshow(gaussian(np.size(image, 1), np.size(image, 0), res_lsq.x[0] + xmin, res_lsq.x[1] + ymin, res_lsq.x[2], res_lsq.x[3], res_lsq.x[4], res_lsq.x[5], res_lsq.x[6]))
        else:
            Nz = np.shape(image)
            Nz = Nz[2]
            imageLoc = image[ymin:ymax, xmin:xmax, :]
            res_lsq = gaussfitRes3D(imageLoc, [fitRange, fitRange+1, int(Nz/2), 3, 3, 3, 0.1, 0.1, 1, 0]) # [x0, y0, z0, wx, wy, wz, ax, ay, A, offset]
        # print results
        print(res_lsq.success)
        print(res_lsq.x)
        if res_lsq.success:
            listOfResults[i, :] = np.abs(res_lsq.x)
    print('---------------------------------------')
    print('Average')
    print('---------------------------------------')
    print(np.average(listOfResults, 0))
    print('---------------------------------------')
    return listOfResults
        

def checkRange(x, fitRange, xmin, xmax):
    """
    Check that the region around the center of a Gaussian does not go out of
    bounds. If the user selects a bead close to the border of the image, the
    region around it, which is needed to fit the data, may go out of bounds.
    This function cuts the range to 0 and N with N+1 the width/height of the
    image.
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    x           bead coordinate (either x or y)
    fitRange    number of pixels up, down, left and right used as fit region
    xmin        minimum coordinate value allowed (0) before going of out bounds
    xmax        maximuum coordinate value allowed (N)
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    xmin, xmax  Input variables, but cut off if needed
                E.g. checkRange(10, 15, 0, 100) returns [0, 25]:
                    10 - 15 --> 0
                    10 + 15 --> 25
    ==========  ===============================================================
    """
    xmin = np.max([x - fitRange, xmin])
    xmax = np.min([x + fitRange, xmax-1])
    return xmin, xmax
        
        
def gaussfitRes(image, fitparamStart):
    """
    2D Gaussian least squares fit
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    image       2D matrix with image data to fit
    fitparamStart    Vector with initialization values for the fit parameters
                    see gaussfitfun2D for more information
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    fitresult   Object with the results of the fit
    ==========  ===============================================================
    """
    fitresult = least_squares(gaussfitfun2D, fitparamStart, args=(fitparamStart[0], image))
    return fitresult


def gaussfitRes3D(image, fitparamStart):
    """
    3D Gaussian least squares fit
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    image       3D matrix with image data to fit
    fitparamStart    Vector with initialization values for the fit parameters
                    see gaussfitfun3D for more information
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    fitresult   Object with the results of the fit
    ==========  ===============================================================
    """
    fitresult = least_squares(gaussfitfun3D, fitparamStart, args=(fitparamStart[0], image))
    return fitresult
        

def gaussfitfun2D(fitparam, dummy, image):
    """
    Calculate residuals of 2D Gaussian fit of 2D data
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    fitparam    Vector with initialization values for the fit parameters
                    [x0, y0, wx, wy, A, offset]
                    x0, y0      center coordinates of the Gaussian function
                    wx, wy      1/e^2 width in x and y
                    A           amplitude of the Gaussian
                    offset      offset of the Gaussian
    image       2D matrix with image data to fit
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    res         1D array with all the residuals
    ==========  ===============================================================
    """
    
    Ny = np.size(image, 0)
    Nx = np.size(image, 1)
    
    x0 = fitparam[0]
    y0 = fitparam[1]
    wx = fitparam[2]
    wy = fitparam[3]
    A = fitparam[4]
    offset = fitparam[5]
    rot = fitparam[6]
    
    res = np.reshape(gaussian(Nx, Ny, x0, y0, wx, wy, A, offset, rot) - image, [Nx*Ny, 1])
    res = np.ravel(res)
    
    return res


def gaussfitfun3D(fitparam, dummy, image):
    """
    Calculate residuals of 3D Gaussian fit of 3D data
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    fitparam    Vector with initialization values for the fit parameters
                    [x0, y0, z0, wx, wy, wz, ax, ay, A, offset]
                    x0, y0, z0  center coordinates of the Gaussian function
                    wx, wy, zw  1/e^2 width in x, y, and z
                    ax, ay      skew in x and y
                    A           amplitude of the Gaussian
                    offset      offset of the Gaussian
    image       3D matrix with image data to fit
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    res         1D array with all the residuals
    ==========  ===============================================================
    """
    
    Ny = np.size(image, 0)
    Nx = np.size(image, 1)
    Nz = np.size(image, 2)
    
    x0 = fitparam[0]
    y0 = fitparam[1]
    z0 = fitparam[2]
    wx = fitparam[3]
    wy = fitparam[4]
    wz = fitparam[5]
    ax = fitparam[6]
    ay = fitparam[7]
    A = fitparam[8]
    offset = fitparam[9]
    
    res = np.reshape(gaussian3D(Nx, Ny, Nz, x0, y0, z0, wx, wy, wz, ax, ay, A, offset) - image, [Nx*Ny*Nz, 1])
    res = np.ravel(res)
    
    return res


def gaussian(Nx, Ny, x0, y0, wx, wy, A, offset, rot):
    """
    Calculate 2D Gaussian function
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    Nx, Ny      Number of data points in horizontal, vertical direction
    x0, y0      Horizontal, vertical center of the Gaussian function
                (integers representing column and row)
    w0, wy      1/e^2 width of the Gaussian in horizontal, vertical direction
    A           Amplitude of the Gaussian
    offset      Offset
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    out         2D matrix with a 2D Gaussian function
    ==========  ===============================================================
    """
    meshgrid = np.meshgrid(np.linspace(0, Nx-1, Nx), np.linspace(0, Ny-1, Ny))
    x = meshgrid[0]
    y = meshgrid[1]
    out = A * np.exp(-2 * ((x-x0-rot*(y-y0))**2 / wx**2 + (y-y0)**2 / wy**2)) + offset
    return out


def gaussian3D(Nx, Ny, Nz, x0, y0, z0, wx, wy, wz, ax, ay, A, offset):
    """
    Calculate 3D Gaussian function
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    Nx, Ny, Nz  Number of data points in horizontal, vertical, and z direction
    x0, y0, z0  Horizontal, vertical, and z center of the Gaussian function
                (integers representing column, row, and plane)
    wx, wy, wz  1/e^2 width of the Gaussian in horizontal, vertical, and z-
                direction
    ax, ay      Skew in the x and y direction
    A           Amplitude of the Gaussian
    offset      Offset
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    out         3D matrix with a 3D Gaussian function
    ==========  ===============================================================
    """
    meshgrid = np.meshgrid(np.linspace(0, Nx-1, Nx), np.linspace(0, Ny-1, Ny), np.linspace(0, Nz-1, Nz))
    x = meshgrid[0]
    y = meshgrid[1]
    z = meshgrid[2]
    out = A * np.exp(-2 * ((x+ax*z-x0)**2 / wx**2 + (y+ay*z-y0)**2 / wy**2) + (z-z0)**2 / wz**2) + offset
    return out
    
