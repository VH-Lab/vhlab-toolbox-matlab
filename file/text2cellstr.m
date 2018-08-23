function c = text2cellstr(filename)
% TEXT2CELLSTR - Read a cell array of strings from a text file
%
%  C = TEXT2CELLSTR(FILENAME)
%
%  Reads a text file and imports each line as an entry 
%  in a cell array of strings.
%  
%  See also: FGETL

c = {};

fid = fopen(filename,'rt');

if fid<0,
	error(['Could not open file ' filename ' for reading.']);
end;

while ~feof(fid),
	c{end+1} = fgetl(fid);
end;
fclose(fid);

