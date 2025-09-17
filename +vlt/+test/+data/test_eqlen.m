function test_eqlen()
% TEST_EQLEN - Test for vlt.data.eqlen
%
    % Test case 1: Equal size and content
    assert(vlt.data.eqlen([1 2], [1 2]), 'Should return true for equal variables');
    assert(vlt.data.eqlen([], []), 'Should return true for empty variables');

    % Test case 2: Different size
    assert(~vlt.data.eqlen([1 2], [1 2 3]), 'Should return false for different sizes');
    assert(~vlt.data.eqlen([1 2], [1; 2]), 'Should return false for different dimensions');

    % Test case 3: Same size, different content
    assert(~vlt.data.eqlen([1 2], [3 4]), 'Should return false for different content');

    disp('All tests for vlt.data.eqlen passed.');
end
