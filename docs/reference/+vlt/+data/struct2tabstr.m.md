# vlt.data.struct2tabstr

```
  STRUCT2TABSTR - convert a struct to a tab-delimited string
 
  S = vlt.data.struct2tabstr(A)
 
  Given a Matlab STRUCT variable A, this function creates a tab-delimited 
  string with the values of the structure.
 
  Values are read from the FIELDNAMES of the structure in turn. If they are
  of type 'char', then they are added to the string S directly. Otherwise,
  they are converted using MAT2STR.
 
  See also: vlt.file.loadStructArray, vlt.file.saveStructArray, vlt.data.tabstr2struct
 
  Example:
     a.fielda = 5;
     a.fieldb = 'my string data';
     s = vlt.data.struct2tabstr(a)
     % convert back
     a2 = vlt.data.tabstr2struct(s, {'fielda','fieldb'} )

```
