def checkfname(fname, extension):
    """
    Check if string ends with given extension
    ===========================================================================
    Input       Meaning
    ---------------------------------------------------------------------------
    fname       String with file name
    extension   Extension that fname should have
    ===========================================================================
    Output      Meaning
    ---------------------------------------------------------------------------
    fname       String with the original fname and added extension if needed
    ===========================================================================
    """
    extL = len(extension)
    if len(fname) <= extL or fname[-extL:] != extension:
        fname = fname + "." + extension
    return fname
