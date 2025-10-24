classdef teststructfindfield < matlab.unittest.TestCase
    methods (Test)
        function testSimpleFind(testCase)
            % Test finding a struct with a specific field value
            S = { ...
                struct('field1', 'value1', 'field2', 10), ...
                struct('field1', 'value2', 'field2', 20) ...
            };

            index = vlt.data.structfindfield(S, 'field2', 20);

            testCase.verifyEqual(index, 2);
        end

        function testFieldNotFound(testCase)
            % Test when the field is not found in any struct
             S = { ...
                struct('field1', 'value1', 'field2', 10), ...
                struct('field1', 'value2', 'field2', 20) ...
            };

            index = vlt.data.structfindfield(S, 'field3', 20);

            testCase.verifyTrue(isempty(index));
        end

        function testValueNotFound(testCase)
            % Test when the value is not found
             S = { ...
                struct('field1', 'value1', 'field2', 10), ...
                struct('field1', 'value2', 'field2', 20) ...
            };

            index = vlt.data.structfindfield(S, 'field2', 30);

            testCase.verifyTrue(isempty(index));
        end
    end
end