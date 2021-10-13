import numpy as np
from scipy.optimize import least_squares
from spad_fcs.FCSanalytical import FCSanalytical
from spad_fcs.FCSanalytical import FCS2Canalytical
from spad_fcs.plotPyCorrFit import plotPyCorrFit
from spad_fcs.plotPyCorrFit import PyCorrFitData
from spad_fcs.FCSanalytical import FCSDualFocus
import matplotlib.pyplot as plt


def FCSfit(Gexp, tau, fitfun, fitInfo, param, lBounds, uBounds, plotInfo, splitData=0, savefig=0, plotTau=True):
    """
    Fit experimental FCS data to the analytical model
    Assuming 3D diffusion in a Gaussian focal volume
    No triplet state assumed
    ===========================================================================
    Input       Meaning
    ---------------------------------------------------------------------------
    Gexp        Vector with experimental autocorrelation curve (G)
    tau         Vector with lag times [s]
    fitfun      Fit function
                    'fitfun2C'           Fit two components
                    'fitfunDualFocus'    Fit two-focus FCS
    fitInfo     np.array boolean vector with [N, tauD, SP, offset, 1e6*A, B, vx, vy]
                    1 if this value has to be fitted
                    0 if this value is fixed during the fit
    param       np.array vector with start values for [N, tauD, SP, offset, A, B, vx, vy]
                    A ~ 1e6*2.5e-8
                    B ~ -1.05
    savefig     0 to not save the figure
                file name with extension to save as "png" or "eps"
    ===========================================================================
    Output      Meaning
    ---------------------------------------------------------------------------
    fitresult   Output of least_squares
                    fitresult.x = fit results
                        tauD in [ms]
    ===========================================================================
    """

    fitparamStart = param[fitInfo==1]
    fixedparam = param[fitInfo==0]
    lowerBounds = lBounds[fitInfo==1]
    upperBounds = uBounds[fitInfo==1]
    print('------')

    if fitfun == 'fitfun2C':
        fitresult = least_squares(fitfun2C, fitparamStart, args=(fixedparam, fitInfo, tau, Gexp), bounds=(lowerBounds, upperBounds))
    elif fitfun == 'fitfunDualFocus':
        fitresult = least_squares(fitfunDualFocus, fitparamStart, args=(fixedparam, fitInfo, tau, Gexp, splitData), bounds=(lowerBounds, upperBounds))
    elif fitfun == 'fitfunCircFCS':
        fitresult = least_squares(fitfunCircFCS, fitparamStart, args=(fixedparam, fitInfo, tau, Gexp), bounds=(lowerBounds, upperBounds))

    plotFit(tau, Gexp, param, fitInfo, fitresult, plotInfo, savefig, plotTau)
    print('tauD = ' + str(fitresult.x[1]) + ' ms')
    print('chi2 = ' + str(chi2FCSfit(tau, Gexp, fitInfo, fitresult)))

    return fitresult


