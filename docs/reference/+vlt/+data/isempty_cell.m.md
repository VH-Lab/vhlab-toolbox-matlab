# vlt.data.isempty_cell

   ISEMPTY_CELL - Returns elements of a cell variable that are empty/not empty
 
   B = ISEMPTY(THECELL)
 
   Returns a logical array the same size as THECELL. Each entry of the array B
   is 1 if the contents of the cell is empty, and 0 otherwise.
 
   Example:
 
      A = {'test', [] ; [] 'more text'}
      B = vlt.data.isempty_cell(A)
 
      B =
            0     1
            1     0
