function b = git_clone(repository, localparentdir)
% GIT_CLONE - clone a git repository onto the local computer
%
% B = vlt.git.git_clone(REPOSITORY, LOCALPARENTDIR)
%
% Clones a git repository REPOSITORY into the local directory
% LOCALPARENTDIR.
%
% If a folder containing the local repository already exists,
% an error is returned.
%
% B is 1 if the operation is successful.
%

if ~exist(localparentdir,'dir'),
	mkdir(localparentdir);
end;

reponames = split(repository,'/');

localreponame = [localparentdir filesep reponames{end}];

if exist([localreponame],'dir'),
	error([localreponame ' already exists.']);
end;

[status,results]=system(['git -C "' localparentdir '" clone ' repository]);

b = (status==0);

