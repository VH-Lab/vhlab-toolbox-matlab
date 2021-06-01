function b = git_stash(dirname)
% GIT_STASH - stash changes to a git repository
%
% B = vlt.git.git_stash(DIRNAME)
%
% Stash the local changes to a GIT repository in DIRNAME.
%

localparentdir = fileparts(dirname);

 % see if pull succeeds

stash_success = 1; % assume success, and update to failure if need be

if ~exist(dirname,'dir'),
	stash_success = 0;
end;

if stash_success, % if we are still going, try to 
	[status,results]=system(['git -C "' dirname '" stash']);

	results,

	pull_success=(status==0);
end;

b = pull_success;

