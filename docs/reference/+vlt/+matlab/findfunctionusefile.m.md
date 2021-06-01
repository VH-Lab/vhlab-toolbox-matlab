# vlt.matlab.findfunctionusefile

  FINDFUNCTIONUSE determine where a function is called in an m file
 
  FUSE = FINDFUNCTIONUSE(FILENAME, MINFO)
 
  Searches the file FILENAME for uses of a Matlab function
  described by minfo returned by vlt.matlab.mfileinfo.
 
  This function searches for instances of [MINFO.NAME]
  Note that it may identify instances in the comments, or instances where the
  user has defined their own internal function of the same name.
 
  Returns a structure of possible usages
  Fieldname                     | Description
  ----------------------------------------------------------------
  fullfilename                  | Full filename of FILENAME
  name                          | Function name from MINFO.NAME
  line                          | Line number where possible usage occurred
  character                     | Character where the name occurrs
  incomments                    | 0/1 is it in a comment?
  package_class_use             | 0/1 Does a '.' appear before the function call?
  allcaps                       | 0/1 Does the function appear in all caps here? (might be documentation use)
  
  See also: vlt.matlab.mfileinfo
