classdef teststructwhatvaries < matlab.unittest.TestCase
    methods (Test)
        function testSimpleVariation(testCase)
            % Test a simple case with one varying field
            S = { ...
                struct('field1', 'value1', 'field2', 10), ...
                struct('field1', 'value1', 'field2', 20), ...
                struct('field1', 'value1', 'field2', 30) ...
            };

            varying_fields = vlt.data.structwhatvaries(S);

            testCase.verifyEqual(varying_fields, {'field2'});
        end

        function testMultipleVariations(testCase)
            % Test with multiple varying fields
            S = { ...
                struct('field1', 'value1', 'field2', 10), ...
                struct('field1', 'value2', 'field2', 20), ...
                struct('field1', 'value1', 'field2', 10) ...
            };

            varying_fields = vlt.data.structwhatvaries(S);

            testCase.verifyEqual(sort(varying_fields), sort({'field1', 'field2'}));
        end

        function testNoVariation(testCase)
            % Test when no fields vary
            S = { ...
                struct('field1', 'value1', 'field2', 10), ...
                struct('field1', 'value1', 'field2', 10), ...
                struct('field1', 'value1', 'field2', 10) ...
            };

            varying_fields = vlt.data.structwhatvaries(S);

            testCase.verifyTrue(isempty(varying_fields));
        end
    end
end