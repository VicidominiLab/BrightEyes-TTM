#!/usr/bin/env python
# coding: utf-8

# In[6]:


get_ipython().run_line_magic('pylab', 'agg')
get_ipython().run_line_magic('load_ext', 'Cython')

from IPython.display import set_matplotlib_formats
import sys 
import os
import scipy.signal
import numpy
import pandas
from scipy.optimize import curve_fit
import matplotlib.pyplot as plt


def readParsedFile(filenameIn="~/data-2020-06-26-Test1/data-1593175269.547629"):
   
    ######################### 
    ### DEFINITION OF DTYPE
    fmt_data_header_struct_out="IHBBBBBB"
    fmt_data_payload_struct_out="IBBBBBBBB"
    fmt_data_total=fmt_data_header_struct_out+(fmt_data_payload_struct_out*7)

    #Definition of dtype for importing data with np.fromfile or np.frombuffer
    dheader=[
        ("event", np.uint32),       # 	uint16_t event;   /H
        ("step", np.ushort),        # 	uint16_t step     ; /H
        ("t_L", np.ubyte),          # 	uint8_t  t_L	  ; /B
        ("scan_enable", np.ubyte),  # 	uint8_t scan_enable     ; /B
        ("line_enable", np.ubyte),  # 	uint8_t line_enable     ; /B
        ("pixel_enable", np.ubyte), # 	uint8_t pixel_enable    ; /B
        ("valid_tdc_L", np.ubyte),  # 	uint8_t valid_tdc_L     ; /B
        ("id_0", np.ubyte)            # 	uint8_t  id		     ; /B // must be in value 0    
        ]

    # dpayload_single=[
    #     ("event", np.ushort),       # 	uint16_t event;
    #     ("t_C", np.ubyte),          # 	uint8_t  t_C     ;
    #     ("t_B", np.ubyte),          # 	uint8_t  t_B     ;
    #     ("t_A", np.ubyte),          # 	uint8_t  t_A     ;
    #     ("useless", np.ubyte),      # 	uint8_t  useless	 ;
    #     ("valid_tdc_C", np.ubyte),  # 	uint8_t  valid_tdc_C ;
    #     ("valid_tdc_B", np.ubyte),  # 	uint8_t  valid_tdc_B ;
    #     ("valid_tdc_A", np.ubyte),   # 	uint8_t  valid_tdc_A ;
    #     ("id", np.ubyte)            # 	uint8_t  id		     ; /B // must be in value 0      
    # ]
    NUMWORDS=8
    dpayload=[]
    for n in range(0,(NUMWORDS-1)):
        dpayload_single=[
        ("event_"+str(n*3), np.uint32),       # 	uint16_t event;
        ("t_"+str(n*3+2), np.ubyte),          # 	uint8_t  t_C     ;
        ("t_"+str(n*3+1), np.ubyte),          # 	uint8_t  t_B     ;
        ("t_"+str(n*3+0), np.ubyte),          # 	uint8_t  t_A     ;
        ("useless_"+str(n), np.ubyte),      # 	uint8_t  useless	 ;
        ("valid_tdc_"+str(n*3+2), np.ubyte),  # 	uint8_t  valid_tdc_C ;
        ("valid_tdc_"+str(n*3+1), np.ubyte),  # 	uint8_t  valid_tdc_B ;
        ("valid_tdc_"+str(n*3+0), np.ubyte),   # 	uint8_t  valid_tdc_A ;
        ("id_"+str(n+1), np.ubyte)            # 	uint8_t  id		     ; /B // must be in value 0      
        ]
        dpayload+=dpayload_single


    dtypeJoin = dheader+dpayload
    dtypeAll = np.dtype(dtypeJoin)
    print(filenameIn)
    data = np.fromfile(filenameIn, dtype=dtypeAll)
    print("**************************")
    print("* Size table: ", data.shape[0])
    print("***************************")
    return data, ("", 0, 0)


