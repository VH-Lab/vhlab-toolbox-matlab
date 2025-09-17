function s = celltable2struct(c)
% VLT.DATA.CELLTABLE2STRUCT - Convert a cell array table to a structure array
%
%   S = vlt.data.celltable2struct(C)
%
%   Converts a table stored in a cell array C to a structure array S.
%   The first row of C is assumed to contain the field names for the structure.
%   If any of these names are not valid Matlab variable names, they are
%   converted using matlab.lang.makeValidName.
%
%   If subsequent rows of C have fewer entries than the header row, the
%   corresponding fields in the structure will be empty.
%
%   Example:
%       C = { {'header1', 'header2'}, {'data1', 10}, {'data2', 20} };
%       S = vlt.data.celltable2struct(C);
%       % S will be a 1x2 struct with fields 'header1' and 'header2'.
%       % S(1).header1 will be 'data1', S(1).header2 will be 10.
%       % S(2).header1 will be 'data2', S(2).header2 will be 20.
%
%   See also: STRUCT2CELL, TABLE, matlab.lang.makeValidName
%

fn = matlab.lang.makeValidName(c{1});

s = vlt.data.emptystruct(fn{:});

for i=2:numel(c),
	news = vlt.data.emptystruct(fn{:});
	for j=1:numel(fn),
		if j<=numel(c{i}),
			eval(['news(1).' fn{j} '=c{i}{j};']);
		else,
			eval(['news(1).' fn{j} '=[];']);
		end
	end
	s(end+1) = news;
end

