# vlt.data.eqemp

```
   vlt.data.eqemp
 
     B = vlt.data.eqemp(X,Y)
 
   If both X and Y are not empty, returns X==Y.  If both X and Y are empty, b=1.
   Otherwise, b=0;
 
   X==Y must be defined for the classes of X and Y, or there will be an error.
   MATLAB does not define == for cell arrays, so vlt.data.eqemp({'r'},{'r'})
   raises MATLAB:UndefinedFunction rather than returning a value; the same is
   true of vlt.data.eqtot and vlt.data.eqlen, which reach this comparison.
   Use ISEQUAL or ISEQUALN for cells, structs and objects. See issue #137
   (item 2), which measured this on a supported release.
 
   See also:  EQ, ISEQUAL, ISEQUALN, vlt.data.eqtot, vlt.data.eqlen

```
