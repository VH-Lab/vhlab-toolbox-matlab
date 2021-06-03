# vlt.signal.filterwaveform

```
   [D] = vlt.signal.filterwaveform(DATA, PARAMETERS)
 
       Filters a one-dimensional waveform.  PARAMETERS is a struct containing
       the following fields:
 
           method = one of 'conv' (1) or 'filtfilt' (2).
           B = the B part of the filter (or the stencil to convolve)
           A = the A part of the filter
 
           filtfilt will call the function filtfilt with the filter parameters
           B and A, while conv will convolve the data with B and remove the
           boundary points--to ensure that DATA does not change size, use only
           odd-length kernels.

```
