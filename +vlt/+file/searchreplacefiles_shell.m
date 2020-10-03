function searchreplacefiles_shell(dirsearch, findstring, replacestring)
% SEARCHREPLACEFILES_SHELL - search and replace text in all files in a directory search
%
%  vlt.file.searchreplacefiles_shell(DIRSEARCH, FINDSTRING, REPLACESTRING)
%
%  Searches all of the files in the string DIRSEARCH (examples: '*.m', 
%  or '*/*.m') for occurrances of the string FINDSTRING and replaces those
%  strings with REPLACESTRING.
%
%  At present, this requires unix (it calls the shell commands 'find' and 'sed').
%
%  The function prints its shell command before attempting to run.
%  


command_string = ['LC_ALL=C find . -type f -name ''' dirsearch ...
	''' -exec  sed -i '''' s/' findstring '/' replacestring '/g {} +']

if isunix,
	system(command_string);
else,
	error(['This function is only compatibile with unix at this time.']);
end;