def calibAlessandro(xdata, TDL_length_ps, min_xlim = 0, max_xlim = 410, flipped = 0, filename_pics="figC_", verbose=True):
    print (".",xdata.min(),xdata.max())    
    
    x =xdata
    if verbose: print(x.shape)


    #%%

    ### Histogram Creation


    # Binning
    maximum_bin_value = max_xlim

    minimum_bin_value = min_xlim
    
    if flipped == 1:

        x = maximum_bin_value-x
        
    else:

        x = x
        
    x
    b = np.append(np.arange(minimum_bin_value,maximum_bin_value),maximum_bin_value)


    #%%
    if verbose: print("1")
    ## Histogram Plotting
    plt.figure()
    plt.title('Histogram')
    histogram,_,_=plt.hist(x,b,label='TDL - Histogram',linewidth=2)
    plt.xlim((min_xlim,max_xlim))
    # plt.ylim((0,1400))
    plt.grid('on',linestyle='dotted',which='both')
    plt.legend()
    plt.xlabel('[Bin]')
    plt.ylabel('Events [N]')
    plt.tight_layout()
    fig=plt.gcf()
    fig.savefig(filename_pics+"2.png")
    fig=plt.gcf()
    fig.savefig(filename_pics+"2.svg")
    #%%
    if verbose: print("2")
    ## Histogram Plotting
    plt.figure()
    plt.title('Histogram')
    histogram,_,_=plt.hist(x,b,label='TDL - Histogram',linewidth=2)
    plt.xlim((min_xlim,max_xlim))
    # plt.ylim((0,1400))
    plt.yscale('log')
    plt.grid('on',linestyle='dotted',which='both')
    plt.legend()
    plt.xlabel('[Bins]')
    plt.ylabel('Events [N]')
    plt.tight_layout()
    fig=plt.gcf()
    fig.savefig(filename_pics+"3.png")
    fig=plt.gcf()
    fig.savefig(filename_pics+"3.svg")

    #%%
    if verbose: print("3")
    ## Differential and Integral Linearity

    avg = mean(histogram)

    ## DNL

    dnl = np.empty(histogram.size)

    for i in range(histogram.size):
      
      dnl[i] = (histogram[i]-avg)/avg
      

    # DNL St.Dev
    dnl_std = np.sqrt(np.var(dnl))  
      
      
    ## DNL Plotting
    if verbose: print("4")
    plt.figure()
    plt.title('Differential Nonlinearity')
    plt.bar(np.arange(minimum_bin_value,maximum_bin_value),dnl,            label=r'DNL -  $\sigma_{DNL}$ = '+str(round(dnl_std,2)) +' [LSB]',linewidth=2)
    plt.xlim((min_xlim,max_xlim))
    # plt.ylim((0,1400))
    plt.grid('on',linestyle='dotted',which='both')
    plt.legend()
    plt.xlabel('[Bin]')
    plt.ylabel('[LSB]')
    plt.tight_layout()
    fig=plt.gcf()
    fig.savefig(filename_pics+"4.png")
    fig=plt.gcf()
    fig.savefig(filename_pics+"4.svg")
    #%%

    ## Differential and Integral Linearity

    avg = mean(histogram)

    ## DNL

    dnl = np.empty(histogram.size)

    for i in range(histogram.size):
      
      dnl[i] = (histogram[i]-avg)/avg
      

    # DNL St.Dev
    dnl_std = np.sqrt(np.var(dnl))  
      
      
    ## DNL Plotting

    plt.figure()
    plt.title('Differential Nonlinearity')
    plt.bar(np.arange(minimum_bin_value,maximum_bin_value),dnl,            label=r'DNL',linewidth=2)
    plt.plot(plt.xlim(),0*np.array([1,1]),             color = 'black',linewidth=1)
    plt.plot(plt.xlim(),(dnl_std)*np.array([1,1]),             label = '$\sigma_{DNL}$ = '+str(round(dnl_std,2)) +' [LSB] ',color = 'orange',linewidth=1)
    plt.plot(plt.xlim(),(-dnl_std)*np.array([1,1]),             color = 'orange',linewidth=1)  
    plt.xlim((min_xlim,max_xlim))
    # plt.ylim((0,1400))
    plt.grid('on',linestyle='dotted',which='both')
    plt.legend()
    plt.xlabel('[Bin]')
    plt.ylabel('[LSB]')
    plt.tight_layout()
    fig=plt.gcf()
    fig.savefig(filename_pics+"5.svg")
    fig=plt.gcf()
    fig.savefig(filename_pics+"5.png")

      
    #%%

    ## INL
      
    inl = np.empty(histogram.size)  
      
    for j in range(histogram.size):
      
      inl[j] = sum(dnl[0:j+1])


    # INL St.Dev
    inl_std = np.sqrt(np.var(inl))  
      
    plt.figure()
    plt.title('Integral Nonlinearity')
    plt.bar(np.arange(minimum_bin_value,maximum_bin_value),inl,            label=r'INL -  $\sigma_{INL}$ = '+str(round(inl_std,2)) +' [LSB]',width=1)
    plt.xlim((min_xlim,max_xlim))
    # plt.ylim((0,1400))
    plt.grid('on',linestyle='dotted',which='both')
    plt.legend()
    plt.xlabel('[Bin]')
    plt.ylabel('[LSB]')
    plt.tight_layout()
    fig=plt.gcf()
    fig.savefig(filename_pics+"6.svg")
    fig=plt.gcf()
    fig.savefig(filename_pics+"6.png")

    #%%
    ## BIN size calculation in picosenconds [ps]

    #Total Number of registered photons N (events)

    N = sum(histogram)
    bin_widths = (histogram * TDL_length_ps)/N
    bin_width_avg = mean(bin_widths)
    output=bin_width_avg

    # Bin Width St.Dev
    bin_widths_std = np.sqrt(np.var(bin_widths))  
      
    plt.figure()
    plt.title('Bin Widths')
    plt.plot(np.arange(minimum_bin_value,maximum_bin_value),bin_widths,            label=r'Widths',linewidth=2)
    plt.plot(plt.xlim(),bin_width_avg*np.array([1,1]),             label= '$AVG_{W}$ =   '+str(round(bin_width_avg,2))+ '  [ps]',linestyle='dashed',color = 'red',linewidth=2)
    plt.plot(plt.xlim(),(bin_width_avg+bin_widths_std)*np.array([1,1]),             label = '$\sigma_{W}$ = '+str(round(bin_widths_std,2)) +' [ps] ',color = 'orange',linewidth=1)
    plt.plot(plt.xlim(),(bin_width_avg-bin_widths_std)*np.array([1,1]),             color = 'orange',linewidth=1)         
    plt.xlim((min_xlim,max_xlim))
    # plt.ylim((0,1400))
    plt.grid('on',linestyle='dotted',which='both')
    plt.legend()
    plt.xlabel('[Bin]')
    plt.ylabel('[ps]')
    plt.tight_layout()
    fig=plt.gcf()
    fig.savefig(filename_pics+"7.svg")
    fig=plt.gcf()
    fig.savefig(filename_pics+"7.png")







    #%%
    ## Time Conversion to Picoseconds

    # Curve Calibration

    N = sum(histogram)
    bin_widths = (histogram * TDL_length_ps)/N
    bin_width_avg = mean(bin_widths)


    time = np.empty(histogram.size)  
      
    for i in range(histogram.size):    
     
            time[i] = sum(bin_widths[0:i]) + (bin_widths[i])/2
            
            
    plt.figure(figsize=(11,9))        
    plt.title('Bin by Bin Calibration Curve')
    plt.plot(np.arange(minimum_bin_value,maximum_bin_value),time,            label=r'Calibration curve',linewidth=2)

    plt.xlim((min_xlim,max_xlim))
    # plt.ylim((0,1400))
    plt.grid('on',linestyle='dotted',which='both')
    plt.legend()
    plt.xlabel('[Bin]')
    plt.ylabel('[ps]')
    plt.tight_layout()   
    fig=plt.gcf()
    fig.savefig(filename_pics+"8.svg")      
    fig=plt.gcf()
    fig.savefig(filename_pics+"8.png")           


    #%% Linearity Fitting


    b_2 = np.append(np.arange(minimum_bin_value,maximum_bin_value-1),maximum_bin_value-1)
      
    def f(x, A, B): # this is your 'straight line' y=f(x)
        return A*x + B

    popt, pcov = curve_fit(f, b_2, time) # your data x, y to fit
        
    linear_fit = popt[0]*b_2 + popt[1]

    residuals = time-linear_fit

    residuals_std = np.sqrt(np.var(residuals))

    #%% Fitting Plot

    plt.figure()    
    plt.subplot(2,1,1)    
    plt.title('Bin by Bin Calibration Curve')
    plt.plot(np.arange(minimum_bin_value,maximum_bin_value),time,            label=r'Calibration curve',linewidth=2)
    plt.plot(np.arange(minimum_bin_value,maximum_bin_value),linear_fit,            label=r'Linear fit',linestyle='dashed',color = 'red',linewidth=1)
    plt.xlim((min_xlim,max_xlim))
    # plt.ylim((0,1400))
    plt.grid('on',linestyle='dotted',which='both')
    plt.legend()
    plt.xlabel('[Bin]')
    plt.ylabel('[ps]')

    plt.tight_layout()
    fig=plt.gcf()
    fig.savefig(filename_pics+"9.svg")
    fig=plt.gcf()
    fig.savefig(filename_pics+"9.png")

    #%% Residuals Plot

    plt.subplot(2,1,2)
      
    plt.title('Residuals  $\sigma_{residuals}$ = '+str(round(residuals_std,2)) +' [ps] ')
    plt.plot(np.arange(minimum_bin_value,maximum_bin_value),residuals,            label=r'Calibration curve',linewidth=2)
    plt.plot(plt.xlim(),(residuals_std)*np.array([1,1]),             color = 'orange',linewidth=1)
    plt.plot(plt.xlim(),0*np.array([1,1]),color = 'black',linewidth=1)         
    plt.plot(plt.xlim(),(-residuals_std)*np.array([1,1]),             color = 'orange',linewidth=1)     
    plt.xlim((min_xlim,max_xlim))
    # plt.ylim((0,1400))
    plt.grid('on',linestyle='dotted',which='both')
    plt.xlabel('[Bin]')
    plt.ylabel('[ps]')

    plt.tight_layout()
    fig=plt.gcf()
    fig.savefig(filename_pics+"10.svg")
    fig=plt.gcf()
    fig.savefig(filename_pics+"10.png")
    return output
