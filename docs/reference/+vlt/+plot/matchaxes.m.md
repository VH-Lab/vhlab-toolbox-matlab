# vlt.plot.matchaxes

```
  MATCHAXES - Set the axis limits on a set of axes to the same value
 
   vlt.plot.matchaxes(AXESLIST, XMIN, XMAX, YMIN, YMAX)
 
   For a list of axes handles AXESHANDLES, this function sets them all
   to the same AXIS values.  If XMIN, XMAX, YMIN, YMAX are numerical values
   then those values are used. A string can also be passed for XMIN, XMAX,
   YMIN, or YMAX (or any combination). The string can be:
   string:                       | Description 
   ---------------------------------------------------------------------
   'axis'                        | The function uses the minimum (for XMIN,
                                 | YMIN) or maximum (for XMAX, YMAX) of the
                                 | values currently on the axes.
   'close'                       | The function uses the the min (or max) value
                                 | of the data plotted on the axes.
 
   Note that this function doesn't install any code that will maintain
   these axes relationships (if you change one axis, the others will not
   automatically change). It simply sets the AXIS values at the time it is
   called.
 
   If XMIN==XMAX or YMIN==YMAX (for example, if the data points all have one value)
   then vlt.plot.matchaxes subtracts 1 from the minimum and adds 1 to the maximum to avoid an 
   error, and a warning is given.
 
   Example: Rescale 2 axes so the Y axes are matched (from 0 to 1) and the X
   axes are based on the maximum and minimum of the 2 axes specified.
      % click in the first axes
      myaxes1 = gca;
      % click in the second axes
      myaxes2 = gca;
      vlt.plot.matchaxes([myaxes1 myaxes2],'axis','axis',0,1);
 
   See also: AXES, AXIS

```
