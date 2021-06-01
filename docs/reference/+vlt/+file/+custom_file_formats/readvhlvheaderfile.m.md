# vlt.file.custom_file_formats.readvhlvheaderfile

  READVHLVHEADERFILE - Read VHLV header file format
 
   HEADERSTRUCT = vlt.file.custom_file_formats.readvhlvheaderfile(MYFILENAME)
 
    Reads the header file format for the VHLAB LabView
    multichannel acquisition system.
 
    It expects MYFILENAME to be the name of a text file, where each line
    begins with a field name followed by a colon ':' and then a tab, followed
    by the value. The expected fields are 'ChannelString', which indicates the
    channel names that were acquired in the LabView system, 'NumChans', the number
    of channels that were acquired, 'SamplingRate', the sampling rate of each
    channel in Hz, and 'SamplesPerChunk', which indicates how many samples were
    written to disk in each burst of recording.  'Multiplexed' indicates
    whether adjacent samples are from different channels (1) or if 
    the channel data is loaded in groups of SamplesPerChunk (0).
 
    The channel numbers correspond to the inputs described in 'ChannelString'.
    For example, if ChannelString is '/dev/ai0', then there is just 1 channel
    and it corresponds to analog input 0 on the acquisition device.
 
    Use vlt.file.custom_file_formats.readvhlvdatafile to read the data.
 
    Example:
      headerstruct = vlt.file.custom_file_formats.readvhlvheaderfile('vhlvanaloginput.vlh')
 
      headerstruct = 
          ChannelString: [1x26 char]
               NumChans: 17
           SamplingRate: 25000
        SamplesPerChunk: 25000
            Multiplexed: 0
 
 
   See also STRUCT, vlt.file.custom_file_formats.readvhlvdatafile
