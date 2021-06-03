# vlt.matlab.mfileinfo

```
  MFILEINFO - return a structure with information about an m-file
 
  MINFO = MFILEINFO(FILENAME)
 
  Returns a structure with information about FILENAME with the following fields:
  Field                 | Description
  --------------------------------------------------------------------
  fullfile              | File name with full path and extension
  path                  | Full path to the file
  name                  | File name without path and without extension
  isfunction            | 0/1 is it a function?
  isclass               | 0/1 is it a classdefinition?
  
 
  See also: vlt.matlab.isclassfile(), vlt.matlab.isfunctionfile()
 
  Example:
    minfo = vlt.matlab.mfileinfo('table.m');

```
