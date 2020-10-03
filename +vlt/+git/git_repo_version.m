function [v,remote] = git_repo_version(filepath)
% GIT_REPO_VERSION - return commit number and remote location of repository
%
% [V, REMOTE] = vlt.git.git_repo_version(FILEPATH)
%
% Uses command line 'git' to query the commit verison number (V) and
% the path of the REMOTE repository. If either query fails, an error
% is returned.
%

v = [];
remote = [];

if ~vlt.git.git_assert(),
	error(['Could not locate git on this machine.']);
end;

[status,results] = system(['git -C "' filepath '" rev-parse HEAD']);

if status~=0,
	error(['Error getting git commit version number for path ' ...
		filepath '.']);
end;

v = strtrim(results);

[status,results]=system(['git -C "' filepath '" config --get remote.origin.url']);

if status~=0,
	error(['Error getting git remote origin url for path ' ...
		filepath '.']);
end;

remote = strtrim(results);
