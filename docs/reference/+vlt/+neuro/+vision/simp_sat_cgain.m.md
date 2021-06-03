# vlt.neuro.vision.simp_sat_cgain

```
  vlt.neuro.vision.simp_sat_cgain - Simple saturating contrast gain
 
   G = vlt.neuro.vision.simp_sat_cgain(C, Cs)
 
   Returns a simple contrast gain.  If contrast C is
   less than Cs, then G = 1.  Otherwise, gain is
   1-(C-Cs).  The gain falls off monotonically with
   slope 1 after the point Cs.

```
