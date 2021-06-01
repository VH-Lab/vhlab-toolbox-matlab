# vlt.signal.value2sample

  vlt.signal.value2sample - give the sample number corresponding to a quantity that is sampled at a fixed rate (value2sample)
 
  S = VALUE2SAMPLE(V, SR, V1)
 
  Given a value (or array of values) that are sampled at a fixed sampling
  rate SR (in samples/sec), and given the value of sample number 1, 
  returns the sample numbers.
 
  See also: vlt.signal.sample2value
  
  Example:
     s = vlt.signal.value2sample(1, 1000, 0) % s is 1001
