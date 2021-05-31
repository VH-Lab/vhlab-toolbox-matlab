# vlt.neuro.vision.oridir.index.compute_dirvecdotorivec

  COMPUTE_DIRVECDOTORIVEC - Direction index based on dot product with computed orientation vector
 
      DI = vlt.neuro.vision.oridir.index.compute_dirvecdotorivec( ANGLES, RATES )
 
      Takes ANGLES in degrees, and RATES is the response to each angle
      in a row vector.
 
      DI is a modified vector index; the function first finds the empirical
      orientation vector and then computes dot product of direction vector with 
      unit orentation vector
