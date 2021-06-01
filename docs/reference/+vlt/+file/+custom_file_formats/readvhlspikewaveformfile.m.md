# vlt.file.custom_file_formats.readvhlspikewaveformfile

  READVHLSPIKEWAVEFORMFILE - Read spike waveforms from binary file
 
   [WAVEFORMS, HEADER] = vlt.file.custom_file_formats.readvhlspikewaveformfile(FID_OR_FILENAME)
     or 
   [WAVEFORMS, HEADER] = vlt.file.custom_file_formats.readvhlspikewaveformfile(FID_OR_FILENAME,...
      WAVE_START,WAVE_END)
 
   Attempts to read spikewaves from WAVE_START to WAVE_END from the binary file
   whose name is given as the first argument, or from the file descriptor (FID).
   The header is parsed and returned in HEADER.
 
   WAVE_END can be INF to indicate that waves should be read to the end of the file.
   The waves are numbered from 1 .. MAX, so WAVE_START needs to be at least 1.
 
   If WAVE_START and WAVE_END are not provided, then all waves are read.
 
   If WAVE_START is less than 1, then only the header is read.
 
   The waveforms are output in the form NUM_SAMPLESxNUM_CHANNELSxNUM_WAVEFORMS
