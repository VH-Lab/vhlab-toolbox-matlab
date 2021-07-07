# vlt.file.isfolder

```
 ISFILE - Searches for a file with name foldername within the existing path
    
    B = vlt.file.isfolder(foldername)
 
    B is 1 if foldername is a folder located on the specified path or in the
    current folder, and 0 if no folder is found.
 
    Note: isfolder is a function found on Matlab versions R2017b and after. 
    Function b uses exist(foldername, 'file') if this is the case
    Unless the absolute path for foldername is specified, exist(foldername,
    'file') will search all files and folders in the search path.

```
