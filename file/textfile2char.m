function str = textfile2char(filename)
% TEXTFILE2CHAR - Read a text file into a character string
%
%  STR = TEXTFILE2CHAR(FILENAME)
%
%  This function reads the entire contents of the file FILENAME into
%  the character string STR.  
%

fid = fopen(filename,'rt');
if fid>0,
	str = char(fread(fid,Inf))';
	fclose(fid);
else,
	error(['Could not open text file named ' filename '.']);
end;
