# vlt.data.namevaluepair

```
  NAMEVALUEPAIR - Describes the use of name/value pairs in Matlab functions
 
  In Matlab, functions often accept extra arguments in the form of 
  NAME/VALUE pairs. For example, a function fun might accept two input
  arguments, and extra name/value pairs that alter the default behavior of the
  function.
 
  out = fun(a,b); % normal behavior
  out = fun(a,b,'gain',5) % set a parameter gain to 5
  out = fun(a,b,'gain',5,'offset',3) % set additional parameters
  
  This capability is only available in functions that are built to
  accept name/value pairs (it is not automatically available in any function).
 
  See also: vlt.data.struct2namevaluepair, VARARGIN, vlt.data.assign

```
