function fullname = fullfilename(filename, usewhich)
% FULLFILENAME - return the full path file name of a file
%
% FULLNAME = FULLFILENAME(FILENAME, [USEWHICH])
%
% Given either a full file name (with path) or just a filename
% (without path), returns the full path filename FULLNAME.
%
% If FILENAME does not exist in the present working directory,
% but is on the Matlab path, it is located using WHICH, unless
% the user passes USEWHICH=0.
%
% See also: FILEPARTS, WHICH
%
% Example:
%   vlt.file.fullfilename('myfile.txt')  % returns [pwd filesep 'myfile.txt']
%   vlt.file.fullfilename('/Users/me/myfile.txt') % returns ['/Users/me/myfile.txt']
%

fullname = '';

if nargin<2,
	usewhich = 1;
end

[foldername,fname] = fileparts(filename);

if isempty(foldername),
	if usewhich, % try to find it somewhere
		fullname = which(filename);
	end

	if isempty(fullname), % we did not find it above, doesn't exist yet
		fullname = [pwd filesep filename]; 
	end
else, % we have a foldername
	if vlt.file.isfilepathroot(foldername), % then we already have full filename
		fullname = filename;
	else,
		fullname = [pwd filesep foldername filesep fname]; 
	end
end;


