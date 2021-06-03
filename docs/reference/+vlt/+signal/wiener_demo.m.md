# vlt.signal.wiener_demo

```
  WIENER_DEMO - Demonstration of filter reconstruction using Wiener filtering
 
   Given a signal x[n] that is filtered by some unknown process, derive the least
   square best filter such that y[n] * myfilter +noise = x[n]
   
   modified from: Digital Signal Processing Using MATLAB for Students and Researchers
   John W. Leis (Wiley, 2011)
 
   The following parameters of the example can be modified by passing name/value pairs:
   Parameter (default)              | Description
   ----------------------------------------------------------------------------
   N (10000)                        | Number of points
   b ([1 0.8 -0.4 0.1])             | Filter parameters (computed using filter)
   L (4)                            | Coefficient length of divided signal
   NewNoise (0)                     | Should we filter the original noise or new noise?

```
