function c = text2cellnum(filename)
% TEXT2CELLNUM - Read each row of a text file as numeric data to produce array of cells
%
%  C = vlt.file.text2cellnum(FILENAME)
%
%  Reads a text file and imports each line as a numeric matrix entry 
%  in a cell array.
%  
%  See also: FGETL, vlt.file.text2cellstr, STR2NUM


c = vlt.file.text2cellstr(filename);

for i=1:length(c),
	c{i} = str2num(c{i});
end;