def fast_histInt(d,xrange=None):
    f=d.astype(int)
    fmin=f.min()
    fb=f-fmin
    count=bincount(fb)
    bin_i=arange(fmin,len(count)+fmin)
    if not(xrange is None):
        cond0 = (bin_i>xrange[0])
        cond1 = (bin_i<xrange[1])
        
        bin_i=bin_i[cond0 & cond1]
        count=count[cond0 & cond1]
    return bin_i, count


def getTimeStr():
    t = datetime.datetime.now()
    
    return str("{:02d}".format(t.year) + 
    "{:02d}".format(t.month) +   
    "{:02d}".format(t.day) +
    "-"  +  
    "{:02d}".format(t.hour) +
    "{:02d}".format(t.minute) +
    "{:02d}".format(t.second))
    
    
    
def myGausFit(x,y,a=None,mean=None,sigma=None,xlim=None):

    if not(xlim is None):
        print(xlim[0],xlim[1])
        y=y[(x>xlim[0]) & (x<xlim[1])]
        x=x[(x>xlim[0]) & (x<xlim[1])]


    if a is None: a = np.nanmax(y)                          #the number of data
    if mean is None: mean = x[y.argmax()]                   #note this correction
    if sigma is None: sigma = 2.5


    def gaus(x,a,x0,sigma):
        return a*exp(-(x-x0)**2/(2*sigma**2))

    plot(x,gaus(x,1,mean,sigma))
    popt,pcov = curve_fit(gaus,x+0.5,y,sigma=np.sqrt(y),p0=[a,mean,sigma])
    a,mean,sigma=popt[0],popt[1],popt[2]
    print(popt)
    xp=linspace(x.min(),x.max())
    plot(xp,gaus(xp,a,mean,sigma),label="$a$=%d \n $\mu$=%f \n $\sigma$=%f \n" % (a,mean,sigma))
    legend()
    return a,mean,sigma,pcov

