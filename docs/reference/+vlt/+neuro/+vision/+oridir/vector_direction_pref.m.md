# vlt.neuro.vision.oridir.vector_direction_pref

```
  VECTOR_DIRECTION_PREF - Determine dir preference/response w/ vector methods
 
   [PREF_RESP, NULL_RESP, DIR_PREF, ORI_PREF] = ...
        vlt.neuro.vision.oridir.vector_direction_pref(ANGLES, RESPONSES, [BLANK])
 
   Calculates the preferred response PREF_RESP and the null response
   NULL_RESP with vector methods.
 
   First, the orientation preference is calculated using vector methods.
   Then, the preferred and null responses are computed at the 2 directions
   that correspond to the orientation angle indicated by the vector method.
   The responses are computed by interpolation.

```
