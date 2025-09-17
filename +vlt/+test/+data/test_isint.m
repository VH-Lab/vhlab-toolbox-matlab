function test_isint()
% TEST_ISINT - Test for vlt.data.isint
%
    % Test case 1: Integer values
    assert(vlt.data.isint([1 2 3]), 'Should return true for [1 2 3]');
    assert(vlt.data.isint(0), 'Should return true for 0');
    assert(vlt.data.isint(-5), 'Should return true for -5');

    % Test case 2: Non-integer values
    assert(~vlt.data.isint([1 2.5 3]), 'Should return false for [1 2.5 3]');
    assert(~vlt.data.isint(pi), 'Should return false for pi');

    % Test case 3: Complex numbers
    assert(~vlt.data.isint(1+1i), 'Should return false for a complex number');

    % Test case 4: Not numeric
    assert(~vlt.data.isint('hello'), 'Should return false for a string');

    disp('All tests for vlt.data.isint passed.');
end
