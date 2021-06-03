# vlt.file.release_lock_file

```
  RELEASE_LOCK_FILE - release a lock file with the key
 
  B = vlt.file.release_lock_file(FID_OR_FILENAME, KEY)
 
  Release a lock file given its FID or its FILENAME and the
  correct KEY that was issued by the function vlt.file.checkout_lock_file.
  Removes the file if the key matches.
 
  B is 1 if the lockfile is either not present or if it was removed
  successfully.
  
  B is 0 if the key does not match (and the file is not removed.)
 
  An error is triggered if the lock file does not have the expected contents
  (an expiration time and a key).
 
  See also: vlt.file.checkout_lock_file
  
  For an example, see vlt.file.checkout_lock_file

```
