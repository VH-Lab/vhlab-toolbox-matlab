function pathn = fixpath(pathstr)
%   PATHN = FIXPATH (PATHSTR)
%
%   Checks the string PATHSTR to see if it ends in FILESEP ('/' on the Unix
%   platform, ':' on Macintosh OS9, '\' on Windows).  PATHN is simply PATHSTR with a FILESEP 
%   attached at the end if necessary.
%
%   See also: FILESEP

pathn = pathstr;

if pathn(end)~=filesep,
	pathn=[pathn filesep];
end;

