# vlt.file.custom_file_formats.vhsb_read

```
  VHSB_READ - write a VHLab series binary file
 
  [Y,X] = vlt.file.custom_file_formats.vhsb_read(FO, X0, X1, OUT_OF_BOUNDS_ERR, ...)
 
  Read Y series data from a VH series binary file from closest X sample
  to value X0 to closest X sample to value X1.
 
  Inputs:
     FO is the file description to write to; it can be a 
          filename or an object of type vlt.file.fileobj
     X0 is the value of X that indicates where to start reading. Can be -Inf to 
          indicate the beginning of the samples in the file.
     X1 is the value of X that indicates where to stop reading. Can be Inf to indicate
          the end of the file.
     OUT_OF_BOUNDS_ERR indicates whether an error should be triggered if X0 or X1 are
          more than one half-sample away from a value of X that is actually in the dataset.
          If OUT_OF_BOUNDS_ERR is 1, then an error is triggered; otherwise, the closest sample
          is returned but no error is given.
          
  Outputs: 
     X is NUMSAMPLESx1, where NUMSAMPLES is the number of samples between
          X0 and X1.
     Y is an NUM_SAMPLESxXxYxZx... dataset with the Y samples that
          are associated with each value of X.
          X(i) is the ith sample returned of X, and Y(i,:,:,...) is the ith sample returned of Y

```
