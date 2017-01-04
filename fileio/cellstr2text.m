function cellstr2text(filename, cs)
% CELLSTR2TEXT - Write a cell string to a text file
%
%   CELLSTR2TEXT(FILENAME, CS)
%
%  Writes the cell array of strings CS to the new text file FILENAME.
%
%  One entry is written per line.
%

fid = fopen(filename,'wt');

if fid>=0,
	for i=1:numel(cs),
		fprintf(fid,[cs{i} '\n']);
	end;
	fclose(fid);
else,
	error(['Could not open ' filename ' for writing.']);
end;
