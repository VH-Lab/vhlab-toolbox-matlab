function test_findclosest()
% TEST_FINDCLOSEST - Test for vlt.data.findclosest
%
    % Test case 1: Simple case
    array = [1 5 10 15];
    value = 6;
    [i, v] = vlt.data.findclosest(array, value);
    assert(i == 2, 'The index should be 2');
    assert(v == 5, 'The value should be 5');

    % Test case 2: Exact match
    value = 10;
    [i, v] = vlt.data.findclosest(array, value);
    assert(i == 3, 'The index should be 3');
    assert(v == 10, 'The value should be 10');

    % Test case 3: Multiple occurrences
    array = [1 5 5 10];
    value = 6;
    [i, v] = vlt.data.findclosest(array, value);
    assert(i == 2, 'The index should be 2 (the first occurrence)');
    assert(v == 5, 'The value should be 5');

    % Test case 4: Empty array
    array = [];
    value = 5;
    [i, v] = vlt.data.findclosest(array, value);
    assert(isempty(i), 'The index should be empty');
    assert(isempty(v), 'The value should be empty');

    disp('All tests for vlt.data.findclosest passed.');
end
