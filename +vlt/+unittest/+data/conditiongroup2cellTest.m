classdef conditiongroup2cellTest < matlab.unittest.TestCase
    methods (Test)
        function testSimple(testCase)
            values = [10 20 30 40 50];
            exp_indexes = [1 1 2 2 1];
            cond_indexes = [1 2 1 2 1];
            [data, exper_indexes] = vlt.data.conditiongroup2cell(values, exp_indexes, cond_indexes);
            testCase.verifyEqual(data{1}, [10 30 50]);
            testCase.verifyEqual(exper_indexes{1}, [1 2 1]);
            testCase.verifyEqual(data{2}, [20 40]);
            testCase.verifyEqual(exper_indexes{2}, [1 2]);
        end
    end
end
