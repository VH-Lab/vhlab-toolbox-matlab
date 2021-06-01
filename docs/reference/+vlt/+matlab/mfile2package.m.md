# vlt.matlab.mfile2package

  MFILE2PACKAGE - return the package name (if any) from a full path mfile name
 
  PNAME = MFILE2PACKAGE(MFILENAME)
 
  Returns the package name of the m file named by MFILENAME, which must be 
  specified as a full path.
 
  Example: 
    pname = vlt.matlab.mfile2package('/Users/me/Documents/+mypackage/myf.m');
    % pname = 'mypackage.myf'
