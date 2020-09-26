function minfo = mfileinfo(filename)
% MFILEINFO - return a structure with information about an m-file
%
% MINFO = MFILEINFO(FILENAME)
%
% Returns a structure with information about FILENAME with the following fields:
% Field                 | Description
% --------------------------------------------------------------------
% fullfile              | File name with full path and extension
% path                  | Full path to the file
% name                  | File name without path and without extension
% isfunction            | 0/1 is it a function?
% isclass               | 0/1 is it a classdefinition?
% 
%
% See also: vlt.matlab.isclassfile(), vlt.matlab.isfunctionfile()
%
% Example:
%   minfo = vlt.matlab.mfileinfo('table.m');

if ~exist(filename),
	error([filename ' not found.']);
end;

minfo.fullfile = vlt.file.fullfilename(filename);
[p,name] = fileparts(minfo.fullfile);

minfo.path = p;
minfo.name = name;

minfo.isfunction = vlt.matlab.isfunctionfile(minfo.fullfile);
minfo.isclass = vlt.matlab.isclassfile(minfo.fullfile);


