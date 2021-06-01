# vlt.file.custom_file_formats.newvhlspikewaveformfile

  NEWVHLSPIKEWAVEFORMFILE - Create a binary file for storing spike waveforms
 
    FID = vlt.file.custom_file_formats.newvhlspikewaveformfile(FID_OR_FILENAME, PARAMETERS)
 
    Creates (or writes to) a binary file for storing spike waveforms.
    Data is stored as single precision big endian binary if this function opens the file.
 
    This function creates the header file that include the following
    parameters:
 
    NAME (type):                      DESCRIPTION         
    -------------------------------------------------------------------------
    parameters.numchannels (uint8)    : Number of channels
    parameters.S0 (int8)              : Number of samples before spike center
                                      :  (usually negative)
    parameters.S1 (int8)              : Number of samples after spike center
                                      :  (usually positive)
    parameters.name (80xchar)         : Name (up to 80 characters)
    parameters.ref (uint8)            : Reference number
    parameters.comment (80xchar)      : Up to 80 characters of comment
    parameters.samplingrate           : The sampling rate (float32)
    (first 512 bytes are free for additional header use)
 
   
   The resulting FID (file identifier) can be used to write waveforms to the
   file with the function ADDVHSPIKEWAVEFORMFILE(FID, WAVES)
 
   NOTE: When one is done using the file, it must be closed with FCLOSE(FID).
