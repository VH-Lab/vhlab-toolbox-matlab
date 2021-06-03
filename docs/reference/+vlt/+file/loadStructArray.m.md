# vlt.file.loadStructArray

```
  LOADSTRUCTARRAY - load a struct array from a tab-delimited file
 
  A = vlt.file.loadStructArray(FNAME [, FIELDS])
 
  Reads tab-delimited text from the file FNAME to create an array of
  Matlab STRUCT objects. If FIELDS is not provided, then the field names
  are read from the first row of FNAME.
 
  If the header row contains strings that are not valid Matlab structure
  field names % (because they have a space or begin with a number for example), 
  then they will be converted to valid variable names with 
  MATLAB.LANG.MAKEVALIDNAME.
 
  Each subsequent row contains the values for each entry in the STRUCT array.
 
  See also: vlt.file.saveStructArray, vlt.data.tabstr2struct

```
