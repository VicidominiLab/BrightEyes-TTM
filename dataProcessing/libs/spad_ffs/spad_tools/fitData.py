import numpy as np
from scipy.optimize import least_squares
import matplotlib.pyplot as plt


def fitAndPlot(y, x, fitfun, fitInfo, param, lBounds=-1, uBounds=-1, printResults=1, plotFit=1):
    """
    Fit 1D curve with any of the implemented fit functions
    See fitData for the meaning of the parameters
    Results are plotted
    """
    
    # number of total parameters
    Nparam = len(fitInfo)
    
    # check bounds
    if lBounds == -1:
        lBounds = np.zeros(Nparam)
    if uBounds == -1:
        uBounds = np.zeros(Nparam) + 1e4
    
    # perform fit
    fitresult = fitData(y, x, fitfun, fitInfo, param, lBounds, uBounds)    
    
    # print results
    if printResults:
        fittedParam = fitresult.x
        for i in range(len(fittedParam)):
            print(str(fittedParam[i]))
    
    # plot results
    if plotFit:
        plt.rcParams.update({'font.size': 20})
        plt.figure()
        plt.scatter(x, y, s=1)
        plt.plot(x, y-fitresult.fun)
    
    return fitresult


def fitData(y, x, fitfun, fitInfo, param, lBounds, uBounds):
    """
    Fit 1D curve with any of the implemented fit functions
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    y           Vector with y values
    x           Vector with x values
    fitfun      Fit function
                    'exp'                 A1 * exp(-alpha1 * x) +
                                        + A2 * exp(-alpha2 * x) +
                                        + ...
                                        + An * exp(-alphan * x) +
                                        + B
    fitInfo     np.array boolean vector with [A1, alpha1,..., alphan, C]
                    1 if this value has to be fitted
                    0 if this value is fixed during the fit
    param       np.array vector with start values for [A, B, C]
                    A ~ 1e6*2.5e-8
                    B ~ -1.05
    lBounds     Vector with lower bounds for all parameters
    uBounds     Vector with upper bounds for all parameters
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    fitresult   Output of least_squares
                    fitresult.x = fit results
    ==========  ===============================================================
    """

    # make sure that all variables are np.arrays
    fitInfo = np.asarray(fitInfo)
    param = np.asarray(param)
    lBounds = np.asarray(lBounds)
    uBounds = np.asarray(uBounds)

    # parse fit and fixed parameters
    fitparamStart = param[fitInfo==1]
    fixedparam = param[fitInfo==0]
    lowerBounds = lBounds[fitInfo==1]
    upperBounds = uBounds[fitInfo==1]    

    # perform fit
    if fitfun == 'exp':
        fitresult = least_squares(fitfunExpN, fitparamStart, args=(fixedparam, fitInfo, x, y), bounds=(lowerBounds, upperBounds))

    return fitresult


def fitfunExpN(fitparamStart, fixedparam, fitInfo, x, y):
    """
    Exponential fit function (sum of multiple exponentials is possible)
    y = A * exp(-alpha * x) + B
    (alpha = 1 / tau with tau the lifetime)
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    fitparamStart   List with starting values for the fit parameters:
                        order: [A, alpha, B]
                        E.g. if only A and B are fitted, this becomes a two
                        element vector [1e-4, 0.2]
    fixedparam      List with values for the fixed parameters:
                        order: [A, alpha, B]
                        same principle as fitparamStart
    fitInfo         np.array boolean vector with always 3 elements
                        1 for a fitted parameter, 0 for a fixed parameter
    x               Vector with x values
    y               Vector with experimental y values
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    res         Residuals
    ==========  ===============================================================
    """
    
    fitparam = np.float64(np.zeros(len(fitInfo)))
    fitparam[fitInfo==1] = fitparamStart
    fitparam[fitInfo==0] = fixedparam
    
    # calculate theoretical exponential function
    ytheo = 0
    for i in range(int((len(fitparam) - 1) / 2)):
        A = fitparam[2*i]
        alpha = fitparam[2*i+1]
        ytheo += A * np.exp(-alpha * x)
    B = fitparam[-1]
    ytheo += B
    
    # calculate residuals
    res = y - ytheo
    
    return res
