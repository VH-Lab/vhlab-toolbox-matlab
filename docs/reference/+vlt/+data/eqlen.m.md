# vlt.data.eqlen

```
   vlt.data.eqlen  Returns 1 if objects to compare are equal and have same size
   
     B = vlt.data.eqlen(X,Y)
 
   Returns 1 iff X and Y have the same length and all of the entries in X and
   Y are the same.
 
   Examples:  vlt.data.eqlen([1],[1 1])=0, whereas [1]==[1 1]=[1 1], vlt.data.eqtot([1],[1 1])=1
              vlt.data.eqlen([1 1],[1 1])=1
              vlt.data.eqlen([],[]) = 1
 
   See also:  vlt.data.eqtot, vlt.data.eqemp, EQ

```
