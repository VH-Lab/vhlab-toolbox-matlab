function test_matrow2cell()
% TEST_MATROW2CELL - Test for vlt.data.matrow2cell
%
    % Test case 1: Simple matrix
    A = [1 2; 3 4];
    B = vlt.data.matrow2cell(A);
    assert(iscell(B), 'B should be a cell array');
    assert(isequal(B{1}, [1 2]), 'B{1} should be [1 2]');
    assert(isequal(B{2}, [3 4]), 'B{2} should be [3 4]');

    % Test case 2: Input is already a cell array
    A = {[1 2], [3 4]};
    B = vlt.data.matrow2cell(A);
    assert(isequal(A, B), 'Should return the same cell array');

    disp('All tests for vlt.data.matrow2cell passed.');
end