def barQuick(bins,count,fillcurve=True, border=False, ax=None, *args, **kwargs):
    if ax is None:
        ax=gca()

    
    x=repeat(bins,2)
    y=repeat(count,2)
    x=concatenate(([x[0],x[0]],x[1:],[x[-1],x[-1]+1,x[-1]+1]))
    y=concatenate(([y[0],y[0]],y,[y[-1],0]))

    y[0]=0
    x=x-0.5

    if fillcurve is True:
        ax.fill(x,y, *args, **kwargs)
    if border is True:
        ax.plot(x,y, *args, **kwargs)

def calculate_dt_kC4(dataIn, kC4=43.8, correction_preclk=1):
    kC4=sysclk_ps/round(sysclk_ps/kC4)
    print(kC4,"ps")
    kC4_per_sysclkperiod=round(sysclk_ps/kC4)
    sysclk_ps_over_kC4 = sysclk_ps/kC4

    deltatsmall = (np.asarray(dataIn["t1"]*1.)-np.asarray(dataIn["tL"]*1.))
    deltatbig   = (np.asarray(dataIn["S2"]*1.)-np.asarray(dataIn["S1"]*1.))
    cumulative_step   = (np.asarray(dataIn["CumulativeSTEP"]))

    print(count_nonzero(deltatbig<0))
    deltatbig[deltatbig<0]=deltatbig[deltatbig<0]*1.+max_counter

    a=count_nonzero((deltatsmall<0))
    b=count_nonzero((deltatsmall>0))
    c=count_nonzero((deltatsmall==0))

    deltatbig=mod(deltatbig,2048)

    dt_kC4_without_correction=(deltatsmall)+((deltatbig)*sysclk_ps_over_kC4)
    dt_sysclk_without_correction=dt_kC4_without_correction/sysclk_ps_over_kC4
    dt_without_correction=dt_kC4_without_correction*kC4

    if (correction_preclk==1):
        cond=(deltatsmall<0)
        deltatbig[cond] = deltatbig[cond]
        deltatsmall[cond]= deltatsmall[cond]
    if (correction_preclk==2):
        print("DO NOT USE THIS IS WRONG!")
        cond2=((deltatsmall<0)   & (deltatbig==0))
        deltatbig=deltatbig[logical_not(cond2)]
        deltatsmall=deltatsmall[logical_not(cond2)]

        cond=(deltatsmall<0)       
        deltatbig[cond]= deltatbig[cond]+1
        deltatsmall[cond]= deltatsmall[cond]


    dt_kC4=(deltatsmall)+((deltatbig)*sysclk_ps_over_kC4)
    dt_sysclk=dt_kC4/sysclk_ps_over_kC4
    dt_without=dt_kC4*kC4
    return dt_kC4, kC4,cumulative_step

