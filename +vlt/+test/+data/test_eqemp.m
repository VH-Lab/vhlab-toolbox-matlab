function test_eqemp()
% TEST_EQEMP - Test for vlt.data.eqemp
%
    % Test case 1: Both empty
    assert(vlt.data.eqemp([], []), 'Should return true for two empty variables');

    % Test case 2: One empty, one not
    assert(~vlt.data.eqemp([], [1 2]), 'Should return false for one empty and one non-empty');
    assert(~vlt.data.eqemp([1 2], []), 'Should return false for one non-empty and one empty');

    % Test case 3: Both non-empty and equal
    assert(all(vlt.data.eqemp([1 2], [1 2])), 'Should return true for equal non-empty variables');

    % Test case 4: Both non-empty and not equal
    assert(~all(vlt.data.eqemp([1 2], [3 4])), 'Should return false for non-equal non-empty variables');

    disp('All tests for vlt.data.eqemp passed.');
end
