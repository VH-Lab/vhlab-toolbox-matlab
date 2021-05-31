# vlt.string.intseq2str

  INTSEQ2STR - Convert an array of integers to a compact string, maintaining sequence
 
  STR = vlt.string.intseq2str(A)
 
  Converts the sequence of integers in array A to a compact, human-readable 
  sequence with '-' indicating inclusion of a series of numbers and commas
  separating discontinuous numbers.
 
  The function can also take extra parameters as name/value pairs:
  Parameter (default value)    | Description
  ----------------------------------------------------------------
  sep (',')                    | The separator between the numbers
  seq ('-')                    | The character that indicates a sequential run of numbers
 
  Example:  
      A = [1 2 3 7 10]
      str = vlt.string.intseq2str(A)
      % str == '1-3,7,10'
 
  See also: INT2STR, vlt.string.str2intseq
