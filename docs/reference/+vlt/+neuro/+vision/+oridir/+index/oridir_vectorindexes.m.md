# vlt.neuro.vision.oridir.index.oridir_vectorindexes

  ORIDIR_VECTORINDEX - compute orientation/direction vector indexes
 
  VI = vlt.neuro.vision.oridir.index.oridir_vectorindexes(RESPSTRUCT)
 
  Computes orientation/direction index vector values from a response structure RESP.
 
   RESPSTRUCT is a structure  of response properties with fields:
   Field    | Description
   -----------------------------------------------------------------------------
   curve    |    4xnumber of directions tested,
            |      curve(1,:) is directions tested (degrees, compass coords.)
            |      curve(2,:) is mean responses
            |      curve(3,:) is standard deviation
            |      curve(4,:) is standard error
   ind      |    cell list of individual trial responses for each direction
 
 
  Returns a structure VI with fields:
  Field                           | Description
  ----------------------------------------------------------------------------------------
  ot_HotellingT2_p                |   Hotelling's T^2 test of orientation vector data
  ot_pref                         |   Angle preference in orientation space
  ot_circularvariance             |   Magnitude of response in orientation space (see Ringach et al. 2002)
  ot_index                        |   Orientation index ( (pref-orth)/pref) )
  tuning_width                    |   Vector tuning width (see help vlt.neuro.vision.oridir.index.compute_tuningwidth)
  dir_HotellingT2_p               |   Hotelling's T^2 test of direction vector data
  dir_pref                        |   Angle preference in direction space
  dir_circularvariance            |   Direction index in vector space
  dir_dotproduct_sig_p            |   P value of dot product direction vector significance
                                  |     method of Mazurek et al. 2014
