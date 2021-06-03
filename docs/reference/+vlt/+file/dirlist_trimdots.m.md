# vlt.file.dirlist_trimdots

```
  DIR_TRIMDOTS - Trim strings '.' or '..' from a list of directory strings
    
   DIRLIST = vlt.file.dirlist_trimdots(DIRLIST_OR_DIRLISTSTRUCT, [OUTPUT_STRUCT])
 
   When one obtains output from the MATLAB DIR function, the list sometimes
   includes the POSIX directories '.' (an abbreviation for the current
   directory) and '..' (an abbreviation for the parent directory). 
   This function trims those entries from the directory list (a cell array of
   strings) and returns all other entries.
 
   One can also pass the direct output from the MATLAB DIR function, and
   the directory list will be extracted.
 
   The function stops when it has found both '.' and '..'; if these entries
   occur more than once they will not be removed. Also removes '.DS_Store'
   (Apple desktop information) and '.git' (Git information).
 
   If the argument OUTPUT_STRUCT is present and is 1, and if
   DIRLIST_OR_DIRLISTSTRUCT is a structure returned from the function DIR,
   then the output will be a structure of the same type with the '.' and
   '..' (and '.DS_Store' and '.git') removed.
 
   See also: DIR, vlt.file.dirstrip()
 
   Example:
     D=dir
     dirnumbers=find([D.isdir]) %return indexes that correspond to directories
     % display all of these directories
     dirlist = {D(dirnumbers).name}
     % now trim
     dirlist = vlt.file.dirlist_trimdots(dirlist)

```
