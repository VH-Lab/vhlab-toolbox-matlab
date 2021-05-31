# vlt.file.rename_mfiles_functions

  RENAME_MFILES_FUNCTIONS - Rename mfiles and function names
 
  vlt.file.rename_mfiles_functions(MFILEDIRS, EDITMFILEDIRS, ...)
 
  This function traverses the directory (and all subdirectories) MFILEDIRS and identifies all
  .m files. If any file name renaming parameters (see below) are specified, then the .m files 
  are renamed, and any text within the files that refers to the filename is edited to match the new
  name. The function then traverses the directory EDITMFILEDIRS and any of its subdirectories, looking
  for text occurrences of the renamed functions, which are replaced with the new values.
  
 
  This file also accepts name/value pairs that specify file renaming parameters:
  Parameter (default)           | Description
  ---------------------------------------------------------------------------------
  dirstrings_to_exclude         | Directories whose name contains these strings will be ignored
      {'.git','archived_code'}  | 
  
 
  See also: vlt.data.namevaluepair
