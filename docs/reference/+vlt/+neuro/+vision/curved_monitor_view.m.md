# vlt.neuro.vision.curved_monitor_view

```
  CURVED_MONITOR_VIEW - Given the dimensions of a curved monitor, calculate the viewing angle of the animal
 
  SYSTEM = vlt.neuro.vision.curved_monitor_view(MONITOR_DIAG, ASPECTRATIO, RADIUS, VIEWING_DISTANCE)
 
  MONITOR_DIAG should be the diagonal monitor size (usually what is specified,
  multiply by 2.54 to get cm from inches).
  ASPECTRATIO should be aspect ratio of monitor (width in numerator)
  RADIUS should be the curvature of the monitor (e.g., 180 cm).
  VIEWING_DISTANCE should be the desired animal viewing distance.
 
  All angles are returned in degrees. 
  
  SYSTEM is a structure with the following entries:
  Fieldname:           | Description:
  ------------------------------------------------------
  theta                | Viewing angle of hemifield
                       |     (so 2*theta is whole view)
  monitor_diag         | Monitor diag (from input)
  monitor_height       | Monitor height
  monitor_width        | Monitor width (along curve)
  radius               | Radius of curvature from input
  viewing_distance     | Viewing distance from input
  alpha                | Angle from center of monitor to
  phi                  | Angle from center of monitor to line to edge of monitor
                       |   monitor edge edge when monitor is
                       |   viewed center-on at distance radius 
  C                    | Distance between straight view of animal 
                       |   and edge of monitor
  P                    | Distance between monitor and location that
                       |   makes a right angle with the edge of the monitor
  A                    | Distance between edge of monitor and point P

```
