# vlt.matlab.mfiledirinfo

  MFILEDIRINFO - return m-file info for all files in a directory recursively
  
  MINFO = MFILEDIRINFO(DIRNAME, ...)
 
  Traveres all the m files in DIRNAME and all subdirectories and collects 
  the same information as vlt.matlab.mfileinfo().
 
  This function takes extra parameters as name/value pairs:
  Parameter (default)         | Description
  ----------------------------------------------------------------------
  IgnorePackages (1)          | 0/1; should we ignore package directories that
                              |   begin with a '+' ?
  IgnoreClassDirs (1)         | 0/1: should we ignore class directories that
                              |   begin with a '@' ?
 
  
  See also: vlt.matlab.mfileinfo(), vlt.data.namevaluepair()
 
  Example:
    dirname = '/Users/vanhoosr/Documents/matlab/tools/vhlab-toolbox-matlab';
    m=vlt.matlab.mfiledirinfo(dirname);
