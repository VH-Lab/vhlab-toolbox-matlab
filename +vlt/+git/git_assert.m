function b = git_assert
% GIT_ASSERT - do we have command line git on this machine?
%
% B = vlt.git.git_assert
%
% Tests for presence of 'git' using SYSTEM.
%
%

[status, result] = system('git');

 % make sure it returns the git usage; on MacOS, it can just tell you to install git without an error
clone_str = strfind(lower(result),'clone');
pull_str = strfind(lower(result),'pull');
branch_str = strfind(lower(result),'branch');

b = (status==0 | status==1) & ~isempty(result) & ~isempty(clone_str) & ~isempty(pull_str) & ~isempty(branch_str);;
