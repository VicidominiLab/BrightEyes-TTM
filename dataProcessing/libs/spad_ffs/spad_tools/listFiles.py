import os

def listFiles(directory='C:/Users/SPAD-FCS/OneDrive - Fondazione Istituto Italiano Tecnologia', filetype='bin', substr=False):
    """
    Find all files with file extension 'filetype' in the given directory.
    Subfolders included.

    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    directory   Directory path string, e.g. 'C:\\Users\\SPAD-FCS'
    filetype    File extension
    substr      Only files that contain "substr" are returned
                Use False to not filter on substr
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    files       List of file names
    ==========  ===============================================================
    """
    
    # use current directory is empty string is given
    if directory == "":
        directory = os.getcwd()
    
    files = []
    # r=root, d=directories, f = files
    for r, d, f in os.walk(directory):
        for file in f:
            if '.' + filetype in file and (substr == False or substr in file):
                files.append(os.path.join(r, file))
        
    return files
