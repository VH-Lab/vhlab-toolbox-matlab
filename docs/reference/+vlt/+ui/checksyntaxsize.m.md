# vlt.ui.checksyntaxsize

```
   vlt.ui.checksyntaxsize - Checks syntax and size of uitools string arguments
 
   [B,VALS] = vlt.ui.checksyntaxsize(THEFIG,TAGLIST,SIZELIST,[ERRORMSG, VARNAMELIST])
 
   Examines strings of user interface tools in figure THEFIG.  TAGLIST is
   a cell list of 'Tag' fields to look at, and SIZELIST is a cell list
   of the expected sizes for the arguments (leave an element empty to
   skip the examination for that field).  If a syntax error is found,
   B is 0 and VALS is an empty cell.  Otherwise, the values resulting from
   evaluating each string is returned in the cell list VALS.
 
   Optionally, an error dialog is presented to the user describing the syntax
   or size error (if ERRORMSG is provided and is 1), and the field is
   referenced in this message either by its tag or by the corresponding entry
   in VARNAMELIST if it is provided.

```
