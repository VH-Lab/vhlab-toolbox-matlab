classdef test_flattenstruct2table < matlab.unittest.TestCase
    % vlt.data.flattenstruct2table - test the vlt.data.flattenstruct2table function

    methods (Test)

        function test_scalar_struct(testCase)
            % Test with a single, non-nested struct
            s = struct('a', 1, 'b', 'hello', 'c', [2 3]);
            t = vlt.data.flattenstruct2table(s);

            testCase.verifyEqual(size(t), [1 3]);
            testCase.verifyEqual(t.Properties.VariableNames, {'a', 'b', 'c'});
            testCase.verifyEqual(t.a, 1);
            testCase.verifyEqual(t.b, {'hello'}); % string is returned in cell
            testCase.verifyEqual(t.c, [2 3]);
        end

        function test_struct_array(testCase)
            % Test with a simple struct array
            s = struct('a', {1, 2, 3}, 'b', {'x', 'y', 'z'});
            t = vlt.data.flattenstruct2table(s);

            testCase.verifyEqual(size(t), [3 2]);
            testCase.verifyEqual(t.Properties.VariableNames, {'a', 'b'});
            testCase.verifyEqual(t.a, [1; 2; 3]);
            testCase.verifyEqual(t.b, {'x';'y';'z'});
        end

        function test_nested_scalar_struct(testCase)
            % Test with a struct containing another scalar struct
            s = struct('Header', struct('ID', 'A1', 'Date', '2023-10-26'), 'Value', 42);
            t = vlt.data.flattenstruct2table(s);

            testCase.verifyEqual(size(t), [1 3]);
            expected_names = {'Header.ID', 'Header.Date', 'Value'};
            testCase.verifyEqual(sort(t.Properties.VariableNames), sort(expected_names));
            testCase.verifyEqual(t.("Header.ID"), {'A1'});
            testCase.verifyEqual(t.("Header.Date"), {'2023-10-26'});
            testCase.verifyEqual(t.Value, 42);
        end

        function test_nested_struct_array_special_case(testCase)
            % Test the backward-compatibility case of a nested struct array
            Sub = struct('X', {10, 20}, 'Y', {'a', 'b'}); % A 1x2 struct array
            s = struct('A', Sub, 'C', 3);

            t = vlt.data.flattenstruct2table(s);

            testCase.verifyEqual(size(t), [1 3]);
            expected_names = {'A.X', 'A.Y', 'C'};
            testCase.verifyEqual(sort(t.Properties.VariableNames), sort(expected_names));

            % Verify that the nested data is in a cell within the single row
            testCase.verifyTrue(iscell(t.("A.X")));
            testCase.verifyEqual(t.("A.X"){1}, [10 20]);

            testCase.verifyTrue(iscell(t.("A.Y")));
            testCase.verifyEqual(t.("A.Y"){1}, {'a', 'b'});

            testCase.verifyEqual(t.C, 3);
        end

        function test_abbreviation(testCase)
            % Test the optional abbreviation argument
            s = struct('VeryLongFieldName', 1, 'AnotherLongName', 2);
            abbrev = {{'VeryLong', 'VL'}, {'Name', ''}};
            t = vlt.data.flattenstruct2table(s, abbrev);

            expected_names = {'VLField', 'AnotherLong'};
            testCase.verifyEqual(sort(t.Properties.VariableNames), sort(expected_names));
            testCase.verifyEqual(t.VLField, 1);
            testCase.verifyEqual(t.AnotherLong, 2);
        end

        function test_empty_struct(testCase)
            % Test with an empty struct
            s = struct();
            t = vlt.data.flattenstruct2table(s);
            testCase.verifyTrue(istable(t));
            testCase.verifyEqual(size(t), [0 0]);
        end

        function test_non_struct_input_error(testCase)
            % Test that a non-struct input throws an error
            non_struct = [1, 2, 3];
            testCase.verifyError(@() vlt.data.flattenstruct2table(non_struct), ''); % any error is fine
        end

    end

end
