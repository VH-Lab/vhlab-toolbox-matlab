function backupname = filebackup(fname,varargin)
% FILEBACKUP - Create a backup of a file
%
%  BACKUPNAME = FILEBACKUP(FNAME)
%
%  Creates a backup file of the file named FNAME (full path). The
%  new file is named [FNAME '_bkupNNN' EXT], where NNN is a number.
%  The number NNN is chosen such that no file has that name (for example,
%  if there is a file 001, then the new file created is 002, etc).
%
%  The name of the backup file is BACKUPNAME.
%
%  The behavior of the function can be modified with extra name/value pairs:
%  PARAMETER NAME (default)  |  DESCRIPTION
%  -----------------------------------------------------------------
%  DeleteOrig (0)            |  Delete the original file?
%  Digits (3)                |  Number of digits to use
%  ErrorIfDigitsExceeded (1) |  Produce an error if the number of digits
%                            |    is exceeded. (If no error is produced, then
%                            |    no backup is made.)
%
%  Example:  
%     fname = 'C:\Users\me\mytest.txt';
%     backupname=filebackup(fname); % will be 'C:\Users\me\mytest_bkup001.txt'
%

DeleteOrig = 0;
Digits = 3;
ErrorIfDigitsExceeded = 1;

assign(varargin{:});

if ~exist(fname,'file'),
	error(['No file ' fname ' to backup.']);
end;

[pathstr,name,ext] = fileparts(fname);

maxdigit = power(10,Digits) - 1;

foundit = 0;

for i=1:maxdigit,
	backupname = [pathstr filesep name '_bkup' ...
		sprintf(['%.' int2str(Digits) 'd'],i) ext];
	if ~exist(backupname,'file'),
		foundit = i;
		break;
	end;
end;

if foundit>0,
	success=copyfile(fname,backupname);
	if success==0,
		error(['Could not copy from ' fname ' to ' backupname ...
			'. Check permissions?']);
	end;
	if DeleteOrig,
		delete(fname);
	end;
else,
	backupname = '';
	if ErrorIfDigitsExceeded,
		error(['Could not create backup file with ' ...
			int2str(Digits) ' digits for file ' ...
			fname '.']);
	end;
end;

