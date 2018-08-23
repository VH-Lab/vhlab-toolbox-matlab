function out = readtabdelimitedfile(fname)

% READTABDELIMITEDFILE - Reads data from a tab-delimited file; tries to sort string/number data
%
%
%   OUTPUT = READTABDELIMTEDFILE(FILENAME)
%
%   Reads data from a tab-delimited text file.  OUTPUT is a cell list.  OUTPUT{i,j} is
%   the value from the ith row and jth column in the tab-delimited file; note that the
%   rows and columns need not have the same number of entries.
%
%   This function also tries to assign each value a number using the function STR2NUM.
%   If this process fails, then the value is assumed to be a text string and is stored as such.
%

fid = fopen(fname,'rt');

if fid<0, error(['Error opening file ' fname '.']); end;

out = {};

mynextline = 0; 
linenumber = 1; 
while mynextline~=-1, % this will be -1 if fgetl can't read anything else
	mynextline = fgetl(fid);
	myseparator = strfind(mynextline, sprintf('\t') ); % finds all locations of the tab character
	if ~isempty(myseparator),  % if we find an instance of the separator on this line, it is valid
		out{linenumber} = {};
		myseparator = [1 myseparator length(mynextline)]; % pretend the first character and last character are separators
		for j=2:length(myseparator), % read all the info between the separators
			value = mynextline(myseparator(j-1):myseparator(j));
			value_number = str2num(value);
			if isempty(value_number),
				out{linenumber}{j-1} = value;
			else,
				out{linenumber}{j-1} = value_number;
			end;
		end;
	end;
	linenumber = linenumber + 1;
end
fclose(fid);
