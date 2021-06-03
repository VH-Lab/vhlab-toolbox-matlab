# vlt.file.filesepconversion

```
  FILESEPCONVERSION - convert from one FILESEP platform to another
  
  NEWFILESTRING = vlt.file.filesepconversion(FILESTRING, ORIG_FILESEP, NEW_FILESEP)
 
  Converts a file string from one filepath convention to another.
 
  FILESTRING is a file path string like 'myfolder/myfile.txt'.
  ORIG_FILESEP is the original file separator, like '/'
  NEW_FILESEP is the new file separator, like '\'
 
  Right now this function just performs a substitution. It is unknown if they are
  situations with escape characters (because '\' is often used as an escape character)
  that will fail with this function.

```
