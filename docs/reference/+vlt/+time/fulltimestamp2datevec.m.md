# vlt.time.fulltimestamp2datevec

```
  FULLTIMESTAMP2DATEVEC - Convert full time stamp yyyy-mm-ddTHH:MM:SS-TIMEZONE, to a date vector
 
  [V,TZ] = vlt.time.fulltimestamp2datevec(FULLTIMESTAMP_STR)
 
  Converts a full time stamp in the format
    yyyy-mm-ddTHH:MM:SSTIMEZONE
 
   The date vector V has the same format as the Matlab
   DATEVEC routine: V= [ year month day hour minute seconds]
 
   TZ is the time zone offset from GMT (e.g., EST is GMT -5), in 
   vector format [hour minute].
 
   Example: 
     fulltimestamp_str = '2013-11-27T10:35:35.0695379-05:00';
     [V,TZ]=vlt.time.fulltimestamp2datevec(fulltimestamp_str)
      
   See also: DATEVEC, DATESTRING

```
