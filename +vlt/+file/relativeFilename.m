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
% Example:
%    abs_path = '/Users/myusername/Documents/';
%    abs_filename = '/Users/myusername/Documents/myfolder/myfile.txt'
%    relFname = vlt.file.relativeFilename(abs_path, abs_filename)
%    % relFname == myfolder/myfile.txt'
% 

if nargin<3,
	file_separator = filesep;
end;

abs_path = vlt.file.tidypathstring(abs_path, file_separator);
abs_path(end+1) = file_separator;
abs_filename = vlt.file.tidypathstring(abs_filename, file_separator);

f = findstr(abs_filename,abs_path);

if ~isempty(f),
	relFname = abs_filename(f(1)+numel(abs_path):end);
else,
	error(['Could find no relative path for ' abs_filename ' at path ' abs_path '.']);
end;
