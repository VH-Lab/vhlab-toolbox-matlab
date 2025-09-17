function test_columnize_struct()
% TEST_COLUMNIZE_STRUCT - Test for vlt.data.columnize_struct
%
    % Test case 1: Simple structure
    my_struct.a = [1 2 3];
    my_struct.b = 'test';
    columnized_struct = vlt.data.columnize_struct(my_struct);
    assert(iscolumn(columnized_struct.a), 'Field a should be a column vector');
    assert(isequal(columnized_struct.a, [1; 2; 3]), 'Field a should be [1; 2; 3]');
    assert(ischar(columnized_struct.b), 'Field b should be unchanged');

    % Test case 2: Nested structure
    my_struct.a = [1 2 3];
    my_struct.b.c = [4 5 6];
    my_struct.b.d = [7 8 9];
    columnized_struct = vlt.data.columnize_struct(my_struct);
    assert(iscolumn(columnized_struct.a), 'Field a should be a column vector');
    assert(iscolumn(columnized_struct.b.c), 'Field b.c should be a column vector');
    assert(iscolumn(columnized_struct.b.d), 'Field b.d should be a column vector');

    disp('All tests for vlt.data.columnize_struct passed.');
end
