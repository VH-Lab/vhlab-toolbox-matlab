function [uptodate, changes, untracked_present] = git_status(dirname)
% GIT_STATUS - return git working tree status
%
% [UPTODATE, CHANGES, UNTRACKED_PRESENT] = vlt.git.git_status(DIRNAME)
%
% Examines whether a git working tree is up to date with its current branch
%
% UPTODATE is 1 if the working tree is up-to-date, and 0 if not.
% CHANGES is 1 if the working tree has changes to be committed, and 0 if not.
% UNTRACKED_PRESENT is 1 if there are untracked files present, and 0 if not.
%
% An error is generated if DIRNAME is not a GIT directory.
%
% See also: vlt.git.git_isgitdirectory

b = vlt.git.git_isgitdirectory(dirname);

if ~b,
	error(['Not a GIT directory: ' dirname '.']);
end;

[status,results] = system(['git -C "' dirname '" status ']); 

uptodate = 0;
untracked_present = 0;

if status==0,
	uptodate = ~isempty(strfind(results,'Your branch is up to date with'));
	changes = ~isempty(strfind(results,'Changes to be committed:'));
	untracked_present = ~isempty(strfind(results,'untracked files present'));
else,
	error(['Error running git status: ' results]);
end;

