# vlt.data.struct2mlstr

  STRUCT2MLSTR - Create a text string to fully characterize a structure
 
   STR = vlt.data.struct2mlstr(THESTRUCT)
 
   Produces a string representation of a structure that can be passed to
   an external program to fully encapsulate the structure.  Character strings
   are written directly, integers are written using MAT2STR, 
   numbers are written using MAT2STR, cells are written using vlt.data.cell2mlstr.
   Any other objects are written using the function DISP.
 
   The structure is written in the following way:
   <STRUCT size=[X Y Z ...] fields={ 'fieldname1','fieldname2',...} data=
        <<value1><value2>...<valuen>>
        <<value1><value2>...<valuen>>
   /STRUCT>
 
   where X,Y,Z are the dimension of the structure array
   fieldname1, fieldname2, etc. are the fieldnames of the structure, and
   data contains the data for each struct entry, inside < and >.  Within each data,
   values for each field separated with < and > characters.
   /STRUCT ends the structure.
 
   Newline characters are produced after 'data=' and after each variable entry
   ('\n').
 
   The default parameters may be overridden by passing NAME/VALUE
   pairs as additional arguments, as in:
 
    STR = vlt.data.struct2mlstr(THESTRUCT, 'NAME1', VALUE1,...)
 
   Parameters:             | Description
   ---------------------------------------------------------------
   precision               | Precision we should use for mat2str (default 15)
                           |    (this is the number of digits we should use)
   varname                 | Variable name, entered before data= line as name=
   indent                  | Indentation (default 0)
   indentshift             | How much to indent sub-structures (default 5)
 
 
   Consider also: JSONENCODE, JSONDECODE
 
   See also: vlt.data.mlstr2var, vlt.data.cell2mlstr, vlt.data.struct2str, JSONENCODE
