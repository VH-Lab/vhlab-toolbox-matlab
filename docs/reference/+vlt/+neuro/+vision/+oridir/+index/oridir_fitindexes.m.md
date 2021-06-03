# vlt.neuro.vision.oridir.index.oridir_fitindexes

```
  ORIDIR_FITINDEXES - compute orientation/direction fits, index values
 
  FI = vlt.neuro.vision.oridir.index.oridir_fitindexes(RESPSTRUCT)
 
  Computes orientation/direction index fit values from a response structure RESPSTRUCT.
 
   RESPSTRUCT is a structure  of response properties with fields:
   Field    | Description
   -----------------------------------------------------------------------------
   curve    |    4xnumber of directions tested,
            |      curve(1,:) is directions tested (degrees, compass coords.)
            |      curve(2,:) is mean responses
            |      curve(3,:) is standard deviation
            |      curve(4,:) is standard error
   ind      |    cell list of individual trial responses for each direction
 
 
  Note that fits may be garbage if there are not significantly different responses across different directions.
 
  Returns a structure FI with fields:
  Field                           | Description
  ----------------------------------------------------------------------------------------
  fit_parameters                  |   [Rsp Rp Ot sigm Rn]
  fit                             |   2 row fit; first row is set of directions, second row is responses
  ot_index                        |   Orientation index ( (pref-orth)/pref) )
  ot_index_rectified              |   Orientation index ( (pref-orth)/pref) ) rectified to be in 0, 1
  ot_index_diffsum                |   Orientation index ( (pref-orth)/(pref+orth) )
  ot_index_diffsum_rectified      |   Orientation index ( (pref-orth)/(pref+orth) ), rectified to be in 0,1
  dir_pref                        |   Ot
  tuning_width                    |   Fit tuning width (HWHH, sigm*sqrt(log(4)))
  dir_index                       |   Direction index ( (pref-orth)/pref) )
  dir_index_rectified             |   Direction index ( (pref-orth)/pref) ) rectified to be in 0, 1
  dir_index_diffsum               |   Direction index ( (pref-orth)/(pref+orth) )
  dir_index_diffsum_rectified     |   Direction index ( (pref-orth)/(pref+orth) ), rectified to be in 0,1

```
