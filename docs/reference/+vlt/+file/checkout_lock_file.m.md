# vlt.file.checkout_lock_file

```
  CHECKOUT_LOCK_FILE Try to establish control of a lock file
 
   [FID,KEY] = vlt.file.checkout_lock_file(FILENAME)
 
   This function tries to check out the file FILENAME so that different
   programs do not perform some operation at the same time. This is a quick
   and dirty semaphore implementation (see Wikipedia if unfamilar with 
   semaphores). The LOCKFILE will also EXPIRE in 1 hour unless otherwise specified
   below. A KEY is returned, which is necessary to pass to to vlt.file.release_lock_file.
 
   This function tries to create an empty file called FILENAME. If the file is
   NOT already present and the creation successful, the
   file will be created and FID will return the file ID (see help fopen).
 
   If instead the file already exists, the function will check
   every 1 second for 30 iterations to see if the file disappears.
   If the function is never able to create a new file because the 
   old file exists, then the function will give up and return FID < 0.
 
   
 
   IMPORTANT: RESPONSIBLE CLEANUP: It is important that if the program that
   calls vlt.file.checkout_lock_file is able to create the file (that is, FID>0),
   then it should call vlt.file.release_lock_file to remove the lock file.
   
   IMPORANT: FILE CLOSURE: If 2 output arguments are given (that is, KEY is
   examined), then the lock file is closed before vlt.file.checkout_lock_file exits.
   If KEY is not requested in output, then the FID is left open for 
   backwards compatibility.
 
   Depricated release instructions (new code should not use): 
   1) close the file with fclose(FID) and 2) delete the file
   FILENAME that is created with delete(FILENAME).  If FID<0, then
   it should NOT delete the file FILENAME because it is checked out by
   some other program.
 
   The function can be called with additional output arguments:
   
   [FID,KEY] = vlt.file.checkout_lock_file(FILENAME, CHECKLOOPS)
 
   Alters the number of times the function will check (at 1 second
   intervals) to see if FILENAME has disappeared.
 
   [FID,KEY] = vlt.file.checkout_lock_file(FILENAME, CHECKLOOPS, THROWERROR)
 
   If THROWERROR is 1, the function will return an error instead of
   returning FID<0.
 
   [FID,KEY] = vlt.file.checkout_lock_file(FILENAME, CHECKLOOPS, THROWERROR, EXPIRATION_SECONDS)
 
   This mode allows one to specifically set the expiration time in seconds.
   vlt.file.checkout_lock_file will examine the file for the expiration time and 
   ignore and remove the lock file if it is "expired". By default, EXPIRATION_SECONDS
   is 3600.
 
   Example:
      % I want to make sure only my program writes to myfile.txt.
      % All of my programs that write to myfile.txt will "check out" the 
      % file by creating myfile.txt-lock.
      mylockfile = [userpath filesep 'myfile.txt-lock'];
      [lockfid,key] = vlt.file.checkout_lock_file(mylockfile);
      if lockfid>0,
         % do something
         vlt.file.release_lock_file(mylockfile,key);
      else,
         error(['Never got control of ' mylockfile '; it was busy.']);
      end;
    
 
   See also: vlt.file.release_lock_file, FOPEN, DELETE

```
