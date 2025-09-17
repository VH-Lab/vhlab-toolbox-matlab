function test_findclosestpoint()
% TEST_FINDCLOSESTPOINT - Test for vlt.data.findclosestpoint
%
    % Test case 1: Simple case
    pointlist = [1 1; 5 5; 10 10];
    point = [6 6];
    [i, pointc] = vlt.data.findclosestpoint(pointlist, point);
    assert(i == 2, 'The index should be 2');
    assert(isequal(pointc, [5 5]), 'The closest point should be [5 5]');

    % Test case 2: Exact match
    point = [10 10];
    [i, pointc] = vlt.data.findclosestpoint(pointlist, point);
    assert(i == 3, 'The index should be 3');
    assert(isequal(pointc, [10 10]), 'The closest point should be [10 10]');

    % Test case 3: 3D points
    pointlist = [1 1 1; 5 5 5; 10 10 10];
    point = [6 6 6];
    [i, pointc] = vlt.data.findclosestpoint(pointlist, point);
    assert(i == 2, 'The index should be 2');
    assert(isequal(pointc, [5 5 5]), 'The closest point should be [5 5 5]');

    disp('All tests for vlt.data.findclosestpoint passed.');
end
