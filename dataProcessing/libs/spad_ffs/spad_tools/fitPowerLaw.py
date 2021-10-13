import numpy as np
from scipy.optimize import least_squares
import matplotlib.pyplot as plt


def fitPowerLawG(G, start=0, plotIndv=True, fitInfo=np.array([1, 1, 0]), param=np.array([3.1, -1, 0])):
    # remove dwellTime field from G list
    Gkeys = list(G.__dict__.keys())
    if "dwellTime" in Gkeys:
        Gkeys.remove("dwellTime")
    
    # number of curves
    Nc = len(Gkeys)
        
    # create empty array to store fitreseults
    fitresults = np.zeros((Nc, np.sum(fitInfo)))
    
    # check how to plot
    if Nc == 25 and plotIndv == False:
        plt.rcParams.update({'font.size': 6})
        fig, axs = plt.subplots(5, 5, figsize = (9, 6))
        fig.subplots_adjust(hspace = 1, wspace=.1)
        axs = axs.ravel()
    
    for i in range(len(Gkeys)):
        GName = Gkeys[i]
        Gtemp = getattr(G, GName)
        y = Gtemp[start:,1]
        x = Gtemp[start:,0]
        fitresult = fitPowerLaw(y, x, 'powerlaw', fitInfo, param, np.array([0, -10, -10]), np.array([100, 0, 100]), 0)
        if len(Gkeys) > 10:
            detNr = int(GName[3:-8])
        else:
            detNr = i
        fitresults[detNr, :] = np.array(fitresult.x)
        if Nc == 25 and plotIndv == False:
            axs[detNr].plot(x, y-fitresult.fun, c='k')
            axs[detNr].scatter(x, y, s=3)
            axs[detNr].set_xscale('log')
            axs[detNr].set_title(GName)
        elif plotIndv:
            plt.rcParams.update({'font.size': 20})
            plt.figure()
            plt.scatter(x, y, s=1)
            plt.plot(x, y-fitresult.fun)
            plt.xscale('log')
            plt.title(GName)
    return fitresults


def fitPowerLaw(y, x, fitfun, fitInfo, param, lBounds, uBounds, savefig=0):
    """
    Fit 1D curve with a power law y = A * x^B + C
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    y           Vector with y values
    x           Vector with x values
    fitfun      Fit function
                    'powerlaw'           A * B^x + C
                    'exp'                A * exp(-alpha * x) + B
    fitInfo     np.array boolean vector with [A, B, C]
                    1 if this value has to be fitted
                    0 if this value is fixed during the fit
    param       np.array vector with start values for [A, B, C]
                    A ~ 1e6*2.5e-8
                    B ~ -1.05
    lBounds     Vector with lower bounds for the parameters
    uBounds     Vector with upper bounds for the parameters
    savefig     0 to not save the figure
                file name with extension to save as "png" or "eps"
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
    if fitfun == 'powerlaw':
        fitresult = least_squares(fitfunPowerLaw, fitparamStart, args=(fixedparam, fitInfo, x, y), bounds=(lowerBounds, upperBounds))
    elif fitfun == 'exp':
        fitresult = least_squares(fitfunExp, fitparamStart, args=(fixedparam, fitInfo, x, y), bounds=(lowerBounds, upperBounds))
        
    #plotFit(x, y, param, fitInfo, fitresult, savefig)

    return fitresult


def fitfunPowerLaw(fitparamStart, fixedparam, fitInfo, x, y):
    """
    Power law fit function
    y = A * B^x + C
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    fitparamStart   List with starting values for the fit parameters:
                        order: [A, B, C]
                        E.g. if only A and B are fitted, this becomes a two
                        element vector [1e-4, 0.2]
    fixedparam      List with values for the fixed parameters:
                        order: [A, B, C]
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
    
    # get parameters
    A = fitparam[0]
    B = fitparam[1]
    C = fitparam[2]

    # calculate theoretical power law function
    ytheo = A * x**B + C
    
    # calcualte residuals
    res = y - ytheo
    
    return res


def fitfunExp(fitparamStart, fixedparam, fitInfo, x, y):
    """
    Exponential fit function
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
    
    # get parameters
    A = fitparam[0]
    alpha = fitparam[1]
    B = fitparam[2]

    # calculate theoretical power law function
    ytheo = A * np.exp(-alpha * x) + B
    
    # calculate residuals
    res = y - ytheo
    
    return res
