from matplotlib.colors import ListedColormap
import numpy as np
from matplotlib import colors as mcolors

def colorGradient(startColor, endColor, N):
    vals = np.ones((N, 4))
    vals[:, 0] = np.linspace(startColor[0], endColor[0], N)
    vals[:, 1] = np.linspace(startColor[1], endColor[1], N)
    vals[:, 2] = np.linspace(startColor[2], endColor[2], N)
    return(ListedColormap(vals))
    
    
def cmaps(color, N=256):
    switcher = {
        "blue2black": colorGradient((0, 0, 0, 1), mcolors.to_rgba('#1f77b4'), N),
        "orange2black": colorGradient((0, 0, 0, 1), mcolors.to_rgba('#ff7f0e'), N),
        "green2black": colorGradient((0, 0, 0, 1), mcolors.to_rgba('#2ca02c'), N),
        "red2black": colorGradient((0, 0, 0, 1), mcolors.to_rgba('#d62728'), N),
        "purple2black": colorGradient((0, 0, 0, 1), mcolors.to_rgba('#9467bd'), N),
    }
    # Get the function from switcher dictionary
    func = switcher.get(color, "Invalid color")
    # Execute the function
    return func