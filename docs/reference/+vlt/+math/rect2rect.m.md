# vlt.math.rect2rect

```
  RECT2RECT - Convert among rectangle formats, eg [left bottom width height]->[left top right bottom]
 
    R_OUT = vlt.math.rect2rect(R_IN, DIRECTION)
 
    Converts rectangle R_IN to R_OUT according to format specified in DIRECTION.
 
    DIRECTION should be a string 'IN2OUT', where IN and OUT can be any of:
      'ltrb'   [left top right bottom]
      'lbrt'   [left bottom right top]
      'lbwh'   [left bottom width height]
      'ltwh'   [left top width height]
    
    Case is ignored in the DIRECTION command.
 
    See also: RESCALE_RECT

```
