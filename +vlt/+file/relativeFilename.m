function relFname = relativeFilename(abs_path, abs_filename, file_separator)
% Find a relative file path relative to an absolute path
%
% RELFNAME = RELATIVEFILENAME(ABS_PATH, ABS_FILENAME [, FILE_SEPARATOR])
%
% Return the relative path of an filename ABS_FILENAME relative
% to a path (ABS_PATH).
%
% ABS_FILENAME should be a full path file name, and ABS_PATH should
% be a full path directory.
% 
% If FILE_SEPARATOR isn't specified, it is taken to be FILESEP,
% the file separator on the platform currently running Matlab.
%
% Examples:
%    abs_path = '/Users/myusername/Documents/';
%    abs_filename = '/Users/myusername/Documents/myfolder/myfile.txt'
%    relFname = vlt.file.relativeFilename(abs_path, abs_filename)
%    % relFname = 'myfolder/myfile.txt'
%    abs_path = '/Users/myusername/Documents/';
%    abs_filename = '/Users/myusername/myfolder/myfile.txt'
%    relFname = vlt.file.relativeFilename(abs_path, abs_filename)
%    % relFname = '../myfolder/myfile.txt'
% 

if nargin<3,
	file_separator = filesep;
end;

if vlt.file.isurl(abs_filename),
	error(['Does not work with URLs. URLs are absolute paths.']);
end;

abs_path = vlt.file.tidypathstring(abs_path, file_separator);
abs_path(end+1) = file_separator;
abs_filename = vlt.file.tidypathstring(abs_filename, file_separator);

index_difference = [];
for i=1:numel(abs_path),
	if abs_path(i)~=abs_filename(i),
		index_difference = i
		break;
	end;
end;

if isempty(index_difference), % then we just take what is left
	relFname = abs_filename(numel(abs_path)+1:end);
else,
	% paths diverged earlier
	num_dots = numel(find(file_separator==abs_path(index_difference:end)));
	relFname = [repmat(['..' file_separator],1,num_dots) abs_filename(index_difference:end)];
end;


