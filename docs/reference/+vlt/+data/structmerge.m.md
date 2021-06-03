# vlt.data.structmerge

```
  STRUCTMERGE - Merge struct variables into a common struct
 
   S_OUT = vlt.data.structmerge(S1, S2, ...)
 
   Merges the structures S1 and S2 into a common structure S_OUT
   such that S_OUT has all of the fields of S1 and S2. When 
   S1 and S2 share the same fieldname, the value of S2 is taken.
   The fieldnames will be re-ordered to be in alphabetical order.
 
   The behavior of the function can be altered by passing additional
   arguments as name/value pairs. 
 
   Parameter (default)     | Description
   ------------------------------------------------------------
   ErrorIfNewField (0)     | (0/1) Is it an error if S2 contains a
                           |  field that is not present in S1?
   DoAlphabetical (1)      | (0/1) Alphabetize the field names in the result
  
   See also: STRUCT

```
