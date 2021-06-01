# vlt.docs.class2help

  CLASS2HELP - get help information from a Matlab class .m file
 
  [CLASSHELP, PROP_STRUCT, METHODS_STRUCT, SUPERCLASSES] = CLASS2HELP(FILENAME)
 
  Returns the help string CLASSHELP, a list of properties and the
  'doc' information for each property in PROP_STRUCT, and the name of each
  method and the help in a structure called METHODS_STRUCT.
 
  PROP_STRUCT has fields 'property' and 'doc' that contain each property and
  its 'doc' string.
  
  METHODS_STRUCT has fields 'method', 'description' (the first line from the
  documentation), and 'help' (lines 2..n of the function 'help').
 
  SUPERCLASSES is a list of all superclasses for the file.
