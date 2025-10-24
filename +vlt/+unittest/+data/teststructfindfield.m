classdef teststructfindfield < matlab.unittest.TestCase
    methods (Test)
        function testSimpleFind(testCase)
            % Test finding a simple field
            S = struct('field1', 'value1', 'field2', 10);

            [value] = vlt.data.structfindfield(S, 'field2');

            testCase.verifyEqual(value, 10);
        end

        function testFieldNotFound(testCase)
            % Test when the field is not found
            S = struct('field1', 'value1', 'field2', 10);

            [value] = vlt.data.structfindfield(S, 'field3');

            testCase.verifyTrue(isempty(value));
        end

        function testEmptyStruct(testCase)
            % Test on an empty struct
            S = struct();

            [value] = vlt.data.structfindfield(S, 'field1');

            testCase.verifyTrue(isempty(value));
        end
    end
end