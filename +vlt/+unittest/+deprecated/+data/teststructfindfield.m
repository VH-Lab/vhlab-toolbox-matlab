classdef teststructfindfield < matlab.unittest.TestCase
    methods (Test)
        function testSimpleFind(test_Case)
            % Test finding a struct with a specific field value
            S = { ...
                struct('field1', 'value1', 'field2', 10), ...
                struct('field1', 'value2', 'field2', 20) ...
            };

            index = structfindfield(S, 'field2', 20);

            test_Case.verifyEqual(index, 2);
        end

        function testFieldNotFound(test_Case)
            % Test when the field is not found in any struct
             S = { ...
                struct('field1', 'value1', 'field2', 10), ...
                struct('field1', 'value2', 'field2', 20) ...
            };

            index = structfindfield(S, 'field3', 20);

            test_Case.verifyTrue(isempty(index));
        end

        function testValueNotFound(test_Case)
            % Test when the value is not found
             S = { ...
                struct('field1', 'value1', 'field2', 10), ...
                struct('field1', 'value2', 'field2', 20) ...
            };

            index = structfindfield(S, 'field2', 30);

            test_Case.verifyTrue(isempty(index));
        end
    end
end