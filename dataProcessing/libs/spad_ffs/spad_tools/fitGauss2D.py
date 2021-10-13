import numpy as np
from scipy.optimize import least_squares


def fitGauss2D(y, fitInfo, param, weights=1):
    """
    Fit 2D Gaussian function for STICS analysis
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    y               Matrix with function values
    fitInfo         np.array boolean vector with always 5 elements
                        1 for a fitted parameter, 0 for a fixed parameter
                        order: [x0, y0, A, sigma, offset]
                        E.g. to fit sigma and offset this becomes [0, 0, 0, 1, 1]
    param           List with starting values for all parameters:
                        order: [x0, y0, A, sigma, offset]
    weights         Matrix with weight values
                        1 for unweighted fit
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    fitresult   Result of the nonlinear least squares fit
    ==========  ===============================================================
    """
    
    fitInfo = np.array(fitInfo)
    param = np.array(param)
    lowerBounds = np.array([0, 0, 0, 1e-10, -100])
    upperBounds = np.array([1e6, 1e6, 1e6, 1e6, 100])
    
    fitparamStart = param[fitInfo==1]
    fixedparam = param[fitInfo==0]
    lowerBounds = lowerBounds[fitInfo==1]
    upperBounds = upperBounds[fitInfo==1]
    
    fitresult = least_squares(fitfunGauss2D, fitparamStart, args=(fixedparam, fitInfo, y, weights), bounds=(lowerBounds, upperBounds))
    
    return fitresult
    

def fitfunGauss2D(fitparamStart, fixedparam, fitInfo, y, weights=1):
    """
    Calculate residuals 2D Gaussian function for STICS analysis
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    fitparamStart       List with starting values for the fit parameters:
                        order: [x0, y0, A, sigma, offset]
                        with    x0, y0      position of the Gaussian center
                                A           amplitude of the Gaussian
                                sigma       Standard deviation of the Gaussian
                                            w0 = 2 * sigma
                                            with w0 1/e^2 radius
                                offset      dc offset
    fixedparam          List with values for the fixed parameters:
    fitInfo             Boolean list of always 5 elements
                                1   fit this parameters
                                0   keep this parameter fixed
    y                   Matrix with experimental function values
    weights             Matrix with fit weights
                                1 for unweighted fit
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    res         Vector with residuals: f(param) - y
    ==========  ===============================================================
    """
    param = np.float64(np.zeros(5))
    param[fitInfo==1] = fitparamStart
    param[fitInfo==0] = fixedparam
    
    x0 = param[0]
    y0 = param[1]
    A = param[2]
    sigma = param[3]
    offset = param[4]
    Ny = np.shape(y)[0]
    Nx = np.shape(y)[1]
    
    res = np.reshape(weights * (normal2D(Nx, Ny, x0, y0, A, sigma, offset) - y), [Nx*Ny, 1])
    res = np.ravel(res)

    return res


def normal2D(Nx, Ny, x0, y0, A, sigma, offset):
    """
    Calculate normal 2D distribution
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    Nx, Ny      Number of columns and rows of the data matrix
    x0, y0      Column and row number of the center of the Gaussian function
    A           Amplitude
    sigma       Standard deviation of the Gaussian function
    offset      DC component
    
    y = exp(- ((x-x0)^2 + (y-y0)^2) / (2*sigma^2))
    
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    out         Matrix with normal distribution
    ==========  ===============================================================
    """
    meshgrid = np.meshgrid(np.linspace(0, Nx-1, Nx), np.linspace(0, Ny-1, Ny))
    x = meshgrid[0]
    y = meshgrid[1]
    out = A * np.exp(-((x-x0)**2 + (y-y0)**2) / 2 / sigma**2) + offset
    return out