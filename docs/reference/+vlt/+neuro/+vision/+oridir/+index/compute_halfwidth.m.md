# vlt.neuro.vision.oridir.index.compute_halfwidth

  COMPUTE_LOWHALFMAX
      [LOW,MAX,HIGH] = vlt.neuro.vision.oridir.index.compute_halfwidth( X, Y )
 
      interpolates function by linearly (splines goes strange for small points)
      and returns MAX, where x position where function attains its maximum value
      LOW < MAX,  where function attains half its maximum
      HIGH > MAX, where function attains half its maximum
      returns NAN for LOW or/and HIGH, when function does not come below the point
      
      note: ugly,slow and crude routine,    consider taking log x first
