# vlt.math.divide_nozero

```
   vlt.math.divide_nozero - performs division such that 0/0 = 0
 
   Z = vlt.math.divide_nozero(X,Y)
 
   Performs an element-by-element divison of X and Y in the usual
   way except that 0/0 is 0 instead of NaN.  n/0, where n is any
   number except zero, will still be inf.
 
   See also:  RDIVIDE, LDIVIDE

```
