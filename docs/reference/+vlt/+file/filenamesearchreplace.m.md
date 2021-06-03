# vlt.file.filenamesearchreplace

```
  FILENAMESEARCHREPLACE - Seach and replace filenames within a directory
 
  vlt.file.filenamesearchreplace(DIRNAME, SEARCHSTRS, REPLACESTRS, ...)
 
  This function searches all files in the directory DIRNAME for matches
  of any string in the cell array of strings SEARCHSTRS. If it finds a match,
  then it creates a new file with the search string replaced by the
  corresponding entry in the cell array of strings REPLACESTRS.
 
  This function also can be modified by name/value pairs:
  Parameter (default)      | Description
  ----------------------------------------------------------------
  deleteOriginals (0)      | Should original file be deleted?
  useOutputDir (0)         | Should we write to a different output directory?
  OutputDirPath (DIRNAME)  | The parent path of the output directory
  OutputDir ('subfolder')  | The name of the output directry in OutputDirPath
                           |   (will be created if it doesn't exist)
  noOp (0)                 | If 1, this will not perform the operation but will
                           |   display its intended action
  recursive (0)            | Should we call this recursively on subdirectories?
 
  See also: vlt.data.namevaluepair
  
  Example: Suppose mydirname has a file '.ext1'.
      vlt.file.filenamesearchreplace(mydirname,{'.ext1'},{'.ext2'}, 'deleteOriginals', 1)
      % renames any files with '.ext1' to have '.ext2', deleting old files

```
