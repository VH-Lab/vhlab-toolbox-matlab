function test_simpletable()
% TEST_SIMPLETABLE - Test for vlt.data.simpletable
%
    old_table = [1 2];
    old_cats = [10 20];
    new_entry = [3 4];
    new_cats = [20 30];

    [new_table, new_cats_out] = vlt.data.simpletable(old_table, old_cats, new_entry, new_cats);

    % Expected results after sorting
    expected_table = [1 2 NaN; NaN 3 4];
    expected_cats = [10 20 30];

    assert(isequaln(new_table, expected_table), 'The new table is not correct');
    assert(isequal(new_cats_out, expected_cats), 'The new category list is not correct');

    disp('All tests for vlt.data.simpletable passed.');
end
