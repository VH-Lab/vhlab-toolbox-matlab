# vlt.signal.refractory

  REFRACTORY - Impose a refractory period on events
 
   [OUT_TIMES,OUT_INDEXES] = vlt.signal.refractory(IN_TIMES, REFRACTORY_PERIOD)
 
   This function will remove events from the vector IN_TIMES that occur
   more frequently than REFRACTORY_PERIOD.
 
   IN_TIMES should contain the times of events (in any units, whether they be
   units of time or sample numbers).
 
   REFRACTORY_PERIOD is the time after one event when another event cannot
   be said to happen.  Any events occuring within REFRACTORY_PERIOD of a 
   previous event will be removed.
 
   OUT_TIMES are the times that meet the refractory criteria.  OUT_INDEXES
   are the index values of the points in IN_TIMES that meet the criteria,
   such that OUT_TIMES = IN_TIMES(OUT_INDEXES)
