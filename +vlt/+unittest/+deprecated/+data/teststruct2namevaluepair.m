classdef teststruct2namevaluepair < matlab.unittest.TestCase
    methods (Test)
        function testSimpleStruct(testCase)
            % Test a simple struct
            S = struct('field1', 'value1', 'field2', 10);
            nv = struct2namevaluepair(S);

            expected_nv = {'field1', 'value1', 'field2', 10};

            testCase.verifyEqual(nv, expected_nv);
        end

        function testEmptyStruct(testCase)
            % Test an empty struct
            S = struct();
            nv = struct2namevaluepair(S);

            testCase.verifyTrue(isempty(nv));
        end
    end
end