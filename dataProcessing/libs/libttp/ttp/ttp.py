import os
import shutil
import subprocess
import time

import matplotlib.pyplot as plt
import numpy
import numpy as np
import pandas
# import h5py
import tqdm
import ttpCython
from scipy.optimize import curve_fit




# import h5py


def get_data_for_useconds(t_usecond=1000, verbose=False,
                          programm="timetaggingplatform/dataReceiver/streamerParserWithFrame", folderDestination="",
                          appendText="", metadata="", cwd=None):
    """

    Param t_usecond:
    Param verbose:
    Param programm:
    Param folderDestination:
    Param appendText:
    Param metadata:
    return: filename
    """
    cmd0 = [programm, str(t_usecond)]
    print(cmd0)
    time_start = time.time()
    c = subprocess.run(args=cmd0, stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=cwd)
    time_stop = time.time()
    msg = c.stderr.decode()

    if verbose:
        print(msg)
    filename = msg.split("Filename: ")[-1].rstrip("\n\r")
    print("Original file created ", filename)

    if (folderDestination != ""):
        filename_destination = folderDestination + os.sep + filename + "-" + appendText
        shutil.move(filename, filename_destination)
        print("Moved to ", filename_destination)
        filename_destination = filename_destination
    else:
        filename_destination = filename

    if (metadata != ""):
        np.savez(filename_destination + ".info.npz", metadata)
        print("File Metadata: ", filename_destination + ".info.npz")

    print("File Data: ", filename_destination)

    return filename_destination


