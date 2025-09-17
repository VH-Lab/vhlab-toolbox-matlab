function test_dropnan()
% TEST_DROPNAN - Test for vlt.data.dropnan
%
    % Test case 1: Vector with NaNs
    A = [1 2 NaN 4 5 NaN];
    B = vlt.data.dropnan(A);
    assert(isequal(B, [1 2 4 5]), 'B should be [1 2 4 5]');

    % Test case 2: Vector with no NaNs
    A = [1 2 3 4 5];
    B = vlt.data.dropnan(A);
    assert(isequal(B, A), 'B should be the same as A');

    % Test case 3: Vector with all NaNs
    A = [NaN NaN NaN];
    B = vlt.data.dropnan(A);
    assert(isempty(B), 'B should be empty');

    % Test case 4: Empty vector
    A = [];
    B = vlt.data.dropnan(A);
    assert(isempty(B), 'B should be empty');

    disp('All tests for vlt.data.dropnan passed.');
end
