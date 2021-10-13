cimport cython
cimport numpy as np
import numpy as np
from cpython cimport array
import array
import tqdm as tq
import os


def timeProcessRAW(datapre, channel_number, verbose=False):

        write_en_tdc_name="valid_tdc_%d"% channel_number
        channel ="t_%d"% channel_number
        if verbose: print("Data processing...")
        datapre=datapre[(datapre[write_en_tdc_name]>0) | (datapre["valid_tdc_L"]>0)]

        ok = 0
        okold = 0
        fail = 0

        cdef str K
        cdef long long  last_tL, last_timestamp_1, last_timestamp_2, \
                        printcount, duplicate_case, printdebug, \
                        t1, t2, tL, step, write_en_tdc, write_en_tdc_laser, n, \
                        length, countGood, datapre_trim_len
        cdef bint last_ok
        cdef np.int64_t cumulative_step, last_timestamp_64_1, last_timestamp_64_2
        cdef np.long_t theIndex
        length = len(datapre["t_L"])

        tL_v=np.zeros(length, dtype=int)
        t1_v=np.zeros(length, dtype=int)

        S1_64_v=np.zeros(length, dtype=np.int64)
        SL_64_v=np.zeros(length, dtype=np.int64)

        CumulativeSTEP_v=np.zeros(length, dtype=np.int64)
        theIndex_v=np.zeros(length, dtype=np.long)
        duplicate_v=np.zeros(length, dtype=int)





        last_tL=0
        last_timestamp_1=0
        last_timestamp_64_1=0
        last_t1=0
        last_timestamp_2=0
        last_timestamp_64_2=0

        last_ok=False
        duplicate_case=False
        printdebug=False
        printcount=0

        #uint8 datapre_trim["t_L"],
        #uint8  datapre_trim[channel],
        #uint16  datapre_trim["step"],
        #uint8  datapre_trim[write_en_tdc_name],
        #uint8  datapre_trim["valid_tdc_L"],
        #float64  datapre_trim["cumulative_step"]


        cdef np.uint8_t [:]   t_L_view=np.asarray(datapre["t_L"])
        cdef np.uint8_t[:]   t_1_view=np.asarray(datapre[channel])
        cdef np.uint16_t[:]  step_view=np.asarray(datapre["step"])
        cdef np.uint8_t[:]   valid_1_view=np.asarray(datapre[write_en_tdc_name])
        cdef np.uint8_t[:]   valid_L_view=np.asarray(datapre["valid_tdc_L"])
        cdef np.int64_t[:] cumulative_step_view=np.asarray(datapre["cumulativeStep"])
        cdef np.long_t[:] theIndex_view = np.asarray(datapre.index.to_numpy())



        countGood=0

        pbar = tq.tqdm(total=length) #progress bar
        cdef long long pbar_period
        pbar_period=int(length/100)

        for n in range(0,length):
            tL=t_L_view[n]
            t1=t_1_view[n]
            step=step_view[n]
            write_en_tdc=valid_1_view[n]
            write_en_tdc_laser=valid_L_view[n]
            cumulative_step=cumulative_step_view[n]
            #K=""

            if (write_en_tdc==1):
                last_t1=t1
                #last_tL=tL
                last_timestamp_64_1=cumulative_step
                last_pre_t1=t1
                last_ok = True
                theIndex=theIndex_view[n]

            if (write_en_tdc_laser==1) & (last_ok == True):
                last_ok = False
                last_tL=tL
                #last_t1=t1
                last_timestamp_64_2=cumulative_step

                #K="*"
                tL_v[countGood]=last_tL
                t1_v[countGood]=last_t1


                S1_64_v[countGood]=last_timestamp_64_1
                SL_64_v[countGood]=last_timestamp_64_2

                CumulativeSTEP_v[countGood]=cumulative_step
                duplicate_v[countGood]=duplicate_case
                theIndex_v[countGood]=theIndex
                countGood=countGood+1
                #K=K+"OK"
            if (cython.cmod(n,pbar_period)==0):
                pbar.update(pbar_period)
                #print (n*100./length," %")

        print("Data ready, conversion to array")
        dataout={}

        dataout["t_L"]=tL_v[0:countGood] #*1.
        dataout["t_Ch"]=t1_v[0:countGood] #*1.


        dataout["S_L"]=SL_64_v[0:countGood] #*1.
        dataout["S_Ch"]=S1_64_v[0:countGood] #*1.

        dataout["index"]=theIndex_v[0:countGood]
        if verbose: print(dataout)
        if verbose: print("Data processed!")
        return dataout



def analysisForImg(dataframeInput, StepPerPixel_in, cumulativeStep):
    cdef long long length,n
    cdef np.int64_t step, stepNewLine
    cdef int se,le,pe,frame,line,pixel,last_se,last_le, pixelCorr, microtime
    cdef np.int64_t StepPerPixel
    StepPerPixel=StepPerPixel_in

    
    length = len(dataframeInput["scan_enable"])


    #dataframeInput=np.asarray(dataframeInput)

    cdef np.uint8_t [:] scan_enable_view = np.asarray(dataframeInput["scan_enable"])
    cdef np.uint8_t [:] line_enable_view = np.asarray(dataframeInput["line_enable"])
    cdef np.uint8_t [:] pixel_enable_view = np.asarray(dataframeInput["pixel_enable"])
    cdef np.int64_t [:] cumulative_step_view = np.asarray(cumulativeStep.astype(np.int64))
    cdef np.long_t [:] theIndex_view = np.asarray(dataframeInput.index.to_numpy())
    stepNewLine=cumulativeStep[0]

    print("Arrays copied into analysisForImg")




    arr_px_v=np.zeros(length, dtype=np.uint16)
    arr_px_corr_v=np.zeros(length, dtype=np.uint16)
    arr_py_v=np.zeros(length, dtype=np.uint16)
    arr_frame_v=np.zeros(length, dtype=np.uint16)
    arr_index_v=np.zeros(length, dtype=np.long)

    frame=0
    pixel=0
    line=0
    last_line=0
    last_frame=0
    pixelCorr=0


    pbar = tq.tqdm(total=length) #progress bar
    cdef long long pbar_period
    pbar_period=int(length/100)

    for n in range(0,length):
        se = scan_enable_view[n]
        le = line_enable_view[n]
        pe = pixel_enable_view[n]
        step = cumulative_step_view[n]
        myindex = theIndex_view[n]

        #step=cumulativeStep[n]

        if (se==1):
            pixel=0
            line=0
            if (last_se==0):
                frame=frame+1
                #print(se,last_frame,frame)

            pixelCorr=0
            stepNewLine=step

        if (le==1) and (last_le==0):
            pixel=0
            stepNewLine=step
            line=line+1
            pixelCorr=0

        if (pe==1):
            pixel=pixel+1

        if (cython.cmod(n,pbar_period)==0):
                pbar.update(pbar_period)
                pbar.set_description("Current frame: %d \t"%frame)

        pixelCorr=int(int(step-stepNewLine)/StepPerPixel)
        last_se=se
        last_le=le
        arr_px_v[n]=pixel
        arr_px_corr_v[n]=pixelCorr
        arr_py_v[n]=line
        arr_frame_v[n]=frame
        arr_index_v[n]=myindex


    print("Total Frame:",frame)
    return arr_px_v,arr_py_v,arr_frame_v,arr_px_corr_v, arr_index_v



