# vlt.file.custom_file_formats.writevhlvdatafile

  WRITEVLHVDATAFILE - Write data to a VHLVDATAFILE 
   
  vlt.file.custom_file_formats.writevhlvdatafile(FILENAME, HEADER, DATA)
 
  Write a VHLVDATAFILE file to filename FILENAME, in Multiplex format.
 
  This is the format used by the Van Hooser lab at Brandeis University
  for files acquired via a LabView program (hence the abbreviation VHLV). 
 
  DATA should be channel data; each column should contain data from a single channel.
 
  If the header file in .vlh format does not exist, then it is written
  using the information in HEADER and FILENAME. The header field
  'Multiplexed' is updated to be 1.
 
  One can provide optional name/value pairs:
  PARAMETER (default value)        | Description
  --------------------------------------------------------------------------
  append (1)                       | Should we append to the end of the file?
                                   |  0 - no, create a new file
                                   |  1 - yes, add to the end of the file
 
  See also: vlt.file.custom_file_formats.readvhlvdatafile
