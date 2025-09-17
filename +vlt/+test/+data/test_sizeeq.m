function test_sizeeq()
% TEST_SIZEEQ - Test for vlt.data.sizeeq
%
    % Test case 1: Same size
    assert(vlt.data.sizeeq([1 2], [3 4]), 'Should return true for same size');
    assert(vlt.data.sizeeq([1; 2], [3; 4]), 'Should return true for same size');

    % Test case 2: Different size
    assert(~vlt.data.sizeeq([1 2], [3 4 5]), 'Should return false for different number of elements');
    assert(~vlt.data.sizeeq([1 2], [3; 4]), 'Should return false for different dimensions');

    % Test case 3: Empty arrays
    assert(vlt.data.sizeeq([], []), 'Should return true for two empty arrays');
    assert(~vlt.data.sizeeq([], [1]), 'Should return false for one empty and one non-empty');

    disp('All tests for vlt.data.sizeeq passed.');
end
