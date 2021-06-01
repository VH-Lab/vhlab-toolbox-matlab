# vlt.data.islikevarname

  ISLIKEVARNAME - Is a string like a Matlab variable name (begin with letter)?
 
   [B, ERRORMSG] = vlt.data.islikevarname(NAME)
 
   Checks to see if NAME is a like a valid Matlab variable name. It must
      a) begin with a letter
      b) not have any whitespace
      
   Unlike real Matlab variables, NAME may be a Matlab keyword.
    
   B is 1 if NAME meets the criteria and is 0 otherwise.
   ERRORMSG is a text message describing the problem.
 
   See also: ISVARNAME, vlt.data.valid_varname
