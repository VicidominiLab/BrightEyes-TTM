# -*- coding: utf-8 -*-
"""
Created on Wed Jan 12 12:07:33 2022

@author: eperego 741
"""

import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import axes3d
import time
import pickle
import h5py    

from spad_tools import *
from spad_fcs import *
  
  
  
#### You need to install spadffs 

# Look at docs/source/spadffs.md  for knowing how
# https://github.com/VicidominiLab/BrightEyes-TTM.git
# THE COMPLETE DOCUMENTATION IS AVAILABLE AT https://brighteyes-ttm.readthedocs.io/ 
#### Your Data and Path

Path = # Insert here your path 
Name = "01_20nm_1to1000_SPAD_10us_y_100_x_100"

fileName = Path+ Name + ".bin"
fileNameMeta = Path+Name+"_info.txt"

chunksize = 10 # s # chunk duration
corRes = 1 # 'resolution' of the correlation function: the higher this number, the more lag times are used

listCorr = ['central', 'sum3' , 'sum5']  ### channels to correlate   

[G, data] = FCSLoadAndCorrSplit(fileName , listCorr, corRes, chunksize)  


####  Quality assessment of the data

plotInfo = "sum5"
tau = G.sum5_average[:, 0]
plt.figure()
plt.semilogx(tau[3:],G.sum5_chunk0[:, 1][3:], label = '0')
plt.semilogx(tau[3:],G.sum5_chunk1[:, 1][3:], label = '1')
plt.semilogx(tau[3:],G.sum5_chunk2[:, 1][3:], label = '2')
plt.semilogx(tau[3:],G.sum5_chunk3[:, 1][3:], label = '3')
plt.semilogx(tau[3:],G.sum5_chunk4[:, 1][3:], label = '4')
plt.semilogx(tau[3:],G.sum5_chunk5[:, 1][3:], label = '5')
plt.semilogx(tau[3:],G.sum5_chunk6[:, 1][3:], label = '6')
plt.semilogx(tau[3:],G.sum5_chunk7[:, 1][3:], label = '7')
plt.semilogx(tau[3:],G.sum5_chunk8[:, 1][3:], label = '8')   
plt.semilogx(tau[3:],G.sum5_chunk9[:, 1][3:], label = '9') 
plt.semilogx(tau[3:],G.sum5_chunk10[:, 1][3:], label = '10') 
# plt.semilogx(tau[3:],G.sum5_chunk11[:, 1][3:], label = '11')

plt.plot(tau[3:], np.zeros(len(tau[3:])), '-b')
plt.xlim([10e-6,1])
plt.legend()


### Keep only the good chunks
listOfChunks= [1,2,3,4,5,6,7,8,9] # list of good chunks
G = FCSavChunks(G, listOfChunks)   ### averaging good chunks


## Fitting with one component model 

start = 1 # start index to fit the data, set to 15-30 to remove the afterpulse component at short lag times
fitarray = np.array([1, 1,0 ,0, 0, 0, 0, 0, 0, 0, 0]) # parameters to fit
minBound = np.array([0, 5e-8, 5e-8, 0, 0, 0, 0, 0, 0, 0, 0]) # minimum values for the parameters
maxBound = np.array([1e6, 1000, 10000, 1 , 1e6, 1e6, 1e6, 1e6, 1e6, 1e6, 1e6]) # maximum values for the parameters
# # ---------- central element ----------
SF = 4.5 # shape factor, i.e. z0/w0 with z0 the height of the PSF and w0 the width (1/e^2 radius of the intensity)
startValues = np.array([0.01, 0.69710486 , 5e-8 ,1, 1, 0, 1e-6, SF, 0, 0, 1.0]) # start values for the fit
plotInfo = "central" # used for the color of the output plot
Gexp = G.central_averageX[:, 1]
tau = G.central_averageX[:, 0]
fitresult1= FCSfit(Gexp[start:], tau[start:], 'fitfun2C', fitarray, startValues,  minBound, maxBound, plotInfo, 0,0)

# # ---------- sum3  ----------
SF = 4.0 # shape factor, i.e. z0/w0 with z0 the height of the PSF and w0 the width (1/e^2 radius of the intensity)
startValues = np.array([2.2, 0.69710486 , 5e-8 ,1, 1, 0, 1e-6, SF, 0, 0, 1.0]) # start values for the fit
plotInfo = "sum3" # used for the color of the output plot
Gexp = G.sum3_averageX[:, 1]
tau = G.sum3_averageX[:, 0]
fitresult3= FCSfit(Gexp[start:], tau[start:], 'fitfun2C', fitarray, startValues,  minBound, maxBound, plotInfo, 0,0)

# # ---------- sum5  ----------
SF = 4.0 # shape factor, i.e. z0/w0 with z0 the height of the PSF and w0 the width (1/e^2 radius of the intensity)
startValues = np.array([0.02, 0.69710486 , 5e-8 ,1, 1, 0, 1e-6, SF, 0, 0, 1.0]) # start values for the fit
plotInfo = "sum5" # used for the color of the output plot
Gexp = G.sum5_averageX[:, 1]
tau = G.sum5_averageX[:, 0]
fitresult5= FCSfit(Gexp[start:], tau[start:], 'fitfun2C', fitarray, startValues,  minBound, maxBound, plotInfo, 0,0)


# Printing the paramenters

w0 = np.array([228e-9,260e-9,372e-9])  #### calibrate your detector volumes

tauD = 1e-3 * np.array([fitresult1.x[1],fitresult3.x[1], fitresult5.x[1]])

Nfcs =  np.array([fitresult1.x[0],fitresult3.x[0], fitresult5.x[0]])

print("tau_D = " + str(tauD*1.0e3) + "ms")
print("N = " + str(Nfcs) )


# Diffusion Law 

w02 = w0*w0
x15 = np.arange(-0.2,max(w02*1e12)+0.15,0.01) 
p, V = np.polyfit(w02, tauD,1, cov = True)

plt.figure()
color = 'blue'
plt.plot(w02*1e12,tauD*1.0e3, 'bo', ms=8)
plt.plot(x15, p[0]*1e-9*x15 + p[1]*1e3, '-c')

plt.xlabel('w0 (um2)')
plt.ylabel('tau_D (ms)')
plt.xlim([0,0.25])
plt.ylim([0,max(tauD*1.0e3)+1])

