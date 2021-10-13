def path2fname(path):
    """
    Split path into file name and folder

    ==========  ===============================================================
    Input       Meaning
    ----------  ---------------------------------------------------------------
    path        Path to a file [string], e.g. 'C:\\Users\\SPAD-FCS\\file.ext'
    ==========  ===============================================================
    Output      Meaning
    ----------  ---------------------------------------------------------------
    fname       File name, e.g. 'file.ext'
    folderName  Folder name, e.g. 'C:\\Users\\SPAD-FCS\\'
    ==========  ===============================================================
    """
    
    fname = path.split('\\')[-1]
    folderName = '\\'.join(path.split('\\')[0:-1]) + '\\'
    
    return fname, folderName
