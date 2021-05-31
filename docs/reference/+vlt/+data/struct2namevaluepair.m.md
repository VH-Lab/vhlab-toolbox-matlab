# vlt.data.struct2namevaluepair

  STRUCT2NAMEVALUEPAIR - Convert a structure to a cell array of name/value pairs
 
   NV = vlt.data.struct2namevaluepair(THESTRUCT)
 
   Convert a structure to a cell array of name/value pairs. This is useful for
   passing name/value pairs to functions that accept them as extra arguments.
   Each field name of the structure is used as the 'name', and the value is
   used as the 'value'.
 
   Example:
 
      myStruct.param1 = 1;
      myStruct.param2 = 2;
      nv = vlt.data.struct2namevaluepair(myStruct)
         % nv = {'param1', 1, 'param2', 2}
 
 
   See also: VARARGIN, vlt.data.assign, STRUCT
