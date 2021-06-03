# vlt.file.string2filestring

```
  STRING2FILESTRING - edit a string so it its suitable for use as part of a filename (remove whitespace)
 
  FS = vlt.file.string2filestring(S)
 
  Modifies the string S so that it is suitable for use as part of a filename.
  Removes any characters that are not letters ('A'-'Z', 'a'-'z') or digits ('0'-'9')
  and replaces them with '_'.
 
  Example:
     mystr = 'This is a variable name: 1234.';
     vlt.file.string2filestring(mystr)  % returns 'This_is_a_variable_name__1234_'

```
