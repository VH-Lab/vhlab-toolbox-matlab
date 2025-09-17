function test_colvec()
% TEST_COLVEC - Test for vlt.data.colvec
%
    % Test case 1: Simple matrix
    A = [1 2; 3 4];
    Y = vlt.data.colvec(A);
    assert(iscolumn(Y), 'Y should be a column vector');
    assert(isequal(Y, [1; 3; 2; 4]), 'Y should be [1; 3; 2; 4]');

    % Test case 2: Row vector
    A = [1 2 3];
    Y = vlt.data.colvec(A);
    assert(iscolumn(Y), 'Y should be a column vector');
    assert(isequal(Y, [1; 2; 3]), 'Y should be [1; 2; 3]');

    % Test case 3: Column vector
    A = [1; 2; 3];
    Y = vlt.data.colvec(A);
    assert(iscolumn(Y), 'Y should be a column vector');
    assert(isequal(Y, [1; 2; 3]), 'Y should be [1; 2; 3]');

    disp('All tests for vlt.data.colvec passed.');
end
