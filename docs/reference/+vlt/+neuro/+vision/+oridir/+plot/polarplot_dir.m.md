# vlt.neuro.vision.oridir.plot.polarplot_dir

```
  POLARPLOT_DIR - Produces a polar plot of direction responses
 
   [H,OUTPUTS]=vlt.neuro.vision.oridir.plot.polarplot_dir(ANGLES, RESPONSES, ...)
 
   Produces a polar plot (using the third party library MMPOLAR)
   of direction responses in direction space. The plot handle is
   returned in H.  ANGLES should be direction angles in degrees,
   and RESPONSES are the responses in appropriate units. 
 
   OUTPUTS is a structure with the following fields:
   'meanvector'              :  mean direction vector in the complex plane
   'vectormag'               :  mean direction vector magnitude
   'vectorpref'              :  vector direction preference in degrees
   'dircircularvariance'     :  direction circular variance
   'h_meanvector'            :  plot handle to the mean vector
   'h_circularvariance'      :  plot handle to the dir circular variance vector
 
   Additional name/value pairs can be provided as additional arguments:
   'showmeanvector'          : 0/1 show mean direction vector (default 0)
   'showdircircularvariance' : 0/1 show dir circular variance vector (default 0)
                             :    (plots vector with length equal to 1-dircircular
                             :     variance and angle equal to vector direction 
                             :     preference)
   'style'                   : 'compass' or 'cartesian', default 'compass'
 
   See also: vlt.neuro.vision.oridir.dirspace2orispace, MMPOLAR, vlt.neuro.vision.oridir.plot.polarplot_ori

```
