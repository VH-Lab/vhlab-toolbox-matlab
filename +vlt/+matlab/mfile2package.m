function pname = mfile2package(mfilename)
% MFILE2PACKAGE - return the package name (if any) from a full path mfile name
%
% PNAME = MFILE2PACKAGE(MFILENAME)
%
% Returns the package name of the m file named by MFILENAME, which must be 
% specified as a full path.
%
% Example: 
%   pname = vlt.matlab.mfile2package('/Users/me/Documents/+mypackage/myf.m');
%   % pname = 'mypackage.myf'

 % drop the extension
[fullpath,pname,ext] = fileparts(mfilename);
mfilename = [fullpath filesep pname];

pluses = find(mfilename=='+');

if isempty(pluses),
	return;
end;

pname = mfilename(pluses(1)+1:end);
pname = strrep(pname,[filesep '+'],'.');

% remove last filesep

fsep = find(pname==filesep);

pname(fsep(end))='.';
