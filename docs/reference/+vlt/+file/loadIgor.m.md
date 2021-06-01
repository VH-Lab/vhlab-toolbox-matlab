# vlt.file.loadIgor

   vlt.file.loadIgor Load Igor Binary file
      DATA = vlt.file.loadIgor(FILENAME) loads data from an Igor binary data file.  The
   data is assumed to be one dimentional, and the file is assumed to be from
   a Macintosh computer (that is, the byte ordering is assumed to be
   big-endian); this function, however, should work on any computer. 
 
   One may also use
      DATA = vlt.file.loadIgor(FILENAME,START,STOP)
   This will only load data between samples START and STOP.  STOP may be Inf
   to indicate the end of the file.  The first sample is numbered 1.
   
   Note:  This program has only been tested with float data.
 
   Developer note: Who wrote this? Was it Steve? Ken Sugino?