def FCSfitDualFocus(Gexp, tau, fitInfo, param, plotResults=True, useSingleW=False):
    """
    Fit experimental FCS data to the analytical model
    Assuming 3D diffusion in a Gaussian focal volume
    No triplet state assumed
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    Gexp        2D matrix with correlation curves
                    Each column is a correlation curve
    tau         Vector with tau values for a single autocorrelation curve [s]
    fitInfo     np.array boolean vector with
                    [c, D, w0, ..., wN, SF0, ..., SFN, rho0, ..., rhoN, dc0, ..., dcN]
                    1 if this value has to be fitted
                    0 if this value is fixed during the fit
    param       np.array vector with start values for all the parameters
    limits      Vector with start and stop value to crop G
    ==========  ===============================================================

    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    fitresult   Output of least_squares
    ==========  ===============================================================

    """

    fitparamStart = param[fitInfo==1]
    fixedparam = param[fitInfo==0]
    
    # concatenate all G vectors in single array
    if len(np.shape(Gexp)) == 1:
        # Gexp is vector: only one G given
        NG = 1
    else:
        NG = np.size(Gexp, 1)
    Ntau = np.size(Gexp, 0)
    Gall = np.reshape(np.transpose(Gexp), [Ntau * NG])
    tauall = np.concatenate([tau for i in range(NG)])
    # create vector with ranges of individual correlations
    splitData = [i*Ntau for i in range(NG+1)]
    
    fitresult = least_squares(fitfunDualFocus, fitparamStart, args=(fixedparam, fitInfo, tauall, Gall, splitData, useSingleW))
    
    # plot fit result
    if plotResults:
        Dfitted = param[2]**2 / 4 / (1e-3 * fitresult.x[1])
        residuals = fitresult.fun
        Gfitresult = Gall - residuals
        plt.figure()
        for i in range(NG):
            plt.plot(tau, Gfitresult[splitData[i]:splitData[i+1]])
        plt.xscale('log')
        plt.xlabel('tau (s)')
        plt.ylabel('G')
        plt.ylim([np.min(Gall), np.max(Gall)])
        plt.title('Fit results - Fitted D = ' + "{:.2e}".format(1e12*Dfitted) + ' µm^2/s')
        if NG == 6:
            leg = ['$\Delta r = 0$', '$\Delta r = 1$', '$\Delta r = \sqrt{2}$', '$\Delta r = 2$', '$\Delta r = \sqrt{5}$', '$\Delta r = 2\sqrt{2}$']
            plt.legend(leg)
        elif NG == 5:
            leg = ['$\Delta r = 1$', '$\Delta r = \sqrt{2}$', '$\Delta r = 2$', '$\Delta r = \sqrt{5}$', '$\Delta r = 2\sqrt{2}$']
            plt.legend(leg)
        plt.tight_layout()
        
        # plot fit residuals
        residuals = fitresult.fun
        plt.figure()
        for i in range(NG):
            plt.plot(tau, residuals[splitData[i]:splitData[i+1]])
        plt.xscale('log')
        plt.xlabel('tau (s)')
        plt.ylabel('G')
        plt.title('Fit residuals')
        if NG == 6:
            leg = ['$\Delta r = 0$', '$\Delta r = 1$', '$\Delta r = \sqrt{2}$', '$\Delta r = 2$', '$\Delta r = \sqrt{5}$', '$\Delta r = 2\sqrt{2}$']
            plt.legend(leg)
        elif NG == 5:
            leg = ['$\Delta r = 1$', '$\Delta r = \sqrt{2}$', '$\Delta r = 2$', '$\Delta r = \sqrt{5}$', '$\Delta r = 2\sqrt{2}$']
            plt.legend(leg)
        plt.tight_layout()
        
        # plot original G
        plt.figure()
        for i in range(NG):
            plt.plot(tau, Gall[splitData[i]:splitData[i+1]])
        plt.xscale('log')
        plt.xlabel('tau (s)')
        plt.ylabel('G')
        plt.ylim([np.min(Gall), np.max(Gall)])
        plt.title('Experimental cross-correlations')
        if NG == 6:
            leg = ['$\Delta r = 0$', '$\Delta r = 1$', '$\Delta r = \sqrt{2}$', '$\Delta r = 2$', '$\Delta r = \sqrt{5}$', '$\Delta r = 2\sqrt{2}$']
            plt.legend(leg)
        elif NG == 5:
            leg = ['$\Delta r = 1$', '$\Delta r = \sqrt{2}$', '$\Delta r = 2$', '$\Delta r = \sqrt{5}$', '$\Delta r = 2\sqrt{2}$']
            plt.legend(leg)
        plt.tight_layout()
        
        # plot original G and fit
        plt.figure()
        for i in range(NG):
            plt.plot(tau, Gall[splitData[i]:splitData[i+1]])
            plt.plot(tau, Gfitresult[splitData[i]:splitData[i+1]], 'k')
        plt.xscale('log')
        plt.xlabel('tau (s)')
        plt.ylabel('G')
        plt.ylim([np.min(Gall), np.max(Gall)])
        if NG == 6:
            leg = ['$\Delta r = 0$', '$\Delta r = 1$', '$\Delta r = \sqrt{2}$', '$\Delta r = 2$', '$\Delta r = \sqrt{5}$', '$\Delta r = 2\sqrt{2}$']
            plt.legend(leg)
        elif NG == 5:
            leg = ['$\Delta r = 1$', '$\Delta r = \sqrt{2}$', '$\Delta r = 2$', '$\Delta r = \sqrt{5}$', '$\Delta r = 2\sqrt{2}$']
            plt.legend(leg)
        plt.tight_layout()

    return fitresult


