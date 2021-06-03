# vlt.data.simpletable

```
  SIMPLETABLE - Simple X/Y numeric table
 
    [NEWSIMPLETABLE,NEWCATEGORYLABELS] = vlt.data.simpletable(OLDSIMPLETABLE,...
         OLDCATEGORIES, THIS_ENTRY, THIS_CATEGORIES)
 
    Builds a simple row-based table of data values for specified numerical categories.
    The function takes an existing table (OLDSIMPLETABLE) with numeric categories
    listed in OLDCATEGORIES, and adds a row THIS_ENTRY with a possibly different
    set of numeric categories THIS_CATEGORIES.
 
    If the catogories being added do not exist, then these entries are
    added to NEWCATEGORYLABELS and the preceding entries are filled with NaN
    for that category.
 
    At the end of the function, the table is sorted in ascending order
    by NEWCATEGORYLABELS.
 
    Notes: OLDCATEGORIES and THIS_CATEGORIES must each contain no repeats
    (the same number can appear in both variables, but cannot appear twice in either).
 
    Example: 
        oldcategories = [ 0:pi/2:2*pi ];
        oldsimpletable = [ 1:5 ];
        X2 = [ 0:pi/4:2*pi];
        Y2 = [ 1:0.5:5 ] + 5;
        [newtable,newcats] = vlt.data.simpletable(oldsimpletable,oldcategories,Y2,X2),
 
    See also: TABLE

```
