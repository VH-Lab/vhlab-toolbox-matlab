function combinepdf(mergefile, file1, varargin)
% COMBINEPDF - Merge PDF (portable document format) files on Mac OS X
%
%  COMBINEPDF(MERGEFILENAME, FILE1, FILE2, ...)
%
%  On Mac OS X, this function calls the command line tool
%  /System/Library/Automator/Combine PDF Pages.action/Contents/Resources/join.py
%  to merge PDF files.
%  
%  INPUTS: MERGEFILENAME is the name of the merged file. If it exists,
%  it will be deleted. The filenames to be merged (FILE1, FILE2, ...) are
%  passed as additional arguments. The filenames should either be in full
%  path format or should be in the local directory.
%  
%  This function will fail on platforms other than Mac OS X.
%

if ~ismac | ~isunix,
	error(['This function only works on Mac OS X machines.']);
end;

commandstr = ['/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py -o ' mergefile ' ' file1 ' '];

for i=1:length(varargin),
	commandstr = cat(2,commandstr,[' ' varargin{i} ' ']);
end;

system(commandstr);