def decoration_sysclk_laser(alpha=None):
    ax=gca()
    xlim_store=ax.get_xlim()
    ylim_store=ax.get_ylim()

    x0_sysclk=arange(round(xlim_store[0]/(sysclk_ps/kC4)),1+round(xlim_store[1]/(sysclk_ps/kC4)))*sysclk_ps/kC4
    for x0 in x0_sysclk:
        ax.plot([x0,x0],[ylim_store[0],ylim_store[1]], "--k",alpha=alpha)

    x0_laser=arange(round(xlim_store[0]/(laser_ps/kC4)),1+round(xlim_store[1]/(laser_ps/kC4)))*laser_ps/kC4
    for x0 in x0_laser:
        ax.plot([x0,x0],[ylim_store[0],ylim_store[1]], "r",linewidth=5 ,alpha=alpha)

    ax.set_xlim(xlim_store)
    ax.set_ylim(ylim_store)

def decoration_sysclk_laser_ps(alpha=None):
    ax=gca()
    xlim_store=ax.get_xlim()
    ylim_store=ax.get_ylim()

    x0_sysclk=arange(   round(xlim_store[0]/sysclk_ps),
                      1+round(xlim_store[1]/sysclk_ps))*sysclk_ps
    for x0 in x0_sysclk:
        ax.plot([x0,x0],[ylim_store[0],ylim_store[1]], "--k",alpha=alpha)

    x0_laser=arange(   round(xlim_store[0]/laser_ps),
                     1+round(xlim_store[1]/(laser_ps))
                   )*laser_ps
    print(round(xlim_store[0]/laser_ps),1+round(xlim_store[1]/(laser_ps))*laser_ps)
    for x0 in x0_laser:
        ax.plot([x0,x0],[ylim_store[0],ylim_store[1]], "r",linewidth=5 ,alpha=alpha)

    ax.set_xlim(xlim_store)
    ax.set_ylim(ylim_store)

