function newfilestring = filesepconversion(filestring, orig_filesep, new_filesep)
% FILESEPCONVERSION - convert from one FILESEP platform to another
% 
% NEWFILESTRING = FILESEPCONVERSION(FILESTRING, ORIG_FILESEP, NEW_FILESEP)
%
% Converts a file string from one filepath convention to another.
%
% FILESTRING is a file path string like 'myfolder/myfile.txt'.
% ORIG_FILESEP is the original file separator, like '/'
% NEW_FILESEP is the new file separator, like '\'
%
% Right now this function just performs a substitution. It is unknown if they are
% situations with escape characters (because '\' is often used as an escape character)
% that will fail with this function.
%

newfilestring = filestring;

indexes = find(filestring==orig_filesep); % assumes orig_filesep is 1 character

newfilestring(indexes) = new_filesep;  % assumes new_filesep is 1 character

