function [S_sorted, indexes] = sortstruct(S, varargin)
% VLT.DATA.SORTSTRUCT - Sort a structure array based on field values
%
%   [S_sorted, indexes] = vlt.data.sortstruct(S, 'sign_fieldname1', 'sign_fieldname2', ...)
%
%   Sorts a structure array S based on the values of one or more fields.
%
%   Inputs:
%   'S' is the structure array to be sorted.
%   'sign_fieldname' arguments are strings specifying the field to sort by
%     and the direction ('+' for ascending, '-' for descending).
%
%   Outputs:
%   'S_sorted' is the sorted structure array.
%   'indexes' are the indices that map the original structure to the sorted one.
%
%   Example:
%       s(1) = struct('a', 1, 'b', 10);
%       s(2) = struct('a', 2, 'b', 5);
%       s(3) = struct('a', 1, 'b', 20);
%       [S_sorted, indexes] = vlt.data.sortstruct(s, '+a', '-b');
%       % S_sorted will be s([3 1 2])
%
%   See also: SORTROWS, STRUCT, FIELDNAMES
%


 % parse inputs

if ~isstruct(S),
	error(['S must be a STRUCT.']);
end;

fn = fieldnames(S);

signs = [];
values_to_sort = [];

for i=1:numel(varargin),
	switch varargin{i}(1),
		case '+',
			signs(i) = 1;
		case '-',
			signs(i) = -1;
		otherwise,
			error(['Unknown sign symbol in input ' varargin{i} '.']);
	end;
	entry = find(strcmp(varargin{i}(2:end),fn));
	if numel(entry)~=1,
		error(['No match (or too many matches) for field name ' varargin{i}(2:end) '.']);
	end;
	value = getfield(S(1),fn{entry});
	if ischar(value),
		thestrings = eval(['{S.' fn{entry} '};']);
		[dummy,dummy,values]=unique(thestrings);
	else,
		values = eval(['[S.' fn{entry} '];']);
	end;
	values = values(:); % column
	values_to_sort = cat(2,values_to_sort,values);
end

%values_to_sort;

[Y,indexes] = sortrows(values_to_sort,signs.*[1:size(values_to_sort,2)]);

S_sorted = S(indexes);

