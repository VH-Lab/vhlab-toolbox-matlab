# vlt.data.cell2mlstr

```
  CELL2MLSTR - Create a text string to fully characterize a cellure
 
   STR = vlt.data.cell2mlstr(THECELL)
 
   Produces a string representation of a cellure that can be passed to
   an external program to fully encapsulate the cellure.  Character strings
   are written directly, integers are written using MAT2STR, 
   numbers are written using MAT2STR, cells are written using vlt.data.cell2mlstr.
   Any other objects are written using the function DISP.
 
   The cellure is written in the following way:
   <CELL size=[X Y Z ...] data=
        <value1>
        <value2>
   /CELL>
 
   where X,Y,Z are the dimension of the cellure array, and
   data contains the data for each cell entry, inside < and >.  Within each data,
   values for each field separated with < and > characters.
   /CELL ends the cellure.
 
   Newline characters are produced after 'data=' and after each variable entry
   ('\n').
 
   The default parameters may be overridden by passing NAME/VALUE
   pairs as additional arguments, as in:
 
    STR = vlt.data.cell2str(THECELL, 'NAME1', VALUE1,...)
 
 
   Parameters:             | Description
   ---------------------------------------------------------------
   precision               | Precision we should use for mat2str (default 15)
                           |    (this is the number of digits we should use)
   varname                 | Variable name, entered before data= line as name=
   indent                  | Indentation (default 0)
   indentshift             | How much to indent sub-cellures (default 5)
                       
   Example:
       A = {'test', 5, [3 4 5]}
       vlt.data.cell2mlstr(A)

```
