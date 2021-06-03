# vlt.signal.sample2value

```
  vlt.signal.sample2value - give the value corresponding to a sample number for a fixed sampling rate (sample2value)
 
  V = SAMPLE2VALUE(S, SR, V1)
 
  Given a sample number (or array of sample numbers) S and a fixed
  sampling rate SR (in samples/sec) and the value of sample number 1,
  returns the value V of the sample.
 
  See also: vlt.signal.value2sample
  
  Example:
     v = vlt.signal.sample2value(1001, 1000, 0) % v is 1.0

```
