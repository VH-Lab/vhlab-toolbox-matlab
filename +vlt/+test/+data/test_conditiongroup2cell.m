function test_conditiongroup2cell()
% TEST_CONDITIONGROUP2CELL - Test for vlt.data.conditiongroup2cell
%
    % Test case 1: Simple case
    values = [10 20 30 40 50];
    exp_indexes = [1 1 2 2 1];
    cond_indexes = [1 2 1 2 1];
    [data, exper_indexes] = vlt.data.conditiongroup2cell(values, exp_indexes, cond_indexes);
    assert(isequal(data{1}, [10 30 50]'), 'data{1} is not correct');
    assert(isequal(exper_indexes{1}, [1 2 1]'), 'exper_indexes{1} is not correct');
    assert(isequal(data{2}, [20 40]'), 'data{2} is not correct');
    assert(isequal(exper_indexes{2}, [1 2]'), 'exper_indexes{2} is not correct');

    disp('All tests for vlt.data.conditiongroup2cell passed.');
end
