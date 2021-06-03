# vlt.matlab.replacefunction

```
  REPLACEFUNCTION - replace instances of one function call with another
 
  STATUS = REPLACEFUNCTION(FUSE, REPLACEMENT_TABLE, ...)
 
  This function examines each function use structure FUSE that is
  returned from vlt.matlab.findfunctionusefil or vlt.matlab.findfunctionusedir,
  and displays the relevant lines of code (2 above, and 2 below). It asks the
  user if they would like to replace the function (yes, no) or write a note.
  The status ("skipped", "replaced", or the note) for each entry is returned.
 
  The FUSE(i).name is looked up in the replacement_table for the replacement text.
  The replacement_table should be a struct with fields 'original', and 'replace'.
 
  This function also takes name/value pairs that modify its behavior:
  Parameter (default)            | Description
  ------------------------------------------------------------------------
  MinLine (2)                    | Minimum line number to examine; line numbers
                                 |    less than this value will not be examined
  Disable (1)                    | Disable the changes (the default)
 
  See also: vlt.matlab.findfunctionusefile, vlt.matlab.mfileinfo

```
