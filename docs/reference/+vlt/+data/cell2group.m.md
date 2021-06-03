# vlt.data.cell2group

```
  CELL2GROUP - Turn cell data into a vector with group ID, as appropriate for ANOVA1
 
   [X,GROUP] = vlt.data.cell2group(INPUT_DATA)
 
   Reorganize data that is stored in vectors in different cells of the
   cell array INPUT_DATA into a single vector variable X with
   the group identity of each variable in X indicated by the corresponding
   entry in GROUP.
 
   This is useful for preparing data for ANOVA1.
 
   Example:
             a = { [1 2 3]', [4 5 6]', [7 8 9]' };
             [x,group]=vlt.data.cell2group(a)
             % x is [1 2 3 4 5 6 7 8 9]'
             % group is [1 1 1 2 2 2 3 3 3]'
 
   See also: ANOVA1

```
