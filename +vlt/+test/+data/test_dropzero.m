function test_dropzero()
% TEST_DROPZERO - Test for vlt.data.dropzero
%
    % Test case 1: Vector with zeros
    A = [1 2 0 4 5 0];
    B = vlt.data.dropzero(A);
    assert(isequal(B, [1 2 4 5]), 'B should be [1 2 4 5]');

    % Test case 2: Vector with no zeros
    A = [1 2 3 4 5];
    B = vlt.data.dropzero(A);
    assert(isequal(B, A), 'B should be the same as A');

    % Test case 3: Vector with all zeros
    A = [0 0 0];
    B = vlt.data.dropzero(A);
    assert(isempty(B), 'B should be empty');

    % Test case 4: Empty vector
    A = [];
    B = vlt.data.dropzero(A);
    assert(isempty(B), 'B should be empty');

    disp('All tests for vlt.data.dropzero passed.');
end
