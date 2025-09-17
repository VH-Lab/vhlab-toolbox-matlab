function test_cellarray2mat()
% TEST_CELLARRAY2MAT - Test for vlt.data.cellarray2mat
%
    % Test case 1: Simple case
    c{1} = [1 2 3];
    c{2} = [4 5];
    m = vlt.data.cellarray2mat(c);
    assert(isequaln(m, [1 4; 2 5; 3 NaN]), 'The matrix should be [1 4; 2 5; 3 NaN]');

    % Test case 2: Empty cell array
    c = {};
    m = vlt.data.cellarray2mat(c);
    assert(isempty(m), 'The matrix should be empty');

    % Test case 3: Cell array with empty entries
    c{1} = [1 2 3];
    c{2} = [];
    c{3} = [4 5];
    m = vlt.data.cellarray2mat(c);
    assert(isequaln(m, [1 NaN 4; 2 NaN 5; 3 NaN NaN]), 'The matrix is not correct');

    % Test case 4: Non-vector entry
    c{1} = [1 2; 3 4];
    try
        vlt.data.cellarray2mat(c);
        assert(false, 'Should have thrown an error for non-vector entry');
    catch
        % expected
    end

    disp('All tests for vlt.data.cellarray2mat passed.');
end
