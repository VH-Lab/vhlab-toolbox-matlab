function test_isempty_cell()
% TEST_ISEMPTY_CELL - Test for vlt.data.isempty_cell
%
    % Test case 1: Mixed empty and non-empty cells
    A = {'test', [] ; [] 'more text'};
    B = vlt.data.isempty_cell(A);
    assert(isequal(B, [0 1; 1 0]), 'The result should be [0 1; 1 0]');

    % Test case 2: All empty cells
    A = {[], []};
    B = vlt.data.isempty_cell(A);
    assert(isequal(B, [1 1]), 'The result should be [1 1]');

    % Test case 3: All non-empty cells
    A = {'a', 'b'};
    B = vlt.data.isempty_cell(A);
    assert(isequal(B, [0 0]), 'The result should be [0 0]');

    % Test case 4: Empty input cell
    A = {};
    B = vlt.data.isempty_cell(A);
    assert(isempty(B), 'The result should be empty for an empty input');

    disp('All tests for vlt.data.isempty_cell passed.');
end
