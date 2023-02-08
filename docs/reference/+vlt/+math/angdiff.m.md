# vlt.math.angdiff

```
  vlt.math.angdiff - Angular difference in 0..360
 
   D = vlt.math.angdiff(A)
 
   Computes the angular difference in 0..360. Answer is returned in degrees. 
   If A is a vector of inputs, D will also be a vector with the same orientation (a column or a row).
 
   Returns min(abs([A;A+360;A-360]));
 
   Examples:
      vlt.math.angdiff(0-90) == 90 % there is a 90 degree angular difference between 0 and 90
      vlt.math.angdiff(90-0) == 90 % there is a 90 degree angular difference between 90 and 0
      vlt.math.angdiff(10-359) == 11  % there is an 11 degree angular difference between 10 and 359
      vlt.math.angdiff(10-360) == 10  % there is a 10 degree angular difference between 10 and 360
 
   See also: vlt.math.angdiffwrap, vlt.math.angdiffwrapsign, vlt.math.dangdiffwrap

```
