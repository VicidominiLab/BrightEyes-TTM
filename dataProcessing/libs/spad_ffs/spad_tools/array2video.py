from checkfname import checkfname
import numpy as np
import matplotlib.pyplot as plt
from matplotlib import animation


def array2video(data, fname='video.mp4', norm=False, interval=100):
    """
    Create video from 3D data array
    ===========================================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    data        3D np.array [Ny x Nx x Nt]
    fname       File name to store the video
    norm        Normalize the color map for each frame separately
                If false, the same color map is used for the whole stack
    interval    Number of ms per frame
    ===========================================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    .mp4 file with the video
    ===========================================================================
    """
    
    # number of frames
    Nt = np.size(data, 2)
    
    # create empty variable to store data frames
    ims = []
    Imin = np.min(data)
    Imax = np.max(data)
    
    fig = plt.figure()
    
    FigSize = 10.5 # must be 10.5 to make the array size and video resolution match??
    
    fig.set_size_inches(FigSize * np.size(data, 0) / np.size(data, 1), FigSize, forward=False)
    ax = plt.Axes(fig, [0., 0., 1., 1.])
    ax.set_axis_off()
    fig.add_axes(ax)
    for i in range(Nt):
        if norm:
            im = ax.imshow(data[:,:,i])
        else:
            im = ax.imshow(data[:,:,i], vmin=Imin, vmax=Imax)
        ims.append([im])
    
    ani = animation.ArtistAnimation(fig, ims, interval=interval, blit=True)
    
    fname = checkfname(fname, 'mp4')
    
    ani.save(fname)
