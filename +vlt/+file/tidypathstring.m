function p_string_out = tidypathstring(p_string, file_separator)
% TIDYPATHSTRING - clean up a path string, removing any double file separators
%
% P_STRING_OUT = TIDYPATHSTRING(P_STRING [, FILE_SEPARATOR])
%
% Removes any double file separators. By default, the local machine
% architecture's FILESEP is used, but the user can pass a different
% FILE_SEPARATOR if desired. Any trailing file separator is also
% removed.
% 
% If the string '://' is found, no text before or including this
% string will be edited.
%
% If the file separator is '\', then a leading '\\' is also not
% edited (it is assumed that a Windows fileshare is intended).
%
% Example:
%    p_string = '/Users/Documents//my_data/';
%    p_string_out = vlt.file.tidypathstring(p_string,'/')
%       % p_string_out = '/Users/Documents/my_data'
%


if nargin<2,
	file_separator = filesep;
end;

protection = zeros(size(p_string));

if strcmp(file_separator,'/'),
	pat1 = '://{1,2}';
	[o,e] = regexp(p_string,pat1,'forceCellOutput');
	if ~isempty(o{1}),
		protection(o{1}(1):e{1}(1)) = 1;
	end;
	pat = '//+';
elseif strcmp(file_separator,'\'),
	pat = '(?!(^\\\\))\\\\+';
else,
	path = [file_separator file_separator '+'];
end;

[o,e] = regexp(p_string,pat,'forceCellOutput');

to_delete = [];

for i=1:numel(o{1}),
	to_delete = cat(1,to_delete, [o{1}(i)+1:e{1}(i)]' );
end;

to_delete = setdiff(to_delete,find(protection));

p_string_out = p_string;

p_string_out(to_delete)='';

if strcmp(p_string_out(end),file_separator),
	p_string_out(end) = '';
end;

