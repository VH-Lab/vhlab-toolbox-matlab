# vlt.file.saveStructArray

  SAVESTRUCTARRAY - Save a structure array into a text file
   
    vlt.file.saveStructArray(FILENAME, STRUCTARRAY, [HEADER])
 
    Saves structure array data of type STRUCT into a text
    file.  FILENAME is the name of the file to be written.
    STRUCTARRAY is the Matlab structure to be written (of type
    STRUCT).
 
    If HEADER is 1, then a header row with tab-delimited field names
    is written (recommended if the file is to be read back in with 
    vlt.file.loadStructArray).  The input argument HEADER is optional 
    (and is 1 if not specified).
 
    Any existing FILENAME is overwritten.
 
    Originally from Ken Sugino
 
    See also: vlt.file.loadStructArray, STRUCT, vlt.data.tabstr2struct
