# vlt.file.custom_file_formats.readroirawdatafile

```
  READROIRAWDATAFILE - Read spike waveforms from binary file
 
     ******NOT FUNCTIONAL YET**********
 
   [ROIDATA, HEADER] = vlt.file.custom_file_formats.readroirawdatafile(FID_OR_FILENAME)
     or 
   [ROIDATA, HEADER] = vlt.file.custom_file_formats.readroirawdatafile(FID_OR_FILENAME,...
      ROI_START,ROI_END)
 
   Attempts to read spikewaves from ROI_START to ROI_END from the binary file
   whose name is given as the first argument, or from the file descriptor (FID).
   The header is parsed and returned in HEADER.
 
   ROI_END can be INF to indicate that waves should be read to the end of the file.
   The waves are numbered from 1 .. MAX, so ROI_START needs to be at least 1.
 
   If ROI_START and ROI_END are not provided, then all waves are read.
 
   If ROI_START is less than 1, then only the header is read.
 
   The ROI data is returned in a structure list ROIDATA with the following fields:
        roi:  the roi number (integer)
      frame:  the roi frame number (integer)
          N:  number of points in the image that overlapped the ROI (integer)
    indexes:  the index values of these points (if they were stored) (N integers)
       data:  the actual data values (N doubles)

```
