# vlt.data.celltable2struct

  CELLTABLE2STRUCT - convert a table stored in a CELL datatype to a structure
 
  S = vlt.data.celltable2struct(C)
 
  Converts a table stored in the cell matrix C to a structure.
  It is assumed that the first row of C (C{1}) has structure labels.
  If any of these labels are not valid Matlab variables, then 
  they are converted to be.
  If rows of C{j} (j>1) have fewer entries than the header row,
  then all subsequent fields in the structure will have empty ([])
  values.
 
  Example:
     %Read a tab-seperated-value file with truncated entries (that is,
     %where each line ends prematurely if later fields are empty):
     o = vlt.file.read_tab_delimited_file(filename);
     s = vlt.data.celltable2struct(o);
