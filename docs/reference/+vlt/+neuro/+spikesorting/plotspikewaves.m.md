# vlt.neuro.spikesorting.plotspikewaves

```
  PLOTSPIKEWAVES - Plot spike waveforms to the current axes
 
    H=vlt.neuro.spikesorting.plotspikewaves(WAVES, [INDEXES], ...)
 
  Inputs:
   WAVES: A NumSamples x NumChannels x NumSpikes list of spike
    waveforms. All channels are combined into 1 dimension for the plot.
   INDEXES:  Optional, a list of index values to plot. If not provided,
    then all waves are plotted (subject to restrictions below).
 
  Additional name/value pairs can be provided to modify the default settings
  below:
 
   'SampleTimes'       : The sample times of each spike; default 1:(NumSamples*NumChannels) (sample numbers)
   't'                 : The time of each spike (default 1:NumSpikes, indicating spike order only)
   'TimeGraphBin'**    : If >0 and if t has real times, show a second graph in front of the spike
                       :    waveforms indicating the firing rate in time bins of this size (default 0);
                       :    otherwise show no graph
   'TimeGraphMax'**    : The firing rate in the time graph that is considered "maximum" (default 20 (Hz))
   'ClassID'           : 1xNumSpikes - class identity of each waveform (default 1:NumSpikes, meaning each unique)
   'ColorOrder'        : List of colors (Nx3) to cycle through with class ID; defaults to the default
                       :    color order for the axes, that is, get(gca,'ColorOrder').
   'RandomSubset'      : Should we plot only a random subset? (0/1, default 1)
   'RandomSubsetSize'  : How many waves should we plot?  (default 200)
   'LineWidth'         : Default 0.5
   'ClearAxes'         : Default 0
 
    ** not implemented yet
 
 
   Outputs:
     H: A list of the plot handles for these waves

```
