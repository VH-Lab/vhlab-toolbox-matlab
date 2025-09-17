function test_numornan()
% TEST_NUMORNAN - Test for vlt.data.numornan
%
    % Test case 1: Non-empty input
    assert(vlt.data.numornan(5) == 5, 'Should return the number itself');

    % Test case 2: Empty input
    assert(isnan(vlt.data.numornan([])), 'Should return NaN for an empty input');

    % Test case 3: Empty input with specified dimensions
    n_out = vlt.data.numornan([], [2 2]);
    assert(isequal(size(n_out), [2 2]), 'The output should be a 2x2 matrix');
    assert(all(isnan(n_out(:))), 'All elements should be NaN');

    % Test case 4: Padding with NaNs
    n_out = vlt.data.numornan([1 2], [1 4]);
    assert(isequal(n_out, [1 2 NaN NaN]), 'Should pad with NaNs');

    disp('All tests for vlt.data.numornan passed.');
end
