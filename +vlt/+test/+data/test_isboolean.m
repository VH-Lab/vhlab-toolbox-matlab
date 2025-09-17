function test_isboolean()
% TEST_ISBOOLEAN - Test for vlt.data.isboolean
%
    % Test case 1: Contains only 0s and 1s
    assert(vlt.data.isboolean([0 1 0 1]), 'Should return true for [0 1 0 1]');
    assert(vlt.data.isboolean([1 1 1]), 'Should return true for [1 1 1]');
    assert(vlt.data.isboolean(0), 'Should return true for 0');

    % Test case 2: Contains other numbers
    assert(~vlt.data.isboolean([0 1 2]), 'Should return false for [0 1 2]');
    assert(~vlt.data.isboolean(-1), 'Should return false for -1');

    % Test case 3: Not numeric
    assert(~vlt.data.isboolean('hello'), 'Should return false for a string');
    assert(~vlt.data.isboolean({0, 1}), 'Should return false for a cell array');

    disp('All tests for vlt.data.isboolean passed.');
end
