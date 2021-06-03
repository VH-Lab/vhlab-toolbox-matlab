# vlt.file.vcard2mat

```
  VCARD2STRUCT - read information from Vcard text file, return as Matlab struct
 
  V = VCARD2STRUCT(VCARDFILE)
 
  Reads entries from a VCARD text file.
 
  VCARDFILE can be a text filename or a FILEOBJ object.
 
  Entries that take more than one line (like embedded photos) are currently skipped.
 
  The file will be closed at the conclusion of reading it.
 
  developer note: assumes parameter names are 'type', should read it
  need to look ahead to next line

```
