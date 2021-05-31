# vlt.matlab.isfunctionfile

  ISFUNCTIONFILE - determines if a FILENAME defines a Matlab function
 
  B = ISFUNCTIONFILE(FILENAME)
 
  Returns 1 if FILENAME defines a Matlab function.
  Returns 0 otherwise.
 
  Note that other types of M files are Matlab SCRIPTS and 
  CLASS DEFINITIONS.
 
  See also: vlt.matlab.isclassfile
 
  Example: 
    wfilename = which('vlt.matlab.isfunctionfile')
    b = vlt.matlab.isfunctionfile(wfilename)
