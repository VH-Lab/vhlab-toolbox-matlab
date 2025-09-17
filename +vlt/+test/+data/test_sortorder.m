function test_sortorder()
% TEST_SORTORDER - Test for vlt.data.sortorder
%
    % Test case 1: Simple vector
    A = [3 2 1];
    I = vlt.data.sortorder(A);
    assert(isequal(I, [3 2 1]'), 'The sort order should be [3 2 1]');

    % Test case 2: Vector with repeated elements
    A = [3 1 2 1];
    I = vlt.data.sortorder(A);
    [~, expected_I] = sort(A);
    assert(isequal(I, expected_I), 'The sort order is not correct');

    % Test case 3: Descending order
    A = [1 2 3];
    I = vlt.data.sortorder(A, 'descend');
    assert(isequal(I, [3 2 1]'), 'The sort order should be [3 2 1]');

    disp('All tests for vlt.data.sortorder passed.');
end
