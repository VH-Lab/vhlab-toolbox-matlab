function test_eqtot()
% TEST_EQTOT - Test for vlt.data.eqtot
%
    % Test case 1: Equal variables
    assert(vlt.data.eqtot([4 4 4], [4 4 4]), 'Should return true for equal variables');
    assert(vlt.data.eqtot([1], [1 1]), 'Should return true because [1]==[1 1] is [true true]');

    % Test case 2: Unequal variables
    assert(~vlt.data.eqtot([1 2 3], [4 5 6]), 'Should return false for unequal variables');

    % Test case 3: Empty variables
    assert(vlt.data.eqtot([], []), 'Should return true for empty variables');
    assert(~vlt.data.eqtot([], [1]), 'Should return false for one empty and one non-empty');

    disp('All tests for vlt.data.eqtot passed.');
end
