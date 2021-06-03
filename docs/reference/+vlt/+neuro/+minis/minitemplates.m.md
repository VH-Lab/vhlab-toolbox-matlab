# vlt.neuro.minis.minitemplates

```
 
   [MT,T,PARAMS] = vlt.neuro.minis.minitemplates(...)
 
   Returns several rows of mini EPSC templates, ranging in amplitude from
   0.1 to 1 in amplitude, and with a range of tau onsets and offsets.
 
   T is a series of time points that can be used to plot the templates.
 
   PARAMS is a structure that has one entry per template that indicates
   the Tau_Onset, Tau_Offset, and amplitude used.
   
   This function takes name/value pairs to modify its default behavior.
   Parameter (default)      | Description
   -----------------------------------------------------------------------
   Min_Amplitude (0.1)      | The minimum amplitude to use
   Max_Amplitude (3)        | The maximum amplitude to use
   Amplitude_Steps (9)      | The number of amplitude steps from min to max
   Tau_Onsets ([0.001;      | The range of Tau_Onset values to use (seconds)
              0.003;])      |
   Tau_Offsets ([0.010;     | The range of Tau_Offset values to use (seconds)
     0.020; 0.030]);        |  
   t0 (0)                   | The time of the first sample in each template (seconds)
   t1 (0.100)               | The time of the last sample in each template (seconds)
   dt (0.001)               | The time interval between samples (seconds)

```