def fitfun(fitparamStart, fixedparam, fitInfo, tau, yexp):
    """
    FCS fit function
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    fitparamStart   List with starting values for the fit parameters:
                        order: [N, tauD, SP, offset, A, B]
                        E.g. if only N and tauD are fitted, this becomes a two
                        element vector [1, 1e-3]
    fixedparam      List with values for the fixed parameters:
                        order: [N, tauD, SP, offset, 1e6*A, B]
                        same principle as fitparamStart
    fitInfo         np.array boolean vector with always 6 elements
                        1 for a fitted parameter, 0 for a fixed parameter
                        E.g. to fit N and tau D this becomes [1, 1, 0, 0, 0, 0]
                        order: [N, tauD, SP, offset, 1e6*A, B]
    tau             Vector with tau values
    yexp            Vector with experimental autocorrelation
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    res         Residuals
    ==========  ===============================================================
    """
    
    fitparam = np.float64(np.zeros(6))
    fitparam[fitInfo==1] = fitparamStart
    fitparam[fitInfo==0] = fixedparam
    
    N = fitparam[0]
    tauD = fitparam[1]
    SF = fitparam[2]
    offset = fitparam[3]
    A = fitparam[4]
    B = -fitparam[5]

    # calculate theoretical autocorrelation function    
    FCStheo = FCSanalytical(tau, N, tauD, SF, offset, 1e-6*A, B)
    
    # calcualte residuals
    res = yexp - FCStheo
    
    return res


def fitfun2C(fitparamStart, fixedparam, fitInfo, tau, yexp):
    """
    FCS fit function two components
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    fitparamStart   List with starting values for the fit parameters:
                        order: [N, tauD1, tauD2, F, alpha, T, tautrip, SF, offset, A, B]
                        E.g. if only N and tauD1 are fitted, this becomes a two
                        element vector [1, 1e-3]
    fixedparam      List with values for the fixed parameters:
                        order: [N, tauD1, tauD2, F, alpha, T, tautrip, SF, offset, A, B]
                        same principle as fitparamStart
    fitInfo         np.array boolean vector with always 11 elements
                        1 for a fitted parameter, 0 for a fixed parameter
                        E.g. to fit N and tau D this becomes [1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0]
                        order: [N, tauD1, tauD2, F, alpha, T, tautrip, SF, offset, A, B]
    tau             Vector with tau values
    yexp            Vector with experimental autocorrelation
    
    parameters  N       number of particles in focal volume [dim.less]
                tauD1   diffusion time species 1 [ms]
                tauD2   diffusion time species 2 [ms]
                F       fraction of species 1 [dim.less]
                alpha   relative molecular brightness [dim.less]
                T       fraction in triplet [dim.less]
                tautrip residence time in triplet state [µs]
                SF      shape factor [dim.less]
                offset  [dim.less]
                A, B    afterpulsing properties
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    res         Residuals
    ==========  ===============================================================
    """
    
    fitparam = np.float64(np.zeros(11))
    fitparam[fitInfo==1] = fitparamStart
    fitparam[fitInfo==0] = fixedparam
    
    # convert to SI
    N = fitparam[0]
    tauD1 = 1e-3 * fitparam[1] # ms to s
    tauD2 = 1e-3 * fitparam[2] # ms to s
    F = fitparam[3]
    alpha = fitparam[4]
    T = fitparam[5]
    tautrip = 1e6 * fitparam[6] # s
    SF = fitparam[7]
    offset = fitparam[8]
    A = 1e-6 * fitparam[9]
    B = -fitparam[10]

    # calculate theoretical autocorrelation function
    FCStheo = FCS2Canalytical(tau, N, tauD1, tauD2, F, alpha, T, tautrip, SF, offset, A, B)
    
    # calcualte residuals
    res = yexp - FCStheo
    
    return res


