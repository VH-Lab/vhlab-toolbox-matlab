# vlt.signal.decompose_time

```
  DECOMPOSE_TIME - Unwrap or desegment a concatenated recording into pieces
 
    NEWTIMES = vlt.signal.decompose_time(TIMESTAMPS, TIME_INTERVALS)
 
    Decomposes / desegements time stamps that are from a concatenated
    recording.
 
    It is assumed that TIMESTAMPS are a set of time stamps from a
    recording that has been concatenated from many smaller recordings.
    The beginning and end times of the concatenated recordings are
    provided in TIME_INTERVALS. Each row of TIME_INTERVALS should
    have the start and stop time (in the same units as TIMESTAMPS)
    of the recordings that comprise the concatenated recordings.
    
    Example:
        myrecording1 = [0 1]; % first recording started at 0, ended at 1
        myrecording2 = [2 3]; % second recording started at 2, ended at 3
        % concaneted record of these recordings would have duration 2
        timestamps = [ 0.5 1.5 ]; 
        % event at 1.5 really occured at 2.5 units in real time
        newtimes = vlt.signal.decompose_time(timestamps,[myrecording1;myrecording2])

```
