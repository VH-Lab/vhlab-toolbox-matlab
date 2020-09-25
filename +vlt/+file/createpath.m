function [b,errormsg] = createpath(filename)
% CREATEPATH - create a directory path to a given file name, if necessary
%
% [B,ERRORMSG] = CREATEPATH(FILENAME)
%
% This function creates all directories that are necessary to
% store the file FILENAME, if they don't already exist. If
% the directories already exist, no action is taken.
%
% If the function succeeds, B is 1 and ERRORMSG is empty.
% Otherwise, B is 0 and ERRORMSG contains the error.
%

b = 1;
errormsg = '';

fullname = vlt.file.fullfilename(filename);

[p] = fileparts(fullname);

if ~exist(p,'dir'),
	try,
	        mkdir(p);
	catch,
		b = 0;
		errormsg = lasterr;
	end;
end;

