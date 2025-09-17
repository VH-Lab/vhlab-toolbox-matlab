function test_findrowvec()
% TEST_FINDROWVEC - Test for vlt.data.findrowvec
%
    % Test case 1: Simple case
    A = [1 2 3; 4 5 6; 1 2 3];
    B = [1 2 3];
    I = vlt.data.findrowvec(A, B);
    assert(isequal(I, [1; 3]), 'The indices should be [1; 3]');

    % Test case 2: No match
    B = [7 8 9];
    I = vlt.data.findrowvec(A, B);
    assert(isempty(I), 'The indices should be empty');

    % Test case 3: Empty matrix
    A = [];
    B = [1 2 3];
    I = vlt.data.findrowvec(A, B);
    assert(isempty(I), 'The indices should be empty');

    disp('All tests for vlt.data.findrowvec passed.');
end
