# vlt.file.custom_file_formats.vhsb_sampletype2matlabfwritestring

  VHSH_SAMPLETYPE2MATLABFWRITESTRING - return fwrite/fread string for sample type
 
  S = VHSB_SAMPLETypE2MATLABFWRITESTRING(DATA_TYPE, DATASIZE)
 
  Given the DATA_TYPE (char (1), uint (2), int (3), or float (4)) and
  the DATA_SIZE in bytes, this function returns a format string
  appropriate for passing to FREAD or FWRITE.
 
  Example:
    s = vlt.file.custom_file_formats.vhsb_sampletype2matlabfwritestring(4, 64)
      % s = 'float64'
