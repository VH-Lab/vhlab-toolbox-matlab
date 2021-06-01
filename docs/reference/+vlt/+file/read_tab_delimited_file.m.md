# vlt.file.read_tab_delimited_file

  vlt.file.read_tab_delimited_file - Reads data from a tab-delimited file; tries to sort string/number data
 
 
    OUTPUT = READ_TAB_DELIMTED_FILE(FILENAME)
 
    Reads data from a tab-delimited text file.  OUTPUT is a cell list.  OUTPUT{i,j} is
    the value from the ith row and jth column in the tab-delimited file; note that the
    rows and columns need not have the same number of entries.
 
    The function looks at each string. If it has two '/' anywhere in them, the value is assumed
    to be a date and is read as a string. Otherwise, this function tries to assign each value a
    number using the function STR2NUM. If this process fails, then the value is assumed to be a
    text string and is stored as such.
