# vlt.data.eqemp

```
   vlt.data.eqemp
 
     B = vlt.data.eqemp(X,Y)
 
   If both X and Y are not empty, returns X==Y.  If both X and Y are empty, b=1.
   Otherwise, b=0;
 
   X==Y must be defined for the classes of X and Y, or there will be an error.
   Cell arrays of char vectors are NOT such a case, contrary to what this help
   said before issue #137 (item 2): {'r','g','b'}=={'r','g','b'} compares the
   contents rather than raising, so vlt.data.eqemp, vlt.data.eqtot and
   vlt.data.eqlen all answer for cellstr instead of erroring. That was measured
   in CI and is pinned by vlt.unittest.data.test_eqemp; the old wording sent
   NDI's cross-language symmetry battery looking for an error that never comes.
   Classes with no == at all -- structs and most objects -- do still raise.
   Use ISEQUAL or ISEQUALN for those, and for NaN-aware comparison.
 
   See also:  EQ, ISEQUAL, ISEQUALN, vlt.data.eqtot, vlt.data.eqlen

```
