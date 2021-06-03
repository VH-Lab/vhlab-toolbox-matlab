# vlt.file.isfilepathroot

```
  ISFILEPATHATROOT - determine if a file path is at the root or not
 
  B = vlt.file.isfilepathroot(FILEPATH)
 
  Determines if a FILEPATH is at the root of a drive or not.
  For computers for which ISPC is true, vlt.file.isfilepathroot is true
  if the FILEPATH begins with either '/' or '$:\'.
  For computers for which ISUNIX is true, vlt.file.isfilepathroot is true
  if the FILEPATH is '/'.
 
  Note that the file path does not have to exist to specify a valid
  file path. It is just whether it has the structure of a full file path.
 
  See also: ISPC, ISUNIX
 
  Examples:
     % on unix
     vlt.file.isfilepathroot('/Volumes/test/mytestfile.txt') % true
     vlt.file.isfilepathroot('myfile.txt') % false
 
     % on Windows
     vlt.file.isfilepathroot('C:\myfolder\test') is true
     vlt.file.isfilepathroot('/C/myfolder/test') is true

```