def fitGausOrTwoGaus(x,y):

    meanBins=np.sum(x*y)/np.sum(y)
    stdBins=np.sqrt(np.sum(x*x*y)/np.sum(y)-(meanBins**2))

    peaks, hhhh =scipy.signal.find_peaks(y,  threshold=max(y)*0.01, distance=3.5)



    def gauss(x, *p):
        A, mu, sigma = p
        return A*numpy.exp(-(x-mu)**2/(2.*sigma**2))

    def twogauss(x, *p):
        A0=p[0]
        mu0=p[1]
        sigma0=p[2]
        ratioA=p[3]
        deltaMu=p[4]
        sigma1=p[5]
        return gauss(x, A0,mu0,sigma0)+gauss(x, A0*ratioA,mu0+deltaMu,sigma1)

    #plot(x,y)
    #plot(x[peaks],y[peaks],"xk")
    print(len(peaks))
    results={}

    if len(peaks)>1:
        deltaMuDefault=x[peaks[1]]-x[peaks[0]]
        p0=[max(y),
        meanBins,
        4.,
        1.,
        deltaMuDefault+1,
        1.
        ]

        coeff, var_matrix = curve_fit(twogauss, x, y, p0=p0)
        results["A0"]=coeff[0]
        results["mu0"]=coeff[1]
        results["sigma0"]=coeff[2]
        results["ratioA"]=coeff[3]
        results["deltaMu"]=coeff[4]
        results["sigma1"]=coeff[5]

        #xxx=linspace(meanBins-5*stdBins,meanBins+5*stdBins, 700)
        #plot(xxx,twogauss(xxx,*coeff))
        #xlim(meanBins-5*stdBins,meanBins+5*stdBins)
        #yscale("log")
        #ylim(.1,max(y)*1.2)
    else:
        deltaMuDefault=0
        p0=[max(y),
        meanBins,
        4.
        ]

        coeff, var_matrix = curve_fit(gauss, x, y, p0=p0)
        results["A0"]=coeff[0]
        results["mu0"]=coeff[1]
        results["sigma0"]=coeff[2]
        results["ratioA"]=None
        results["deltaMu"]=None
        results["sigma1"]=None
    return results
            
print("Functions loaded")


# In[7]:



