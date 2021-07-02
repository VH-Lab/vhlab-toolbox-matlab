function cellstr = splitindex(str,indexes)
% SPLITINDEX - split a string at specific index values into a cell array of strings
%
% CELLSTR = vlt.string.splitindex(STR, INDEXES)
%
% Splits a string into a cell array of strings at the index values indicated in 
% INDEXES.
%
% See also: split, strsplit
%
% Example:
%       str = 'A,B,C';
%       indexes = find(str==',');
%       cellstr = vlt.string.splitindex(str,indexes) % {'A','B','C'}


cellstr = {};
for i=1:numel(indexes)+1,
	if i==1,
		start = 1;
	else,
		start = indexes(i-1)+1;
	end;
	if i==numel(indexes)+1,
		end_pos = numel(str);
	else,
		end_pos = indexes(i)-1;
	end;
	cellstr{end+1} = str(start:end_pos);
end;

