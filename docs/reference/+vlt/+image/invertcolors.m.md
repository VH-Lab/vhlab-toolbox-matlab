# vlt.image.invertcolors

```
  Invert colors in an RGB image **UNTESTED**
 
    RGB_OUT = INVERTCOLORS(RGB_IN)
 
    Inverts an RGB image RGB_IN so that black becomes white and
    white becomes black.  The output is returned in RGB_OUT.
 
    RGB_OUT = INVERTCOLORS(RGB_IN, C1, C2)
 
    One can specify the axis of reversal by providing 2 colors
    and the midpoint.  For example, with the default conversion,
    C1 = [0 0 0] and C2 = [1 1 1].
 
 
    **COMPLETELY UNTESTED; TEST AND FIX BEFORE USE**
 
    ** BUG, fails color [0 0 1] start development there **

```
