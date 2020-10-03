function b = git_install(dirname, repository)
% GIT_PULL - pull changes to a git repository
%
% B = vlt.git.git_pull(DIRNAME, REPOSITORY)
%
% 'Install' is our term for forcing the local directory DIRNAME to match the
% remote REPOSITORY, either by cloning or pulling the latest changes. Any files
% in the local directory DIRNAME that don't match the remote REPOSITORY are deleted.
% 
% If DIRNAME does not exist, then the repository is cloned.
% If DIRNAME exists and has local changes, the directory is deleted and cloned fresh.
% If the DIRNAME exists and has no local changes, the directory is updated by
% pulling.
%
% Note: if you have any local changes, vlt.git.git_install will totally remove them.
%
% B is 1 if the operation is successful.
%

localparentdir = fileparts(dirname);

must_clone = 0;

if ~exist(dirname,'dir'),
	must_clone = 1;
end;

status_good = 0;
if ~must_clone,
	try,
		[uptodate,changes,untrackedfiles] = vlt.git.git_status(dirname);
		status_good = ~changes & ~untrackedfiles;
	end;
end;

if status_good, % we can pull without difficulty
	b=vlt.git.git_pull(dirname);
else,
	must_clone = 1;
end;

if must_clone, 
	if exist(dirname,'dir'), 
		rmdir(dirname,'s');
	end;
	b=vlt.git.git_clone(repository,localparentdir);
end;

