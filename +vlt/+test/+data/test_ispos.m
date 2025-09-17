function test_ispos()
% TEST_ISPOS - Test for vlt.data.ispos
%
    % Test case 1: Positive numbers
    assert(vlt.data.ispos([1 2 3]), 'Should return true for [1 2 3]');
    assert(vlt.data.ispos(5), 'Should return true for 5');

    % Test case 2: Zero
    assert(~vlt.data.ispos([1 0 3]), 'Should return false for [1 0 3]');

    % Test case 3: Negative numbers
    assert(~vlt.data.ispos([-1 2 3]), 'Should return false for [-1 2 3]');

    % Test case 4: Not numeric
    assert(~vlt.data.ispos('hello'), 'Should return false for a string');

    disp('All tests for vlt.data.ispos passed.');
end
