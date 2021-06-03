# vlt.file.custom_file_formats.addroirawdatafile

```
   ADDVHLSPIKEWAVEFORMFILE - Add waveforms to a VHL spike waveform file
 
    ******NOT FUNCTIONAL YET*********
 
     vlt.file.custom_file_formats.addvhlspikewaveformfile(FID_OR_FILENAME, WAVEFORMS)
 
   Add waveform data to a VHL spike waveform file.
 
   If an open FID (file identifier) is passed, then the data is 
   written to that file.  Note that in this case no checking is
   performed to make sure that waveform sizes correspond to what
   is contained in the file's header, so make sure the waveform
   sizes are accurate.
 
   If instead a FILENAME is passed, then the function attempts to
   open FILENAME and checks to make sure that WAVEFORMS matches
   the header file parameters.
 
   WAVEFORMS should be a matrix of size:
        NUM_SAMPLES x NUM_CHANNELS X NUM_WAVEFORMS. 
 
   See also:  vlt.file.custom_file_formats.newvhlspikewaveformfile

```
