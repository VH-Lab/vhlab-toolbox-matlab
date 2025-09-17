function test_hasAllFields()
% TEST_HASALLFIELDS - Test for vlt.data.hasAllFields
%
    r = struct('test1', 5, 'test2', [6 1]);

    % Test case 1: All fields and sizes match
    [g, e] = vlt.data.hasAllFields(r, {'test1', 'test2'}, {[1 1], [1 2]});
    assert(g == 1, 'Should return true when all fields and sizes match');
    assert(isempty(e), 'Error message should be empty');

    % Test case 2: Missing field
    [g, e] = vlt.data.hasAllFields(r, {'test1', 'test3'}, {[1 1], [1 2]});
    assert(g == 0, 'Should return false when a field is missing');
    assert(strcmp(e, '''test3'' not present.'), 'Incorrect error message for missing field');

    % Test case 3: Incorrect size
    [g, e] = vlt.data.hasAllFields(r, {'test1', 'test2'}, {[1 1], [2 2]});
    assert(g == 0, 'Should return false when a field has incorrect size');
    assert(contains(e, 'not of expected size'), 'Incorrect error message for size mismatch');

    % Test case 4: Wildcard size
    [g, e] = vlt.data.hasAllFields(r, {'test1', 'test2'}, {[-1 -1], [-1 -1]});
    assert(g == 1, 'Should return true when using wildcard sizes');
    assert(isempty(e), 'Error message should be empty');

    disp('All tests for vlt.data.hasAllFields passed.');
end
