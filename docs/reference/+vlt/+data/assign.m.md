# vlt.data.assign

```
  assign - make a list of assignments (matlab 5 or higher)
 
 	vlt.data.assign('VAR1', VAL1, 'VAR2', VAL2, ...) makes the assignments 
 	VAR1 = VAL1; VAR2 = VAL2; ... in the caller's workspace.
 
 	This is most useful when passing in an option list to a
 	function.  Thus in the function which starts:
 		function foo(x,y,varargin)
 		z = 0;
 		vlt.data.assign(varargin{:});
 	the variable z can be given a non-default value by calling the
 	function like so: foo(x,y,'z',4);
 
        If the input is a single structure, then the structure is converted
        to a set of NAME/VALUE pairs and interpreted as 'VAR1', VAL1, etc,
        where VAR1 is the first field name of the input, VAL1 is the value of the field name,
        etc.

```
