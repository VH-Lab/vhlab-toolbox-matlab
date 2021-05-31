# vlt.neuro.stimulus.plot_stimulus_timeseries

  PLOT_STIMULUS_TIMESERIES - plot the occurence of a stimulus or stimuli as a thick bar on a time series plot
 
  [H,HTEXT] = vlt.neuro.stimulus.plot_stimulus_timeseries(Y, STIMON, STIMOFF, ...)
 
  Uses a thick horizontal bar to indicate the presentation time of a set of stimuli.
  STIMON should be a vector containing all stimulus ON times.
  STIMOFF should be a vector containing all stimulus OFF times.
  
  This function takes additional arguments in the form of name/value pairs:
 
  Parameter (default value)          | Description
  ---------------------------------------------------------------------------
  stimid ([])                        | Stimulus ID numbers for each entry in
                                     |     STIMON/STIMOFF; if present, will be plotted
                                     |     Can also be a cell array of string names
  linewidth (2)                      | Line size
  linecolor ([0 0 0])                | Line color
  FontSize (12)                      | Font size for text (if 'stimid' is present)
  FontWeight ('normal')              | Font weight
  FontColor([0 0 0])                 | Text default color
  textycoord (Y+1)                   | Text y coordinate
  HorizontalAlignment ('center')     | Text horizontal alignment
