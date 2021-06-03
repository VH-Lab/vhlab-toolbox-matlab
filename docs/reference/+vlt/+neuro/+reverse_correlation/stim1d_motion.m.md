# vlt.neuro.reverse_correlation.stim1d_motion

```
  vlt.neuro.reverse_correlation.stim1d_motion -- Creates a 1-D (space) motion stimulus for model computation
 
    STIM=vlt.neuro.reverse_correlation.stim1d_motion(X, T, SPFREQ, SPPHASE, TF, DIR)
 
    Creates a discrete 1-D (in space) motion stimulus that can be fed to
    a 1-d spatial model
  
        X should be a vector indicating the spatial positions to create, in degrees
           (example: 0:0.1:10 creates 100 positions in increments of 0.1 degrees)
        T should be the time values to compute (stim is assumed to be constant in each bin)
           (example: 0:0.01:2 simulates 2 seconds in 0.01s steps, or a 100Hz monitor)
        SPFREQ is the spatial frequency of the grating (say 0.1 cycles per degree)
        SPPHASE is the spatial phase of the grating (between 0 and 2*pi)
        TF is the temporal frequency (in Hz)
        DIR is the direction (1 is left, -1 is right, 0 for no motion)
 
     One can imagine that the units of the returned stimulus is brightness.
 
     Each row of the returned stimulus represents the stimulus at 1 value
     of time; time is represented across the columns.
        
     Example: stim = vlt.neuro.reverse_correlation.stim1d_motion([0:0.1:10],[0:0.01:2],0.1,0,4,1);

```
