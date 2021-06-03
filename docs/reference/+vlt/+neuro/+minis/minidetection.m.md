# vlt.neuro.minis.minidetection

```
  MINIDETECTION - Detect minis from noise -- THIS FUNCTION DOESNT WORK YET, STILL IN DEVELOPMENT
 
   MINISTRUCT = vlt.neuro.minis.minidetection(DATA, SI, ...)
 
   Finds spontaneous miniature evoked potential/current events in a recorded trace.
 
   Inputs:
   DATA should be an R x S matrix, where each row has a data set, and S is the number
   of samples in each recording. The sampling interval for the records is specified
   by SI.
 
   Additional modifications can be provided by specifying parameters as name/value pairs:
   Parameter (default)     | Description
   -----------------------------------------------------------------------------
   do_detrend_median (1)   | Should we detrend the data using vlt.signal.detrend_median?
   detrend_timescale (0.5) | Over what timescale? (in seconds)
   estimate_std_median (1) | Should we use the median method (STD_MEDIAN) to estimate 
                           |   standard deviation (1) or the standard method
                           |   of calling STD (0)?
   minisimulation (see txt)| What mini detection simulation should we use to 
                           |  determine optimal threshold? Default is
                           |  'minidetectionsimulation_guassian'
                           |  This file must be on the path and it must be the
                           |  results of vlt.neuro.minis.minidetectionsimulation
   t_before (-0.020)       | Time before each mini to grab (in seconds, rounded to
                           |  nearest sample based on SI)
   t_after (0.100)         | Time after each mini to grab (in seconds, rounded to
                           |  nearest sample based on SI)
   
 
   Outputs:
   MINISTRUCT is a structure with the following fields:
   Fieldname:            | Description
   -----------------------------------------------------------------------------
   frequency             | The overall average frequency of detected mini events
   amplitude             | The overall average amplitude of detected mini events
   intereventintervals   | The time intervals between detected mini events
   wavetime              | A time axis for plotting mini waveforms
   meanminiwaveform      | The grand mean mini waveform
   miniamplitudes        | The amplitude for each mini
   row_minisamples{}     | For each row of DATA, the samples that correspond to mini peaks
   row_minitimes{}       | For each row of DATA, the times (from beginning of row DATA)
                         |   that correspond to peaks
   row_miniwaveforms{}   | For each row of DATA, the waveform associated with each mini 
   row_miniamplitudes{}  | For each row of DATA, the amplitude associated with each mini
 
 
   See also:

```
