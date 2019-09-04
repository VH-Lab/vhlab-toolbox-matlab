function b = git_assert
% GIT_ASSERT - do we have command line git on this machine?
%
% B = GIT_ASSERT
%
% Tests for presence of 'git' using SYSTEM.
%
%

[status, result] = system('git');

b = (status==0 | status==1) & ~isempty(result);
