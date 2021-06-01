# vlt.neuro.vision.oridir.plot.polarplot_ori

  POLARPLOT_ORI - Produces a polar plot of orientation responses
 
   [H,OUTPUTS]=vlt.neuro.vision.oridir.plot.polarplot_ori(ANGLES, RESPONSES, ...)
 
   Produces a polar plot (using the third party library MMPOLAR)
   of orientation responses in orientation space. The plot handle is
   returned in H.  ANGLES should be orientation angles in degrees,
   and RESPONSES are the responses in appropriate units. 
 
   OUTPUTS is a structure with the following fields:
      'meanvector'        :  mean orientation vector in the complex plane
      'vectormag'         :  mean vector magnitude
      'vectorpref'        :  vector preference in degrees
      'circularvariance'  :  circular variance
      'h_meanvector'      :  plot handle to the mean vector
      'h_circularvariance':  plot handle to the circular variance vector
 
   Additional name/value pairs can be provided as additional arguments:
   'showmeanvector'          : 0/1 show mean orientation vector (default 0)
   'showcircularvariance'    : 0/1 show circular variance vector (default 0)
                             :    (plots vector with length equal to 1-circular
                             :     variance and angle equal to orientation
                             :     preference)
   'style'                   : 'compass' or 'cartesian', default 'compass'
 
   See also: vlt.neuro.vision.oridir.dirspace2orispace, MMPOLAR, vlt.neuro.vision.oridir.plot.polarplot_dir
