# vlt.file.fixtilde

   vlt.file.fixtilde - Removes ~ from filenames and replaces with user home directory
 
   NEWNAME = vlt.file.fixtilde(FILENAME)
 
   Removes '~' symbol for a user's home directory in unix and replaces it
   with the actual path.
 
   e.g.  vlt.file.fixtilde('~/myfile') returns '/home/username/myfile'
 
   If the tilde is not the leading character then no changes are made.
