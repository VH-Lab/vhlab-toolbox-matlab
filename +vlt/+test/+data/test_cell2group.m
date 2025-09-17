function test_cell2group()
% TEST_CELL2GROUP - Test for vlt.data.cell2group
%
    % Test case 1: Simple case
    a = { [1 2 3]', [4 5 6]', [7 8 9]' };
    [x, group] = vlt.data.cell2group(a);
    assert(isequal(x, [1 2 3 4 5 6 7 8 9]'), 'x should be the concatenated data');
    assert(isequal(group, [1 1 1 2 2 2 3 3 3]'), 'group should be the group indices');

    % Test case 2: Empty cell
    a = { [], [1 2 3]' };
    [x, group] = vlt.data.cell2group(a);
    assert(isequal(x, [1 2 3]'), 'x should be the concatenated data');
    assert(isequal(group, [2 2 2]'), 'group should be the group indices');

    % Test case 3: Empty input
    a = {};
    [x, group] = vlt.data.cell2group(a);
    assert(isempty(x), 'x should be empty for empty input');
    assert(isempty(group), 'group should be empty for empty input');

    disp('All tests for vlt.data.cell2group passed.');
end
