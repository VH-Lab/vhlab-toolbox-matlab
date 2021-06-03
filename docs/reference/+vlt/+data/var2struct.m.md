# vlt.data.var2struct

```
  VAR2STRUCT - Export variable(s) to a structure
 
   OUTPUT = vlt.data.var2struct('NAME1', 'NAME2', ...)
 
   Saves local workspace variables as a structure.
   
   Each variable is added a field to the structure OUTPUT.
 
   Example:
      Imagine your workspace has 3 variables, A=5, B=6, C=7;
     
      output = vlt.data.var2struct('a','b')
 
        produces
 
      output = 
         a: 5
         b: 6

```
