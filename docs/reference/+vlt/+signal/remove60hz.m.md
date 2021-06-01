# vlt.signal.remove60hz

  REMOVE60HZ remove 60Hz noise
 
    DATA_OUT = vlt.signal.remove60hz(DATA_IN, SAMPLERATE)
 
    Removes 60Hz noise via filtering with the methods and 
    parameters described below. DATA_IN must be a vector.
 
    User beware: check the output of this function carefully
    with your data, to be sure that it doesn't produce garbage.
    High frequencies (like spikes) can often be disturbed by
    certain methods employed here ('sgolay'), so this is best
    done on low frequency data (for example, membrane potential
    with spikes removed).
 
    The method and parameters of the function can be modified
    with name/value pairs:
 
    Parameter (default):           |  Description 
    --------------------------------------------------------------
    METHOD ('sgolay')              |  If 'sgolay':
                                   |      Use Savitzky-Golay filter
                                   |      Relies on SOGOLAYFILT
                                   |  If 'cheby1':
                                   |      Use chebychev1 type filter
                                   |      Relies on CHEBY1 and FILTFILT
                                   |      (Signal Processing Toolbox)
                                   |  If 'ellip':
                                   |      Use elliptical filter
                                   |      Relies on ELLIP and FILTFILT
                                   |  If 'ellip+sgolay', then the algorithm
                                   |      uses a blend of the 'ellip' and 
                                   |      'sgolay' methods. The signal is 
                                   |      first high-pass filtered above
                                   |      'ellipsgolay_high'. This high-pass
                                   |      signal is then removed from the data,
                                   |      and the remaining low-pass signal
                                   |      is passed through the standard
                                   |      'sgolay' mode. Finally, the high
                                   |      frequencies that were identified
                                   |      in the 'high-pass' filter are added back.
    sgolay_freq (60)               |  For 'sgolay', the frequency to remove.
                                   |      
    Stop ([55 65])                 |  For 'cheby1' and 'ellip', the
                                   |      stop filter frequencies
    R (0.5)                        |  For 'cheby1' and 'ellip', R
                                   |      decibles of peak-
                                   |      to-peak ripple in passband
    Rs (20)                        |  For 'ellip', at least Rs decibles
                                   |      of attentuation
                                          in the stop band
    Order (3)                      |  For 'cheby1' and 'ellip', the filter
                                   |      order
    ellipsgolay_high (65)          |  For 'ellip+sgolay', the high pass frequency
    
    
                              
    If you get NaN for your output data, try reducing the filter order.
 
    Contributions: Wes Alford, Steve Van Hooser
