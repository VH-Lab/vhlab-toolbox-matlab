# vlt.file.custom_file_formats.newroirawdatafile

```
  NEWROIRAWDATAFILE - Create a binary file for storing spike waveforms
 
     **********NOT COMPLETE YET!!!!!!!!!!!************
 
 
    FID = vlt.file.custom_file_formats.newroirawdatafile(FILENAME, PARAMETERS)
 
    Creates (and leaves open) a new binary file for storing raw data that is
    extracted from images.  Optionally, one can also store the image index values
    that correspond to the roi pixels.
 
    This function creates the header portion that include the following
    parameters:
 
    NAME (type):                      DESCRIPTION         
    -------------------------------------------------------------------------
    parameters.name (80xchar)         : Name (up to 80 characters)
    parameters.ref (uint8)            : Reference number
    parameters.comment (80xchar)      : Up to 80 characters of comment
    parameters.precision (uint8)      : The precision --
                                      :    0 = uint16
                                      :    1 = uint32
                                      :    2 = float32
                                      :    3 = float64     
    parameters.indexesincluded (uint8): Are index values included?
                                      :    0 = no
                                      :    1 = yes
    (first 512 bytes are free for additional header use)
 
   Each bit of data includes
     the ROI number (1 16 bit integer)
     the frame number (1 32 bit integer)
     N, the number of points falling in the roi on this frame (1 32 bit integer)
     the N index values of these data points (N 32 bit integers), if parameters.precision is 1
     the N values of these pixels (N values of type parameters.precision)
 
   The resulting FID (file identifier) can be used to write waveforms to the
   file with the function vlt.file.custom_file_formats.addroirawdatafile(FID, roinum, framenum, indexes, pixelvalues, precision)
 
   NOTE: When one is done using the file, it must be closed with FCLOSE(FID).

```
