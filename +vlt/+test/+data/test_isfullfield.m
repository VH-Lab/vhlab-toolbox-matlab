function test_isfullfield()
% TEST_ISFULLFIELD - Test for vlt.data.isfullfield
%
    A = struct('a', struct('sub1', 1, 'sub2', 2), 'b', 5);

    % Test case 1: Existing field
    [b, value] = vlt.data.isfullfield(A, 'b');
    assert(b == 1, 'Should return true for an existing field');
    assert(value == 5, 'The value should be 5');

    % Test case 2: Existing subfield
    [b, value] = vlt.data.isfullfield(A, 'a.sub1');
    assert(b == 1, 'Should return true for an existing subfield');
    assert(value == 1, 'The value should be 1');

    % Test case 3: Non-existing field
    [b, value] = vlt.data.isfullfield(A, 'c');
    assert(b == 0, 'Should return false for a non-existing field');
    assert(isempty(value), 'The value should be empty');

    % Test case 4: Non-existing subfield
    [b, value] = vlt.data.isfullfield(A, 'a.sub3');
    assert(b == 0, 'Should return false for a non-existing subfield');
    assert(isempty(value), 'The value should be empty');

    disp('All tests for vlt.data.isfullfield passed.');
end
