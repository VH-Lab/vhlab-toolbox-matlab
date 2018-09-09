function s = celltable2struct(c)
% CELLTABLE2STRUCT - convert a table stored in a CELL datatype to a structure
%
% S = CELLTABLE2STRUCT(C)
%
% Converts a table stored in the cell matrix C to a structure.
% It is assumed that the first row of C (C{1}) has structure labels.
% If any of these labels are not valid Matlab variables, then 
% they are converted to be.
% If rows of C{j} (j>1) have fewer entries than the header row,
% then all subsequent fields in the structure will have empty ([])
% values.
%
% Example:
%    %Read a tab-seperated-value file with truncated entries (that is,
%    %where each line ends prematurely if later fields are empty):
%    o = read_tab_delimited_file(filename);
%    s = celltable2struct(o);
%

fn = matlab.lang.makeValidName(c{1});

s = emptystruct(fn{:});

for i=2:numel(c),
	news = emptystruct(fn{:});
	for j=1:numel(fn),
		if j<=numel(c{i}),
			eval(['news(1).' fn{j} '=c{i}{j};']);
		else,
			eval(['news(1).' fn{j} '=[];']);
		end
	end
	s(end+1) = news;
end