def fitfunDualFocus(fitparamStart, fixedparam, fitInfo, tau, yexp, splitData, useSingleW=False):
    """
    Dual focus FCS fit function
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    fitparamStart   List with starting values for the fit parameters:
                        order: [c, tauD, w2 for all, SF for all, rho for all, offset for all]
                        E.g. if only N and tauD are fitted, this becomes a two
                        element vector [1, 1e-3]
    fixedparam      List with values for the fixed parameters:
                        order: [N, tauD, SF, offset]
                        same principle as fitparamStart
    fitInfo         np.array boolean vector with always 4 elements
                        1 for a fitted parameter, 0 for a fixed parameter
                        E.g. to fit N and tau D this becomes [1, 1, 0, 0]
                        order: [N, tauD, SF, offset]
    tau             Vector with tau values
                        All curves are concatenated
    yexp            Vector with experimental autocorrelation
    splitData       Vector with indices to split data
                        has to start with 0 and end with N (= number of data points)
                        E.g. [0 100 200] will split the data into two traces
                        One from 0 to 99 and one from 100 to 199
    useSingleW      Use the same w0 value for all cross-correlation curves
                    If True, "fitparamStart", "fixedparam" and "fitInfo"
                    remain as before, bu only the first w0 value is used
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    res         Fit residuals
    ==========  ===============================================================
    """
    
    sD = splitData
    Ntraces = len(sD) - 1
    
    fitparam = np.float64(np.zeros(4 + 5*Ntraces))
    fitparam[fitInfo==1] = fitparamStart
    fitparam[fitInfo==0] = fixedparam
    
    N0 = fitparam[0]
    tauD0 = 1e-3 * fitparam[1] # ms -> s
    w = fitparam[2:2+Ntraces]
    if useSingleW:
        w = w * 0 + fitparam[2]
    SF = fitparam[2+Ntraces:2+2*Ntraces]
    rhox = fitparam[2+2*Ntraces:2+3*Ntraces]
    rhoy = fitparam[2+3*Ntraces:2+4*Ntraces]
    vx = fitparam[2+4*Ntraces:3+4*Ntraces]
    vy = fitparam[3+4*Ntraces:4+4*Ntraces]
    dc = fitparam[4+4*Ntraces:4+5*Ntraces]
    
    # get particle concentration
    c = N0 / np.pi**(3/2) / w[0]**3 / SF[0]
    # calculate N for all curves
    N = [np.pi**(3/2) * c * w[i]**3 * SF[i] for i in range(Ntraces)]
    
    # get diffusion coefficient
    D = w[0]**2 / 4 / tauD0
    
#    plt.figure()
#    for i in range(Ntraces):
#        plt.plot(tau[sD[i]:sD[i+1]], FCSDualFocus(tau[sD[i]:sD[i+1]], N[i], D, w[i], SF[i], rho[i], dc[i]))
#        plt.plot(tau[sD[i]:sD[i+1]], yexp[sD[i]:sD[i+1]])
#    plt.xscale('log')
    yModel = np.concatenate([FCSDualFocus(tau[sD[i]:sD[i+1]], N[i], D, w[i], SF[i], rhox[i], rhoy[i], dc[i], vx, vy) for i in range(Ntraces)])

    res = yexp - yModel
    
    return res


def fitfunCircFCS(fitparamStart, fixedparam, fitInfo, tau, yexp):
    """
    Dual focus FCS fit function
    ===========================================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    fitparamStart   List with starting values for the fit parameters:
                        order: [N, tauD, w, SF, Rcirc, Tcirc, offset]
                        E.g. if only N and tauD are fitted, this becomes a two
                        element vector [1, 1e-3]
    fixedparam      List with values for the fixed parameters
                        same principle as fitparamStart
    fitInfo         np.array boolean vector with always 7 elements
                        1 for a fitted parameter, 0 for a fixed parameter
                        E.g. to fit N and tau D this becomes [1, 1, 0, 0, 0, 0, 0]
    tau             Vector with tau values
    yexp            Vector with experimental autocorrelation
    ===========================================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    res         Fit residuals
    ===========================================================================
    """
    
    fitparam = np.float64(np.zeros(7))
    fitparam[fitInfo==1] = fitparamStart
    fitparam[fitInfo==0] = fixedparam
    
    N = fitparam[0]
    tauD0 = 1e-3 * fitparam[1] # ms -> s
    w = fitparam[2]
    SF = fitparam[3]
    Rcirc = fitparam[4]
    Tcirc = fitparam[5]
    alpha = 2 * np.pi / Tcirc * tau
    rho = Rcirc * np.sqrt(2-2*np.cos(alpha)) # = 2 * Rcirc * abs(sin(alpha/2))
    dc = fitparam[6]
    
    # get diffusion coefficient
    D = w**2 / 4 / tauD0

    yModel = FCSDualFocus(tau, N, D, w, SF, rho, 0, dc, 0, 0)

    res = yexp - yModel
    
    return res


