# vlt.path.pathstr2cellarray

  PATHSTR2CELLARRAY - Convert a path string to a cell list of strings
 
    PATH_CELLSTR = vlt.path.pathstr2cellarray
 
    Converts the current path string to a cell list of strings in
    PATH_CELLSTR.  
 
    One can also use the constructions:
        PATH_CELLSTR = vlt.path.pathstr2cellarray(PATHSTR)
          to specify a path string other than the current PATH, or
        PATH_CELLSTR = vlt.path.pathstr2cellarray(PATHSTR, SEPARATOR)
          to use a path separator other than the current PATHSEP.
     
    Example:  Remove all paths that have 'VH_matlab_code' in them
        path_cellstr = vlt.path.pathstr2cellarray;
        matches = strfind(path_cellstr,'VH_matlab_code');
        inds = find(1-vlt.data.isempty_cell(matches)); % find indexes of all matches
        rmpath(path_cellstr(inds));
        path_cellstr = vlt.path.pathstr2cellarray; % update the list to reflect the changes
 
 
    See also: PATH, PATHSEP, vlt.data.isempty_cell
