# vlt.file.custom_file_formats.vhsb_write

  VHSB_WRITE - write a VHLab series binary file
 
  B = vlt.file.custom_file_formats.vhsb_write(FO, X, Y, ...)
 
  Write series data to a VH series binary file.
 
  Inputs:
     FO is the file description to write to; it can be a 
          filename or an object of type FILEOBJ
     X is a NUMSAMPLESx1 dataset, usually the independent variable.
          X can be empty if an X_start and X_increment are provided
     Y is an NUM_SAMPLESxXxYxZx... dataset with the Y samples that
          are associated with each value of X.
          X(i) is the ith sample of X, and Y(i,:,:,...) is the ith sample of Y
          
  Outputs: 
     B is 1 if the file was written successfully, 0 otherwise
  
  The function accepts parameters that modify the default functionality
  as name/value pairs.
 
  Parameter (default)                           | Description
  ------------------------------------------------------------------------------
  use_filelock (1)                              | Lock the file with vlt.file.checkout_lock_file
  X_start (X(1))                                | The value of X in the first sample
  X_increment (0)                               | The increment between subsequent values of X
                                                |    (needs only be non-zero if X_constantinterval is 1)
  X_stored (1)                                  | Should values of X be stored (1), or computed from X_start
                                                |    and X_increment (0)?
  X_constantinterval (0)                        | Is there a constant interval between X samples (1) or not (0) or
                                                |    not necessarily (0)?
  X_units ('')                                  | The units of X (a character string, up to 255 characters)
  Y_units ('')                                  | The units of Y (a character string, up to 255 characters)
  X_data_size (64)                              | The resolution (in bits) for X
  X_data_type ('float')                         | The data type to be written for X ('char','uint','int','float')
  Y_data_size (64)                              | The resolution (in bits) for Y
  Y_data_type ('float')                         | The data type to be written for Y ('char','uint','int','float')
  X_usescale (0)                                | Scale the X data before writing to disk (and after reading)?
  Y_usescale (0)                                | Scale the Y data before writing to disk (and after reading)?
  X_scale (1)                                   | The X scale factor to use to write samples to disk
  X_offset (0)                                  | The X offset to use (Xdisk = X/X_scale + X_offset)
  Y_scale (1)                                   | The Y scale factor to use
  Y_offset (0)                                  | The Y offset to use (Ydisk = Y/Y_scale + X_offset)
 
  See also: vlt.data.namevaluepair
