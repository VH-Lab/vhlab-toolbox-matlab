# vlt.data.hasAllFields

```
   Part of the NewStim package
   [GOOD,ERRORMSG] = vlt.data.hasAllFields(VARIABLE,FIELDNAMES,FIELDSIZES)
 
   Checks to see if VARIABLE has all of the fieldnames in the cellstr FIELDNAMES
   and also checks to see if the values of those names match the dimensions
   given in the cell array FIELDSIZES.  If you don't care to analyze one
   dimension, pass -1 for that dimension.
 
   For example,
       r = struct('test1',5,'test2',[6 1]);
       s = struct('test1',5,'test3',[6 1]);
 
       [g,e]=vlt.data.hasAllFields(r,{'test1','test2'},{[1 1],[1 2]})
                gives g = 1, e=''.
       [g,e]=vlt.data.hasAllFields(s,{'test1','test2'},{[1 1],[1 2]})
                gives g = 0, e=['''test2''' not present.']
   If you didn't care how many columns the test2 field of r was, then you could
   pass [1 -1] instead of [1 2], or if you didn't care what size it was at all
   then you could pass [-1 -1].
 
   Note:  At present, this function does not work on arrays of structs, only
   structs.  As a work-around, pass the first element of a struct array to see
   if it is good.

```
