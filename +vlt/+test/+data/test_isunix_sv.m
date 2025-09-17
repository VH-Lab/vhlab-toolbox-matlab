function test_isunix_sv()
% TEST_ISUNIX_SV - Test for vlt.data.isunix_sv
%
    % This test is simple: it just checks that the output is a boolean
    % and is consistent with the built-in `isunix` function.

    b = vlt.data.isunix_sv();
    assert(islogical(b) || (b==0) || (b==1), 'Output should be boolean-like');
    assert(b == isunix, 'Output should be consistent with isunix');

    disp('All tests for vlt.data.isunix_sv passed.');
end
