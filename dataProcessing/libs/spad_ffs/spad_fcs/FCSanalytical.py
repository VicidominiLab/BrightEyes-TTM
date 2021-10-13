import numpy as np


def FCSanalytical(tau, N, tauD, SF, offset, A=0, B=0):
    """
    Calculate the analytical FCS autocorrelation function assuming 3D Gaussian
    diffusion without triplet state
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    tau         Lag time [s] (vector)
    N           Number of particles on average in the focal volume [dimensionsless]
                N = w0^2 * z0 * c * pi^(3/2)
                with c the average particle concentration
    D           Diffusion coefficient of the fluorophores/particles [µm^2/s]
    SF          Shape factor of the PSF
    A, B        Afterpulsing characteristics
                Power law assumed: G = A * tau^B (with B < 0)
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    Gy          Vector with the autocorrelation G(tau)
    ==========  ===============================================================
    """

    # standard autocorrelation function
    Gy = 1 / N / (1 + tau/tauD) # lateral correlation
    Gy /= np.sqrt(1 + tau / (SF**2*tauD)) # axial correlation
    Gy += offset # offset
    # power law component to take into account afterpulsing (see e.g. Buchholz, Biophys J., 2018)
    Gy += A * tau**B
    
    if type(Gy) == np.float64:
        Garray = np.zeros((1, 2))
    else:
        Garray = np.zeros((np.size(Gy, 0), 2))
    Garray[:, 0] = tau
    Garray[:, 1] = Gy

    #G = correlations()
    #setattr(G, 'theory', Garray)

    return Gy


def FCS2Canalytical(tau, N, tauD1, tauD2, F, alpha=1, T=0, tautrip=1e-6, SF=5, offset=0, A=0, B=0):
    """
    Calculate the analytical FCS autocorrelation function assuming 3D Gaussian
    diffusion with triplet state, afterpulsing and 2 components
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    tau         Lag time [s] (vector)
    N           Number of particles on average in the focal volume [dimensionsless]
                N = w0^2 * z0 * c * pi^(3/2)
                with c the average particle concentration
    tauD1       Diffusion time species 1 [s]
    tauD2       Diffusion time species 2 [s]
    F           Fraction of species 1
    alpha       Relative molecular brightness q2/q1
    T           Fraction in triplet
    tautrip     Residence time in triplet state [s]
    SF          Shape factor of the PSF
    A, B        Afterpulsing characteristics
                Power law assumed: G = A * tau^B (with B < 0)
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    Gy          Vector with the autocorrelation G(tau)
    ==========  ===============================================================
    """

    # amplitude
    Gy = N * (F + alpha*(1-F))**2
    Gy = 1 / Gy
    
    # triplet
    Gy *= (1 + (T * np.exp(-tau / tautrip)) / (1 - T))
    
    # diffusion
    Gy *= F / (1 + tau/tauD1) / np.sqrt(1 + tau/SF**2/tauD1) + alpha**2 * (1-F) / (1 + tau/tauD2) / np.sqrt(1 + tau/SF**2/tauD2)

    # offset
    Gy += offset

    # afterpulsing (see e.g. Buchholz, Biophys J., 2018)
    Gy += A * tau**B

    return Gy


def FCSDualFocus(tau, N, D, w, SF, rhox, rhoy, offset, vx=0, vy=0):
    """
    Calculate the analytical FCS crosscorrelation function for dual focus FCS
    assuming 3D Gaussian and diffusion without triplet state
    Equation from Scipioni, Nat. Comm., 2018 and consistent with own Maple
    calculations
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    tau         Lag time [s] (vector)
    N           Number of particles on average in the focal volume [dimensionsless]
                    N = w0^2 * z0 * c * pi^(3/2)
                    with c the average particle concentration
                    and w0 the effective focal volume (w0^2 + w1^2) / 2
    D           Diffusion coefficient of the fluorophores/particles [µm^2/s]
    w           Radius of the effective PSF, i.e. sqrt((w0^2 + w1^2) / 2)
                     with w0 and w1 the 1/e^2 radii of the two PSFs
    SF          Shape factor of the PSF
    rhox        Distance between the two detector elements in the horizontal direction [m]
    rhoy        Distance between the two detector elements in the vertical direction [m]
    offset      DC component of G
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    Gy          Vector with the autocorrelation G(tau)
    ==========  ===============================================================
    """
    tauD = w**2 / 4 / D
    G = N * (1 + tau/tauD) * np.sqrt(1 + tau/(tauD*SF**2))
    G = 1 / G
    G = G * np.exp(-((rhox - vx*tau)**2 + (rhoy - vy*tau)**2) / w**2 / (1 + tau/tauD))
    G += offset
    
    return G
    