# vlt.file.fullfilename

  FULLFILENAME - return the full path file name of a file
 
  FULLNAME = vlt.file.fullfilename(FILENAME, [USEWHICH])
 
  Given either a full file name (with path) or just a filename
  (without path), returns the full path filename FULLNAME.
 
  If FILENAME does not exist in the present working directory,
  but is on the Matlab path, it is located using WHICH, unless
  the user passes USEWHICH=0.
 
  See also: FILEPARTS, WHICH
 
  Example:
    vlt.file.fullfilename('myfile.txt')  % returns [pwd filesep 'myfile.txt']
    vlt.file.fullfilename('/Users/me/myfile.txt') % returns ['/Users/me/myfile.txt']