get_ipython().run_cell_magic('cython', '-a', 'cimport numpy as np\nimport numpy as np\nfrom cpython cimport array\nimport array\ndef timeProcess(datapre, channel_number, verbose=True):\n        write_en_tdc_name="valid_tdc_%d"% channel_number\n        channel ="t_%d"% channel_number\n        if verbose: print("Data processing...")\n        datapre=datapre[(datapre[write_en_tdc_name]>0) | (datapre["valid_tdc_L"]>0)]\n        ok = 0\n        okold = 0\n        fail = 0\n        \n        cdef str K\n        cdef long long  last_tL, last_timestamp_1, last_timestamp_2, \\\n                        printcount, duplicate_case, printdebug, \\\n                        t1, t2, tL, step, write_en_tdc, write_en_tdc_laser, n, \\\n                        length, countGood, datapre_trim_len\n        cdef bint last_ok\n        cdef np.float64_t cumulative_step\n        \n        length = len(datapre["t_L"])\n        \n        tL_v=np.zeros(length, dtype=int)\n        t1_v=np.zeros(length, dtype=int)\n        S1_v=np.zeros(length, dtype=int)\n        S2_v=np.zeros(length, dtype=int)\n        CumulativeSTEP_v=np.zeros(length, dtype=np.float64)\n        duplicate_v=np.zeros(length, dtype=int)\n        \n        \n        \n        \n        \n        last_tL=0\n        last_timestamp_1=0\n        last_t1=0\n        last_timestamp_2=0\n        last_ok=False\n        duplicate_case=False\n        printdebug=False\n        printcount=0\n        \n        #uint8 datapre_trim["t_L"],\n        #uint8  datapre_trim[channel],\n        #uint16  datapre_trim["step"],\n        #uint8  datapre_trim[write_en_tdc_name],\n        #uint8  datapre_trim["valid_tdc_L"],\n        #float64  datapre_trim["cumulative_step"]\n        \n        \n        cdef np.uint8_t [:]   t_L_view=datapre["t_L"]\n        cdef np.uint8_t[:]   t_1_view=datapre[channel]\n        cdef np.uint16_t[:]  step_view=datapre["step"]\n        cdef np.uint8_t[:]   valid_1_view=datapre[write_en_tdc_name]\n        cdef np.uint8_t[:]   valid_L_view=datapre["valid_tdc_L"]\n        cdef np.float64_t[:] cumulative_step_view=datapre["cumulative_step"]\n        \n        \n\n        \n        \n        countGood=0\n        \n        \n        for n in np.arange(0,length):\n            tL=t_L_view[n]\n            t1=t_1_view[n]\n            step=step_view[n]\n            write_en_tdc=valid_1_view[n]\n            write_en_tdc_laser=valid_L_view[n]\n            cumulative_step=cumulative_step_view[n]\n            #K=""\n            \n            if (write_en_tdc==1):\n                last_t1=t1\n                #last_tL=tL\n                last_timestamp_1=step\n                last_pre_t1=t1\n                last_ok = True\n                \n            if (write_en_tdc_laser==1) & (last_ok == True):\n                last_ok = False\n                last_tL=tL\n                #last_t1=t1\n                last_timestamp_2=step\n                #K="*"   \n                \n                tL_v[countGood]=last_tL\n                t1_v[countGood]=last_t1\n                S1_v[countGood]=last_timestamp_1\n                S2_v[countGood]=last_timestamp_2\n                CumulativeSTEP_v[countGood]=cumulative_step\n                duplicate_v[countGood]=duplicate_case\n                countGood=countGood+1\n                #K=K+"OK"\n            if ((n%1000000)==0):\n                print (n*100./length," %")\n                    \n\n        print("Data ready, conversion to array")\n        dataout={}\n        dataout["tL"]=tL_v[0:countGood]*1.\n        dataout["t1"]=t1_v[0:countGood]*1.\n        dataout["S1"]=S1_v[0:countGood]*1.\n        dataout["S2"]=S2_v[0:countGood]*1.\n        dataout["CumulativeSTEP"]=CumulativeSTEP_v[0:countGood]*1.\n        dataout["duplicate"]=duplicate_v[0:countGood]*1.\n        if verbose: print(dataout)\n        if verbose: print("Data processed!")\n        return dataout            \n')


# In[ ]:





# In[8]:


def autoCalibrateTAP(timeData, debugPlots=False):
    bins, counts=fast_histInt(timeData)
    if debugPlots==True:
        barQuick(bins,counts)

    bin_widths = (counts * sysclk_ps)/sum(counts)
    bin_width_avg = mean(bin_widths)
    time = np.empty(counts.size)  

    for i in range(counts.size):    
        time[i] = sum(bin_widths[0:i]) + (bin_widths[i])/2
    time_ps=np.zeros(len(timeData))
    for n in range(len(timeData)):
        ggg=int(timeData[n])
        time_ps[n]=time[ggg]

    return time_ps

def dt_with_autoCalibratedTAP(time_data):
        tL_ps=autoCalibrateTAP(time_data["tL"])
        t1_ps=autoCalibrateTAP(time_data["t1"])
        dt=t1_ps-tL_ps+(sysclk_ps*(time_data["S2"]-time_data["S1"]))
        return dt


# In[20]:


def convert(filenameToRead, kC4=43.4):
    data=[]
    df=[]
    data, metadata=readParsedFile(filenameToRead)


