from spad_tools.constants import constants
import numpy as np


def StokesEinstein(D, T=293, visc=1e-3):
    """
    Calculate the diameter of particles based on the Stokes-Einstein equation
    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    D           Diffusion coefficient of the particles [in µm^2/s]
    T           Temperature of the suspension [in K]
    visc        Viscosity of the solvent [in Pa.s]
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    d           Diameter of the particles [in m]
    ==========  ===============================================================
    """

    kb = constants('boltzmann')
    r = kb * T / 6 / np.pi / visc / D
    d = 2 * r
    return d
