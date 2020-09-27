function [b,d] = filediff(file1, file2)
% FILEDIFF - return the output of the system tool 'diff'
%
% [B,D] = vlt.file.filediff(FILE1,FILE2)
%
% Returns the output of the system tool ['diff file1 file2]', if 'diff' exists.
% B is 0 if the files do not differ, and 1 if they do differ.
% The output of the function (the text notes of the differences) are returned in D.
%
%

[status,r] = system('diff');

if status > 100,
	error(['No diff tool found: ' r]);
end;

[status, d] = system(['diff ' file1 ' ' file2]);

b = numel(d)==0;
