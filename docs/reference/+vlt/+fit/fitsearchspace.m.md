# vlt.fit.fitsearchspace

```
  FITSEARCHSPACE - return a set of vectors that span a range
  
  X0_VECTORS = vlt.fit.fitearchspace(LOWER_BOUNDS, UPPER_BOUNDS, NSPACE)
 
  Given a set of LOWER_BOUNDS = [ m1 m2 ... ] and UPPER_BOUNDS = [n1 n2 ...],
  this function computes a set of vectors that tile this space in NSPACE
  steps (using LINSPACE).
 
  The columns of X0_VECTORS are vector values (NPOINTS x dimension of bounds).
 
  See also: LINSPACE, MESHGRID, NDGRID
 
  Example:
     X0_vectors = vlt.fit.fitearchspace([0 0],[1 1],5)

```