def plotFit(tau, yexp, param, fitInfo, fitResult, plotInfo="", savefig=0, plotTau=True):  
    # final parameters
    param[fitInfo==1] = fitResult.x
    # param now contains the final values for [N, tauD, SF, offset]
    # store in object
    data = PyCorrFitData()
    if len(param) < 7:
        data.tauD = 1e3 * param[1] # in ms
    else:
        data.tauD = [param[1], param[2]] # in ms, 2 components
    
    G = yexp
    Gres = fitResult.fun
    Gfit = G - Gres
    
    Gdata = np.zeros([len(tau), 4])
    Gdata[:, 0] = tau
    Gdata[:, 1] = G
    Gdata[:, 2] = Gfit
    Gdata[:, 3] = Gres
    
    data.data = Gdata
    
    # plot
    plotPyCorrFit(data, plotInfo, savefig, plotTau)


def G2globalFitStruct(G, listOfFields=['spatialCorr'], start=0, N=5):
    """
    Create all variables needed for FCS fit based on correlation object G
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    G               Correlation object
    listOfFields    Type of analysis, e.g. "spatialCorr", "crossCenterAv",...
    start           Start index for G and tau
    N               Number of correlations to use
                     For "spatialCorr", N=3 means the central 3x3 square of G
                     For "crossCenterAv", N=3 means rho=1, rho=sqrt(2), and
                         rho=2 are used
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    Gout            Vector with all G's appended to one another
    tau             Vector with all tau's appended to one another
    split           Vector with the boundary indices for Gout and tau
    rhox, rhoy      Vector with rhox and rhoy values for all Gout values
    Gcolumns        2D matrix with all G's in different columns
    ==========  ===============================================================
    """
    if listOfFields == '':
        listOfFields = list(G.__dict__.keys())
    pxdwelltime = G.dwellTime
    tau = []
    Gout = []
    rhox = []
    rhoy = []
    if 'spatialCorr' in listOfFields:
        Gcrop = G.spatialCorr[:, :, start:]
        Gshape = np.shape(Gcrop)
        GNy = Gshape[0]
        GNx = Gshape[1]
        GNt = Gshape[2]
        Gcolumns = np.zeros((GNt, N**2))
        Centerx = int(np.floor(GNx/2))
        Centery = int(np.floor(GNy/2))
        GxStart = int(-np.floor(N/2))
        for i in range(N):
            for j in range(N):
                Gcolumns[:, i*N+j] = Gcrop[GxStart+i+Centery, GxStart+j+Centerx, :]
                rhox = np.append(rhox, GxStart+j)
                rhoy = np.append(rhoy, GxStart+i)
                tau = np.append(tau, np.linspace(start*pxdwelltime, pxdwelltime*(GNt-1), GNt-start))
                Gout = np.append(Gout, Gcrop[i, j, :])
        Gcrop = Gcolumns
        split = np.linspace(0, GNt*N*N, N*N+1)
    elif 'crossCenterAv' in listOfFields:
        # average all pair-correlations between the center and the other pixels
        # that are equally far from the center
        Gcrop = G.crossCenterAv[start:,:]
        Gshape = np.shape(Gcrop)
        GNt = Gshape[0]
        for i in range(6):
            Gout = np.append(Gout, Gcrop[:, i])
            tau = np.append(tau, np.linspace(start*pxdwelltime, pxdwelltime*(GNt-1), GNt-start))
        rhox = np.array([0, 1, np.sqrt(2), 2, np.sqrt(5), np.sqrt(8)])
        rhoy = np.array([0, 0, 0, 0, 0, 0])
        split = np.linspace(0, GNt*6, 7)
    elif 'crossCenterAvN' in listOfFields:
        # similar to crossCenterAv, but without the central autocorrelation
        # only the N G's closest to the center are calculated
        Gcrop = G.crossCenterAv[start:,1:N+1]
        Gshape = np.shape(Gcrop)
        GNt = Gshape[0]
        for i in range(N):
            Gout = np.append(Gout, Gcrop[:, i])
            tau = np.append(tau, np.linspace(start*pxdwelltime, pxdwelltime*(GNt-1), GNt-start))
        rhox = np.array([1, np.sqrt(2), 2, np.sqrt(5), np.sqrt(8)])
        rhox = rhox[0:N]
        rhoy = np.array([0, 0, 0, 0, 0])
        rhoy = rhoy[0:N]
        split = np.linspace(0, GNt*N, N+1)
    elif 'twofocus5' in listOfFields:
        # average all pair-correlations between the center and the other pixels
        # that are equally far from the center
        Nt = len(G.twofocusTB_average[start:,0])
        Gcrop = np.zeros((Nt, 6))
        # cross-correlation top and bottom
        Gcrop[:,0] = (G.twofocusTB_average[start:,1] + G.twofocusBT_average[start:,1]) / 2
        # cross-correlation left and right
        Gcrop[:,1] = (G.twofocusLR_average[start:,1] + G.twofocusRL_average[start:,1]) / 2
        # cross-correlation left and top
        Gcrop[:,2] = (G.twofocusLT_average[start:,1] + G.twofocusTL_average[start:,1]) / 2
        # cross-correlation bottom and right
        Gcrop[:,3] = (G.twofocusBR_average[start:,1] + G.twofocusRB_average[start:,1]) / 2
        # cross-correlation left and bottom
        Gcrop[:,4] = (G.twofocusLB_average[start:,1] + G.twofocusBL_average[start:,1]) / 2
        # cross-correlation top and right
        Gcrop[:,5] = (G.twofocusTR_average[start:,1] + G.twofocusRT_average[start:,1]) / 2
        for i in range(6):
            Gout = np.append(Gout, Gcrop[:, i])
            tau = np.append(tau, np.linspace(start*pxdwelltime, pxdwelltime*(Nt-1), Nt-start))
        rhox = np.array([2, 2, np.sqrt(2), np.sqrt(2), np.sqrt(2), np.sqrt(2)])
        rhoy = np.array([0, 0, 0, 0, 0, 0])
        split = np.linspace(0, Nt*6, 7)
    elif 'twofocus5Av' in listOfFields:
        # average all pair-correlations between the center and the other pixels
        # that are equally far from the center
        Nt = len(G.twofocusTB_average[start:,0])
        Gcrop = np.zeros((Nt, 2))
        # cross-correlation long distance
        Gcrop[:,0] = G.twofocusTB_average[start:,1] + G.twofocusBT_average[start:,1]
        Gcrop[:,0] += G.twofocusLR_average[start:,1] + G.twofocusRL_average[start:,1]
        Gcrop[:,0] /= 4
        # cross-correlation short distance
        Gcrop[:,1] = G.twofocusLT_average[start:,1] + G.twofocusTL_average[start:,1]
        Gcrop[:,1] += G.twofocusBR_average[start:,1] + G.twofocusRB_average[start:,1]
        Gcrop[:,1] += G.twofocusLB_average[start:,1] + G.twofocusBL_average[start:,1]
        Gcrop[:,1] += G.twofocusTR_average[start:,1] + G.twofocusRT_average[start:,1]
        Gcrop[:,1] /= 8
        for i in range(2):
            Gout = np.append(Gout, Gcrop[:, i])
            tau = np.append(tau, np.linspace(start*pxdwelltime, pxdwelltime*(Nt-1), Nt-start))
        rhox = np.array([2, np.sqrt(2)])
        rhoy = np.array([0, 0])
        split = np.linspace(0, Nt*2, 3)
    return Gout, tau, split, rhox, rhoy, Gcrop


def chi2FCSfit(tau, Gexp, fitInfo, fitResult):
    # calculate the chi2 value for the FCS fit
    Gres = fitResult.fun
    Gfit = Gexp - Gres
    dof = len(tau) - np.sum(fitInfo) - 1 # degrees of freedom
    chi2 = np.sum((Gexp-Gfit)**2 / np.abs(Gfit)) / dof
    return chi2
    
