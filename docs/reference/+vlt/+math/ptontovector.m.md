# vlt.math.ptontovector

```
  PTONTOVECTOR - Find distance between point and a vector
 
  [D, CPT] = vlt.math.ptontovector(OFFSET, VECTOR_DIR, PT)
 
  Calculates the Euclidean distance D between a vector that is specified
  by the line
 
  X = OFFSET + VECTOR_DIR * t for all t
 
  and the given PT. The closest point on the line X, CPT, is returned.
 
  This function accepts additional arguments in the form of name/value pairs.
  Parameter (default)      | Description
  ----------------------------------------------------------------------
  Segment (0)              | Only calculate distance to points within the
                           |   segment from offset to offset + vector_dir

```
