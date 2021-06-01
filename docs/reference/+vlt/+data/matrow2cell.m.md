# vlt.data.matrow2cell

  MATROW2CELL - Convert a matrix to a cell array with each row as a cell
  
  B = vlt.data.matrow2cell(A)
 
  Given a matrix A, a cell array B is created such that the entries of 
  B{i} are the ith rows of A.
 
  If A is a cell array, then no action is taken and B = A.
 
  One might want to use this when using JSONDECODE, when regularly-sized
  items might be returned as a matrix instead of the more general cell array.
