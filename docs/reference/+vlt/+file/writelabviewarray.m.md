# vlt.file.writelabviewarray

  vlt.file.writelabviewarray - Write a LabView array into Matlab
 
   vlt.file.writelabviewarray(FNAME, A, DATASIZE, MACHINEFORMAT)
 
   Write values in matrix A to a LabView array file.
 
   DATASIZE is the size of the data; the argument should be 
   a size suitable for using in the function FWRITE (e.g.,
   'double', 'int', etc)
 
   MACHINEFORMAT is the one of the following strings, as 
   described in the FOPEN help (default is 'b'):
     'ieee-le'     or 'l' - IEEE floating point with little-endian
                            byte ordering
     'ieee-be'     or 'b' - IEEE floating point with big-endian
                            byte ordering
     'ieee-le.l64' or 'a' - IEEE floating point with little-endian
                            byte ordering and 64 bit long data type
     'ieee-be.l64' or 's' - IEEE floating point with big-endian byte
                            ordering and 64 bit long data type.
