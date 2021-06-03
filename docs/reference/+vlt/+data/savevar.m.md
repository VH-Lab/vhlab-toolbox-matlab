# vlt.data.savevar

```
  vlt.data.savevar - Saves variables in a Matlab file
 
   vlt.data.savevar(FILENAME,VARIABLE,VARIABLENAME,OPTIONSTRING1,OPTIONSTRING2,...)
 
   Saves the variable VARIABLE to the file FILENAME.  The name of 
   the variable in the file will be VARIABLENAME.  OPTIONS is a 
   string of options passed to the MATLAB SAVE command.
 
   For example:
 
     vlt.data.savevar('myfile',5,'myvariable','-append','-mat');
  
   See also: SAVE

```
