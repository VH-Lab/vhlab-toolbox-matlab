function b = git_pull(dirname)
% GIT_PULL - pull changes to a git repository
%
% B = vlt.git.git_pull(DIRNAME)
%
% Pulls the remote changes to a GIT repository into the local directory
% DIRNAME.
%
% If there are local changes to be committed, the operation may fail and B
% will be 0.
%

localparentdir = fileparts(dirname);

 % see if pull succeeds

pull_success = 1; % assume success, and update to failure if need be

if ~exist(dirname,'dir'),
	pull_success = 0;
end;

if pull_success, % if we are still going, try to pull
	[status,results]=system(['git -C "' dirname '" pull']);

	pull_success=(status==0);
end;

b = pull_success;

