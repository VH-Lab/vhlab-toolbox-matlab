classdef teststructpartialmatch < matlab.unittest.TestCase
    methods (Test)
        function testSimpleMatch(testCase)
            % Test finding a single matching struct
            S = [ ...
                struct('field1', 'value1', 'field2', 10); ...
                struct('field1', 'value2', 'field2', 20); ...
                struct('field1', 'value1', 'field2', 30) ...
            ];
            M = struct('field1', 'value2');

            indices = vlt.data.structpartialmatch(S, M);

            testCase.verifyEqual(indices, 2);
        end

        function testMultipleMatches(testCase)
            % Test finding multiple matching structs
            S = [ ...
                struct('field1', 'value1', 'field2', 10); ...
                struct('field1', 'value2', 'field2', 20); ...
                struct('field1', 'value1', 'field2', 30) ...
            ];
            M = struct('field1', 'value1');

            indices = vlt.data.structpartialmatch(S, M);

            testCase.verifyEqual(indices, [1; 3]);
        end

        function testNoMatch(testCase)
            % Test when no structs match
            S = [ ...
                struct('field1', 'value1', 'field2', 10); ...
                struct('field1', 'value2', 'field2', 20); ...
                struct('field1', 'value1', 'field2', 30) ...
            ];
            M = struct('field1', 'value3');

            indices = vlt.data.structpartialmatch(S, M);

            testCase.verifyTrue(isempty(indices));
        end

        function testMultipleFieldsMatch(testCase)
            % Test matching based on multiple fields
             S = [ ...
                struct('field1', 'value1', 'field2', 10); ...
                struct('field1', 'value2', 'field2', 20); ...
                struct('field1', 'value1', 'field2', 30) ...
            ];
            M = struct('field1', 'value1', 'field2', 30);

            indices = vlt.data.structpartialmatch(S, M);

            testCase.verifyEqual(indices, 3);
        end
    end
end