def covertDataForEli(filenameToRead, kC4=43.4):
    data=[]
    df=[]
    data, metadata=readParsedFile(filenameToRead)


    #savez(filename_save+".npz", data=data, metadata=metadata )
    dataf=pandas.DataFrame(data)


    full_time_s=(data["event"][-1]-data["event"][0])/1000.
    df=dataf
    l = len(df["scan_enable"]*1.)
    se = sum(df["scan_enable"]*1.)
    le = sum(df["line_enable"]*1.)
    pe = sum(df["pixel_enable"]*1.)
    ll = sum(df["valid_tdc_L"]*1.)
    print(full_time_s)
    print("Scan_enable",se,"ratio", se*1./l, "rate", se/full_time_s)
    print("line_enable",le,"ratio", le*1./l, "rate", le/full_time_s)
    print("pixel_enable",pe,"ratio", pe*1./l, "rate", pe/full_time_s)
    print("Laser",ll,"ratio", ll*1./l, "rate", ll/full_time_s)
    diffStep=np.append([0],diff(df["step"]*1.)) #the diff calculate the i[n+1]-i[n] so for realign I add a 0 as first cell of the array
    sumStep=cumsum((diffStep<0)*65536.)
    cumulativeStep=df["step"]*1.-df["step"][0]*1. +sumStep
    cumulativeStep=asarray(cumulativeStep)

    photons_data=df[["valid_tdc_0", 
                     "valid_tdc_1", 
                      "valid_tdc_2", 
                      "valid_tdc_3", 
                      "valid_tdc_4", 
                      "valid_tdc_5", 
                      "valid_tdc_6", 
                      "valid_tdc_7", 
                      "valid_tdc_8", 
                      "valid_tdc_9", 
                      "valid_tdc_10",
                      "valid_tdc_11",
                      "valid_tdc_12",
                      "valid_tdc_13",
                      "valid_tdc_14",
                      "valid_tdc_15",
                      "valid_tdc_16",
                      "valid_tdc_17",
                      "valid_tdc_18",
                      "valid_tdc_19",
                      "valid_tdc_20",
                      ]]

    totalphotons=asarray(photons_data.sum(axis=1))
    totalphotons.shape
    df["total_photon"]=totalphotons
    df["cumulative_step"]=cumulativeStep
    print("Added total_photon and cumulative_step")

    df.keys()
    print("Convert to_records()")
    data=df.to_records()
    dataForEli={}
    kC4_per_sysclkperiod=round(sysclk_ps/kC4)
    
    print("Start process")
    datafilename=filenameToRead.split("/")[-1]
    destinationfolder="/".join(filenameToRead.split("/")[:-1])+"/output/"

    if not os.path.exists(destinationfolder):
        os.makedirs(destinationfolder)
        print("Folder not found, created", destinationfolder)

    for i in range(0,number_of_channels):
            print("Start conversion of %d channel"% i )
            print("t_%d"%i,"valid_tdc_%d"%i)

            print("..")
            time_data=timeProcess(data, channel_number=i)
            dataSelected=time_data
            print("Done")
            dt=dt_with_autoCalibratedTAP(dataSelected)
            figure(figsize(15,5))
            myrange=-0.2*laser_ps,laser_ps*1.2
            h=hist(dt,bins=int((myrange[1]-myrange[0])/kC4),range=myrange)
            yscale("log")
            decoration_sysclk_laser_ps()            
            savefig(destinationfolder+datafilename+"-Plot%0d.png"%i)
            print("Plot saved: ", destinationfolder+datafilename+"-Plot%0d.png"%i)
            dataForEli["microtime_ch%d"%i]=dt
            dataForEli["macrotime_ch%d"%i]=dataSelected["CumulativeSTEP"]*sysclk_ps

    dataForEli["sysclk_period_ps"]=sysclk_ps
    dataForEli.keys()

    savez(destinationfolder+datafilename+"-TimestampMultiCh.npz", data=dataForEli)
    print("Data saved: ", destinationfolder+datafilename+"-TimestampMultiCh.npz")


# In[21]:




#filenameToRead="/home/myuser/Desktop/data-1596120272014674_holdoff_25ns_laser65"

if len(sys.argv)<2:
    print("Please use:\nipython DataConversionEli.py -- /home/blah/filename \n")

else:
    filenameToRead=sys.argv[1]
    print("Filename: ", filenameToRead)


    sysclk_MHz=240.
    laser_MHz=40.
    max_counter=2**16-1 #16-bit macrocounter
    number_of_channels=21 
    sysclk_ps=1000000./sysclk_MHz #ps
    laser_ps=1000000./laser_MHz #ps



    covertDataForEli(filenameToRead)


# In[ ]:




