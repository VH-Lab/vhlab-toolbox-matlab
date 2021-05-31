# vlt.file.custom_file_formats.readvhlvdatafile_orig

  READVHLVDATAFILE - Read LabView data from the VH Lab format
 
   [T,D,TOTAL_SAMPLES,TOTAL_TIME] = vlt.file.custom_file_formats.readvhlvdatafile(FILENAME, HEADERSTRUCT, CHANNELNUMS, T0, T1)
 
   This function reads data from the multichannel VHLab LabView binary
   data file format. FILENAME is the name of the file to open, 
   HEADERSTRUCT is the header structure as returned from 
   vlt.file.custom_file_formats.readvhlvheaderfile, CHANNELNUMS are the channel numbers to read, where
   0 is the first channel in the list that was acquired in LabView, 1 is
   the second channel, etc.  See the HEADERSTRUCT to learn the mapping between
   the channel list and the inputs of the device (such as ai0, ai1, ... ports
   on the National Instruments card). If HEADERSTRUCT is empty, then a file with
   the same name but with extension .vlh is opened as the header file.
   T0 is the time relative to the beginning of the recording to start reading
   from, and T1 is the time relative to the beginning of the recording to read to.
 
   TOTAL_SAMPLES is the estimated number of total samples in the file.
   TOTAL_TIME is the estimated time length of the file.
 
   The data can be stored in 2 different binary formats. If the 'Multiplexed'
   field of HEADERSTRUCT is not provided or is 0, then the data are assumed to
   to be stored in binary chunks with headerstruct.SamplesPerChunk samples of channel 1
   stored, followed by headerstruct.SamplesPerChunk samples of channel 2 stored, etc.
   If headerstruct.Multiplexed is 1, then the samples are perfectly multiplexed so that
   sample 1 is the first sample of channel 1, sample 2 is the first sample of channel 2, 
   and so on.
 
   Example:
      myheader = vlt.file.custom_file_formats.readvhlvheaderfile('vhlvanaloginput.vlh');
 
      % read from 0 to 5 seconds on the first channel acquired
      [T,D] = vlt.file.custom_file_formats.readvhlvdatafile('vhlvanaloginput.vld',myheader,1,0,5);
      figure;
      plot(T,D);
      xlabel('Time(s)');
      ylabel('Volts');  % or mV or microV, whatever the units were
