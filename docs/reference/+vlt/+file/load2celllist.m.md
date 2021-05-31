# vlt.file.load2celllist

  vlt.file.load2celllist - Loads saved objects to a cell list
 
   [OBJS,OBJNAMES] = vlt.file.load2celllist(FILENAME, ...)
 
   Loads objects from a Matlab file FILENAME into a cell list.
   Additional arguments are passed on to the Matlab LOAD command.
 
   OBJS is a cell list of all variables matching the loading
   criteria
 
   Example:
       [myobjs,mynames]=vlt.file.load2celllist('myfile','cell*','-mat');
   
       If the file 'myfile' contains two variables named 'cell1'
       and 'cell2', then
        mynames = {'cell1' 'cell2'} and
        myobjs = { (data of 'cell1')  (data of 'cell2') }
 
   See also:  LOAD, READCELLSFROMEXPERIMENTLIST
