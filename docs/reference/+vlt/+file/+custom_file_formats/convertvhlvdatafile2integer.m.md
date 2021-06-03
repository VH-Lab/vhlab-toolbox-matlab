# vlt.file.custom_file_formats.convertvhlvdatafile2integer

```
  CONVERTVHLVDATAFILE2INTEGER - Convert a VH LabView file to binary integer format
 
   vlt.file.custom_file_formats.convertvhlvdatafile2integer(OLDFILENAME, HEADERSTRUCT, OUTPUTFILENAME, SCALE, PRECISION)
 
   This function reads data from the multichannel VHLab LabView binary
   data file format and writes a new file with precision PRECISION,
   where PRECISION is 'int32' or 'int16'.
   HEADERSTRUCT is the header structure as returned from 
   vlt.file.custom_file_formats.readvhlvheaderfile (or use empty, [], to open a file of the same name
   as OLDFILENAME with extension 'vlh').
   
   OUTPUTFILENAME is the name of the new file to be written; a new header
   file with the same name as OUTPUTFILENAME and extension
   'vlh' will be created. The data are divided by SCALE before writing.
 
   The output file will be saved with channel multiplexing.
 
   Example:
        vlt.file.custom_file_formats.convertvhlvdatafile2integer('vhlvanaloginput.vld',[],'vhlvanaloginput_int.vld',10,'int16');

```
