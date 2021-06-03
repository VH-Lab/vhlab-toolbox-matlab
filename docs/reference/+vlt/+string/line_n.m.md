# vlt.string.line_n

```
  LINE_N - Get the Nth line of a character string
 
   [LINE_N_STR, POS, EOL_MARKS] = vlt.string.line_n(STR, N, ...)
 
   Returns the Nth line of a multiline string STR.
   LINE_N_STR is the string contents of the Nth line,
   without the end of line character.
   The position of the beginning of the Nth line within the
   string STR is returned in POS.
   The function also returns all of the locations of the
   end of line marks EOL_MARKS.
 
   If the last character of STR is not an end-of-line, then the function
   adds an end-of-line character to the end of the string (and this is returned
   in EOL_MARKS).
 
   The behavior of the function can be altered by adding
   name/value pairs:
   Name (default value):          | Description
   -----------------------------------------------------------------------
   eol (sprintf('\n'))            | End of line character, could also use '\r'
   eol_marks ([])                 | If it is non-empty, then the program
                                  |   skips the search for eol_marks and
                                  |   uses the provided variable. This is useful
                                  |   if the user is going to call vlt.string.line_n
                                  |   many times; one can save the search time
                                  |   in subsequent calls.   
 
   Example:
      str = sprintf('This is a test.\nThis is line two.\nThis is line 3.')
      vlt.string.line_n(str,1)
      vlt.string.line_n(str,2)
      vlt.string.line_n(str,3)

```
