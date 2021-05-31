# vlt.neuro.vision.oridir.rotated_oripref_stats

  ROTATED_ORIPREF_STATS - compute mean and dispersion of a set of orientation angle preferences with respect to a reference angle
 
  [MEANANGLE,DISPERSION] = vlt.neuro.vision.oridir.rotated_oripref_stats(ORI_PREF, REFERENCE_ANGLE)
 
  Given a vector of ORI_PREF values (can be in 0..360 but will be converted to 0..180 with MOD)
  and a REFERENCE_ANGLE that defines '0' (can be in 0..360 but will be converted to 0..180 with MOD)
  returns the mean angle MEANANGLE and the DISPERSION, calculated as the circular variance (CIRC_VAR).
