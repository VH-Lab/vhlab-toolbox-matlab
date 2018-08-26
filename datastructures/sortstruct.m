function [S_sorted, indexes] = sortstruct(S, varargin)
% SORTSTRUCT - sort structure by fieldname values
% 
% [S_sorted, indexes] = SORTSTRUCT(S, 'sign_fieldname1', 'sign_fieldname2', ...)
%
% Sorts the structure S according to the values in successive fieldnames.
%
% Given a structure S, S_sorted is the sorted version according to the values
% in fieldname1, fieldname2, etc. 
%
% sign should either be +1 or -1 depending upon if the data are to be sorted in
% ascending or descending order.
%
%
% Example: 
%    s = struct('test1',[1],'test2',5);
%    s(2) = struct('test1',[1],'test2',4); 
%
%   [S_sorted,indexes] = sortstruct(s,'+test1','+test2');
%    % indexes == [2;1] and S_sorted = s([2;1])


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

