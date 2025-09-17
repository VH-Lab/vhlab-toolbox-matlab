function test_assign()
% TEST_ASSIGN - Test for vlt.data.assign
%
    % Test case 1: Assigning simple variables
    a = 1;
    b = 2;
    vlt.data.assign('a', 5, 'b', 10);
    assert(a == 5, 'a should be 5');
    assert(b == 10, 'b should be 10');

    % Test case 2: Assigning a structure
    c = 3;
    d = 4;
    my_struct = struct('c', 15, 'd', 20);
    vlt.data.assign(my_struct);
    assert(c == 15, 'c should be 15');
    assert(d == 20, 'd should be 20');

    % Test case 3: Assigning a cell array
    e = 5;
    f = 6;
    my_cell = {'e', 25, 'f', 30};
    vlt.data.assign(my_cell);
    assert(e == 25, 'e should be 25');
    assert(f == 30, 'f should be 30');

    disp('All tests for vlt.data.assign passed.');
end
