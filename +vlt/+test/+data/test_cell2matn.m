function test_cell2matn()
% TEST_CELL2MATN - Test for vlt.data.cell2matn
%
    % Test case 1: Simple case
    a{1,1} = 1; a{1,2} = 2; a{2,1} = 3;
    m = vlt.data.cell2matn(a);
    assert(isequaln(m, [1 2; 3 NaN]), 'The matrix should be [1 2; 3 NaN]');

    % Test case 2: All empty
    a = cell(2,2);
    m = vlt.data.cell2matn(a);
    assert(isequaln(m, [NaN NaN; NaN NaN]), 'The matrix should be all NaNs');

    % Test case 3: Non-numeric entry
    a{1,1} = 'hello';
    try
        vlt.data.cell2matn(a);
        assert(false, 'Should have thrown an error for non-numeric entry');
    catch
        % expected
    end

    % Test case 4: Non-scalar entry
    a{1,1} = [1 2];
    try
        vlt.data.cell2matn(a);
        assert(false, 'Should have thrown an error for non-scalar entry');
    catch
        % expected
    end

    disp('All tests for vlt.data.cell2matn passed.');
end
