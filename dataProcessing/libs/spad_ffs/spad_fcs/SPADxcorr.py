import numpy as np


def SPADxcorr(tau, rhox, rhoy, rhoz, c, D, w0, w1, z0, z1):
    """
    Calculate the FCS correlation for SPAD detection (not used)
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    tau         Lag time [s]
    rhox        Spatial shift in the x, y, and z direction between two detector
    rhoy         elements [m]. Usually, rhoz = 0. Rhox and rhoy correspond to
    rhoz         the spatial shifts in the sample space
    c           Concentration of fluorophores/particles [/m^3]
    D           Diffusion coefficient of the fluorophores/particles [µm^2/s]
    w0          Lateral 1/e^2 radius of the first PSF
    w1          Lateral 1/e^2 radius of the second PSF
    z0          Axial 1/e^2 value of the first PSF
    z1          Axial 1/e^2 value of the second PSF
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    G           Cross-correlation between the two signals
    ==========  ===============================================================
    """

    lat = 8 * D * tau + w0**2 + w1**2
    ax = 8 * D * tau + z0**2 + z1**2
    G = 4 / (np.sqrt(2) * np.pi**(3/2) * c * lat * np.sqrt(ax))
    G = G * np.exp(-(16 * D * tau * (rhox**2 + rhoy**2 + rhoz**2) +
                     2 * (z0**2 + z1**2) * (rhox**2 + rhoy**2) +
                     2 * (w0**2 + w1**2) * rhoz**2) / (lat * ax))

    return G
