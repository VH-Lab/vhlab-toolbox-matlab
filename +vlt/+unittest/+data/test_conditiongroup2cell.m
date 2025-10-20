classdef test_conditiongroup2cell < matlab.unittest.TestCase
    methods(Test)
        function test_simple_case(testCase)
            values = [101:110];
            experiment_indexes = [1 1 1 1 1 2 2 2 2 2];
            condition_indexes = [1 2 1 2 1 2 1 2 1 2];

            [data, exper_indexes_out] = vlt.data.conditiongroup2cell(values, experiment_indexes, condition_indexes);

            expected_data = {[101 103 105 107 109], [102 104 106 108 110]};
            expected_exper_indexes = {[1 1 1 2 2], [1 1 2 2 2]};

            testCase.verifyEqual(data, expected_data);
            testCase.verifyEqual(exper_indexes_out, expected_exper_indexes);
        end
    end
end
