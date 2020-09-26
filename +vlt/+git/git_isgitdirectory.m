function b = git_isgitdirectory(dirname)
% GIT_ISGITDIRECTORY - is a given directory a GIT directory?
%
% B = GIT_ISGITDIRECTORY(DIRNAME)
%
% Examines whether DIRNAME is a GIT directory.
%

if git_assert,
	[status,results] = system(['git -C "' dirname '" status']);
	b = ((status==0) | (status==1)) & ~isempty(results);
else,
	error(['GIT not available on system.']);
end;


