function fn = fixtilde(filename)

%  FIXTILDE - Removes ~ from filenames and replaces with user home directory
%
%  NEWNAME = FIXTILDE(FILENAME)
%
%  Removes '~' symbol for a user's home directory in unix and replaces it
%  with the actual path.
%
%  e.g.  FIXTILDE('~/myfile') returns '/home/username/myfile'
%
%  If the tilde is not the leading character then no changes are made.
%

fn = filename;
if strcmp(fn(1),'~'),
	if ispc
		homedir = getenv('USERPROFILE');
	else
		homedir = getenv('HOME');
	end
	fn = [homedir fn(2:end)];
end;
