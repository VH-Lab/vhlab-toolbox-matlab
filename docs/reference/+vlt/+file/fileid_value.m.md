# vlt.file.fileid_value

 FILEID_VALUE - return the value of an FID whether it is an FID or inside a FILEOBJ
 
  FID = vlt.file.fileid_value(FID_OR_FILEOBJ)
 
  Given a value which may be a FID or a vlt.file.fileobj object, return either the FID or
  the FID field of the vlt.file.fileobj object.
 
  Allows one to test 'if vlt.file.fileid_value(f)<0' without knowing if f is a Matlab file identifier
  or a vlt.file.fileobj.
