# vlt.matlab.findfunctionusedir

```
  FINDFUNCTIONUSEDIR determine where a function is called in a directory of m-files
 
  FUSE = FINDFUNCTIONUSEDIR(DIRNAME, MINFO)
 
  Searches the directory DIRNAME for uses of a Matlab function
  described by minfo returned by vlt.matlab.mfileinfo.
 
  This function searches for instances of [MINFO.NAME]
  Note that it may identify instances in the comments, or instances where the
  user has defined their own internal function of the same name.
 
  Returns the structure described in vlt.matlab.findfunctionusefile.
 
  This function takes extra parameters as name/value pairs:
  Parameter (default)         | Description
  ----------------------------------------------------------------------
  IgnorePackages (0)          | 0/1; should we ignore package directories that
                              |   begin with a '+' ?
  IgnoreClassDirs (0)         | 0/1: should we ignore class directories that
                              |   begin with a '@' ?
 
  See also: vlt.matlab.mfileinfo, vlt.matlab.findfunctionusefile, vlt.data.namevaluepair

```
