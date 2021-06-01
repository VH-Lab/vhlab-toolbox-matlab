# vlt.string.str2intseq

  STR2INTSEQ - Recover a sequence of integers from a string
 
  A = vlt.string.str2intseq(STR)
 
  Given a string that specifies a list of integers, with a dash ('-') indicating a run of
  sequential integers in order, and a comma (',') indicating integers that are not
  (necessarily) sequential.
 
  The function can also take extra parameters as name/value pairs:
  Parameter (default value)    | Description
  ----------------------------------------------------------------
  sep (',')                    | The separator between the numbers
  seq ('-')                    | The character that indicates a sequential run of numbers
 
  Example:
      str = '1-3,7,10,12';
      a = vlt.string.str2intseq(str);
      % a == [1 2 3 7 10 12]
