# vlt.string.ismatlabstring

```
  ISMATLABSTRING - is a character within a Matlab string?
 
  TF = vlt.string.ismatlabstring(STR, [STARTISWITHINSTRING])
 
  Returns 0/1 for each character of STR as to whether or not the
  character is within a Matlab string literal. The quotes are considered
  to be part of the string.
 
  It is normally assumed that the beginning of STR is not already
  considered to be part of a Matlab string. The user can pass STARTISWITHINSTRING as
  1 to indicate that the first character of STR should be taken to be within a Matlab
  string.
 
  Examples:
     str = ['myvar=5; a = ''my string'';']
     vlt.string.ismatlabstring(str)
              000000000000011111111100
 
     str = ['myvar=5; a = [''my '''' '' int2str(5) '' string'';]']
     vlt.string.ismatlabstring(str)

```
