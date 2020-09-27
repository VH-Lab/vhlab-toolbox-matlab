function p = getpathname(cksds)

%  P = GETPATHNAME(THEDIRSTRUCT)
%
%  Returns the pathname associated with THEDIRSTRUCT.

p = vlt.file.fixpath(vlt.file.fixtilde(cksds.pathname));
