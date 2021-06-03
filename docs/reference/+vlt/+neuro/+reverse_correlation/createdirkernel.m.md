# vlt.neuro.reverse_correlation.createdirkernel

```
  vlt.neuro.reverse_correlation.createdirkernel - Create a model direction-selective kernel
 
   D = vlt.neuro.reverse_correlation.createdirkernel(X, T, SPFREQ, SPHASE, TF, DIR, SPACE_GAUSS, TIME_DE, ABSNORM)
 
   Creates a model direction-selective kernel
 
        X should be a vector indicating the spatial positions to create, in degrees
           (example: 0:0.1:10 creates 100 positions in increments of 0.1 degrees)
        T should be the time values of the kernel to create (kernel is assumed to
           be constant in each bin)
           (example: 0:0.001:0.5 is 0.5 seconds in 0.001s steps)
        SPFREQ is the spatial frequency preference of the kernel (say 0.1 cycles per degree)
        SPPHASE is the spatial phase pref of the grating (between 0 and 2*pi)
        TF is the temporal frequency of drifting (in Hz)
        DIR is the slant direction (1 is left, -1 is right, 0 for no slant)
        SPACE_GAUSS is a 2 element vector for gaussian envelope [mean and variance]
        TIME_DE is a 3 element vector describing a double exponential function
            TIME_DE = [ onset tau1 tau2], where G>0 only for T>offset, and
            then G=((tau1*tau2)/(tau1-tau2))*(exp(-t/tau1) - exp(-t/tau2))
            (rougly speaking, tau1 is the onset time constant, tau2 is offset)
        ABSNORM -- if this parameter is not empty ([]) then the kernel will be
        normalized so the optimal stimulus will produce a response of ABSNORM.

```
