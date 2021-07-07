# vlt.string.splitindex

```
  SPLITINDEX - split a string at specific index values into a cell array of strings
 
  CELLSTR = vlt.string.splitindex(STR, INDEXES)
 
  Splits a string into a cell array of strings at the index values indicated in 
  INDEXES.
 
  See also: split, strsplit
 
  Example:
        str = 'A,B,C';
        indexes = find(str==',');
        cellstr = vlt.string.splitindex(str,indexes) % {'A','B','C'}

```
