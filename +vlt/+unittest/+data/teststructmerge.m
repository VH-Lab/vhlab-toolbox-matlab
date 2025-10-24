classdef teststructmerge < matlab.unittest.TestCase
    methods (Test)
        function testSimpleMerge(testCase)
            % Test merging two simple structs
            S1 = struct('field1', 'value1', 'field2', 10);
            S2 = struct('field3', 'value3', 'field4', 20);
            S_merged = vlt.data.structmerge(S1, S2);

            expected = struct('field1', 'value1', 'field2', 10, 'field3', 'value3', 'field4', 20);
            testCase.verifyEqual(S_merged, expected);
        end

        function testOverwriteMerge(testCase)
            % Test that the second struct's fields overwrite the first's
            S1 = struct('field1', 'value1', 'field2', 10);
            S2 = struct('field2', 'new_value', 'field3', 20);
            S_merged = vlt.data.structmerge(S1, S2);

            expected = struct('field1', 'value1', 'field2', 'new_value', 'field3', 20);
            testCase.verifyEqual(S_merged, expected);
        end
    end
end