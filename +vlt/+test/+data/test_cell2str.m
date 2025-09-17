function test_cell2str()
% TEST_CELL2STR - Test for vlt.data.cell2str
%
    % Test case 1: Cell array of strings
    A = {'test','test2','test3'};
    str = vlt.data.cell2str(A);
    assert(strcmp(str, '{ ''test'', ''test2'', ''test3'' }'));
    B = eval(str);
    assert(isequal(A, B));

    % Test case 2: Cell array of numbers
    A = {1, 2, 3};
    str = vlt.data.cell2str(A);
    assert(strcmp(str, '{ [1], [2], [3] }'));
    B = eval(str);
    assert(isequal(A, B));

    % Test case 3: Mixed cell array
    A = {'test', 1, [2 3]};
    str = vlt.data.cell2str(A);
    assert(strcmp(str, '{ ''test'', [1], [2 3] }'));
    B = eval(str);
    assert(isequal(A, B));

    % Test case 4: Empty cell array
    A = {};
    str = vlt.data.cell2str(A);
    assert(strcmp(str, '{}'));
    B = eval(str);
    assert(isequal(A, B));

    disp('All tests for vlt.data.cell2str passed.');
end
