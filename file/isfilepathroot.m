function b = isfilepathroot(filepath)
% ISFILEPATHATROOT - determine if a file path is at the root or not
%
% B = ISFILEPATHROOT(FILEPATH)
%
% Determines if a FILEPATH is at the root of a drive or not.
% For computers for which ISPC is true, ISFILEPATHROOT is true
% if the FILEPATH begins with either '/' or '$:\'.
% For computers for which ISUNIX is true, ISFILEPATHROOT is true
% if the FILEPATH is '/'.
%
% Note that the file path does not have to exist to specify a valid
% file path. It is just whether it has the structure of a full file path.
%
% See also: ISPC, ISUNIX
%
% Examples:
%    % on unix
%    isfilepathroot('/Volumes/test/mytestfile.txt') % true
%    isfilepathroot('myfile.txt') % false
%
%    % on Windows
%    isfilepathroot('C:\myfolder\test') is true
%    isfilepathroot('/C/myfolder/test') is true
%

b = 0;

if ispc,
	b1 = ~isempty(strfind(filepath,':\'));
	b2 = filepath(1)=='/'; % unix file separator is valid on Windows
	b = b1 | b2;
elseif isunix,
	b = filepath(1)=='/';
else,
	error(['Not PC and not UNIX. Do not know how to proceed.']); 
end;


