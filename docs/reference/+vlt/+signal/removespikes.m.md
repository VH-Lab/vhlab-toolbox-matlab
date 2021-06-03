# vlt.signal.removespikes

```
  REMOVESPIKES - Remove spikes from voltage trace w/ linear interpolation
 
    DATA_OUT = vlt.signal.removespikes(DATA, T, SPIKETIMES, ...)
 
    Inputs:
      DATA - The voltage data values (time series data) (must be bigger than
                3 data points)
      T    - Either the time of each data sample in DATA, or a 1x2 vector
               with T(1) as the time of the first sample, and T(2) as the 
               sample interval. For both methods, the samples are assumed to be
               taken at regular sample intervals.
      SPIKETIMES - Spike times (in same time units as T)   
    Outputs:
      DATA_OUT - The data with the spikes removed and filled in by linear
        inpolation
 
    Optional inputs:
      One can provide additional inputs to this function with name/value
      pairs. For example, to change the time T0 before each spike that is 
      removed or the time T1 after each spike that is removed, use:
    DATA_OUT = vlt.signal.removespikes(DATA, T, SPIKETIMES, 'T0', t0, 'T1', t1)
 
    Parameters that can be modified:
    Name (default value):            | Meaning
    -------------------------------------------------------------------
    SPIKE_INTERP_METHOD (1)          | If 1, then use linear interpolation (via Matlab function INTERP1)
    SPIKE_BEGINNING_END_METHOD (1)   | If 1, then use pre-and post spike time to find the base
                                     |    of the spike before and after the spike occurs
                                     |    (uses parameters t0 and t1 below)
    t0 (0.003)                       | If 1x1: Time before spike to remove (in sec)
                                     |    The sample closest to this time is
                                     |    chosen
                                     | If 1x2: The range of times to consider as
                                     |    the baseline value; the median value 
                                     |    is taken as the baseline; (e.g., [0.001 0.003]
                                     |    considers times between 1ms and 3ms)
    t1 (0.005)                       | If 1x1: Time after spike to remove (in sec)
                                     |    The sample closest to this time is
                                     |    chosen
                                     | If 1x2: The range of times to consider as
                                     |    the baseline value; the median value 
                                     |    is taken as the baseline; (e.g., [0.001 0.003]
                                     |    considers times between 1ms and 3ms)

```
