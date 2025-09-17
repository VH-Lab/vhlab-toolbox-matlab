classdef simpletableTest < matlab.unittest.TestCase
    methods (Test)
        function testSimpleTable(testCase)
            old_table = [1 2];
            old_cats = [10 20];
            new_entry = [3 4];
            new_cats = [20 30];

            [new_table, new_cats_out] = vlt.data.simpletable(old_table, old_cats, new_entry, new_cats);

            expected_table = [1 2 NaN; NaN 3 4];
            expected_cats = [10 20 30];

            testCase.verifyEqual(new_table, expected_table, 'AbsTol', 1e-9);
            testCase.verifyEqual(new_cats_out, expected_cats);
        end
    end
end
