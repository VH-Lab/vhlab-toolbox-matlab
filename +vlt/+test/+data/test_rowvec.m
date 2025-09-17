function test_rowvec()
% TEST_ROWVEC - Test for vlt.data.rowvec
%
    % Test case 1: Simple matrix
    A = [1 2; 3 4];
    Y = vlt.data.rowvec(A);
    assert(isrow(Y), 'Y should be a row vector');
    assert(isequal(Y, [1 3 2 4]), 'Y should be [1 3 2 4]');

    % Test case 2: Column vector
    A = [1; 2; 3];
    Y = vlt.data.rowvec(A);
    assert(isrow(Y), 'Y should be a row vector');
    assert(isequal(Y, [1 2 3]), 'Y should be [1 2 3]');

    % Test case 3: Row vector
    A = [1 2 3];
    Y = vlt.data.rowvec(A);
    assert(isrow(Y), 'Y should be a row vector');
    assert(isequal(Y, [1 2 3]), 'Y should be [1 2 3]');

    disp('All tests for vlt.data.rowvec passed.');
end
