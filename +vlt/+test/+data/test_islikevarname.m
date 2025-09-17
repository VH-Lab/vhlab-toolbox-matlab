function test_islikevarname()
% TEST_ISLIKEVARNAME - Test for vlt.data.islikevarname
%
    % Test case 1: Valid name
    [b, e] = vlt.data.islikevarname('my_var');
    assert(b == 1, 'Should return true for a valid name');
    assert(isempty(e), 'Error message should be empty');

    % Test case 2: Starts with a number
    [b, e] = vlt.data.islikevarname('1my_var');
    assert(b == 0, 'Should return false for a name starting with a number');
    assert(~isempty(e), 'Error message should not be empty');

    % Test case 3: Contains whitespace
    [b, e] = vlt.data.islikevarname('my var');
    assert(b == 0, 'Should return false for a name with whitespace');
    assert(~isempty(e), 'Error message should not be empty');

    % Test case 4: Empty name
    [b, e] = vlt.data.islikevarname('');
    assert(b == 0, 'Should return false for an empty name');
    assert(~isempty(e), 'Error message should not be empty');

    % Test case 5: Not a char string
    [b, e] = vlt.data.islikevarname(123);
    assert(b == 0, 'Should return false for a non-char input');
    assert(~isempty(e), 'Error message should not be empty');

    disp('All tests for vlt.data.islikevarname passed.');
end
