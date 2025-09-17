function test_sortstruct()
% TEST_SORTSTRUCT - Test for vlt.data.sortstruct
%
    s(1) = struct('a', 1, 'b', 10);
    s(2) = struct('a', 2, 'b', 5);
    s(3) = struct('a', 1, 'b', 20);

    % Test case 1: Sort by one field, ascending
    [S_sorted, indexes] = vlt.data.sortstruct(s, '+a');
    assert(isequal(indexes, [1; 3; 2]), 'Sort by one field ascending failed');

    % Test case 2: Sort by one field, descending
    [S_sorted, indexes] = vlt.data.sortstruct(s, '-b');
    assert(isequal(indexes, [3; 1; 2]), 'Sort by one field descending failed');

    % Test case 3: Sort by two fields
    [S_sorted, indexes] = vlt.data.sortstruct(s, '+a', '-b');
    assert(isequal(indexes, [3; 1; 2]), 'Sort by two fields failed');

    disp('All tests for vlt.data.sortstruct passed.');
end
