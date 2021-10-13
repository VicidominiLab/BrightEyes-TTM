from pathlib import Path


class infoObj:
    pass


def getFCSinfo(fname, parameter=['all']):
    
    """
    Get info from FCS info file
    ===========================================================================
    Input           Meaning
    ---------------------------------------------------------------------------
    fname           File name [.txt]
    parameter       Name of the parameter to return
                    E.g. "READING SPEED [kHz]" will return the reading speed
                    Leave blank to return an object containing all info
    ===========================================================================
    Output
    ---------------------------------------------------------------------------
    info            Either an object will all information
                    Or the requested parameter
    ===========================================================================
    """
    
    # PARSE INPUT
    fname = fname.replace("\\", "/")
    fname = Path(fname)
    
    f = open(fname, "r")
    if f.mode == "r":
        contents = f.read()
        if parameter == ['all']:
            output = infoObj()
            info = float(getFCSinfoSingleParam(contents, "DURATION [s]"))
            output.duration = info
            info = float(getFCSinfoSingleParam(contents, "TOTAL NUMBER OF DATA POINTS"))
            output.numberOfDataPoints = info
            info = float(getFCSinfoSingleParam(contents, "HOLD-OFF [x5 ns]"))
            output.holdOffx5 = info
            output.holdOff = info * 5
            info = float(getFCSinfoSingleParam(contents, "READING SPEED [kHz]"))
            output.readingSpeed = info
            output.dwellTime = 1e-3 / info # s
            return output
        else:
            output = getFCSinfoSingleParam(contents, parameter)
            return float(output)


def getFileInfo(fname, parameter=['all']):
    
    """
    Get info from FCS/imaging info file
    ===========================================================================
    Input           Meaning
    ---------------------------------------------------------------------------
    fname           File name [.txt]
    parameter       Name of the parameter to return
                    E.g. "READING SPEED [kHz]" will return the reading speed
                    Leave blank to return an object containing all info
    ===========================================================================
    Output
    ---------------------------------------------------------------------------
    info            Either an object will all information
                    Or the requested parameter
    ===========================================================================
    """
    
    # PARSE INPUT
    fname = fname.replace("\\", "/")
    fname = Path(fname)
    
    f = open(fname, "r")
    if f.mode == "r":
        contents = f.read()
        if parameter == ['all']:
            output = infoObj()
            
            info = float(getFCSinfoSingleParam(contents, "NUMBER OF TIME BINS PER PIXEL"))
            output.numberOfTbinsPerPixel = info
            
            info = float(getFCSinfoSingleParam(contents, "NUMBER OF PIXELS"))
            output.numberOfPixels = info
            
            info = float(getFCSinfoSingleParam(contents, "NUMBER OF LINES"))
            output.numberOfLines = info
            
            info = float(getFCSinfoSingleParam(contents, "NUMBER OF FRAMES"))
            output.numberOfFrames = info
            
            info = float(getFCSinfoSingleParam(contents, "RANGE X [µm]"))
            output.rangeX = info
            
            info = float(getFCSinfoSingleParam(contents, "RANGE Y [µm]"))
            output.rangeY = info
            
            info = float(getFCSinfoSingleParam(contents, "RANGE Z [µm]"))
            output.rangeZ = info
            
            info = float(getFCSinfoSingleParam(contents, "TOTAL NUMBER OF DATA POINTS"))
            output.numberOfDataPoints = info
            
            info = float(getFCSinfoSingleParam(contents, "HOLD-OFF [x5 ns]"))
            output.holdOffx5 = info
            output.holdOff = info * 5
            
            info = float(getFCSinfoSingleParam(contents, "TIME RESOLUTION [µs]"))
            output.timeResolution = info
            
            output.dwellTime = 1e-6 * output.timeResolution * output.numberOfTbinsPerPixel # s
            output.duration = output.dwellTime * output.numberOfPixels * output.numberOfLines * output.numberOfFrames # s
            output.pxsize = output.rangeX / output.numberOfPixels
            
            return output
        else:
            output = getFCSinfoSingleParam(contents, parameter)
            return float(output)


def getFCSinfoSingleParam(contents, parameter):
    # get single parameter from FCS info file
    start = contents.find(parameter)
    start = start + len(parameter) + 1
    stop = contents.find("\n", start)
    if stop == -1:
        stop = len(contents)
    return contents[start:stop]