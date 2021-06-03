# vlt.math.interval2continuous

```
  INTERVAL2CONTINUOUS - transform a discrete interval to continuous time at timesteps
 
  [DATA,T] = vlt.math.interval2continuous(TIMESTAMPS,DATAPOINTS,TRES)
 
  Transforms a discrete interval function to continuous time.  The function
  is expressed as a set of TIMESTAMPS and values (DATAPOINTS), where the
  function takes the value DATAPOINT(i) from TIMESTAMP(i) to TIMESTAMP(i+1).
  Thus, length(TIMESTAMPS)=length(DATAPOINT)+1.  The data are sampled
  continuously with sample difference TRES.  The data and sample times are
  returned in DATA and T, respectively.
 
  Note: The function vlt.math.stepfunc does the same thing and is easier to understand.
 
  See also:  vlt.math.stepfunc

```
