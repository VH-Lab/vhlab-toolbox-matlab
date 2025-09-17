function test_nanstderr()
% TEST_NANSTDERR - Test for vlt.data.nanstderr
%
    % Test case 1: Vector with NaNs
    data = [1 2 NaN 4 5];
    se = vlt.data.nanstderr(data);
    expected_se = nanstd(data) / sqrt(4);
    assert(abs(se - expected_se) < 1e-10, 'Standard error is not correct');

    % Test case 2: Matrix with NaNs
    data = [1 2 NaN 4 5; 6 NaN 8 9 10]';
    se = vlt.data.nanstderr(data);
    expected_se1 = nanstd(data(:,1)) / sqrt(4);
    expected_se2 = nanstd(data(:,2)) / sqrt(4);
    assert(abs(se(1) - expected_se1) < 1e-10, 'Standard error for column 1 is not correct');
    assert(abs(se(2) - expected_se2) < 1e-10, 'Standard error for column 2 is not correct');

    disp('All tests for vlt.data.nanstderr passed.');
end
