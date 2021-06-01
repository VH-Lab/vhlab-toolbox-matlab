# vlt.path.absolute2relative

  vlt.path.absolute2relative - Determine the relative path between two filenames, given two absolute names
 
  r = vlt.path.absolute2relative(absolutepath1, absolutepath2)
 
  Given two absolute paths, this function returns the relative path of path1 with respect to path2.
 
  This function takes name/value pairs that modify its default behavior:
  | Parameter                | Description                                 |
  | ------------------------ | ------------------------------------------- |
  | input_filesep ('/')      | Input file separator (consider filesep)     |
  | output_filesep ('/')     | Output file separator (usually '/' for html |
  | backdir_symbol ('..')    | Symbol for moving back one directory        |
  
 
  **Example**:
      r=vlt.path.absolute2relative('/Users/me/mydir1/mydir2/myfile1.m', '/Users/me/mydir3/myfile2.m')
      % r = '../mydir1/mydir2/myfile1.m'
