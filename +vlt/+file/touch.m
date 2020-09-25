function touch(filename)
% TOUCH - create a file (empty) if it does not already exist
%
% TOUCH(FILENAME)
%
% This function checks to see if FILENAME exists. If it does not
% exist, it creates a blank file and creates all necessary
% directories that may be required.
%
% If the file does not exist and cannot be created, an error is
% generated.
%

if exist(filename,'file'), % if it's there, we are done
	return;
end;

fullname = vlt.file.fullfilename(filename);

[b,errormsg] = vlt.file.createpath(fullname);

if b,
	error(errormsg);
end;

 % now we need to make the blank file

fid = fopen(fullname,'w+t');

if fid<0,
	error(['Could not open file ' fullname '.']);
end;

fclose(fid);

