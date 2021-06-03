# vlt.file.filebackup

```
  FILEBACKUP - Create a backup of a file
 
   BACKUPNAME = vlt.file.filebackup(FNAME)
 
   Creates a backup file of the file named FNAME (full path). The
   new file is named [FNAME '_bkupNNN' EXT], where NNN is a number.
   The number NNN is chosen such that no file has that name (for example,
   if there is a file 001, then the new file created is 002, etc).
 
   The name of the backup file is BACKUPNAME.
 
   The behavior of the function can be modified with extra name/value pairs:
   PARAMETER NAME (default)  |  DESCRIPTION
   -----------------------------------------------------------------
   DeleteOrig (0)            |  Delete the original file?
   Digits (3)                |  Number of digits to use
   ErrorIfDigitsExceeded (1) |  Produce an error if the number of digits
                             |    is exceeded. (If no error is produced, then
                             |    no backup is made.)
 
   Example:  
      fname = 'C:\Users\me\mytest.txt';
      backupname=vlt.file.filebackup(fname); % will be 'C:\Users\me\mytest_bkup001.txt'

```