def dtypeAll():
    """
    Generate the dtype for read the RAW-"parsed" data file
    Param filenameIn:
    Return:  dtypeAll
    """
    #########################
    ### DEFINITION OF DTYPE
    fmt_data_header_struct_out = "IHBBBBBB"
    fmt_data_payload_struct_out = "IBBBBBBBB"
    fmt_data_total = fmt_data_header_struct_out + (fmt_data_payload_struct_out * 7)

    # Definition of dtype for importing data with np.fromfile or np.frombuffer
    dheader = [
        ("event", np.uint32),  # uint16_t event;   /H
        ("step", np.ushort),  # uint16_t step     ; /H
        ("t_L", np.ubyte),  # uint8_t  t_L	  ; /B
        ("scan_enable", np.ubyte),  # uint8_t scan_enable     ; /B
        ("line_enable", np.ubyte),  # uint8_t line_enable     ; /B
        ("pixel_enable", np.ubyte),  # uint8_t pixel_enable    ; /B
        ("valid_tdc_L", np.ubyte),  # uint8_t valid_tdc_L     ; /B
        ("id_0", np.ubyte)  # uint8_t  id		     ; /B // must be in value 0
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
    NUMWORDS = 8
    dpayload = []
    for n in range(0, (NUMWORDS - 1)):
        dpayload_single = [
            ("event_" + str(n * 3), np.uint32),  # uint16_t event;
            ("t_" + str(n * 3 + 2), np.ubyte),  # uint8_t  t_C     ;
            ("t_" + str(n * 3 + 1), np.ubyte),  # uint8_t  t_B     ;
            ("t_" + str(n * 3 + 0), np.ubyte),  # uint8_t  t_A     ;
            ("useless_" + str(n), np.ubyte),  # uint8_t  useless	 ;
            ("valid_tdc_" + str(n * 3 + 2), np.ubyte),  # uint8_t  valid_tdc_C ;
            ("valid_tdc_" + str(n * 3 + 1), np.ubyte),  # uint8_t  valid_tdc_B ;
            ("valid_tdc_" + str(n * 3 + 0), np.ubyte),  # uint8_t  valid_tdc_A ;
            ("id_" + str(n + 1), np.ubyte)  # uint8_t  id		     ; /B // must be in value 0
        ]
        dpayload += dpayload_single

    dtypeJoin = dheader + dpayload
    return np.dtype(dtypeJoin)

def readParsedFile(filenameIn="~/data-2020-06-26-Test1/data-1593175269.547629"):

    print(filenameIn)
    data = np.fromfile(filenameIn, dtype=dtypeAll())
    print("**************************")
    print("* Size table: ", data.shape[0])
    print("***************************")
    return data, ("", 0, 0), dtypeAll()


def getSizeData(filenameIn):
    return int(os.path.getsize(filenameIn)/dtypeAll().itemsize)

def readParsedFilePANDAS(filenameIn="~/data-2020-06-26-Test1/data-1593175269.547629"):
    """

    Return:   data, ("", 0, 0)
    """
   
    print(filenameIn)
    data = np.fromfile(filenameIn, dtype=dtypeAll())
    print("**************************")
    print("* Size table: ", data.shape[0])
    print("***************************")
    return data, ("", 0, 0)


def readRAWfileToPandas(filenameIn=None, buffer=None, offset=0, count=-1, removeNoData=True):
    fmt_data_header_struct_out = "IHBBBBBB"
    fmt_data_payload_struct_out = "IBBBBBBBB"
    fmt_data_total = fmt_data_header_struct_out + (fmt_data_payload_struct_out * 7)

    # Definition of dtype for importing data with np.fromfile or np.frombuffer
    dheader = [
        ("step", np.uint16),  # uint16_t step     ; /H
        ("t_L", np.uint8),  # uint8_t  t_L	  ; /B
        ("WORD_HEAD", np.uint8),  # uint8_t scan_enable     ; /B
    ]

    # dpayload_single=[
    #     ("event", np.ushort),       # 	uint16_t event;
    #     ("t_C", np.uint8),          # 	uint8_t  t_C     ;
    #     ("t_B", np.uint8),          # 	uint8_t  t_B     ;
    #     ("t_A", np.uint8),          # 	uint8_t  t_A     ;
    #     ("useless", np.uint8),      # 	uint8_t  useless	 ;
    #     ("valid_tdc_C", np.uint8),  # 	uint8_t  valid_tdc_C ;
    #     ("valid_tdc_B", np.uint8),  # 	uint8_t  valid_tdc_B ;
    #     ("valid_tdc_A", np.uint8),   # 	uint8_t  valid_tdc_A ;
    #     ("id", np.uint8)            # 	uint8_t  id		     ; /B // must be in value 0
    # ]
    NUMWORDS = 8
    dpayload = []
    for n in range(0, (NUMWORDS - 1)):
        dpayload_single = [
            ("t_" + str(n * 3 + 2), np.uint8),  # uint8_t  t_C     ;
            ("t_" + str(n * 3 + 1), np.uint8),  # uint8_t  t_B     ;
            ("t_" + str(n * 3 + 0), np.uint8),  # uint8_t  t_A     ;
#             ("useless_" + str(n)+
#             "valid_tdc_" + str(n * 3 + 2)+
#             "valid_tdc_" + str(n * 3 + 1)+
#             "valid_tdc_" + str(n * 3 + 0)+
#             "id_" + str(n + 1), np.uint8)  # uint8_t  id		     ; /B // must be in value 0
            ("WORD_" + str(n), np.uint8)  # uint8_t  id		     ; /B // must be in value 0
        ]
        dpayload += dpayload_single

    dtypeJoin = dheader + dpayload
    dtypeAll = np.dtype(dtypeJoin)
    if filenameIn != None:
        data = np.fromfile(filenameIn, dtype=dtypeAll, offset=offset, count=count)
    if buffer != None:
        data = np.frombuffer(buffer, dtype=dtypeAll, offset=offset, count=count)
    df=pandas.DataFrame(data)
     
    df["scan_enable"]=(data["WORD_HEAD"] & (1<<0)) >>0
    df["line_enable"]=(data["WORD_HEAD"] & (1<<1)) >>1
    df["pixel_enable"]=(data["WORD_HEAD"]& (1<<2)) >>2
    df["valid_tdc_L"]=(data["WORD_HEAD"] & (1<<3)) >>3
    df["id_0"]=(data["WORD_HEAD"] & 0b1111_0000) >>4

    for n in range(0, (NUMWORDS - 1)): 
        df["useless_" + str(n)]           = (data["WORD_" + str(n)] & 1<<0) >>0
        df["valid_tdc_" + str(n * 3 + 0)] = (data["WORD_" + str(n)] & 1<<1) >>1
        df["valid_tdc_" + str(n * 3 + 1)] = (data["WORD_" + str(n)] & 1<<2) >>2
        df["valid_tdc_" + str(n * 3 + 2)] = (data["WORD_" + str(n)] & 1<<3) >>3
        df[ "id_" + str(n + 1)]           = (data["WORD_" + str(n)] & 0b1111_0000) >>4    
    
    data=None
    
    if removeNoData:
        df=df[df["id_0"]!=15]
    return df
        

def find_nearest_idx(array, value):
    """

    Return:   idx
    """
    array = np.asarray(array)
    idx = (np.abs(array - value)).argmin()
    return idx


def autoCalibrateTAP(timeData, sysclk_ps, debugPlots=False):
    """

    Return:   time_ps
    """
    # bins, counts=fast_histInt(timeData,dmin=0)
    print("autocalibTap", int(timeData.max() - timeData.min() + 1), [int(timeData.min()), int(timeData.max() + 1)])
    hhh = np.histogram(timeData, bins=int(timeData.max() - timeData.min()), range=[timeData.min(), int(timeData.max())])

    bins = hhh[1][:-1].astype(int)
    counts = hhh[0]
    if debugPlots == True:
        plt.step(bins, counts)

    bin_widths = (counts * sysclk_ps) / sum(counts)
    bin_width_avg = np.mean(bin_widths)
    time = np.empty(counts.size)

    for i in range(counts.size):
        time[i] = sum(bin_widths[0:i]) + (bin_widths[i]) / 2
    time_ps = np.zeros(len(timeData))
    for n in range(len(timeData)):
        time_ps[n] = time[find_nearest_idx(bins, int(timeData[n]))]

    return time_ps


def dt_with_autoCalibratedTAP(time_data, sysclk_ps):
    """

    Return:  dt
    """
    tL_ps = autoCalibrateTAP(time_data["t_L"], sysclk_ps)
    t1_ps = autoCalibrateTAP(time_data["t_Ch"], sysclk_ps)
    dt = t1_ps - tL_ps + (sysclk_ps * (time_data["S_Ch"] - time_data["S_L"]))
    return dt


def dt_with_fixConstant(time_data, sysclk_ps, kC4=48.):
    """

    Return:  dt
    """
    tL_ps = time_data["t_L"] * kC4
    t1_ps = time_data["t_Ch"] * kC4
    dt = t1_ps - tL_ps + (sysclk_ps * (time_data["S_Ch"] - time_data["S_L"]))
    return dt


def fast_histInt(d, xrange=None, dmin=None):
    """

    Return:  bin_i, count
    """
    f = d.astype(int)
    if dmin is None:
        fmin = f.min()
    else:
        fmin = 0
    fb = f - fmin
    count = np.bincount(fb)
    bin_i = np.arange(fmin, len(count) + fmin)
    if not (xrange is None):
        cond0 = (bin_i > xrange[0])
        cond1 = (bin_i < xrange[1])

        bin_i = bin_i[cond0 & cond1]
        count = count[cond0 & cond1]
    return bin_i, count


def decoration_sysclk_laser_ps(laser_ps="", sysclk_ps="", alpha=None, ax=None):
    """

    """
    if (ax is None):
        ax = plt.gca()
    xlim_store = ax.get_xlim()
    ylim_store = ax.get_ylim()
    
    if (sysclk_ps!=""):
        x0_sysclk = np.arange(round(xlim_store[0] / sysclk_ps),
                              1 + round(xlim_store[1] / sysclk_ps)) * sysclk_ps
        for x0 in x0_sysclk:
            ax.plot([x0, x0], [ylim_store[0], ylim_store[1]], "--k", alpha=alpha)

    if (laser_ps!=""):
        x0_laser = np.arange(round(xlim_store[0] / laser_ps),
                             1 + round(xlim_store[1] / (laser_ps))
                             ) * laser_ps
        print(round(xlim_store[0] / laser_ps), 1 + round(xlim_store[1] / (laser_ps)) * laser_ps)
        for x0 in x0_laser:
            ax.plot([x0, x0], [ylim_store[0], ylim_store[1]], "r", linewidth=5, alpha=alpha)

    ax.set_xlim(xlim_store)
    ax.set_ylim(ylim_store)




def fitGaus(x, y):
    """

    Return:       results["A"] = coeff[0]
                 results["mu"] = coeff[1]
                 results["sigma"] = coeff[2]
    """
    meanBins = np.sum(x * y) / np.sum(y)
    stdBins = np.sqrt(np.sum(x * x * y) / np.sum(y) - (meanBins ** 2))

    peaks, hhhh = scipy.signal.find_peaks(y, threshold=max(y) * 0.01, distance=3.5)

    def gauss(x, *p):
        A, mu, sigma = p
        return A * numpy.exp(-(x - mu) ** 2 / (2. * sigma ** 2))

    def twogauss(x, *p):
        A0 = p[0]
        mu0 = p[1]
        sigma0 = p[2]
        ratioA = p[3]
        deltaMu = p[4]
        sigma1 = p[5]
        return gauss(x, A0, mu0, sigma0) + gauss(x, A0 * ratioA, mu0 + deltaMu, sigma1)

    # plot(x,y)
    # plot(x[peaks],y[peaks],"xk")
    print(len(peaks))
    results = {}

    deltaMuDefault = 0
    p0 = [max(y),
          meanBins,
          60.
          ]

    coeff, var_matrix = curve_fit(gauss, x, y, p0=p0)
    results["A"] = coeff[0]
    results["mu"] = coeff[1]
    results["sigma"] = coeff[2]

    return results


#     filenameToRead='/home/mdonato-fast/Data/data-1596030228884508'
#     sysclk_MHz = 240.
#     laser_MHz = 40.
#     dwell_time_us=1000
#     list_of_channels=np.arange(0,21)
#     #list_of_channels=[1] #np.arange(0,21)
#     autoCalibration=True
#     kC4=45.                                       ## <-- Choose carefully for calibration
#     textInPlot=None
#     ignorePixelLineFrame=False1
#     makePlots=False




def convertFromRAWBuffer(data,filenameOutputHDF5 = "/dev/shm/preview-raw-h5",sysclk_MHz=240., laser_MHz=40., dwell_time_us=1000.,
               list_of_channels=np.arange(0, 21),
               autoCalibration=True, kC4=45., textInPlot="", ignorePixelLineFrame=False,
               makePlots=False, compressionLevel=0, fitEnable=False, metadata={},
               destinationFolder="", chunk_start=None, chunk_stop=None):
    """

    Return:           myReturn["mean_list"] = mean_list
                     myReturn["sigma_list"] = sigma_list
                     myReturn["filenameH5"] = filenameOutputHDF5
    """
    print("Start readRAWfileToPandas")
    dfINPUT = readRAWfileToPandas(buffer=data)
    print("readRAWfileToPandas done.")
    sysclk_ps = 1e6 / sysclk_MHz
    laser_ps = 1e6 / laser_MHz
    
    metadataClk={}
    metadataClk["sysclk_MHz"]=np.asarray(sysclk_MHz)
    metadataClk["laser_MHz"]=np.asarray(laser_MHz)
    metadataClk["sysclk_ps"]=np.asarray(sysclk_ps)
    metadataClk["laser_ps"]=np.asarray(laser_ps)
    metadataOut={**metadata,**metadataClk}
    
    
    StepPerPixel_in = sysclk_MHz * dwell_time_us
    mean_list = []
    sigma_list = []
    myReturn = {}
    
    print("Calculate rates ")
    
    print("Calculate cumulative step ")
    diffStep = np.append([0], np.diff(
        dfINPUT["step"] * 1.))  # the diff calculate the i[n+1]-i[n] so for realign I add a 0 as first cell of the array
    sumStep = np.cumsum((diffStep < 0) * 65536.)
    # cumulativeStep=dfINPUT["step"]*1.-dfINPUT["step"][0]*1. +sumStep
    cumulativeStep = dfINPUT["step"] * 1. + sumStep
    cumulativeStep = np.asarray(cumulativeStep, dtype=np.int64)
    print("Add cumulativeStep")
    dfINPUT["cumulativeStep"] = cumulativeStep
    
    
    full_time_s = (cumulativeStep[-1]-cumulativeStep[0]) / (sysclk_MHz * 1e6)
    l = len(dfINPUT["scan_enable"] * 1.)
    se = sum(dfINPUT["scan_enable"] * 1.)
    le = sum(dfINPUT["line_enable"] * 1.)
    pe = sum(dfINPUT["pixel_enable"] * 1.)
    ll = sum(dfINPUT["valid_tdc_L"] * 1.)
    print("Acquisition lasted: ", full_time_s, "s")
    print("Scan_enable", se, "ratio", se * 1. / l, "rate", se / full_time_s)
    print("line_enable", le, "ratio", le * 1. / l, "rate", le / full_time_s)
    print("pixel_enable", pe, "ratio", pe * 1. / l, "rate", pe / full_time_s)
    print("Laser", ll, "ratio", ll * 1. / l, "rate", ll / full_time_s)



    print("Calculate totalphotons ")
    photons_data = dfINPUT[["valid_tdc_0",
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

    totalphotons = np.asarray(photons_data.sum(axis=1))

    print("kC4<===", kC4)
    print("sysclk_ps<===", sysclk_ps)

    kC4_rounded = 1. / (round(sysclk_ps / kC4) / sysclk_ps)
    print("kC4<===", kC4_rounded)
    kC4 = kC4_rounded

    print("Start process")

    dfOUTPUT = pandas.DataFrame()
    dfOUTPUT["total_photon"] = totalphotons.astype(np.uint8)
    dfOUTPUT["cumulative_step"] = cumulativeStep
    # dfOUTPUT["sysclk_period_ps"]=sysclk_ps

    if ignorePixelLineFrame:
        print("analysisForImg do not run due to ignorePixelLineFrame=True")
    else:
        print("Start analysisForImg")
        arr_px, arr_py, arr_frame, arr_px_corr, arr_index = ttpCython.analysisForImg(dfINPUT, StepPerPixel_in, cumulativeStep)
        dfOUTPUT["arr_px"] = arr_px
        dfOUTPUT["arr_px_corr"] = arr_px_corr
        dfOUTPUT["arr_py"] = arr_py
        dfOUTPUT["arr_frame"] = arr_frame

    dfOUTPUT.to_hdf(filenameOutputHDF5, mode='w', key="main", complevel=compressionLevel, format="table")
    print("New HDF5 written")
    print(dfOUTPUT.dtypes)

    for i in tqdm.tqdm(list_of_channels):
        dfCHANNEL_OUTPUT = pandas.DataFrame()

        print("Start conversion of %d channel" % i)
        print("t_%d" % i, "valid_tdc_%d" % i)

        print("..")
        timeDataProcessed = ttpCython.timeProcessRAW(dfINPUT, channel_number=i)

        # dataout["t_L"]=tL_v[0:countGood] #*1.
        # dataout["t_Ch"]=t1_v[0:countGood] #*1.
        # dataout["S_L"]=S1_v[0:countGood] #*1.
        # dataout["S_Ch"]=S2_v[0:countGood] #*1.
        # dataout["CumulativeSTEP"]=CumulativeSTEP_v[0:countGood] #*1.
        # dataout["duplicate"]=duplicate_v[0:countGood] #*1.
        # dataout["index"]=theIndex_v[0:countGood]

        dfCHANNEL_OUTPUT["t_%d" % i] = timeDataProcessed["t_Ch"].astype(np.int16)
        dfCHANNEL_OUTPUT["t_L" % i] = timeDataProcessed["t_L"].astype(np.int16)

        dS = timeDataProcessed["S_L"] - timeDataProcessed["S_Ch"]
        dfCHANNEL_OUTPUT["dS_%d" % i] = dS.astype(np.uint16)
        # dfCHANNEL_OUTPUT["S_L"%i]=timeDataProcessed["S_L"]
        # dfCHANNEL_OUTPUT["S_Ch_%d"%i]=timeDataProcessed["S_Ch"]

        dfCHANNEL_OUTPUT["index_%d" % i] = timeDataProcessed["index"]
        dfCHANNEL_OUTPUT = dfCHANNEL_OUTPUT.set_index("index_%d" % i)

        print("Adding keys to HDF5... ", '"ch_%d"' % i)

        dfCHANNEL_OUTPUT.to_hdf(filenameOutputHDF5, key="ch_%d" % i, complevel=compressionLevel, format="table")
        print(dfCHANNEL_OUTPUT.dtypes)

    if not(metadataOut is None):
        metadataDf=pandas.DataFrame(metadataOut,index=[0])
        metadataDf.to_hdf(filenameOutputHDF5, key="metadata", complevel=1)
        
    print("Data saved: ", filenameOutputHDF5)
    # dfOUTPUT=[]
    # dfCHANNEL_OUTPUT=[]
    # print ("OK")

    myReturn["mean_list"] = mean_list
    myReturn["sigma_list"] = sigma_list
    myReturn["filenameH5"] = filenameOutputHDF5
    return myReturn






def convertDataRAW(filenameToRead, fileInputRAW=False, sysclk_MHz=240., laser_MHz=40., dwell_time_us=1000.,
                   list_of_channels=np.arange(0, 21),
                   autoCalibration=True, kC4=45., textInPlot="", ignorePixelLineFrame=False,
                   makePlots=False, compressionLevel=0, fitEnable=False, metadata={},
                   destinationFolder="", chunk_start=None, chunk_stop=None):
    """

    Return:           myReturn["mean_list"] = mean_list
                     myReturn["sigma_list"] = sigma_list
                     myReturn["filenameH5"] = filenameOutputHDF5
    """
    lastRow=getSizeData(filenameToRead)
    
    sysclk_ps = 1e6 / sysclk_MHz
    laser_ps = 1e6 / laser_MHz
    
    metadataClk={}
    metadataClk["sysclk_MHz"]=np.asarray(sysclk_MHz)
    metadataClk["laser_MHz"]=np.asarray(laser_MHz)
    metadataClk["sysclk_ps"]=np.asarray(sysclk_ps)
    metadataClk["laser_ps"]=np.asarray(laser_ps)
    metadataOut={**metadata,**metadataClk}
    
    
    StepPerPixel_in = sysclk_MHz * dwell_time_us
    mean_list = []
    sigma_list = []
    myReturn = {}
    
    # savez(filename_save+".npz", data=data, metadata=metadata )
    
    if fileInputRAW:
        print("Convert RAW file to DataFrame")
        dfINPUT = readRAWfileToPandas(filenameToRead)
        print("Converted\n")
    
    else:
        data = []
        data, _, _ = readParsedFile(filenameToRead)
       
        print("Convert to DataFrame")
        dfINPUT = pandas.DataFrame(data[chunk_start:chunk_stop])
        print("Converted\n")
        data = None  # to empty memory

    print("Calculate rates ")

    print("Calculate cumulative step ")
    diffStep = np.append([0], np.diff(
        dfINPUT["step"] * 1.))  # the diff calculate the i[n+1]-i[n] so for realign I add a 0 as first cell of the array
    sumStep = np.cumsum((diffStep < 0) * 65536.)
    # cumulativeStep=dfINPUT["step"]*1.-dfINPUT["step"][0]*1. +sumStep
    cumulativeStep = dfINPUT["step"] * 1. + sumStep
    cumulativeStep = np.asarray(cumulativeStep, dtype=np.int64)
    print("Add cumulativeStep")
    dfINPUT["cumulativeStep"] = cumulativeStep
    
    
    full_time_s = (cumulativeStep[-1]-cumulativeStep[0]) / (sysclk_MHz * 1e6)
    l = len(dfINPUT["scan_enable"] * 1.)
    se = sum(dfINPUT["scan_enable"] * 1.)
    le = sum(dfINPUT["line_enable"] * 1.)
    pe = sum(dfINPUT["pixel_enable"] * 1.)
    ll = sum(dfINPUT["valid_tdc_L"] * 1.)
    print("Acquisition lasted: ", full_time_s, "s")
    print("Scan_enable", se, "ratio", se * 1. / l, "rate", se / full_time_s)
    print("line_enable", le, "ratio", le * 1. / l, "rate", le / full_time_s)
    print("pixel_enable", pe, "ratio", pe * 1. / l, "rate", pe / full_time_s)
    print("Laser", ll, "ratio", ll * 1. / l, "rate", ll / full_time_s)



    print("Calculate totalphotons ")
    photons_data = dfINPUT[["valid_tdc_0",
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

    totalphotons = np.asarray(photons_data.sum(axis=1))

    print("kC4<===", kC4)
    print("sysclk_ps<===", sysclk_ps)

    kC4_rounded = 1. / (round(sysclk_ps / kC4) / sysclk_ps)
    print("kC4<===", kC4_rounded)
    kC4 = kC4_rounded

    print("Start process")
    datafilename = filenameToRead.split(os.sep)[-1]
    if destinationFolder == "":
        destinationFolder = os.sep.join(filenameToRead.split(os.sep)[:-1]) + os.sep+"output"
    destinationFolder=destinationFolder+os.sep
    if not os.path.exists(destinationFolder):
        os.makedirs(destinationFolder)
        print("Folder not found, created", destinationFolder)

    subfix=""        
    if (chunk_start!=None or chunk_stop!=None):
        subfix+="-"       
        if chunk_start!=None:
            subfix+="%d"%chunk_start
        else:
            subfix+="0"
        subfix+="-"
        if chunk_stop!=None:
            subfix+="%d"%chunk_stop
        else:
            subfix+="%d"%lastRow

    subfix+="-raw.h5"
    filenameOutputHDF5 = destinationFolder + datafilename + subfix

    

    # dfOUTPUT = pandas.DataFrame()
    # dfOUTPUT["total_photon"] = totalphotons.astype(np.uint8)
    # dfOUTPUT["cumulative_step"] = cumulativeStep
    # dfOUTPUT["t_L"] = dfINPUT["t_L"].astype(np.uint8)
    # dfOUTPUT["valid_tdc_L"] = dfINPUT["valid_tdc_L"].astype(np.uint8)
    
    # dfOUTPUT["sysclk_period_ps"]=sysclk_ps
    
    
    dfOUTPUT=pandas.DataFrame()

    dfOUTPUT["cumulative_step"] = cumulativeStep
    dfOUTPUT["t_L"] = dfINPUT["t_L"].astype(np.uint8)
    dfOUTPUT["valid_tdc_L"]=dfINPUT["valid_tdc_L"]
    dfOUTPUT["total_photon"]=totalphotons
    
    dfOUTPUT["cumsum_totalph"]=np.cumsum(dfOUTPUT["total_photon"])
    only_valid_L=dfOUTPUT[dfOUTPUT["valid_tdc_L"]==1]
    total_photon_laser=np.diff(only_valid_L["cumsum_totalph"])

    dfOUTPUT["total_photon_laser"]=0
    dfOUTPUT["total_photon_laser"]=pandas.DataFrame(
                                                total_photon_laser.astype(np.uint8)  ,
                                                index=only_valid_L["cumsum_totalph"].index[1:]
                                              )
    del dfOUTPUT["cumsum_totalph"]
    dfOUTPUT["total_photon_laser"]=dfOUTPUT["total_photon_laser"].fillna(method="bfill").fillna(0).astype(np.uint8)
        
    
    

    if ignorePixelLineFrame:
        print("analysisForImg do not run due to ignorePixelLineFrame=True")
    else:
        print("Start analysisForImg")
        arr_px, arr_py, arr_frame, arr_px_corr, arr_index = ttpCython.analysisForImg(dfINPUT, StepPerPixel_in, cumulativeStep)
        dfOUTPUT["arr_px"] = arr_px
        dfOUTPUT["arr_px_corr"] = arr_px_corr
        dfOUTPUT["arr_py"] = arr_py
        dfOUTPUT["arr_frame"] = arr_frame

    dfOUTPUT.to_hdf(filenameOutputHDF5, mode='w', key="main", complevel=compressionLevel, format="table")
    print("New HDF5 written")
    print(dfOUTPUT.dtypes)

    for i in tqdm.tqdm(list_of_channels):
        dfCHANNEL_OUTPUT = pandas.DataFrame()

        print("Start conversion of %d channel" % i)
        print("t_%d" % i, "valid_tdc_%d" % i)

        print("..")
        timeDataProcessed = ttpCython.timeProcessRAW(dfINPUT, channel_number=i)

        # dataout["t_L"]=tL_v[0:countGood] #*1.
        # dataout["t_Ch"]=t1_v[0:countGood] #*1.
        # dataout["S_L"]=S1_v[0:countGood] #*1.
        # dataout["S_Ch"]=S2_v[0:countGood] #*1.
        # dataout["CumulativeSTEP"]=CumulativeSTEP_v[0:countGood] #*1.
        # dataout["duplicate"]=duplicate_v[0:countGood] #*1.
        # dataout["index"]=theIndex_v[0:countGood]

        dfCHANNEL_OUTPUT["t_%d" % i] = timeDataProcessed["t_Ch"].astype(np.int16)
        dfCHANNEL_OUTPUT["t_L" % i] = timeDataProcessed["t_L"].astype(np.int16)

        dS = timeDataProcessed["S_L"] - timeDataProcessed["S_Ch"]
        dfCHANNEL_OUTPUT["dS_%d" % i] = dS.astype(np.uint16)
        # dfCHANNEL_OUTPUT["S_L"%i]=timeDataProcessed["S_L"]
        # dfCHANNEL_OUTPUT["S_Ch_%d"%i]=timeDataProcessed["S_Ch"]

        dfCHANNEL_OUTPUT["index_%d" % i] = timeDataProcessed["index"]
        dfCHANNEL_OUTPUT = dfCHANNEL_OUTPUT.set_index("index_%d" % i)

        print("Adding keys to HDF5... ", '"ch_%d"' % i)

        dfCHANNEL_OUTPUT.to_hdf(filenameOutputHDF5, key="ch_%d" % i, complevel=compressionLevel, format="table")
        print(dfCHANNEL_OUTPUT.dtypes)

    if not(metadataOut is None):
        metadataDf=pandas.DataFrame(metadataOut,index=[0])
        metadataDf.to_hdf(filenameOutputHDF5, key="metadata", complevel=1)
        
    print("Data saved: ", filenameOutputHDF5)
    # dfOUTPUT=[]
    # dfCHANNEL_OUTPUT=[]
    # print ("OK")

    myReturn["mean_list"] = mean_list
    myReturn["sigma_list"] = sigma_list
    myReturn["filenameH5"] = filenameOutputHDF5
    return myReturn




    
#     N = sum(histogram)
#     bin_widths = (histogram * 1)/N
#     time = np.empty(histogram.size)  
#     for i in range(histogram.size):    
#             time[i] = sum(bin_widths[0:i]) + (bin_widths[i])/2



def binwidth_normalized(counts):
    bin_width_normalized=counts/np.sum(counts)
    
    time=np.zeros(bin_width_normalized.size)
    for i in range(0,bin_width_normalized.size):    
        time[i] = np.sum(bin_width_normalized[0:i]) + (bin_width_normalized[i])/2
    return time
    

def calculateCalibFromH5(filenameH5, listChannel, plots=False):
    """

    Return:          calibDict
    """
    h_ch_0=pandas.read_hdf(filenameH5, key="ch_%d"%listChannel[0])
    h_main=pandas.read_hdf(filenameH5, key="main")
    df = pandas.merge(h_ch_0, h_main, how="inner", left_index=True, right_index=True, validate="one_to_one", suffixes=["","_right"])
    d_ch_0 = df 
    dt=df["t_L"].astype(int)
    data_t = dt

    h=np.histogram(data_t, range=[0,150],bins=150)
    bins=h[1]
    counts=h[0]
    if plots==True:
        plt.figure()
        plt.bar(bins[:-1],counts,width=1)
        plt.title("ch_L")
    calibDict={}
    calibDict["ch_L"]=binwidth_normalized(counts)

    for ch in tqdm.tqdm(listChannel):
        h_ch_0=pandas.read_hdf(filenameH5, key="ch_%d"%ch)
        h_main=pandas.read_hdf(filenameH5, key="main")
        df = pandas.merge(h_ch_0, h_main, how="inner", left_index=True, right_index=True, validate="one_to_one", suffixes=["","_right"])
        data_t = df["t_%d"%ch].astype(int)
        h=np.histogram(data_t, range=[0,150],bins=150)
        bins=h[1]
        counts=h[0]
        calibDict["ch_%d"%ch]=binwidth_normalized(counts)
        if plots==True:
            plt.figure()
            plt.bar(bins[:-1],counts,width=1)
            plt.title("ch_%d"%ch)

    return calibDict

def applyCalibDict(filenameH5, calibDict, channel=0, getAbsoluteTime=False):
    metadataDict=pandas.read_hdf(filenameH5, key="metadata")

    sysclk_MHz=metadataDict["sysclk_MHz"][0]
    laser_MHz=metadataDict["laser_MHz"][0]
    sysclk_ps=metadataDict["sysclk_ps"][0]
    laser_ps=metadataDict["laser_ps"][0]
    
    h_ch=pandas.read_hdf(filenameH5, key="ch_%d"%channel)
    h_main=pandas.read_hdf(filenameH5, key="main")

    df = pandas.merge(h_ch, h_main, how="inner", left_index=True, right_index=True, validate="one_to_one", suffixes=["","_right"])

    t_L = calibDict["ch_L"][df["t_L"].astype(int)]*sysclk_ps
    t_0 = calibDict["ch_%d"%channel][df["t_%d"%channel].astype(int)]*sysclk_ps

    dt=df["dS_%d"%channel].astype(int)*sysclk_ps+(t_0-t_L)
    dt_mod = np.mod(dt,laser_ps)
    
    df["dt_%d"%channel] = dt
    
    if getAbsoluteTime==True:
        T_0=(df["cumulative_step"]-df["dS_%d"%channel].astype(int))*sysclk_ps-t_0
        T_L=(df["cumulative_step"])*sysclk_ps-t_L
        df["T_L" ] = T_L
        df["T_%d"% channel] = T_0
    
    return df


def image_4d_fast(npixel,nbins,nchannel,table_channels,laser_ps, bin_ir=0):
    
    image_4d=np.zeros((npixel,npixel,nbins,nchannel))
    
    if (bin_ir==0):
        bin_ir=np.zeros(nchannel)

    for ch in tqdm.tqdm(np.arange(nchannel)):    
        data_single_ch=table_channels[ch]
        data_single_frame_ch= data_single_ch[data_single_ch['arr_frame']==1]    
        data_forHistogram=np.asarray(data_single_frame_ch[["arr_px","arr_py", "dt_%d" % ch]])


        shift_time=bin_ir[ch]*laser_ps/nbins


        data_forHistogram[:,2]=laser_ps-data_forHistogram[:,2]-shift_time #flip the time and correct the time shift


        data_forHistogram[:,2]=np.mod(data_forHistogram[:,2],laser_ps) #apply the mod to dt
        
        hist_result=np.histogramdd(data_forHistogram,
                                        bins=[npixel,npixel,nbins],
                                        range=[[0,npixel],[0,npixel],[0,laser_ps]])        
        image_4d[:,:,:,ch] = hist_result[0]
    return image_4d

