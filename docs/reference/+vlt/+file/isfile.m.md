# vlt.file.isfile

```
 ISFILE - Searches for a file with name filename within the existing path
    
    B = vlt.file.isfile(FILENAME)
 
    B is 1 if filename is a file located on the specified path or in the
    current folder, and 0 if no file is found.
 
    Note: isfile is a function found on Matlab versions R2017b and after. 
    Function b uses exist(filename, 'file') if this is the case
    Unless the absolute path for filename is specified, exist(filename,
    'file') will search all files and folders in the search path.

```
