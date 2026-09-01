# vlt.data.eqlen

```
   vlt.data.eqlen  Returns 1 if objects to compare are equal and have same size
   
     B = vlt.data.eqlen(X,Y)
 
   Returns 1 iff X and Y have the same length and all of the entries in X and
   Y are the same.
 
   Examples:  vlt.data.eqlen([1],[1 1])=0, whereas [1]==[1 1]=[1 1], vlt.data.eqtot([1],[1 1])=1
              vlt.data.eqlen([1 1],[1 1])=1
              vlt.data.eqlen([],[]) = 1
 
   Comparison bottoms out in X==Y (see vlt.data.eqemp), which has two
   consequences worth knowing: NaN is not equal to itself, so
   vlt.data.eqlen(NaN,NaN) is 0; and classes for which == is undefined, cell
   arrays among them, raise an error rather than returning a value. Use
   ISEQUALN when you want either of those to come out the other way. See
   issue #137 (items 2 and 3).
 
   See also:  vlt.data.eqtot, vlt.data.eqemp, EQ, ISEQUALN

```
