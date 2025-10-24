classdef teststructwhatvaries < matlab.unittest.TestCase
    methods (Test)
        function testSimpleVariation(testCase)
            % Test a simple case with one varying field
            S = [ ...
                struct('field1', 'value1', 'field2', 10); ...
                struct('field1', 'value1', 'field2', 20); ...
                struct('field1', 'value1', 'field2', 30) ...
            ];

            [varying_fields, C] = structwhatvaries(S);

            testCase.verifyEqual(varying_fields, {{'field2'}});
            testCase.verifyEqual(C, {{10; 20; 30}});
        end

        function testMultipleVariations(testCase)
            % Test with multiple varying fields
            S = [ ...
                struct('field1', 'value1', 'field2', 10); ...
                struct('field1', 'value2', 'field2', 20); ...
                struct('field1', 'value1', 'field2', 10) ...
            ];

            [varying_fields, C] = structwhatvaries(S);

            testCase.verifyEqual(sort(varying_fields{1}), sort({'field1', 'field2'}));

            % The order of fields is not guaranteed, so we'll check the contents
            % of C based on the order of varying_fields
            if strcmp(varying_fields{1}{1}, 'field1')
                testCase.verifyEqual(C{1}, {'value1'; 'value2'; 'value1'});
                testCase.verifyEqual(C{2}, {10; 20; 10});
            else
                testCase.verifyEqual(C{1}, {10; 20; 10});
                testCase.verifyEqual(C{2}, {'value1'; 'value2'; 'value1'});
            end

        end

        function testNoVariation(testCase)
            % Test when no fields vary
            S = [ ...
                struct('field1', 'value1', 'field2', 10); ...
                struct('field1', 'value1', 'field2', 10); ...
                struct('field1', 'value1', 'field2', 10) ...
            ];

            [varying_fields, C] = structwhatvaries(S);

            testCase.verifyTrue(isempty(varying_fields{1}));
            testCase.verifyTrue(isempty(C));
        end
    end
end